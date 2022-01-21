#!/usr/bin/env bash
# Note: Making change in this file might require making change to the get-latest-tag.sh script.
# This script returns the next version number to be released
# Currently versions are tagged using fully qualified release version (FQV) {Year}.{Month}.{Date}-{TeamCitySequentialBuildNumber}
# The next version number has format xx.xx.xx
set -e

Year=$(date +"%y")
Month=$(echo $(date +"%m"))
CURRENT_MINOR_VERSION=${Year}.${Month##0}
tag_prefix=$1-${CURRENT_MINOR_VERSION}
tag=$(git tag -l "${tag_prefix}*" --sort=-taggerdate)
version=${tag: ${#1} + 1}
if [[ $version == "${CURRENT_MINOR_VERSION}"* ]]; then
    IFS='.-'
    read -ra version_array <<< "${version}"
    version_array[2]=$((version_array[2]+1))
    echo "${version_array[0]}.${version_array[1]}.${version_array[2]}"
else
    echo "${CURRENT_MINOR_VERSION}.0"
fi
