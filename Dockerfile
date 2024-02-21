# Trying to get GitHub Runner working to build container images
FROM ubuntu:latest

ARG RUNNER_VERSION="2.313.0"
ARG DEBIAN_FRONTEND=nointeractive
ARG REPO=default
ARG TOKEN=secretinformation

# Provide the Repo and token at run time
ENV TOKEN=${TOKEN} \
    REPO=${REPO}
    
RUN apt-get update -y && apt-get upgrade -y && useradd -m podman

RUN rm -rf ~/.local/share/containers && \
    usermod --add-subuids 200000-201000 --add-subgids 200000-201000 podman

RUN apt-get install -y --no-install-recommends \
    buildah \
    ca-certificates \
    curl \
    jq \
    build-essential \
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

RUN cd /home/podman && mkdir actions-runner && cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    chown -R podman ~podman && /home/podman/actions-runner/bin/installdependencies.sh 

COPY start.sh start.sh

RUN chmod +x start.sh

USER podman

ENTRYPOINT ["./start.sh"]