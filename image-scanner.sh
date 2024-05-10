#!/bin/bash

# Container scanning is the process of analyzing components within containers to uncover 
# potential security threats. It is integral to ensuring that the software remains secure 
# as it progresses through the application life cycle. Container scanning takes its cues 
# from practices like vulnerability scanning and penetration testing.

# This script uses Trivy, a simple and comprehensive vulnerability scanner for containers
# and other artifacts. Trivy can find vulnerabilities, IaC misconfigurations, secrets, 
# SBOM discovery, Cloud scanning, Kubernetes security risks, and more. 
# More information about Trivy can be found at https://trivy.dev/.

# This shell script automates the process of scanning container images from a specific Docker 
# organization (passed in, as an argument) using the Trivy vulnerability scanner. The script 
# retrieves a list of Docker repositories from Docker Hub and runs Trivy scans on each image 
# to generate security reports. These reports are saved as HTML files in a designated directory.

# Check if the organization name is provided as an argument
if [ -z "$1" ]; then
    echo "Error: Please provide the Docker organization name as an argument."
    echo "Usage: $0 <organization_name>"
    exit 1
fi

# Get Docker Organization Name from the script argument
ORG="$1"

# Check if trivy is installed and install it if not
if ! command -v trivy &> /dev/null; then
    echo "Trivy is not installed. Installing..."
    wget https://github.com/aquasecurity/trivy/releases/download/v0.51.1/trivy_0.51.1_Linux-64bit.deb
    sudo dpkg -i trivy_0.51.1_Linux-64bit.deb
else
    echo "Found trivy, using trivy v$(trivy -v | cut -d ' ' -f 2)"
fi

echo "Retrieving repository list ..."
REPO_LIST=$(curl -s "https://hub.docker.com/v2/repositories/${ORG}/?page_size=100" | jq -r '.results|.[]|.name')

# Get today's date in the desired format for folder naming
TODAY_DATE=$(date +'%d-%m-%Y')
# Define the root and sub directory name
ROOT_DIR="image-scanner-reports"
DIR="bahmni-${TODAY_DATE}"

# Create the root and sub directory if it doesn't exist
mkdir -p "$ROOT_DIR/$DIR"

echo "Generating scan report...."

# Iterate through each image and run Trivy scan
for image in $REPO_LIST; do
    # Replace '/' with '-' in the image name
    image_name=$(echo "$image" | tr '/' '-')

    # Define the Output File
    output_file_txt="$ROOT_DIR/${DIR}/${image}-${TODAY_DATE}.html"

    # Run Trivy scan on the image
    echo "Scanning image: $image"
    trivy image --severity HIGH,CRITICAL --format template --template "@html.tpl" --output "$output_file_txt" "${ORG}/$image_name"
    echo "" >> "$output_file_txt"

    # Check if Trivy scan was successful
    if [ $? -eq 0 ]; then
        echo "Trivy scan completed for $image."
    else
        echo "Error: Trivy scan failed for $image."
    fi
done