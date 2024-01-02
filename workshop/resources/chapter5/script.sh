k apply -f back.yml
k apply -f env-config.yml

k debug -it back --image=busybox
wget -qO- http://back-service/api/flag

k patch configmaps env-config --type merge -p '{"data":{"VERSION":"1.1.0"}}'
k rollout restart deploy back

k debug -it back --image=busybox
wget -qO- http://back-service/api/flag
