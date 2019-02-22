FROM buildpack-deps:jessie

ENV HELM_VERSION v2.5.0
ENV IAM_AUTH_VERSION 1.11.5
ENV HELM_VERSION v2.9.0
ENV TERRAFORM_VERSION 0.11.11

USER root

# Run package update and install some basics
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
		python-dev

# install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
		echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list  && \
		apt-get update  && \
		apt-get install -y kubectl && \
		ln -s /usr/bin/kubectl /usr/local/bin/kubectl

# install helm
RUN curl -o helm-$HELM_VERSION-linux-amd64.tgz https://storage.googleapis.com/kubernetes-helm/helm-$HELM_VERSION-linux-amd64.tar.gz && \
		tar -zxvf helm-$HELM_VERSION-linux-amd64.tgz && \
		mv linux-amd64/helm /usr/local/bin/helm

# install aws
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# install aws-iam-authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/$IAM_AUTH_VERSION/2018-12-06/bin/darwin/amd64/aws-iam-authenticator && \
		chmod +x ./aws-iam-authenticator && \
		cp ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# install jq to parse json within bash scripts
RUN curl -o /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq && \
  chmod +x /usr/local/bin/jq

# install kubeseal
RUN release=$(curl --silent "https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p') && \
		wget https://github.com/bitnami-labs/sealed-secrets/releases/download/$release/kubeseal-linux-amd64 && \
		install -m 755 kubeseal-linux-amd64 /usr/local/bin/kubeseal

# install terraform
RUN curl -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
		ls -alh && \
		unzip terraform.zip && \
		chmod +x terraform && \
		mv terraform /usr/local/bin/terraform

ADD ./scripts /src/scripts
RUN mkdir /src/scripts_shared

CMD ./src/scripts/run.sh
