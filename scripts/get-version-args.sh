#!/bin/bash

BUILD_NUMBER="$(date +%s)"
echo -n "--build-number $BUILD_NUMBER "

if [[ "$IS_WEEKLY" = 1 ]]; then
  BUILD_NAME="Weekly $(date -d "$WEEKLY_EPOCH" +%Y-%U)"
  BUILD_SEMVER="$(date -d "$WEEKLY_EPOCH" +%Y.%U)"
fi

if [[ -n "$PATCH_VERSION" ]]; then
	BUILD_NAME+=".$PATCH_VERSION"
	BUILD_SEMVER+=".$PATCH_VERSION"
fi

if [[ -n "$BUILD_SEMVER" ]]; then
  echo -n "--build-name $BUILD_SEMVER "
fi

if [[ -n "$BUILD_NAME" ]]; then
  echo -n "--dart-define=VERSION_NAME=$BUILD_NAME "
fi