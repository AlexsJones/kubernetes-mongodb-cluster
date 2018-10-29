# kubernetes-mongodb-cluster

A scalable cluster for SSL secured mongodb.

Built on the great work of others, brought together in k8s manifests.

## Dependencies

``
- golang
- go get github.com/AlexsJones/vortex
```
## Get me started

``
./build_environment.sh dev
./generate_pem.sh
kubectl create -f deployment/
```