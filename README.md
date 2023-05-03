# bahmni-infra-utils
Non-application specific utilities for Bahmni infra

## 📦 [setArtifactVersion.sh](./setArtifactVersion.sh)

This is used in Github Actions to set `ARTIFACT_VERSION` as an environment variable in the actions runner.
The version would be set as follows:
- If the push is a tag the version would be the tag name.
- If the push is on a branch named `release-<version>` then the version would be `<version>-rc`.
- If the push is on any other branch, then the version would be `<version>-<github_run_number>`. The version will be read from `package/.appversion`.

## 📦 [trivy_scan.sh](./trivy_scan.sh)

This script can be used in Github Actions to run a [Trivy Filesystem scan](https://aquasecurity.github.io/trivy/v0.19.2/vulnerability/scanning/filesystem/) and [Secrets Scan](https://aquasecurity.github.io/trivy/v0.27.1/docs/secret/scanning/).
Here are the instructions for how to use it:
- You can add the following step to your Github Actions workflow:
    ```
    - name: Trivy Scan
        run: |
          wget -q https://raw.githubusercontent.com/Bahmni/bahmni-infra-utils/main/trivy_scan.sh && chmod +x trivy_scan.sh
          ./trivy_scan.sh
          rm trivy_scan.sh.sh
    ```
This will download the script from the Github repository, make it executable, run it, and then remove it. You can also pass command line arguments to the script in this workflow step to specify the paths to scan.
```
./trivy_scan.sh <path> <path> 
```
