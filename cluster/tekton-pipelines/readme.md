## Useful Links
 - [Installing Tekton Dashboard](https://tekton.dev/docs/dashboard/install/#installing-tekton-dashboard-on-kubernetes)
 - [Tekton dashboard](http://localhost:8001/api/v1/namespaces/tekton-pipelines/services/tekton-dashboard:http/proxy/#/tasks)

## Tekton
Tekton hub has a lot of pre-packaged tasks such as git-clone and curl.
CURL is very useful to see whether desirable endpoints are reachable.

```console
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml
brew install tektoncd-cli
tkn hub install task git-clone
tkn hub install task curl
```
## Build Pipeline
```console
kubectl apply -f ./cluster/tekton-pipelines/show-readme.yaml
kubectl apply -f ./cluster/tekton-pipelines/build-flyway.yaml
kubectl apply -f ./cluster/tekton-pipelines/build.yaml
kubectl create -f ./cluster/tekton-pipelines/build-run.yaml
```

## Argo CD

```console
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/heads/master/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
### Building Docker images inside a pod
Anno 2025 both Kaniko and Buildah are the popular tools.
Kaniko seems to be Tekton first choice.
Also it is *easy* to run as image.
The tricky thing, Kaniko and Buildah want to see endpoints configured in the cluster.
Here a decent readme explaining how to set up your local Docker registries.
- [Gist explaining how the Docker insecure registry is accessed both from the host and the cluster](https://gist.github.com/trisberg/37c97b6cc53def9a3e38be6143786589)

```console
docker run -v $(pwd):/workspace  \
    gcr.io/kaniko-project/executor:latest \
    --dockerfile=/workspace/Dockerfile  \
    --context=/workspace \
    --destination=10.244.0.4:5000/hello \
    --insecure-registry=10.244.0.4:5000 \
    --insecure --verbosity=trace
```
### Sample Dockerfile to play with
```nano
FROM node:14
WORKDIR /usr/src/app
COPY package*.json app.js ./
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]

```
