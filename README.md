# kubernetes-mongodb-cluster

A scalable kubernetes cluster for SSL secured mongodb.

*Updated to support 3.6/4.0 with a better sidecar implementation*

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
- google cloud platform (for a few annotations e.g. load balancer and pvc)
```
## Get me started

```
kubectl create ns mongodb
docker run -v $PWD:/tmp tibbar/vortex:v1 -template /tmp/templates -output /tmp/deployment -varpath /tmp/environments/dev.yaml
./generate_pem.sh <SomePassword>
kubectl apply -f deployment/mongo
```

## Test it works

The mongo-job runs the following command

```
kubectl exec -it mongod-0 -n mongodb -c mongod -- mongo --host 127.0.0.1:27017 --authenticationDatabase admin --username root --password root --eval "rs.status()"
```


## Configuration
- Primary mongodb configuration is within `templates/mongo/configmap.yaml` for wiredtiger settings and log paths

- Within `templates/mongo/statefulset.yaml` the mongod boot options can be changed to suit requirements.

- Also for some of the dynamic yaml configuration based on environment look at `environments/dev.yaml` creating your own where applicable.


### Changing User/password

```
mongodb:
  rootusername: "root"
  rootpassword: "root"
```

Can be changed in the environment folder file


### Restoring a database backup

Since 1.10 you can now upload mongodumps into configmaps or in `utils/pod-mongorestore.yaml` you can just use `kubectl cp`
then execute the backup file


## Using UI tools

Tools such as mongochef/robochef can be used with their direct connection mode on localhost:27017 and
`kubectl port-forward mongod-0 27017:27017`
