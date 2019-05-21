# kubernetes-mongodb-cluster

A scalable kubernetes cluster for SSL secured mongodb.
This runs on GKE with local disks and performs backups to Google Cloud Storage.

![issues](https://img.shields.io/github/issues/AlexsJones/kubernetes-mongodb-cluster.svg)
![forks](https://img.shields.io/github/forks/AlexsJones/kubernetes-mongodb-cluster.svg)
![stars](https://img.shields.io/github/stars/AlexsJones/kubernetes-mongodb-cluster.svg)
![license](https://img.shields.io/github/license/AlexsJones/kubernetes-mongodb-cluster.svg)
![twitter](https://img.shields.io/twitter/url/https/github.com/AlexsJones/kubernetes-mongodb-cluster.svg?style=social)


Built on the great work of others, brought together in k8s manifests.

- Statefulset
- Local disk management with [local-volume-provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/local-volume/provisioner)
- GKE/GCS backup system
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

By default within `environments/dev.yaml` `with_gcs_backups: "true"` is true which means it assumes you are on GKE and want to have the option to take with_gcs_backups to the bucket `storage_bucket: mongodb-gcs-backups`


0. Create a cluster with at least 1 local disk attached to each node.
```
gcloud container clusters create example-cluster --zone us-central1-a --node-locations us-central1-a,us-central1-b,us-central1-c  --min-nodes=1 --scopes=https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.full_control,https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/cloud-platform --project=myproject --local-ssd-count=1 --disk-type=pd-ssd
```

1. Create the mongodb namespace.

2. You must upload a Google Cloud Platform service account JSON file with permission to write/read Google cloud storage.

 `kubectl create secret generic google-credentials --from-file=google-credentials -n mongodb`

```
{{- if .with_gcs_backups }}
      - name: google-credentials
        secret:
          secretName: google-credentials
{{- end }}
```

3. After this has been uploaded it is time to deploy.

```
./build_environment.sh example-with-storage
./generate_pem.sh <SomePassword>
kubectl apply -f deployment/gke-storage
kubectl apply -f deployment/mongo
```


## Test it works

Make a backup:
`kubectl exec -it mongod-0 -c mongod -n mongodb -- /bin/bash -c /etc/make_backup.sh`


Test the replica set:
```
kubectl exec -it mongod-0 -c mongod -- mongo --host 127.0.0.1:27017 --authenticationDatabase admin --username root --password root --eval "rs.status()"
```

## Mongodb specific configuration
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


## Using UI tools

Tools such as mongochef/robochef can be used with their direct connection mode on localhost:27017 and
`kubectl port-forward mongod-0 27017:27017`
