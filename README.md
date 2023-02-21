# Formation K8 pour développeurs

## Statut 

Work In progress 


## Objectif 

* [rappel des bases des containers](./container.md)
* [Installation du cluster K8](./setup_local_k8.md)
* [comprendre fondamentaux de Kubernetes](./step_one.md)
* savoir déployer des applications dans un cluster


## Plan / TODO

* container build, run, log
* lancer container avec réseaux différents

* lancer app avec un nginx + port + volume (impératif puis declaratif via yaml)
* appli front + api séparée + configmap
* appli front + api + db + secrets 
* meme + monitoring
* sécurité ?
* helm ? 

utiliser des images distroless ?  : k8s.gcr.io/nginx-slim:0.8

https://github.com/ahmetb/kubectx/blob/master/kubens

 analyse static des manifest : 
https://kube-score.com/
Popeye
Polaris 
