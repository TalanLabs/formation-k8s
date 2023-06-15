# Ingress

## Objectif 

## Ingress et Ingress Controller

Ingress (ou une entrée réseau), expose les routes HTTP et HTTPS de l'extérieur du cluster à des services au sein du cluster. 
Le routage du trafic est contrôlé par des règles définies sur la ressource Ingress.

```bash
    internet
        |
   [ Ingress ]
   --|-----|--
   [ Services ]
```

Un contrôleur d'Ingress est responsable de l'exécution de l'Ingress, généralement avec un load-balancer (équilibreur de charge),

> Un ingress sans controller n'a aucun effet 


Attention : 

un cluster déployé dans une VM comme vagrant ne peut pas fournir un service de type `Loadbalancer` 
On utilisera un service de type `ClusterIp`  

> L'ingress est version plus poussée des services de type `LoadBalancer`. 
> Il ajoute des fonctionnalités spécifiques au protocôle HTTP (redirection selon le path, gestion de certificats TLS, sticky session selon un bearer token...)

## Quelques exemples

Redirection selon le path de l'url
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
spec:
  rules:
    - http:
        paths:
          - path: /api1
            backend:
              service:
                name: service1
                port:
                  number: 80
            pathType: Prefix
          - path: /api2
            backend:
              service:
                name: service2
                port:
                  number: 80
            pathType: Prefix
```

Utilisation d'un certificat TLS
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: testsecret-tls
data:
  tls.crt: base64 encoded cert
  tls.key: base64 encoded key
type: kubernetes.io/tls
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
spec:
  tls:
    - hosts:
        - https-example.foo.com
      secretName: testsecret-tls
  rules:
    - host: https-example.foo.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: service1
                port:
                  number: 80
```

Utilisation d'un Load Balancer AWS
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
          - path: /
            backend:
              service:
                name: service1
                port:
                  number: 80
            pathType: Prefix

```

## Exercice

Un ingress controller qui gère les load balancer AWS a été installé sur le cluster 

* Créer un ingress pour AWS
* Rediriger le path `/api` vers le backend et le path `/` vers le frontend
* Dans la console AWS, retrouver le nom de domaine du Load Balancer
* Ouvrir le front dans son navigateur
* Changer en conséquence le `BACK_URL` dans la configmap

L'exercice s'arrête ici, mais dans un projet, on achète un nom de domaine qu'on redirige vers le Load Balancer. on génère aussi un certificat TLS correspondant au nom de domaine, on l'intègre dans l'ingress, et on redirige le trafic HTTP vers de l'HTTPS.
Tout ceci est transparent pour notre code applicatif!

## A retenir 

* L'ingress et IngressController permettent de controller et rediriger le trafic entrant vers un ou des services 


## Pour aller plus loin

* [Learn more about Ingress on the main Kubernetes documentation site](https://kubernetes.io/docs/concepts/services-networking/ingress/).
* [Nginx Ingress Controller website](https://kubernetes.github.io/ingress-nginx/deploy/)
