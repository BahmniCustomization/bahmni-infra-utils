#!/bin/bash
set -e

checkIfTagExists(){
  version=$1
  tagCount=$(curl -s https://api.github.com/repos/$GITHUB_REPOSITORY/tags | jq --arg tagName "$version"  '[.[] | select( .name == $tagName)] | length')
  if [ $tagCount -gt 0 ]; then
    echo "Error: Version $version already released. Please update your version in package/.appversion"
    exit 1
  fi
}

setVersionAsGithubEnv(){
  version=$1
  echo "Setting version $version"
  echo "ARTIFACT_VERSION=$version" >> $GITHUB_ENV
}

case $GITHUB_REF in
  refs/tags/*)
      echo "Current action is for tag.."
      setVersionAsGithubEnv "$GITHUB_REF_NAME"
      ;;
  refs/heads/release-*)
      echo "Current action is for release branch.."
      version=$(echo $GITHUB_REF_NAME | cut -d '-' -f 2)
      checkIfTagExists "$version"
      setVersionAsGithubEnv "$version"-rc
      ;;
  *)
      echo "Current action is neither tag nor release branch.."
      version=$(cat package/.appversion)
      checkIfTagExists "$version"
      setVersionAsGithubEnv "$version-$GITHUB_RUN_NUMBER"
      ;;
esac
