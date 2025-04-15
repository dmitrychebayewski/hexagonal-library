### Working With Spring Boot Application With Flyway Migration In Your Minikube Environment 

Why is Flyway migration with InitContainer interesting?

Decoupling the database migration from Spring boot startup cycle
is a step forward towards zero-downtime deployment.

InitContainer is a special container (we can consider it a co-container to a pod) 
that run to completion during Pod initialization.

Some ideas how for how to use init containers (await a service, pre-fetch data) make a suggestion
that we can prepare Flyway migrations with an init container.

For testing a deployment of a spring boot application we'll need:
- [a spring boot application](../README.md);
- Docker;
- a local implementation of Kubernetes, for example, Minikube.

Before we try to automate the entire infrastructure deployment,
it is vert important to see every single K8S yaml descriptor working locally according to the specification.
We'll need to complete the following crucial points in the cluster:
- Set up environment variables, keeping the passwords, in the cluster;
- Set up the configuration maps; 
- Set up the storage;
- Set up the database;
- (optionally) set up the  sealed secrets;
- make the initial database baseline in the cluster.

### Start Minikube

```console
kubectl config use-context minikube
minikube start --insecure-registry registry.dev.svc.cluster.local:5000
minikube addons enable registry
minikube dashboard
```
### Set Up Environment Variables In The Cluster

Replace the stars in the example with your own passwords.
```console
kubectl create secret generic flyway-secret --from-literal=FLYWAY_PASSWORD=********
kubectl create secret generic postgres-secret --from-literal=POSTGRES_PASSWORD=********
kubectl create secret generic hexagonal-secret --from-literal=SPRING_DATASOURCE_PASSWORD=********
```

### Set Up The Configuration Maps
```console
kubectl apply -f ./cluster/postgres/postgres-configmap.yaml
kubectl apply -f ./cluster/db-migration/flyway-configmap.yaml
kubectl apply -f ./cluster/hexagonal-configmap.yaml
```
### Set Up The Storage
```console
kubectl apply -f ./cluster/postgres/persistent-volume.yaml
```
### Set Up The Postgres DB
[more about postgres](postgres/postgres.md)
```console
kubectl apply -f ./cluster/postgres/extensions/postgres-stateful-set.yaml
kubectl apply -fcluster/postgres/extensions/postgres-load-balancer-service.yaml
```
### Configure Your Docker To Understand Your Cluster
#### Linux
```console
eval $(minikube docker-env)
```
#### Powershell
```console
PS: & minikube -p minikube docker-env --shell powershell | Invoke-Expression
```

### Make The Initial DB Baseline

```console
$ kubectl apply -f ./cluster/db-migration/util/db-baseline.yaml
```
Eval (or Windows powershell | Invoke-Expression) command makes a local docker use minikube environment 
(to build an image directly and populate your cluster with it).

### Deploy The Application
#### Build the init container
Go to infrastructure/src/main/resources/db-migration
```console
docker build -t db-migration .
```
#### Build the app container
Go to root (hexagonal-library)
```console
docker build -t hexagonal-service .
```
#### Deploy The App
```console
kubectl apply -f ./cluster/hexagonal-deployment.yaml
kubectl apply -f ./cluster/hexagonal-load-balancer-service.yaml
```
### Links
- [comparing 8 ways to push your image into a minikube cluster](https://minikube.sigs.k8s.io/docs/handbook/pushing/)
- [With Helm](https://medium.com/@hijessicahsu/deploy-postgres-on-minikube-5cd8f9ffc9c)
- [With Istio-ingres](https://medium.com/swlh/deploy-spring-boot-app-on-kubernetes-minikube-on-macos-df410ef858c8)
- [Postrges in minikube from Scratch](https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster)
- [Flyway init container master class](https://blog.sebastian-daschner.com/entries/flyway-migrate-databases-managed-k8s)
- [Github for the previous one](https://github.com/sdaschner/zero-downtime-kubernetes/tree/db-migrations)
- [Mystery of env variables and namespaces in Flyway](https://documentation.red-gate.com/fd/environments-namespace-277578909.html)
