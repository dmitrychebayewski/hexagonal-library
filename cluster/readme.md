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
$kubectl config use-context minikube
$minikube start — vm-driver=virtualbox
$minikube dashboard
```
### Set Up Environment Variables In The Cluster

Replace the stars in the example with your own passwords.
```console
$kubectl create secret generic flyway-secret --from-literal=FLYWAY_PASSWORD=********
$kubectl create secret generic postgres-secret --from-literal=POSTGRES_PASSWORD=********
$kubectl create secret generic hexagonal-secret --from-literal=SPRING_DATASOURCE_PASSWORD=********
```

### Set Up The Configuration Maps
```
$kubectl -f apply ./cluster/postgres/postgres-configmap.yaml, cluster/db-migration/flyway-configmap.yaml, cluster/hexagonal-configmap.yaml
```
### Set Up The Storage
```console
$kubectl -f apply cluster/postgres/persistent-volume.yaml

```
### Set Up The Postgres DB
[more about postgres](postgres/postgres.md)
```
$kubectl -f apply cluster/postgres/extensions/postgres-stateful-set.yaml, cluster/postgres/extensions/postgres-load-balancer-service.yaml
```
### Configure Your Docker To Understand Your Cluster

```linux
$eval $(minikube docker-env)
```

```powershell
PS: & minikube -p minikube docker-env --shell powershell | Invoke-Expression
```

### Make The Initial DB Baseline
From the cluster directory:
```console
$ kubectl apply -f db-migration/util/db-baseline.yaml
```
Eval (or Windows powershell | Invoke-Expression) command makes a local docker use minikube environment 
(to build an image directly and populate your cluster with it).

### Deploy The Application
#### Build the init container
Go to infrastructure/src/main/resources/db-migration
```
$docker build -t db-migration .
```
#### Build the app container
Go to cluster/
```
$docker build -t hexagonal-service .
```
#### Deploy The App
```
$ kubectl apply -f hexagonal-deployment.yaml, hexagonal-load-balancer-service.yaml
```
### Links
https://medium.com/@hijessicahsu/deploy-postgres-on-minikube-5cd8f9ffc9c
https://medium.com/swlh/deploy-spring-boot-app-on-kubernetes-minikube-on-macos-df410ef858c8
https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster
https://blog.sebastian-daschner.com/entries/flyway-migrate-databases-managed-k8s
https://github.com/sdaschner/zero-downtime-kubernetes/tree/db-migrations
https://documentation.red-gate.com/fd/environments-namespace-277578909.html