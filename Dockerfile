# Trying to get GitHub Runner working to build container images
FROM ubuntu:latest

ARG RUNNER_VERSION="2.314.1"
ARG DEBIAN_FRONTEND=nointeractive
ARG REPO=default
ARG TOKEN=secretinformation
# Use 1001 and 121 for compatibility with GitHub-hosted runners
ARG RUNNER_UID=1000
ARG DOCKER_GID=1001
ARG XDG_RUNTIME_DIR=/run/user/${UID}

# Provide the Repo and token at run time
ENV TOKEN=${TOKEN} \
    REPO=${REPO}

RUN useradd -m runner && \
    usermod --add-subuids 100000-165535 --add-subgids 100000-165535 runner

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    build-essential \
    buildah \
    ca-certificates \
    curl \
    fuse-overlayfs \
    git \
    jq \
    libssl-dev \
    libffi-dev \
    podman \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    uidmap \
    slirp4netns

RUN cd /home/runner && mkdir actions-runner && cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh 

COPY start.sh start.sh

RUN chmod +x start.sh

USER runner

ENTRYPOINT ["./start.sh"]