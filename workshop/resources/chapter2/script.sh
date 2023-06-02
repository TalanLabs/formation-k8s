k apply -f back.yml

k port-forward back 8080:8080
curl http://localhost:8080/


k debug -it back --image=busybox
wget -qO- http://localhost:8080/
ping back
ifconfig
wget -qO- http://back:8080/

k get po back -o json

k delete po back
