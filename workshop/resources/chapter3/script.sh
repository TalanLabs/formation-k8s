k apply -f back-cip.yml

k debug -it back --image=busybox
wget -qO- http://back-service

k delete po back
k delete svc back-service
