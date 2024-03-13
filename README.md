# github-runner
Create a GitHub runner container image that builds containers with rootless podman

```{note}
A GitHub API token is required to connect the runner to a repository. GitHub tokens can be generated at this [![link to creating API tokens](https://github.com/settings/tokens)]
```

[![GitHub Runner Build, Push, & Update](https://github.com/NicholasCote/github-runner/actions/workflows/gh-runner-build.yaml/badge.svg)](https://github.com/NicholasCote/github-runner/actions/workflows/gh-runner-build.yaml)

## GitOps CICD

This repository utilizes GitHub actions to build a new container image whenever changes are made, push that image to NSF NCAR's Harbor container registry, and update the Helm chart values.yaml file to use the new image tag. This repository is connected to the NSF NCAR instance of Argo CD and will automatically sync to use the new image.

## Building an image

The container image needs to know the repository to use and uses an API token to connect to it in order to get a GitHub runner registration token. These can be supplied during the container build, or when the container is run. Examples of both commands can be found below:

***Note:*** Do not include secret information on build if you are planning on storing the container image in a public repository. Instead build the base container and specify the secret information when running the container. 

`podman build -t hub.k8s.ucar.edu/ncote/github-runner:2024-03-06.21.38 .`

```
podman run -e REPO=NicholasCote/github-runner -e TOKEN=${GITHUB_TOKEN} hub.k8s.ucar.edu/ncote/github-runner:2024-03-06.21.38
```

## Using K8s Secrets

If you intend to deploy a GitHub runner to a Kubernetes cluster secrets can be utilized to inject the GitHub API token. Secrets can be created in a number of different ways. Add something like the following lines to your Deployment YAML file to include the secret in the GitHub runner image on run:

```yaml
        env:
        - name: REPO
          value: {{ .Values.webapp.repo }}
        - name: TOKEN
          valueFrom:
            secretKeyRef:
              name: ncote-github-token
              key: token
```

## Helm Chart

There is an example Helm chart in the gh-runner-helm/ directory. Update the values.yaml file with custom information for your own deployment.