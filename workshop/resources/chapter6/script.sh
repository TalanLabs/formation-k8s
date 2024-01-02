k apply -f env-config.yml
k apply -f front.yml
k apply -f back.yml

kubectl port-forward back 3000:3000
curl http://localhost:3000/version

kubectl port-forward front 8080:8080
curl http://localhost:8080
