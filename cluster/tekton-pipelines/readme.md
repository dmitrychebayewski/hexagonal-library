https://www.justinpolidori.it/posts/20211127_tekton/
https://tekton.dev/docs/dashboard/install/#installing-tekton-dashboard-on-kubernetes
https://gist.github.com/trisberg/37c97b6cc53def9a3e38be6143786589

## Tekton

```console
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml
brew install tektoncd-cli
tkn hub install task git-clone
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

```console
docker run -v $(pwd):/workspace  \
    gcr.io/kaniko-project/executor:latest \
    --dockerfile=/workspace/Dockerfile  \
    --context=/workspace \
    --destination=registry.dev.svc.cluster.local:5000/hello \
    --insecure-registry=registry.dev.svc.cluster.local:5000 \
    --insecure --verbosity=trace
docker \
    run -v $(pwd):/build \
    -v /var/lib/containers1:/var/lib/containers:Z \
    quay.io/buildah/stable \
    buildah build \
    --storage-driver=vfs \
    --layers \
    --file Dockerfile \
    --tag hello:0.0.1 
```

"InsecureRegistry": [
"10.96.0.0/12",
"registry.dev.svc.cluster.local:5000"
]
