Bootstrap local cluster
-----------------------

# Start a k3d cluster
make start

# Install requirements
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.2/cert-manager.yaml

helm repo add minio https://operator.min.io/
helm install --namespace minio-operator --create-namespace minio-operator minio/operator

helm repo add cloudnative-pg https://cloudnative-pg.io/charts
helm install cnpg cloudnative-pg/cloudnative-pg --version 0.27.0 --namespace cnpg-system --create-namespace
helm install plugin-barman-cloud cloudnative-pg/plugin-barman-cloud --version 0.4.0 --namespace cnpg-system --create-namespace

Deploy Minio bucket to store backup and WAL
-------------------------------------------

kubectl apply -f ./cnpg-backup-bucket

Deploy CNPG clusters
------------------------

kubectl apply -f ./cnpg-cluster-source
kubectl apply -f ./cnpg-cluster-target

Deploy a dummy application
--------------------------

make -C dummy-app
