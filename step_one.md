# Commandes basiques


## Kubectl

Création d'un alias pour simplifier l'écriture des commandes

```bash
alias k=kubetcl
```

Et ne pas oublier 

```bash
# aide de kubectl  
k --help

# aide sur la ressource Pod
k explain pods

# aide sur l'exectution de la commande run d'un pod
k run pod --help
``` 

Pour lister tous les types de ressources et leur alias :

```bash
kubectl api-resources
```


## Infos du cluster

Afficher les infos du cluster

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
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
```


## Namespace

Lister les namespaces

```bash
k get ns  
```

Création d'un nouveau namespace de façon impérative

```bash
k create ns learnk8
```

Création d'un nouveau namespace via fichier de spécification Yaml

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


Utilisation du context

```bash
k config set-context --current --namespace=learnk8
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

Tips, possible de cibler le champ avec le format `jsonpath`

```bash
k config view -o jsonpath='{.contexts[].context.namespace}'
```


## création d'un pod

nb: on évite la création impérative. les fichiers permettent de reproduire, modifier , partager et versionner facilement nos configurations

```bash
k run mypod --image=busybox --dry-run=client -o yaml > pod.yaml

cat pod.yaml
 
apiversion: v1
kind: pod
metadata:
  creationtimestamp: null
  labels:
    run: mypod
  name: mypod
spec:
  containers:
  - image: busybox
    name: mypod
    resources: {}
  dnspolicy: clusterfirst
  restartpolicy: always
status: {}

```

exécution

```bash
k apply -f pod.yaml

pod/mypod created

```

vérifions les pods créés

```bash
k get pods -o wide
```


execution d'une commande dans le pod

```bash
kubectl exec -it mypod -- /bin/bash
```

error !

```bash
mypod   0/1     crashloopbackoff   5 (60s ago)   4m14s   172.16.158.2   worker-node02   <none>           <none>
```

les containeurs n'ont pas de terminale (tty) attaché par défaut, il faut le rajouter (dans notre cas)


ajoutons l'option  `tty` dans `pod.yaml`  

```bash
  containers:
  - image: busybox
    name: mypod
    resources: {}
    tty: true
  dnspolicy: clusterfirst
```

appliquons les changements

```bash
k apply -f pod.yaml
```

execution du shell dans le container

```bash
kubectl exec -it mypod -- /bin/sh
```



todo : request limit ?
