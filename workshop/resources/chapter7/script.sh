k apply -f volume.yml
k apply -f back.yml
k apply -f env-config.yml

k exec -it  $(k get po -l app=formation-back -o custom-columns=:metadata.name) -- sh
cat /app/bdd/bdd.json

k apply -f job.yml

k exec -it  $(k get po -l app=formation-back -o custom-columns=:metadata.name) -- sh
cat /app/bdd/bdd.json
