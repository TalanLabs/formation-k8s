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

Une image a été déployée sur un registry ECR. Son nom est: `810454728139.dkr.ecr.eu-west-3.amazonaws.com/formation-k8s-front:latest`
Elle contient un frontend qui expose un endpoint sur le port 3000 sur le path `/`


Pour pouvoir appeler le backend, le conteneur a besoin du fichier `/app/build/env.js` dont le contenu est:
```js
window.__ENV__ = {
  BACK_URL: "http://#HOSTNAME_OF_MY_BACKEND#/api"
}
```

* créer un déploiement avec une instance du frontend
* Créer une configmap avec le contenu de env.js
* ajouter un point de montage sur le path `/app/build`
* lancer un port-forward sur le port 3000
* ouvrir http://localhost:3000 sur un navigateur
* Le flag du backend doit s'afficher

## A retenir 

* chaque pod est monté avec un volume éphémère, détruit avec le pod
* il est courant de monter des configmap / secrets dans les containers

