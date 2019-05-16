# kubernetes-mongodb-cluster

A scalable kubernetes cluster for SSL secured mongodb on GKE with backups.

![issues](https://img.shields.io/github/issues/AlexsJones/kubernetes-mongodb-cluster.svg)
![forks](https://img.shields.io/github/forks/AlexsJones/kubernetes-mongodb-cluster.svg)
![stars](https://img.shields.io/github/stars/AlexsJones/kubernetes-mongodb-cluster.svg)
![license](https://img.shields.io/github/license/AlexsJones/kubernetes-mongodb-cluster.svg)
![twitter](https://img.shields.io/twitter/url/https/github.com/AlexsJones/kubernetes-mongodb-cluster.svg?style=social)


- GKE local disks
- Backups with FUSE to Google storage
- Statefulset
- Node/Pod affinity keys
- Configmap for mongo.conf, boot options and per env tuning
- Service discovery with sidecars
- Supports auto scaling
- Example built with generated SSL cert

## Dependencies

```
- golang
- go get github.com/AlexsJones/vortex
- google cloud platform (for a few annotations e.g. load balancer and pvc) and GKE cluster
```
## Get me started

If you want to start from absolute zero here is the command to build the cluster on GKE:

1.

```
gcloud container clusters create mongodbcluster --num-nodes 1 --node-locations=europe-west2-a,europe-west2-b,europe-west2-c --local-ssd-count 3 --region=europe-west2 --labels=type=mongodb --node-labels=node-type=mongodb --machine-type=n1-standard-8

kubectl create clusterrolebinding cluster-admin-binding   --clusterrole=cluster-admin   --user=$(gcloud config get-value core/account)
```

2.

- Provide a service account with access to the `storage_bucket` as defined in `environments/<yourenv>`
  e.g `storage_bucket: mybucketintheus` *It must have access to storage object get/list/create*

- Download the secret for this service account locally e.g `gcloud iam service-accounts keys create google-credentials --iam-account <EMAIL_OF_SVC_ACCOUNT>`

- `kubectl create secret generic google-credentials --from-file=google-credentials -n mongodb`

3.

Followed by the deployment (production-gke)

```
- `./build_environment.sh production-gke `
- ./generate_pem.sh <SomePassword>
- `kubectl apply -f deployment/gke-storage -n mongodb`
- `kubectl apply -f deployment/mongo -n mongodb`
```

_To confirm the local-disks are attached run the following_

```
❯ kubectl get pvc -n mongodb
NAME            STATUS   VOLUME              CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-mongod-0   Bound    local-pv-46a6870e   368Gi      RWO            local-scsi     1m
data-mongod-1   Bound    local-pv-93823dd3   368Gi      RWO            local-scsi     40s
data-mongod-2   Bound    local-pv-69642ae6   368Gi      RWO            local-scsi     17s

```

4.




## But I don't like GKE and/or I'm on another provider

If you do not wish to use GKE nor local-scsi do the following deployment


```
- Check your environment/<env> does not have local-scsi storage class set
- `./build_environment.sh <env>`
- ./generate_pem.sh <SomePassword>
- `kubectl apply -f deployment/mongo -n mongodb`
```
./build

## Test it works

The mongo-job runs the following command

```
kubectl exec -it mongod-0 -n mongodb -c mongod -- mongo --host 127.0.0.1:27017 --authenticationDatabase admin --username root --password root --eval "rs.status()"
```

Execute the job with

```
kubectl apply -f deployment/utils/job.yaml -n mongodb
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

## Using UI tools

Tools such as mongochef/robochef can be used with their direct connection mode on localhost:27017 and
`kubectl port-forward mongod-0 27017:27017`


### Creditations

Influenced and inspired by:
- https://github.com/MichaelScript/kubernetes-mongodb
- https://github.com/cvallance/mongo-k8s-sidecar
- My own experience with trying to implement this.. https://kubernetes.io/blog/2017/01/running-mongodb-on-kubernetes-with-statefulsets/
