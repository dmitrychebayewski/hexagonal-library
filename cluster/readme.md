## Why is deployment to a K8S-compatible cluster interesting?

Kubernetes (/ˌk(j)uːbərˈnɛtɪs, -ˈneɪtɪs, -ˈneɪtiːz, -ˈnɛtiːz/), 
also known as K8s is an open-source container orchestration system for automating software deployment, scaling, and management.
Deploying the code to a K8S-compatible cluster compared to on-premises deployment assumes either:
- DevOps
- GitOps
- or Infrastructure As Code mind-skillset. 

As for the benefits, here they are to mention a few: 
>GitOps: Changes to configuration can be managed using code review practices, and can be rolled back using version-controlling. Essentially, all of the changes to a code are tracked, bookmarked, and making any updates to the history can be made easier. As explained by Red Hat, "visibility to change means the ability to trace and reproduce issues quickly, improving overall security."

>Infrastructure As Code: Reducing THe Effort And Risk of making changes to infrastructure 

## But why this workshop?

My experience with deployment into any cloud as software developer, either with "DevOps", or "Platform Engineering" 
or even with "Rebranded sysop" led to a few well-known frustrations.
Very often, software developers are set under pressure by the "devops cycle".
You've built a solution that meets the customer's needs and so you have to deploy it to an unknown (=challenging your knowledge), 
very complex (=tightened-up) infrastructure with weird (=highly optimised) stack. You have strict deadlines.
Next to your own software solution, very often you have to deliver:
- an extension of a "deployment code"
- and an extension of a "build pipeline code"
- or a new deployment
- or even a new CI/CD pipeline
- or even a new infrastructure
- and make it all work together!

Hoe win je je technische hobbels in een onbekende stack over? 
So how do you win over your technical hurdles in an unknown stack?
One of the tactics that worked for me was:
>Keep building (the infrastructure as code), but in the environment that you are your own boss, where you're allowed to make failures - and fix them! 
>When it works - put it to the real world as soon as possible!

That's how we came to Docker Desktop and Minikube.
[Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download) is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes.
Minikube is compatible with a family of the orchestrators including OpenShift and Kubernetes cluster

### What are the alternatives to minikube and docker
>Podman is an alternative to Docker

> Kubeadm, kind, k3s are anno 2025 alternatives to minikube

## Start Using The Code

Assuming that your development environment meets the following prerequisites:
- Windows 11 with recent WSL or Mac Os
- Docker desktop
- minikube
- kubectl

start the workshop!
Given you are familiar with Java, know how to set up TCP/IP networking and DNS, it will take you from 15 to 240 minutes to complete 
the exercise.

### Building Spring Boot Application With Flyway Migration InitContainer 

Why is Flyway migration with InitContainer interesting? Decoupling the database migration from Spring boot startup cycle
is a step forward towards zero-downtime deployment.
InitContainer is a special container (we can consider it a co-container to a pod) 
that run to completion during Pod initialization.
Some ideas for how to use init containers (await a service, pre-fetch data) make a suggestion 
that we can prepare Flyway migrations with an init container.

Before we try to automate the entire deployment,
it is important to see every single K8S piece working locally according to the specification!
We'll need to see the following crucial points in the cluster working:
- Environment variables, keeping the passwords, in the cluster are set up;
- Environment variables, keeping the configuration values (config maps) are set up; 
- Disk storage (volumes) is provisioned;
- Database container (postgres) is set up.

### Start Minikube
First start your Docker desktop. Then start execute the following commands.
A tricky thing with minikube: you have to create a cluster with a insecure registry set up inside a cluster!
As minikube uses an own Docker process, it is logical to create an insecure (avoiding a lot of checks) Docker registry
for your testing purposes. 
The following command parameters take care that a registry with 'registry.dev.svc.cluster.local' host name and port 5000 is set up in the cluster
 - -insecure-registry registry.dev.svc.cluster.local:5000
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
### Configure Your Docker To Push Images to Your Cluster's Registry
Eval (or Windows powershell | Invoke-Expression) command makes a local docker use minikube environment
(to build an image directly and populate your cluster with it).
#### Mac Os
```console
eval $(minikube docker-env)
```
#### Windows 11
```console
PS: & minikube -p minikube docker-env --shell powershell | Invoke-Expression
```

### Make The Initial DB Baseline

```console
$ kubectl apply -f ./cluster/db-migration/util/db-baseline.yaml
```

### Deploy The Application
You have to deploy your solution so that the database is initialised even before the cluster start up to wind your app.
You can achieve it with [InitContainer](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) pattern.

#### Build the init container
Go to the [infrastructure/src/main/resources/db-migration](../infrastructure/src/main/resources/db-migration), delivered with the application code
and build the db-migration image. The image will be automatically pushed to the cluster.
[Dockerfile](../infrastructure/src/main/resources/db-migration/Dockerfile) is a spec how to build an "all-in-one" mini-app
fulfilling the specific need (import the database changes with FlyWay).
```console
docker build -t db-migration .
```
#### Build the app container
Go to root [hexagonal-library](..) and build the port-adapter service as spring boot application. 
```console
docker build -t hexagonal-service .
```
Finally, deploy the application.

#### Deploy The App
```console
kubectl apply -f ./cluster/hexagonal-deployment.yaml
kubectl apply -f ./cluster/hexagonal-load-balancer-service.yaml
```
Check the application is up and running with a command:
```console
kubectl get pods
```
### Build Yor App With Tekton CI/CD Pipelines
Now we'll build the pipeline building db-migration and hexagonal-service (the latter under construction).

[Go to ->](./tekton-pipelines/readme.md)

### Links
- [comparing 8 ways to push your image into a minikube cluster](https://minikube.sigs.k8s.io/docs/handbook/pushing/)
- [With Helm](https://medium.com/@hijessicahsu/deploy-postgres-on-minikube-5cd8f9ffc9c)
- [With Istio-ingres](https://medium.com/swlh/deploy-spring-boot-app-on-kubernetes-minikube-on-macos-df410ef858c8)
- [Postgres in minikube from Scratch](https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster)
- [Flyway init container master class](https://blog.sebastian-daschner.com/entries/flyway-migrate-databases-managed-k8s)
- [Github for the previous one](https://github.com/sdaschner/zero-downtime-kubernetes/tree/db-migrations)
- [Mystery of env variables and namespaces in Flyway](https://documentation.red-gate.com/fd/environments-namespace-277578909.html)
