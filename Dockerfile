# Trying to get GitHub Runner working to build container images
FROM quay.io/podman/stable:latest

ARG RUNNER_VERSION="2.314.1"
ARG DEBIAN_FRONTEND=nointeractive
ARG REPO=default
ARG TOKEN=secretinformation

# Provide the Repo and token at run time
ENV TOKEN=${TOKEN} \
    REPO=${REPO}

# Install jq and git
RUN dnf -y update; yum -y install jq git python

RUN cd /home/podman && mkdir actions-runner && cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    chown -R podman ~podman && /home/podman/actions-runner/bin/installdependencies.sh 

COPY start.sh start.sh

RUN chmod +x start.sh

USER podman

ENTRYPOINT ["./start.sh"]