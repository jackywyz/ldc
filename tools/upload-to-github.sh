#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <tag> <file> (and GITHUB_TOKEN environment variable)"
  exit 1
fi
if [[ "$CIRRUS_RELEASE" == "" ]]; then
  echo "Not a release. No need to deploy!"
  exit 0
fi

artifact=$2
artifactFilename=$(basename $artifact)
 
echo "Uploading $artifact to GitHub release $CIRRUS_TAG ($CIRRUS_RELEASE)..."
curl -s \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/octet-stream" \
  --data-binary @$artifact \
  https://uploads.github.com/repos/$CIRRUS_REPO_FULL_NAME/releases/$CIRRUS_RELEASE/assets?name=$artifactFilename
