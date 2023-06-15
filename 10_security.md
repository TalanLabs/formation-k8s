# Sécurité

La sécurité est un sujet souvent négligé. 
L'OWASP a publié un [top 10](https://owasp.org/www-project-kubernetes-top-ten/) dédié à Kubernetes. 

Parmi les failles mentionnées, celles qui dépendent des définitions de ressources sont les suivantes.

## L'option securityContext du pod

Penser à adapter les options suivantes dans ses pods:
```yaml
  securityContext:
    runAsUser: 5554
    readOnlyRootFilesystem: true
    privileged: false
```

## Utiliser les ressources Role et RoleBinding

Ces ressources permettent de contrôler les droits d'accès aux différentes ressources selon le rôle de l'utilisateur (lecture écriture dans un seul namespace, interdiction de supprimer les volumes...).

Pour aller plus loin: [https://kubernetes.io/fr/docs/reference/access-authn-authz/rbac/]()


## Utiliser la ressource NetworkPolicy

Pour segmenter le réseau

Pour aller plus loin: [https://kubernetes.io/docs/concepts/services-networking/network-policies/]()
