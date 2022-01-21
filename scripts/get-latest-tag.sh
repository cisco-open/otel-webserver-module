#!/usr/bin/env bash
# Note: Making change in this file might require making change to the get-next-version-number.sh script.
# This script return the last successful git tag for the provided input
# Ex for invocation ./get-lastest-tag.sh nodejsagent
#   This returns the numeric components of last successful
#   git tag of the format nodejsagent-[0-9]+.[0-9]+.[0-9]+
#   If last tag in the repository that matches the format is nodejsgent-4.5.23.
#   This will return 4.5.23
# Note: If no git tag exist for the provided input that matches the format, it returns
#   currentYear.currentMonth.0
set -e

year=`date +%C`
month=`date +%m`
CURRENT_MINOR_VERSION=${year}.${month##0}
tag_prefix=$1-"[0-9]*.[0-9]*.[0-9]*"
tag=$(git tag -l "${tag_prefix}" --sort=-taggerdate)
version=${tag: ${#1} + 1}

if [ -n "$version" ]; then
  IFS='.'
  read -ra version_array <<< "${version}"
  version_len=${#version_array[@]}
  latest_version="${version_array[0]}"
  for (( i=1; i<$version_len; i++ )); do latest_version="${latest_version}.${version_array[i]}" ; done
  echo "${latest_version}"
else
  echo "${CURRENT_MINOR_VERSION}.0"
fi
