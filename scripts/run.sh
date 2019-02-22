#!/bin/bash

show_help() {
cat << EOF
This image has the following tools installed:

  * Kubectl - kubectl
  * Helm - helm
  * AWS cli - aws
  * AWS iam authenticator - aws-iam-authenticator
  * Sealed secrets cli - kubeseal
  * Terraform - terraform
  * JQ - jq

You can use them in the follwoing fashion:

  docker run nearform/noise-cli:0.0.2 terraform

You can use all commands directly by executing this in a shell:

  mkdir -p ~/cloud-cli && \
  docker run --rm -d --name cloud-cli -v ~/cloud-cli:/src/scripts_shared nearform/noise-cli:0.0.2 /src/scripts/keepalive && \
  export PATH=~/cloud-cli/:$PATH

This will add all the tools to your path

To stop the comtainer, run:

  ./~/cloud-cli/stop
EOF
}

show_help

