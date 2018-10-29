# kubernetes-mongodb-cluster

A scalable cluster for SSL secured mongodb.

Built on the great work of others, brought together in k8s manifests.

- Statefulset with sidecars
- Supports auto scaling
- Example built with generated SSL cert

_If you believe it, it will come true!_

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

## Configuration

Within `templates/statefulset.yaml` the mongod options can be changed to suit requirements.
