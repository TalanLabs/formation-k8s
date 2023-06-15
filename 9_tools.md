# Outils 

Nous avons une application complète hébergée sur Kubernetes, mais notre chemin ne s'arrête pas là! L'éco-système K8S est très avancé et il existe de nombreux outils intéressants!

Je vous propose ici un petit florilège non exhaustif de tooling à connaître. 

### Command Line

[Krew](https://krew.sigs.k8s.io/) est un gestionnaire de plugin pour `kubectl`. À l'occasion, explorez son marketplace!

> ctx et ns sont des incontournables pour changer de contexte et de namespace.

### Déploiement

Dans un projet, on définit une multitude de ressources, légèrement différentes d'un environnement à l'autre. Pour éviter le bon vieux copier-coller, deux outils s'offrent à nous.
* [Helm](https://helm.sh/): Permet de faire du templating sur les fichiers yaml. On y ajoute un fichier de clés/valeurs par environnement. Fourni aussi un marketplace d'applications clé en main.
* [Kustomize](https://kustomize.io/): Ajoute des fichiers yaml de patch pour nos ressources
* [Les CRD](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/): Créer son propre type de ressource. À utiliser avec modération. Par contre la notion est à connaître, elle est répandue.

Pour déployer automatiquement les ressources définies dans notre repo Git sur les clusters: [Argo CD](https://argo-cd.readthedocs.io/en/stable/) 


### Miscellaneous
* [Istio](https://istio.io/) pour du service mesh
* [Rancher](https://www.rancher.com/) pour gérer les Master Node (update, multi-cluster, etc.). 

### Distributions

Services managés:
* [EKS](https://aws.amazon.com/fr/eks/) par AWS
* [AKS](https://azure.microsoft.com/fr-fr/products/kubernetes-service) par Azure
* [GKE](https://cloud.google.com/kubernetes-engine?hl=fr) par GCP
* Des clusters gratuits sont proposés par [Scaleway](https://www.scaleway.com/fr/)

On premise:
* [kubeadm](https://kubernetes.io/fr/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

Pour un environnement dev:
* [kind](https://kind.sigs.k8s.io/): Fourni avec Docker Desktop. N'utilise que des containers Docker pour fonctionner
* [Minikube](https://minikube.sigs.k8s.io/docs/start/): Très présent dans la littérature pour des raisons historiques. Passe par l'utilisation d'une VM
* [K3S](https://k3s.io/) et [MicroK8S](https://microk8s.io/) pour de l'IOT

## Exercice: 

* Créer un chart Helm reprenant les ressources précédentes
* Extraire deux variables: le namespace et l'id de l'EFS

S'inspirer de [https://github.com/helm/examples/tree/main/charts/hello-world]()
