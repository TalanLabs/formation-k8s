# Service

La notion de service est une couche d'astraction qui permet d'exposer une application qui tourne sur plusieurs noeuds



Création d'un service qui expose le port  `80` pour notre application `myngninx`

```bash
k expose deploy mynginx --port 80 --dry-run=client -o yaml > service.yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: mynginx
  name: mynginx
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: mynginx
status:
  loadBalancer: {}
```

```bash
k create -f service.yaml

service/mynginx created
```

Listons les services

```bash
k get svc

NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   172.17.0.1      <none>        443/TCP   4d
mynginx      ClusterIP   172.17.24.238   <none>        80/TCP    3s
```

Pour en savoir plus sur les propriétés créés pour notre service 

```bash
k describe service mynginx

Name:              mynginx
Namespace:         default
Labels:            app=mynginx
Annotations:       <none>
Selector:          app=mynginx
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                172.17.24.238
IPs:               172.17.24.238
Port:              <unset>  80/TCP
TargetPort:        80/TCP
Endpoints:         172.16.158.11:80,172.16.87.200:80,172.16.87.201:80
Session Affinity:  None
Events:            <none>
```

A noter que le type de service est `Type : Cluster IP` 


Testons notre service nginx sur cette ip (toujour depuis le cluster dans vagrant)

```bash
curl 172.17.24.238

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
Nous avons bien un service dont l'ip reste fixe mais avec des conteneurs qui peuvent varier en nombre ou autre en fonction des déploiements


Testons d'accéder au service depuis le système host

```bash
curl 172.17.24.238

timeout
```

=> le réseau n'est pas accessible depuis l'extérieur du cluster avec un service de type `ClusterIp` 



