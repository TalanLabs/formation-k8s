# Configmap


```bash
kubectl create configmap app-config --from-literal=PORT=4000 --dry-run=client -o yaml > config.yaml

apiVersion: v1
data:
  PORT: "3000"
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: language

```
```bash
k create -f config.yaml

configmap/app-config created
```


```bash
k get configmaps

NAME               DATA   AGE
app-config         1      97s
kube-root-ca.crt   1      4d18h
``` 

```bash
Name:         app-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
PORT:
----
4000

BinaryData
====

Events:  <none>
```


Associer un configmap à un container

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-env
spec:
  containers:
    - name: test-env
      image: gcr.io/google_containers/busybox
      command: [ "/bin/sh", "-c", "env" ]
      env:
        - name: PORT
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: PORT
  restartPolicy: Never
```

```bash
k create -f pod.yaml
```

NB : En cas d'erreur, `k describe pod test-env` 


Regardez les logs du containeur

```bash
k logs test-env

KUBERNETES_PORT=tcp://172.17.0.1:443
KUBERNETES_SERVICE_PORT=443
MYNGINX_PORT_80_TCP=tcp://172.17.24.238:80
HOSTNAME=busybox
SHLVL=1
HOME=/root
PORT=4000
MYNGINX_SERVICE_HOST=172.17.24.238
TERM=xterm
```



## Secret 


```bash
k create secret generic apikey --from-literal=API_KEY=123–456 --dry-run=client -o yaml > secret.yaml
```

```bash
k create -f secret.yaml

secret/apikey created
```


```bash
k get secret apikey

NAME     TYPE     DATA   AGE
apikey   Opaque   1      8s
```

```bash
k describe secret apikey
Name:         apikey
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
API_KEY:  9 bytes
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-env
spec:
  containers:
    - name: test-env
      image: gcr.io/google_containers/busybox
      command: [ "/bin/sh", "-c", "env" ]
      env:
      - name: API_KEY
          valueFrom:
            secretKeyRef:
              name: apikey
              key: API_KEY
  restartPolicy: Never
```


```bash
k logs test-env
KUBERNETES_SERVICE_PORT=443
MYNGINX_PORT_80_TCP=tcp://172.17.24.238:80
KUBERNETES_PORT=tcp://172.17.0.1:443
HOSTNAME=test-env
SHLVL=1
HOME=/root
MYNGINX_SERVICE_HOST=172.17.24.238
TERM=xterm
KUBERNETES_PORT_443_TCP_ADDR=172.17.0.1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_PORT_443_TCP_PORT=443
MYNGINX_SERVICE_PORT=80
MYNGINX_PORT=tcp://172.17.24.238:80
KUBERNETES_PORT_443_TCP_PROTO=tcp
API_KEY=123–456
```

!NB : la valeur du secret est visible ! 
