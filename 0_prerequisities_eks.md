# Prérequis - EKS

Pour Linux, je vous conseille d'installer [HomeBrew](https://brew.sh/) pour simplifier les installations suivantes. 

## Installations
[AWS CLI](https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/getting-started-install.html) et [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/)

## Configuration

Configurer un [AWS Profile](https://docs.aws.amazon.com/toolkit-for-visual-studio/latest/user-guide/keys-profiles-credentials.html)

Exécuter:
```
export AWS_PROFILE=#MY_PROFILE_NAME#
aws eks update-kubeconfig --name formation-eks --region eu-west-3
kubectl config set-context --current --namespace=#PRENOM.NOM#
```

