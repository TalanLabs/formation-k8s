# Outils 


## Helm

[HELM](https://helm.sh/) est un gestionnaire de paquet pour K8

Vous pouvez trouver des configuration sur le [https://artifacthub.io](https://artifacthub.io/) 


### Exemple d'usage

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

Ajout du repositiry Bitnami

```bash
helm repo add myrepo https://charts.bitnami.com/bitnami

"myrepo" has been added to your repositories
```

Installation de la configuration Wordpress

```bash
helm install mywp myrepo/wordpress

NAME: mywp
LAST DEPLOYED: Thu Feb 23 09:12:19 2023
NAMESPACE: learnk8
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: wordpress
CHART VERSION: 15.2.45
APP VERSION: 6.1.1

** Please be patient while the chart is being deployed **

Your WordPress site can be accessed through the following DNS name from within your cluster:

    mywp-wordpress.learnk8.svc.cluster.local (port 80)

To access your WordPress site from outside the cluster follow the steps below:

1. Get the WordPress URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace learnk8 -w mywp-wordpress'

   export SERVICE_IP=$(kubectl get svc --namespace learnk8 mywp-wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
   echo "WordPress URL: http://$SERVICE_IP/"
   echo "WordPress Admin URL: http://$SERVICE_IP/admin"

2. Open a browser and access WordPress using the obtained URL.

3. Login with the following credentials below to see your blog:

  echo Username: user
  echo Password: $(kubectl get secret --namespace learnk8 mywp-wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)

```

```bash
 k get svc

NAME             TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
mywp-mariadb     ClusterIP      172.17.63.34   <none>        3306/TCP                     2m27s
mywp-wordpress   LoadBalancer   172.17.56.96   <pending>     80:32444/TCP,443:31872/TCP   2m27s

```

## Kustomize

Inclus dans `kubectl` kustomize permet de patcher et personnaliser des configurations


### Exemple d'usage 

Install binary (si pas dispo via `kubectl -k` )

```bash
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
```

Arborescence du dossier de nos configurations

```bash
kustomize/
├── deployment.yaml
├── kustomization.yaml
└── service.yaml
```

Le fichier `kustomization.yaml` contien des libellés qu'on veut appliquer à toutes nos ressources 

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

commonLabels:
  app: http-test-kustomize

resources:
  - service.yaml
  - deployment.yaml
```

Pour visualiser le résultat :

```bash
kustomize build kustomize

apiVersion: v1
kind: Service
metadata:
  labels:
    app: http-test-kustomize
  name: http-test-kustomize
spec:
  ports:
  - name: http
    port: 8080
  selector:
    app: http-test-kustomize
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: http-test-kustomize
  name: http-test-kustomize
spec:
  selector:
    matchLabels:
      app: http-test-kustomize
  template:
    metadata:
      labels:
        app: http-test-kustomize
    spec:
      containers:
      - image: nginx
        name: app
        ports:
        - containerPort: 8080
          name: http
          protocol: TCP
```
Appliquer et générer les ressources 

```bash
kubectl apply -k kustomize
```

[Documentation Kustomize](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/)



