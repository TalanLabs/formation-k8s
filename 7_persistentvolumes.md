# Volumes


## Objectif

* comprendre les volumes persistent
* manipuler les volumes pour stocker des données 


## Les volumes persistants 


[Documentation sur les volumes K8](https://kubernetes.io/fr/docs/concepts/storage/volumes/) 
[Documentation sur les volumes persistants](https://kubernetes.io/fr/docs/concepts/storage/persistent-volumes/) 

Il existe de nombreux volumes providers (AWS EBS, Azure Disk, point de montage NFS...).
Un volume persistant permet de conserver des données indépendamment du cycle de vie.
Comme pour les autres volumes, il peut être partagé entre plusieurs volumes.


## PersistentVolume

Un PersistentVolume, ou PV, est un type de ressource qui permet de s'interfacer avec un espace de stockage. 
Il permet de réserver un espace et de signaler au cluster sa disponibilité pour une utilisation ultérieure.

Exemple avec AWS EFS
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mypv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: efs-sc
  csi:
    driver: efs.csi.aws.com
    volumeHandle: <FILE_SYSTEM_ID:PATH>
```

Il existe plusieurs Access Modes:
* ReadOnlyMany: accès en lecture seule par plusieurs nodes
* ReadWriteMany: accès en lecture écriture par plusieurs nodes
* ReadWriteOnce: accès en lecture écriture par un node. Peut être utilisé par plusieurs pods sur le même node.

L'option `persistentVolumeReclaimPolicy` permet de dire ce qu'on fera du volume lorsqu'il ne sera plus utilisé: 
* Retain: Le volume et ses données sont conservés, mais il n'est plus utilisable par un nouveau pod. Seule une opération manuelle pourra le rendre disponible.
* Delete: Le volume et les données sont supprimés
* Recycle (deprecated): les données sont supprimées, le volume est de nouveau disponible 

`storageClassName` et `csi` donnent des contraintes sur l'espace de stockage à utiliser.

## PersistentVolumeClaim

Un PersistentVolumeClaim, ou PVC, permet d'informer au cluster qu'on a besoin d'un stockage. 
K8S se charger de trouver un PV qui correspond aux spécifications du PVC et d'associer le PVC au PV

Exemple avec AWS EFS
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: efs-sc
  resources:
    requests:
      storage: 100Mi
```

## Utilisation du PVC par le Pod

Exemple avec un volume initialisé dans un initContainer
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - image: alpine
    name: my-pod
    command: ['sh', '-c', 'cat /data/file ; sleep 3600']
    volumeMounts:
    - mountPath: /data
      name: data-volume
  initContainers:
  - image: create-file
    name: my-pod
    command: ['sh', '-c', 'echo Coucou > /tmp/file']
    volumeMounts:
    - mountPath: /tmp
      name: data-volume
  volumes:
    - name: data-volume
      persistentVolumeClaim:
        claimName: mypvc
```

## Exercices 

L'image du `frontend` de l'application a été déployée sur un registry ECR. Son nom est: `810454728139.dkr.ecr.eu-west-3.amazonaws.com/k8-chatroulette-front:latest`
Elle contient un backend qui expose un endpoint sur le port `8080` sur le path `/`.


L'image du `backend` de l'application a été déployée sur un registry ECR. Son nom est: `810454728139.dkr.ecr.eu-west-3.amazonaws.com/k8-chatroulette-back:latest`
Elle contient un backend qui expose un endpoint sur le port `3000` sur le path `/version`

L'application `backend` possede deux variables d'environment permettant de sauvegarder les images sur disque: `APP_STORAGE`  et `DB_DIRECTORY`

* Un pv qui utilise un EFS a été créé pour chaque utilisateur. Afficher la specification yaml de son pv
* créer un PVC
* Dans la configmap du back, ajouter une variable `APP_STORAGE` (resp `DB_DIRECTORY`) avec la valeur `fs` (resp `/images`).
* Ajouter le pv au deployment du `backend` sur le mount path `/images`

> Ne pas hésiter à utiliser la commande `kubectl exec` pour explorer le filesystem des pods

## A retenir 

* le volume permet de persister des données et de les partager
* il existe de multitudes d'abstraction de filesystem (ex Aws S3, Azure Blog, etc)

## Pour aller plus loin

Dans une application statefull, on privilégiera le [StatefulSet](https://kubernetes.io/fr/docs/concepts/workloads/controllers/statefulset/) au Deployment
