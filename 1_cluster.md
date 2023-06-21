# Configurer et accéder au cluster 

* manipuler le cluster avec kubectl
* comprendre les namespaces


## Kubectl

Création d'un alias pour simplifier l'écriture des commandes

```bash
alias k=kubetcl
```

> nb: pas requis, mais fait gagner du temps sur des commandes parfois longues..

## Commandes importantes

Aide de kubectl  

```bash
k --help
```

Aide sur la ressource Pod

```bash
k explain pods
```

Pour lister tous les types de ressources et leur alias 

```bash
kubectl api-resources
```

Pour lister toutes les ressources existantes (ici, tous les pods) 

```bash
kubectl get pods
```

Pour créer ou modifier une ressource en utilisant un fichier de description 

```bash
kubectl apply -f mypod.yml
```

Pour supprimer une ressource en utilisant (ici, un pod qui s'appelle mypod) 

```bash
kubectl delete pod mypod
```

Pour obtenir des détails sur une ressource (très utile pour le debug) 

```bash
kubectl describe pod mypod
```

Pour modifier une ressource, [kubectl patch](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/update-api-object-kubectl-patch/)
avec la spécification [jsonpath](https://jsonpatch.com/)

## Connection au cluster

Kubectl utilise un fichier `~/.kube/config`  pour stocker les informations du cluster 

* Serveurs (IP, CA Cert, Nom)
* Users (Nom, Certificat, Clé)
* Context, association d'un user et d'un Serveurs

```bash
cat ~/.kube/config
```


## Namespace

Lister les namespaces

```bash
k get ns  
```



Création d'un nouveau namespace `learnk8` en ligne de commande

```bash
k create ns learnk8
```

Supprimer un Namespace

```bash
k delete ns learnk8
```

Recommandé : création d'un nouveau namespace via fichier de spécification Yaml

```bash
 k create ns learnk8 --dry-run=client -o yaml > namespace.yaml
```

```bash
cat namespace.yaml

apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: learnk8
spec: {}
status: {}
vagrant@mast
```

Appliquer cette config à notre cluster

```bash
k apply -f namespace.yaml

namespace/learnk8 created
```

Voir les informations du namespace, dont les limites, quotas, etc

```bash
kubectl describe namespace learnk8

Name:         learnk8
Labels:       kubernetes.io/metadata.name=learnk8
Annotations:  <none>
Status:       Active

No resource quota.

No LimitRange resource.
```


Vérifer le contexte et cluster courant

```bash
k config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.0.0.10:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    namespace: learnk8
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
```

Tips: possible de cibler le champ avec le format `jsonpath`

```bash
k config view -o jsonpath='{.contexts[].context.namespace}'
```


## Plus d'infos 

* [Doc officielle : Accéder au cluster](https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster/)
