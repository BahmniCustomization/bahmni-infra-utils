# bahmni-infra-utils
Non-application specific utilities for Bahmni infra

## 📦 [setArtifactVersion.sh](./setArtifactVersion.sh)

This is used in Github Actions to set `ARTIFACT_VERSION` as an environment variable in the actions runner.
The version would be set as follows:
- If the push is a tag the version would be the tag name.
- If the push is on a branch named `release-<version>` then the version would be `<version>-rc`.
- If the push is on any other branch, then the version would be `<version>-<github_run_number>`. The version will be read from `package/.appversion`.
