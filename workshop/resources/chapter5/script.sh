k apply -f back.yml
k apply -f env-config.yml

curl http://k8s-formatio-backserv-66808b0642-62ed5ce43111e6ca.elb.eu-west-3.amazonaws.com/flag

k patch configmaps env-config --type merge -p '{"data":{"FLAG":"FLAG_FROM_CONFIG_2"}}'
k rollout restart deploy back

curl http://k8s-formatio-backserv-66808b0642-62ed5ce43111e6ca.elb.eu-west-3.amazonaws.com/flag
