# Setup local K8

Création d'un cluster K8 local pour pratiquer la manipulation des ressources


### Vagrant (recommandé) 

TODO : schema nodes dans vagrant 


[Installation Vagrant](https://developer.hashicorp.com/vagrant)

CKA/CKAD/CKS Certification Practice Environment 

[Vagrant + Kubeadm](https://github.com/techiescamp/vagrant-kubeadm-kubernetes)

```bash
git clone git@github.com:techiescamp/vagrant-kubeadm-kubernetes.git
```

Nb : Comment marqué dans le repo, il y a une modification à faire sur Mac/Linux

```bash
mkdir -p /etc/vbox/
echo "* 0.0.0.0/0 ::/0" | sudo tee -a /etc/vbox/networks.conf
```

Changez le nombre de noeuds "worker" à 2 dans le fichier `settings.yaml`

```yaml
#  ommitted code
nodes:
  control:
    cpu: 2
    memory: 4096
  workers:
    count: 2
# ommitted code
```

```bash
vagrant up
```

Les machines se préparent pendant quelques minutes... :) 

Connectez-vous au noeud master: 

```bash
vagrant ssh master
```

Vous devriez avoir 2 noeuds de type worker 

```bash
kubectl get nodes

NAME            STATUS   ROLES           AGE    VERSION
master-node     Ready    control-plane   13m    v1.26.1
worker-node01   Ready    worker          10m    v1.26.1
worker-node02   Ready    worker          104s   v1.26.1
```

Tips: définir un alias k pour kubectl 

```bash
alias k=kubectl
```

Lister les pods de tous les namespaces avec l'option wide pour plus d'infos)

```bash
k get po -A -o wide
```

### Minikube

[Minikube installation](https://minikube.sigs.k8s.io/docs/start/) 

Nb: veiller à créer au moinds 2 noeuds

```bash
minikube start --nodes 2 
```

Lister les noeuds

```bash
minikube kubectl get nodes
```

Bonus : K8 dashboard

```bash
minikube dashboard
```


