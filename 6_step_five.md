# Volumes


## Objectif

* comprendre les différents types de volumes
* manipuler les volumes pour stocker des données 
* manipuler les volumes pour partager des fichier de configuration / secret


## Les différents types de volume 

TODO 

* volume ephémère vs persistant


## Volume


Partage d'un volume entre containers d'un même pod (ie: sidecar)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - image: alpine
    name: my-pod-1
    command: ['sh', '-c', 'echo Container 1 is Running ; sleep 3600']
    volumeMounts:
    - mountPath: /data
      name: data-volume

  - image: alpine
    name: my-pod-2
    command: ['sh', '-c', 'echo Container 2 is Running ; sleep 3600']
    
    volumeMounts:
    - mountPath: /data2
      name: data-volume


  volumes:
  - name: data-volume
    emptyDir: {}
```

Afficher les logs des containers 

```bash
k logs mypod -c my-pod-1 

k logs mypod -c my-pod-2
```

Ecrire un fichier dans le volume partagé `/data`  depuis `my-pod-1` 

```bash
k exec -it mypod -c my-pod-1  -- /bin/sh

cd /data
echo 'hello' > whatever.txt
```

Lire le contenu depuis le meme volume partagé `/data2`  de `my-pod-2` 

```bash
k exec -it mypod -c my-pod-2  -- /bin/sh

cd /data2
cat whatever.txt
```

