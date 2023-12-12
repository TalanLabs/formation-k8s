kubectl apply -f back.yml
kubectl get po back -o json

kubectl port-forward back 3000:3000
curl http://localhost:3000/version


kubectl apply -f front.yml
kubectl get po front -o json

kubectl port-forward front 8080:8080
curl http://localhost:8080


kubectl debug -it back --image=busybox
wget -qO- http://localhost:3000/
ping back
ifconfig
wget -qO- http://back:3000/


kubectl delete po back
kubectl delete po front
