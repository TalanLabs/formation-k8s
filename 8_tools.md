# Outils 


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



