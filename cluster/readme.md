### Working With Spring Boot Application with Flyway Migration in your Minikube Environment 

Why is Flyway migration with InitContainer interesting?

Decoupling the database migration from Spring boot startup cycle
is one step forward towards zero-downtime deployment.

InitContainer is a special container (we can consider it a co-container to a pod) 
that run to completion during Pod initialization.

Some ideas how for how to use init containers (await a service, pre-fetch data) make suggestion
that we can prepare Flyway migration with an init container.

For testing a deployment of a spring boot application we'll need a spring boot application,
Docker and a local implementation of Kubernetes, for example, Minikube.
Also, we'll need a few manual actions for setting up our environment variables, keeping the passwords.

### Start Minikube

$kubectl config use-context minikube
$minikube start — vm-driver=virtualbox
$minikube dashboard

### Build the Spring Boot Application from a project root
$cd cluster
$eval $(minikube docker-env)
$docker build -t hexagonal-service .

Eval command makes a local docker use minikube environment (to build an image directly to your cluster).

### Keeping the secret passwords in the kubernetes secrets

Replace the stars in the example with your own passwords.

$kubectl create secret generic flyway-secret --from-literal=FLYWAY_PASSWORD=********
$kubectl create secret generic postgres-secret --from-literal=POSTGRES_PASSWORD=********
$kubectl create secret generic hexagonal-secret --from-literal=SPRING_DATASOURCE_PASSWORD=********


### Links
https://medium.com/@hijessicahsu/deploy-postgres-on-minikube-5cd8f9ffc9c
https://medium.com/@jerome.decoster/kubernetes-init-container-pattern-minikube-39eceece084
https://medium.com/swlh/deploy-spring-boot-app-on-kubernetes-minikube-on-macos-df410ef858c8

https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster

https://blog.sebastian-daschner.com/entries/flyway-migrate-databases-managed-k8s
https://github.com/sdaschner/zero-downtime-kubernetes/tree/db-migrations

https://documentation.red-gate.com/fd/environments-namespace-277578909.html