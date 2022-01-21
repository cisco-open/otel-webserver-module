#ifndef __agent_version_h
#define __agent_version_h

#define AGENT_BUILD_NUMBER ""
#define AGENT_SHA1 "360f9767a1f479215eb45974da1c7f47a88481a0"
#define AGENT_VERSION_ "21.6.0"
#define RELEASE_ "GA"
#define FULL_AGENT_VERSION_ "WebServer Agent  v21.6.0 GA r360f9767a1f479215eb45974da1c7f47a88481a0: DEV-BUILD"

static const char AGENT_VERSION[] =
    AGENT_VERSION_ RELEASE_  AGENT_BUILD_NUMBER AGENT_SHA1;

static const char FULL_AGENT_VERSION[] =
    FULL_AGENT_VERSION_;

#endif

