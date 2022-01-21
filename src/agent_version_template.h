#ifndef __agent_version_h
#define __agent_version_h

#define AGENT_BUILD_NUMBER "$jenkinsBuildNumber"
#define AGENT_SHA1 "$headSHA1"
#define AGENT_VERSION_ "$agentVersion"
#define RELEASE_ "$agentRelease"
#define FULL_AGENT_VERSION_ "$fullVersion"

static const char AGENT_VERSION[] =
    AGENT_VERSION_ RELEASE_  AGENT_BUILD_NUMBER AGENT_SHA1;

static const char FULL_AGENT_VERSION[] =
    FULL_AGENT_VERSION_;

#endif

