# Ingress

## Objectif 


## Ingress et Ingress Controller

Ingress (ou une entrée réseau), expose les routes HTTP et HTTPS de l'extérieur du cluster à des services au sein du cluster. 
Le routage du trafic est contrôlé par des règles définies sur la ressource Ingress.

    internet
        |
   [ Ingress ]
   --|-----|--
   [ Services ]

Un contrôleur d'Ingress est responsable de l'exécution de l'Ingress, généralement avec un load-balancer (équilibreur de charge),

> Un ingress sans controller n'a aucun effet 






## Exercices

## A retenir 


## Pour aller plus loin 


* [Learn more about Ingress on the main Kubernetes documentation site](https://kubernetes.io/docs/concepts/services-networking/ingress/).
* [Nginx Ingress Controller website](https://kubernetes.github.io/ingress-nginx/deploy/)
