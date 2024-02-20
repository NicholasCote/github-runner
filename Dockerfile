FROM ubuntu:latest

ARG RUNNER_VERSION="2.313.0"
ARG DEBIAN_FRONTEND=nointeractive
ARG REPO=default
ARG TOKEN=secretinformation

ENV TOKEN=${TOKEN} \
    REPO=${REPO}
    
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip

RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    podman

RUN cd /home/docker && mkdir actions-runner && cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER docker

ENTRYPOINT ["./start.sh"]