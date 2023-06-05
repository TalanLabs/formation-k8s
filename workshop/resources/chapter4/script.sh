k apply -f back.yml

k debug -it $(k get po -l app=formation-back -o custom-columns=:metadata.name) --image=busybox
wget -qO- http://back-service/flag

k patch deploy back -p '{"spec":{"template": {"spec":{"containers":[{"env":[{"name":"FLAG","value":"FLAG_2"}],"name":"back"}]}}}}'

k debug -it $(k get po -l app=formation-back -o custom-columns=:metadata.name) --image=busybox
wget -qO- http://back-service/flag

k rollout history deploy back
k rollout undo deploy back

k debug -it $(k get po -l app=formation-back -o custom-columns=:metadata.name) --image=busybox
wget -qO- http://back-service/flag

k delete deploy back
k delete svc back-service
