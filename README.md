# github-runner
Create a GitHub runner container image

## Building an image

The container image needs to know the repository to use and uses an API token to connect to it in order to get a GitHub runner registration token. These can be supplied during the container build, or when the container is run. Examples of both commands can be found below:

***Note:*** Do not include secret information on build if you are planning on storing the container image in a public repository. Instead build the base container and specify the secret information when running the container. 

`docker build -t ncote/github-runner .`

`docker run -e REPO=NicholasCote/github-runner -e TOKEN=${GITHUB_TOKEN} ncote/github-runner`

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