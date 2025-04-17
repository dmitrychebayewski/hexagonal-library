## Argo CD
Argo CD is a declarative, GitOps continuous delivery tool (both for your application and deployment code)
for Kubernetes or OpenShift cluster.
With argo Cd your deployment continuously delivered to yur customer!

### Install Argo CD
```console
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/heads/master/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

### Argo CD deployment triggers
//TODO verification
To [trigger](https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/triggers/) The trigger defines the condition when the notification should be sent) a new deployment in Argo CD when you make changes to your Kubernetes YAML files, you need to ensure that Argo CD detects the changes and applies them to the cluster.

### Trigger a Sync Manually (Optional)
If you want to trigger a sync manually, you can do so using the Argo CD CLI or the Argo CD UI.

#### Using the Argo CD CLI
```console
argocd app sync my-app
```

#### Using the Argo CD UI
Navigate to the Argo CD UI.
Select your application.
Click on the "Sync" button.
### Automate Sync with Auto-Sync Policy
You can configure Argo CD to automatically sync changes from your Git repository. 
This is done by setting the syncPolicy in your Application resource.

### Troubleshooting
If the changes are not being applied, check the following
 - Ensure that the Git repository and path are correctly configured in the Application resource
 - Verify that the changes are committed and pushed to the correct branch 
 - Check the Argo CD logs for any errors or warnings.
```console 
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller
```
By following these steps, you should be able to trigger a new deployment in Argo CD when you make changes 
to your Kubernetes YAML files.