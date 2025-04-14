https://www.justinpolidori.it/posts/20211127_tekton/
https://tekton.dev/docs/dashboard/install/#installing-tekton-dashboard-on-kubernetes

##
```console
cat ~/.ssh/known_hosts | base64
cat ~/.ssh/_priv_key_| base64
cat ~/.ssh/config | base64
```
## Tekton

```console
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml
brew install tektoncd-cli
tkn hub install task git-clone
```
## Pipeline
```console
kubectl apply -f ./cluster/tekton-pipelines/show-readme.yaml
kubectl apply -f ./cluster/tekton-pipelines/build-flyway.yaml
kubectl apply -f ./cluster/tekton-pipelines/build.yaml
kubectl apply -f ./cluster/tekton-pipelines/build-run.yaml
```

## Argo CD

```console
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/heads/master/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
