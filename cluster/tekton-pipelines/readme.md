## Why are Tekton CI/CD Pipelines interesting?
[Tekton](https://tekton.dev) is an open-source framework for creating CI/CD systems, 
allowing developers to build, test, and deploy across cloud providers.
As a developer you are challenged with building, extending, optimizing the cloud-native CI/CD pipelines.
Who but yourself could build a better pipeline that carefully delivers the features, that you have built, to the customer? 
If you're daily deploying to a K8S or a compatible (OpenShift) cluster, most likely your pipelines are built with Tekton.
As you install tekton in your local development environment, you explore how easily and precisely the pipelines are built. 

## Useful Links
 - [Installing Tekton Dashboard](https://tekton.dev/docs/dashboard/install/#installing-tekton-dashboard-on-kubernetes)
 - [Tekton dashboard](http://localhost:8001/api/v1/namespaces/tekton-pipelines/services/tekton-dashboard:http/proxy/#/tasks)

## Start Using The Code

Assuming that your development environment meets the following prerequisites:
- Windows 11 wit recent WSL or MacOs
- Docker desktop
- minikube
- kubectl
- tkn (tekton CLI)
install tekton in your cluster.

Given you are familiar with Java, know how to set up TCP/IP networking and DNS and you are getting more and more familiar 
with minikube, it will take you from 30 to 240 minutes to complete the exercise.

## Tekton Tasks
Tekton hub has a variety of well-tested pre-packaged tasks such as git-clone and curl.
CURL is very useful to see whether desirable endpoints are reachable.
So let's start using Tekton!

Below is a mixed way of installing tekton and a few tekton tasks: with kubectl as yaml or with tkn CLI.
```console
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml
brew install tektoncd-cli
tkn hub install task git-clone
tkn hub install task curl
```
## Build Your Pipeline
Your pipeline will in the first go consist of three small steps:
- get your code from Git;
- build the image from your source;
- push the image to the internal docker registry known to the cluster

Let's create our pipeline!

```console
kubectl apply -f ./cluster/tekton-pipelines/show-readme.yaml
kubectl apply -f ./cluster/tekton-pipelines/build-flyway.yaml
kubectl apply -f ./cluster/tekton-pipelines/build.yaml
```
Let's start a proxy:
```console
kubectl proxy 
```
and see the pipeline configured using the [Tekton dashboard](http://localhost:8001/api/v1/namespaces/tekton-pipelines/services/tekton-dashboard:http/proxy/#/tasks)
Basically we have configured a tiny pipeline as described in a Tekton guide 
[Build and push an image with Tekton](https://tekton.dev/docs/how-to-guides/kaniko-build-push/)

The workshop differs slightly from the guideline.
Anno 2025 both Kaniko and Buildah are both very popular tools.
kaniko and buildah both don't depend on a Docker daemon and execute each command within a Dockerfile completely in userspace.
This enables building container images in environments that can't easily or securely run a Docker daemon,
such as a standard Kubernetes or Openshift cluster.
Kaniko seems to be Tekton first choice, but we'll focus on buildah (separate steps for build and push).

Now let's create a pipeline run!

```console
kubectl create -f ./cluster/tekton-pipelines/build-run.yaml
```
and see it working on a Tekton dashboard.

### Troubleshooting
In the first instance, investigate logs using the following commands
```console
kubectl get pods
kubectl logs <pod>
```
Otherwise, fetch the logs using the minikube dashboard
```console
minikube dashboard
```
### Troubleshooting building Docker images inside a pod

The tricky thing, both Kaniko and Buildah make a ping to (insecure) Docker registry 
[endpoint, configured in the cluster](build-flyway.yaml) before pushing an image.
So basically if the endpoint is not reachable, kaniko or buildah will gracefully fail the job.
How to know the endpoint so that it is pingable?
Well, for the time being use the IP address that you can obtain fron the minikube console -> services (all namespaces) -> registry.

### Troubleshooting routing issues with curl
Configure and run a curl task to debug your endpoints within the cluster:
[curl-run](task-runs/curl-run.yaml)

Here a decent readme explaining how to set up your local Docker registries.
- [Gist explaining how the Docker insecure registry is accessed both from the host and the cluster](https://gist.github.com/trisberg/37c97b6cc53def9a3e38be6143786589)

## More work to do (under construction...)
## [-> Go to Argo CD](../git-ops/readme.md)

## Tools
Running test build inside minikube
Go to minikube
```console
minikube ssh
docker run -v $(pwd):/workspace  \
    gcr.io/kaniko-project/executor:latest \
    --dockerfile=/workspace/Dockerfile  \
    --context=/workspace \
    --destination=10.244.0.4:5000/hello \
    --insecure-registry=10.244.0.4:5000 \
    --insecure --verbosity=trace
```
You can create Dockerfile using one of examples below
### Sample Dockerfile to play with
```dockerfile
FROM node:14
WORKDIR /usr/src/app
COPY package*.json app.js ./
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]

```
```dockerfile
FROM openjdk:11-jre-slim as builder
WORKDIR application
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM openjdk:11-jre-slim
WORKDIR application
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/spring-boot-loader/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
```
