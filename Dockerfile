FROM alpine:latest

ENV GCLOUDSDK_VERSION="282.0.0"
ENV TERRAFORM_VERSION="0.12.21"
ENV PACKER_VERSION="0.9.0"
ENV KUBECTL_VERSION="v1.17.3"

# install a few nessersary packages 
RUN apk update \
  && apk add \
  curl \
  unzip \
  py-pip \
  git \
  jq

# install docker
# https://www.docker.com/
# https://docs.docker.com/compose/
RUN apk add \
  docker \
  docker-compose

# install awscli and aws sdk for python
# https://aws.amazon.com/cli/
# https://aws.amazon.com/sdk-for-python/
RUN pip install \
  awscli \
  boto3

# install ansible
# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
RUN apk add ansible

# install packer
# https://packer.io/
RUN curl -sSLo /tmp/packer.zip "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" \
  && unzip /tmp/packer.zip -d /usr/bin \
  && rm -f /tmp/packer.zip

# install terraform
# https://www.hashicorp.com/products/terraform/
RUN curl -sSLo /tmp/terraform.zip  "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  && unzip /tmp/terraform.zip -d /usr/bin \
  && rm -f /tmp/terraform.zip

# install gcloud 
# https://cloud.google.com/sdk/install
ENV PATH /usr/bin/google-cloud-sdk/bin:$PATH

RUN curl -sSLo /tmp/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUDSDK_VERSION}-linux-x86_64.tar.gz \
  && tar -C /usr/bin -zxvf /tmp/google-cloud-sdk.tar.gz google-cloud-sdk \
  && rm -f /tmp/google-cloud-sdk.tar.gz \
  && gcloud --version

# install kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
RUN curl -sSLo /tmp/kubectl "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL}/bin/linux/amd64/kubectl" \
  && chmod +x ./tmp/kubectl \
  && mv /tmp/kubectl /usr/bin/kubectl \
  && kubectl version --client
