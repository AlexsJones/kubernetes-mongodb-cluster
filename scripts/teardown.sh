kubectl scale --replicas=0 sts/mongod -n mongodb
kubectl delete pvc --all -n mongodb
kubectl delete sts/mongodb -n mongodb