## Infra

Install [AWS CLI](https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/getting-started-install.html) and [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

Configure an [AWS Profile](https://docs.aws.amazon.com/toolkit-for-visual-studio/latest/user-guide/keys-profiles-credentials.html)

```
cd iac
export AWS_PROFILE=#MY_PROFILE_NAME#
terragrunt init
terragrunt apply
aws eks update-kubeconfig --name formation-eks --region eu-west-3
```

This project is expensive.Don't forget to destroy it as often as possible. 

```
terragrunt destroy
```

## Docker images

```
aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 810454728139.dkr.ecr.eu-west-3.amazonaws.com
cd back
docker build -t 810454728139.dkr.ecr.eu-west-3.amazonaws.com/formation-k8s-back .
docker push 810454728139.dkr.ecr.eu-west-3.amazonaws.com/formation-k8s-back
cd ../front
docker build -t 810454728139.dkr.ecr.eu-west-3.amazonaws.com/formation-k8s-front .
docker push 810454728139.dkr.ecr.eu-west-3.amazonaws.com/formation-k8s-front
```
