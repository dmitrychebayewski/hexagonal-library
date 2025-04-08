### Postrges As Stateful Set - Load Balancer

Why is StatefulSet an interesting option to consider for your postgres as pod?
Well, read this if you naively think that postgres as pod just works as expected.
There are a lot of things to consider (data integrity on restart etc).
[The bottom line](https://stackoverflow.com/questions/68516778/if-i-declare-2-replicas-of-postgresql-statefulset-pods-in-k8s-are-they-the-same):
```
More common would be to use the volumeClaimTemplate system so each pod gets its own distinct storage. Then you set up Postgres streaming replication yourself.
Or look at using an operator which handles that setup (and probably more) for you.
```
[Postgres Stateful Set](https://www.bmc.com/blogs/kubernetes-postgresql/)

### Port forwarding
```console
$ kubectl port-forward svc/postgres 5432:5432
```