# Kubernetes 

TODO : schema composants

* opensource 
* écrit en Go
* ensemble de binaires sans dépendance
* Faciles à conteneuriser et à packager

Composants : 
* etcd: Base de données
* kube-apiserver : API server qui permet la configuration d'objets Kubernetes (Pod, Service, Deployment, etc.)
* kube-proxy : Permet le forwarding TCP/UDP et le load balancing entre les services et les backends (Pods)
* kube-scheduler : planifie les ressources en fonctions de règles explicites ou implicites
* kube-controller-manager : Responsable de l'état du cluster, boucle infinie qui régule l'état du cluster afin d'atteindre un état désiré


Ressources :
* Namespaces
* Pods
* Deployments
* DaemonSets
* StatefulSets
* Jobs
* Cronjobs


# Setup


[Local K8](./setup_local_k8.md)

