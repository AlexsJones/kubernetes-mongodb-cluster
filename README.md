# kubernetes-mongodb-cluster

A scalable kubernetes cluster for SSL secured mongodb.

Built on the great work of others, brought together in k8s manifests.

- Statefulset
- Configmap for mongo.conf, boot options and per env tuning
- Service discovery with sidecars
- Supports auto scaling
- Example built with generated SSL cert

Influenced and inspired by:
- https://github.com/MichaelScript/kubernetes-mongodb
- https://github.com/cvallance/mongo-k8s-sidecar
- My own experience with trying to implement this.. https://kubernetes.io/blog/2017/01/running-mongodb-on-kubernetes-with-statefulsets/

## Dependencies

```
- golang
- go get github.com/AlexsJones/vortex


```
## Get me started

```
./build_environment.sh dev
./generate_pem.sh <SomePassword>
kubectl apply -f deployment/
```

## Configuration
- Primary mongodb configuration is within `templates/configmap.yaml` for wiredtiger settings and log paths

- Within `templates/statefulset.yaml` the mongod boot options can be changed to suit requirements.

- Also for some of the dynamic yaml configuration based on environment look at `environments/dev.yaml` creating your own where applicable.
