# bahmni-infra-utils
Non-application specific utilities for Bahmni infra

## 📦 [container-scanner.sh](./container-scanner.sh)

This shell script automates the process of scanning container images from a specific Docker organization (in this case, bahmni) using the Trivy vulnerability scanner. The script retrieves a list of Docker repositories from Docker Hub and runs Trivy scans on each image to generate security reports. These reports are saved as HTML files in a designated directory.

To use this script:

1. Save the script as container-scanner.sh.
2. Make the script executable by running the following command in your terminal:
    ```
    chmod +x container-scanner.sh
    ```
3. Run the script to generate the scan report of container images from Bahmni namespace.

    Example usage:
    ```
    ./container-scanner.sh
    ```

    **_NOTE:_** Replace `./container-scanner.sh` with the actual path to your script file if it's located in a different directory.

## 📦 [html.tpl](./html.tpl)

The provided HTML template is used by the Trivy vulnerability scanner in the `container-scanner.sh` script to generate detailed reports on container images. The template is responsible for formatting the vulnerability and misconfiguration data produced by Trivy scans into an easily readable and visually structured HTML document.

## 📦 [setArtifactVersion.sh](./setArtifactVersion.sh)

This is used in Github Actions to set `ARTIFACT_VERSION` as an environment variable in the actions runner.
The version would be set as follows:
- If the push is a tag the version would be the tag name.
- If the push is on a branch named `release-<version>` then the version would be `<version>-rc`.
- If the push is on any other branch, then the version would be `<version>-<github_run_number>`. The version will be read from `package/.appversion`.

## 📦 [transifex.sh](./transifex.sh)

This script simplifies the process of managing translations for Bahmni projects. It is used for pushing and pulling translations to/from Transifex. It checks if the Transifex CLI is installed, and if not, installs it. Then, it performs the specified Transifex operation (push or pull) based on the provided argument.

To use this script:

1. Save the script in your repository.
2. Make sure to have a `.tx/config` file in your repository for Transifex configuration.
3. Make the script executable by running the following command in your terminal:
    ```
    chmod +x transifex.sh
    ```
4. Run the script with the appropriate argument (push or pull) to perform the desired operation.

    Example usage:
    ```
    ./transifex.sh push
    ./transifex.sh pull
    ```

    **_NOTE:_** Replace `./transifex.sh` with the actual path to your script file if it's located in a different directory.

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
