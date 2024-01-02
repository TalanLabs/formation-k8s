# Volumes


## Objectif

* comprendre les volumes éphémères
* manipuler les volumes pour partager des fichiers de configuration / secret


## Les volumes éphémères 

[Documentation sur les volumes éphémères](https://kubernetes.io/docs/concepts/storage/ephemeral-volumes/) 

C'est un type de volume qui permet d'injecter des fichiers dans un container. Les modifications sur ces fichiers ne seront pas conservées lors d'un restart.
Il est souvent utilisé pour injecter de la configuration.


## Mount Path


Création d'un point de montage alimenté par une configmap

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - image: alpine
    name: my-pod
    command: ['sh', '-c', 'echo Container 1 is Running ; sleep 3600']
    volumeMounts:
    - mountPath: /data
      name: data-volume

  volumes:
  - name: data-volume
    configMap:
      name: config
```

La configmap définissant les fichiers

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: config
data:
  whatever.txt: |
    hello
```

Afficher le contenu de `/data`

```bash
k exec -it mypod -- /bin/sh

ls /data
whatever.txt


cat /data/whatever.txt
hello
```


## Exercices 

L'image du `frontend` de l'application a été déployée sur un registry ECR. Son nom est: `810454728139.dkr.ecr.eu-west-3.amazonaws.com/k8-chatroulette-front:latest`
Elle contient un backend qui expose un endpoint sur le port `8080` sur le path `/`.


L'image du `backend` de l'application a été déployée sur un registry ECR. Son nom est: `810454728139.dkr.ecr.eu-west-3.amazonaws.com/k8-chatroulette-back:latest`
Elle contient un backend qui expose un endpoint sur le port `3000` sur le path `/version`

L'application `backend` possede deux variables d'environment permettant de sauvegarder les images sur disque: `APP_STORAGE`  et `DB_DIRECTORY`

* créer un déploiement pour le back
* créer un déploiement pour le front
* créer un config map configurant les variables d'environments avec les valeurs `APP_STORAGE=fs` et `DB_DIRECTORY=/images` 
* ajouter un point de montage sur le path `/images`
* lancer un port-forward sur le port 8080
* ouvrir http://localhost:8080 sur un navigateur

## A retenir 

* chaque pod est monté avec un volume éphémère, détruit avec le pod
* il est courant de monter des configmap / secrets dans les containers

