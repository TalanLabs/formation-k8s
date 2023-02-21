# Déploiement


TODO: schema

Le déploiement est à un niveau d'abstraction supérieur au pod
Il permet de gérer le cycle de vie des application en définissant les images, nombre de pods et d'autes paramètres


```bash
k create deployment --image=nginx mynginx --dry-run=client -o yaml > deployment.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: mynginx
  name: mynginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mynginx
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: mynginx
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
status: {}
```

> Noter que la valeur de `replicas` est à `1` 


Execution de notre déploiement

```bash
k create -f deployment.yaml

deployment.apps/mynginx created
```

Regardons l'état de nos déploiements

```bash
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
mynginx   1/1     1            1           34s
```

Plus de détail avec `-o wide`

```bash
k get deploy -o wide

NAME      READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES   SELECTOR
mynginx   1/1     1            1           3m31s   nginx        nginx    app=mynginx
```


Pour en savoir plus sur les propriétés utilisés par K8 lors du déploiement 

```bash
k describe deploy mynginx

Name:                   mynginx
Namespace:              default
CreationTimestamp:      Mon, 20 Feb 2023 12:30:38 +0000
Labels:                 app=mynginx
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=mynginx
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=mynginx
  Containers:
   nginx:
    Image:        nginx
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   mynginx-56766fcf49 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  111s  deployment-controller  Scaled up replica set mynginx-56766fcf49 to 1
```


A noter la propriété `StrategyType: RollingUpdate` 

Le déploiement repose sur de `replicaset`

```bash
k get replicaset

NAME                 DESIRED   CURRENT   READY   AGE
mynginx-56766fcf49   1         1         1       8m14s
```


Si l'ont souhaite augment le nombre de pods

```yaml
# other code
spec:
  replicas: 3
```

```bash
k apply -f deployment.yaml 
```

```bash
k get deployment

NAME      READY   UP-TO-DATE   AVAILABLE   AGE
mynginx   3/3     3            3           12m
```

Se connecter à un des pods

```bash
k get pods

NAME                       READY   STATUS    RESTARTS   AGE
mynginx-56766fcf49-7b6pw   1/1     Running   0          6m49s
mynginx-56766fcf49-7z68l   1/1     Running   0          6m49s
mynginx-56766fcf49-kcszt   1/1     Running   0          18m
mypod                      1/1     Running   0          90m
mypodbis                   1/1     Running   0          30m
```

```bash
k exec -it mynginx-56766fcf49-kcszt -- /bin/sh

nginx -V
nginx version: nginx/1.23.3
built by gcc 10.2.1 20210110 (Debian 10.2.1-6)
```

Changement de version de l'image nginx utilisée 

```yaml
    spec:
      containers:
        - image: nginx:1.19
          name: nginx
          resources: {}
```

```bash
k apply -f deployment.yaml 
```

```bash
k get pods

NAME                       READY   STATUS              RESTARTS   AGE
mynginx-56766fcf49-7b6pw   1/1     Running             0          12m
mynginx-56766fcf49-kcszt   1/1     Running             0          24m
mynginx-6d9c57cffd-nwbbj   0/1     ContainerCreating   0          1s
mynginx-6d9c57cffd-t9ds2   1/1     Running             0          11s
```

```bash
k rollout status deployment/mynginx

deployment "mynginx" successfully rolled out
```

Afficher l'historique des déploiements

```bash
k rollout history deployment/mynginx
deployment.apps/mynginx
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```

Revenir au déploiement précédent

```bash
k rollout undo deployment/mynginx

deployment.apps/mynginx rolled back
```

Cela recréer une autre version, ici la 3ème

```bash
k rollout history deployment/mynginx
deployment.apps/mynginx
REVISION  CHANGE-CAUSE
2         <none>
3         <none>
```


Afficher les logs des pods de notre deploiement

```bash
k 

```

A noter, le nom des pods contient le hash des replicaset

```bash
k get rs -o wide

NAME                 DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES       SELECTOR
mynginx-56766fcf49   0         0         0       44m   nginx        nginx        app=mynginx,pod-template-hash=56766fcf49
mynginx-6d9c57cffd   3         3         3       19m   nginx        nginx:1.19   app=mynginx,pod-template-hash=6d9c57cffd
```

```bash
k get pods --show-labels

NAME                       READY   STATUS    RESTARTS   AGE     LABELS
mynginx-6d9c57cffd-55ccv   1/1     Running   0          3m28s   app=mynginx,pod-template-hash=6d9c57cffd
mynginx-6d9c57cffd-7mmwf   1/1     Running   0          3m23s   app=mynginx,pod-template-hash=6d9c57cffd
mynginx-6d9c57cffd-df8q2   1/1     Running   0          3m26s   app=mynginx,pod-template-hash=6d9c57cffd
```


Pour streamer les logs de nos pods

```bash
k logs -f -l app=mynginx
```

## Conclusion 

Nous avons bien des pods déployés avec l'image nginx

En revanche, à chaque déploiement, l'ip de nos containers va changer...

Nous allons mettre en place à notion de [service](./step_three.md)
