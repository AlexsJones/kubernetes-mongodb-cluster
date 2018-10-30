# kubernetes-mongodb-cluster

A scalable kubernetes cluster for SSL secured mongodb.

![issues](https://img.shields.io/github/issues/AlexsJones/kubernetes-mongodb-cluster.svg)
![forks](https://img.shields.io/github/forks/AlexsJones/kubernetes-mongodb-cluster.svg)
![stars](https://img.shields.io/github/stars/AlexsJones/kubernetes-mongodb-cluster.svg)
![license](https://img.shields.io/github/license/AlexsJones/kubernetes-mongodb-cluster.svg)
![twitter](https://img.shields.io/twitter/url/https/github.com/AlexsJones/kubernetes-mongodb-cluster.svg?style=social)


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
- google cloud platform (for a few annotations e.g. load balancer and pvc)
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
