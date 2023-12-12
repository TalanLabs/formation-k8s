k apply -f back.yml

k debug -it $(k get po -l app=chatroulette-back -o custom-columns=:metadata.name) --image=busybox
wget -qO- http://localhost:3000/version


k rollout history deploy back
k rollout undo deploy back

k debug -it $(k get po -l app=chatroulette-back -o custom-columns=:metadata.name) --image=busybox
wget -qO- http://localhost:3000/version

k delete deploy back
