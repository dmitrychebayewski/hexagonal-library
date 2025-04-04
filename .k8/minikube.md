https://medium.com/@hijessicahsu/deploy-postgres-on-minikube-5cd8f9ffc9c
https://medium.com/@jerome.decoster/kubernetes-init-container-pattern-minikube-39eceece084
https://medium.com/swlh/deploy-spring-boot-app-on-kubernetes-minikube-on-macos-df410ef858c8
https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster

https://blog.sebastian-daschner.com/entries/flyway-migrate-databases-managed-k8s
https://documentation.red-gate.com/fd/environments-namespace-277578909.html
https://github.com/sdaschner/zero-downtime-kubernetes/tree/db-migrations

$docker run -p 5432:5432 \                         
-e POSTGRES_PASSWORD=postgres \
-e POSTGRES_USER=postgres \
-e POSTGRES_DB=postgres \
postgres:17

$kubectl config use-context minikube
$minikube start — vm-driver=virtualbox
$minikube dashboard
$cd hexagonal-library
$eval $(minikube docker-env)
$docker build -t hexagonal-service .
$kubectl apply -f .k8/hexagonal-deployment.yaml
$kubectl create secret generic flyway-secret --from-literal=FLYWAY_PASSWORD=********
$kubectl create secret generic postgres-secret --from-literal=POSTGRES_PASSWORD=********



##Accessing Host
$ minikube ssh "route -n | grep ^0.0.0.0 | awk '{ print $2 }'"
After the addon is enabled, please run "minikube tunnel" and your ingress resources would be available at "127.0.0.1"