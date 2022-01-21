COMMON_MAKEFILE := $(CURDIR)/$(lastword $(MAKEFILE_LIST))

ifdef VOLUME_TO_BE_CACHED
volume_id := $(shell docker volume ls -q -f label=cache=true -f name=$(VOLUME_TO_BE_CACHED))
volume_already_cached = $(info $(VOLUME_TO_BE_CACHED) already cached)
volume_used_by_containers := $(shell docker ps -q -a -f volume=$(VOLUME_TO_BE_CACHED))
define create_volume
	$(foreach container,$(volume_used_by_containers),docker rm $(container) -f &&) echo done container remove
	docker volume rm $(VOLUME_TO_BE_CACHED) -f
	docker volume create $(VOLUME_TO_BE_CACHED) --label cache=true
endef
ifdef VOLUME_APPLY_CHMOD
define apply_chmod
	docker run --rm -v $(VOLUME_TO_BE_CACHED):/$(VOLUME_TO_BE_CACHED) busybox chmod 777 /$(VOLUME_TO_BE_CACHED)
endef
endif
define volume_not_cached
$(create_volume)
$(apply_chmod)
endef
volume_cache_logic := $(if $(volume_id),$(volume_already_cached),$(volume_not_cached))
else
volume_cache_logic = $(error VOLUME_TO_BE_CACHED should be specified)
endif
setup-volume-cache:
	$(volume_cache_logic)

docker-login:
	@docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD) $(DOCKER_REGISTRY)
	@docker login -u "$(DOCKER_CACHE_LOGIN)" -p "$(DOCKER_CACHE_PASSWORD)" "$(DOCKER_CACHE_URL)"


docker-logout:
	@docker logout $(DOCKER_REGISTRY)
	@docker logout "$(DOCKER_CACHE_URL)"


setup-linux:
	$(MAKE) -f "$(COMMON_MAKEFILE)" setup-volume-cache VOLUME_TO_BE_CACHED=gradle_linux VOLUME_APPLY_CHMOD=1

docker-clean:
	$(DOCKER_COMPOSE) down --rmi local -v
	$(DOCKER_COMPOSE) rm -f -v

GRADLE_OPTS := --stacktrace --info --no-daemon
GRADLEW := ./gradlew $(GRADLE_OPTS)

DOCKER_COMPOSE_LINUX := docker-compose -f docker-compose.yml

LINUX_x64 := $(DOCKER_COMPOSE_LINUX) run -w /webserver_agent apache_agent_centos6-x64 
LINUX_i686 := $(DOCKER_COMPOSE_LINUX) run -w /webserver_agent apache_agent_centos6-i686 

set-build-number: ## Set the build number for Webserver Agent
	@echo "##teamcity[setParameter name='AGENT_VERSION' value='$(shell ./scripts/get-next-version-number.sh webserver_agent)']"
	@echo "##teamcity[setParameter name='HEAD_SHA' value='$(shell ./scripts/get-head-sha.sh)']"
ifneq ($(strip $(RELEASE_BUILD)),)
	@echo "##teamcity[buildNumber '$(shell ./scripts/get-next-version-number.sh webserver_agent)-{build.number}']"
endif

clean-linux: DOCKER_COMPOSE = $(DOCKER_COMPOSE_LINUX)
clean-linux: docker-clean

clean-sonar: clean-linux

## CODE ANALYSIS TASKS

sonar-analysis: clean-linux setup-linux ## run Sonar analysis on linux machine
	$(LINUX_x64) $(GRADLEW) sonar -DenableCoverage=true

## BUILD TASKS

build-x64: clean-linux setup-linux
	$(LINUX_x64) $(GRADLEW) assembleWebServerAgent

build-i686: clean-linux setup-linux
	$(LINUX_i686) $(GRADLEW) assembleWebServerAgent

## RELEASE TASKS

publishToPortal: clean-linux setup-linux ## Run Linux x64 build task
	$(LINUX_x64) $(GRADLEW) -DagentName="webserver-sdk" publishToDownloadPortal

setGitTag:
	@echo $(shell ./scripts/create-git-tag.sh apache_agent)
