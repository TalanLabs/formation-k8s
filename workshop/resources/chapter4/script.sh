k apply -f back.yml

k debug -it back --image=busybox
wget -qO- http://back-service/

k delete deploy back
k delete svc back-service
