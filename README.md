# github-runner
Create a GitHub runner container image

## Building an image

The container image needs to know the repository to use and uses an API token to connect to it in order to get a GitHub runner registration token. These can be supplied during the container build, or when the container is run. Examples of both commands can be found below:

***Note:*** Do not include secret information on build if you are planning on storing the container image in a public repository. Instead build the base container and specify the secret information when running the container. 

`docker build --build-arg="REPO=NicholasCote/github-runner" --build-arg="TOKEN=${GITHUB_TOKEN}" -t ncote/github-runner .`

`docker run -e REPO=NicholasCote/github-runner -e TOKEN=${GITHUB_TOKEN} ncote/github-runner`