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


## CKAD exam

What's in the CKAD exam

CKAD Curriculum https://github.com/cncf/curriculum

Application Design and Build - 20%
* Define, build and modify container images
* Understand Jobs and CronJobs
* Understand multi-container Pod design patterns (e.g. sidecar, init and others)
* Utilize persistent and ephemeral volumes

Application Deployment - 20%
*  Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
* Understand Deployments and how to perform rolling updates
* Use the Helm package manager to deploy existing packages

Application observability and maintenance - 15%
* Understand API deprecations
* Implement probes and health checks
* Use provided tools to monitor Kubernetes applications
* Utilize container logs
* Debugging in Kubernetes

Application Environment, Configuration, and Security - 25%
* Discover and use resources that extend Kubernetes (CRD)
* Understanding and defining resource requirements, limits and quotas
* Understand ConfigMaps
* Create & consume Secrets
* Understand ServiceAccounts
* Understand SecurityContexts

 Services & Networking - 15%
* Demonstrate basic understanding of NetworkPolicies
* Provide and troubleshoot access to applications via services
* Use Ingress rules to expose applications

