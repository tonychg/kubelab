Bootstrap local cluster
-----------------------

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.2/cert-manager.yaml

helm repo add minio https://operator.min.io/
helm install --namespace minio-operator --create-namespace minio-operator minio/operator

helm repo add cloudnative-pg https://cloudnative-pg.io/charts
helm install cnpg cloudnative-pg/cloudnative-pg --version 0.27.0 --namespace cnpg-system --create-namespace
helm install plugin-barman-cloud cloudnative-pg/plugin-barman-cloud --version 0.4.0 --namespace cnpg-system --create-namespace

kubectl apply -f ./cnpg-backup-bucket
kubectl apply -f ./cnpg-cluster-source
make -C dummy-app K3D_CLUSTER=k3d-local-0 deploy
