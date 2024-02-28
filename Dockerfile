# Trying to get GitHub Runner working to build container images
FROM ubuntu:latest

ARG RUNNER_VERSION="2.313.0"
ARG DEBIAN_FRONTEND=nointeractive
ARG REPO=default
ARG TOKEN=secretinformation

# Provide the Repo and token at run time
ENV TOKEN=${TOKEN} \
    REPO=${REPO}
    
RUN apt-get update -y && apt-get upgrade -y && useradd -m builder

# Add user ids to allow rootless builds
RUN usermod --add-subuids 100000-165535 --add-subgids 100000-165535 builder

VOLUME /var/lib/containers
VOLUME /home/podman/.local/share/containers

RUN apt-get install -y --no-install-recommends \
    buildah \
    ca-certificates \
    curl \
    jq \
    build-essential \
    fuse-overlayfs \
    git \
    libssl-dev \
    libffi-dev \
    podman \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    uidmap \
    slirp4netns

RUN cd /home/builder && mkdir actions-runner && cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    chown -R builder ~builder && /home/builder/actions-runner/bin/installdependencies.sh 

COPY start.sh start.sh

RUN chmod +x start.sh

USER builder

ENTRYPOINT ["./start.sh"]