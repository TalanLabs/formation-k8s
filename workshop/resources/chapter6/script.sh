k apply -f front.yml
k apply -f env-file-for-front.yml

k port-forward $(k get po -l app=formation-front -o custom-columns=:metadata.name) 3000:3000
curl http://localhost:3000/
