# Pod

## Objectif

* creation et manipulation des images via des pods


## Création d'une ressource Pod


Création via les arguments de `kubectl` 

```bash
k run mypod --image=busybox
```


> nb: on évite la création de resources directement via les arguments..
> les fichiers permettent de reproduire, modifier , partager et versionner facilement nos configurations


K8 permet de générer des configurations à partir d'une commande CLI avec `--dry-run=client` 

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

Exécution de la configuration

```bash
k create -f pod.yaml

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

les containeurs n'ont pas de terminal (tty) attaché par défaut, il faut le rajouter (dans notre cas)


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


## Exercices

* créer un pod avec un nom différent de l'image 
* se connecter au pod et afficher les variables d'environnment
* détruire le pod 

## A retenir 

* Créer un pod n'est pas très différent de la commande Docker ou Podman
* A ce stade, l'intérêt de K8 est plus que discutable 

