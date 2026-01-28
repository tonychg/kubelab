CLUSTER_NAME = k3d-local
CLUSTER_WORKER = 3
CLUSTER_IMAGE = rancher/k3s:v1.35.0-k3s1

NETWORK_NAME = k3d-local
NETWORK_CIDR = 172.86.0.0/16
NETWORK_GATEWAY = 172.86.0.1

DOCKER_COMMAND = docker
DOCKER_NETWORK_CREATE_ARGS = --subnet $(NETWORK_CIDR) --gateway $(NETWORK_GATEWAY) $(NETWORK_NAME)
DOCKER_NETWORK_CREATE = $(DOCKER_COMMAND) network create $(DOCKER_NETWORK_CREATE_ARGS)
DOCKER_NETWORK_DELETE = $(DOCKER_COMMAND) network rm -f $(NETWORK_NAME)
NETWORK_ID = $(shell $(DOCKER_COMMAND) network ls | grep $(NETWORK_NAME) | awk '{print$1}')

K3D_COMMAND = k3d
K3D_REGISTRY_CREATE = $(K3D_COMMAND) registry create registry --port 5000 --default-network $(NETWORK_NAME)
K3D_REGISTRY_DELETE = $(K3D_COMMAND) registry delete registry
K3D_CLUSTER_CREATE_ARGS = --agents=$(CLUSTER_WORKER) --no-lb --image=$(CLUSTER_IMAGE) --network=$(NETWORK_NAME) --registry-use k3d-registry:5000
K3D_CLUSTER_CREATE = $(K3D_COMMAND) cluster create $(K3D_CLUSTER_CREATE_ARGS) $(CLUSTER_NAME)
K3D_CLUSTER_DELETE = $(K3D_COMMAND) cluster delete $(CLUSTER_NAME)

start: create-network create-registry create-cluster

delete-network:
	@$(DOCKER_NETWORK_DELETE)

create-network:
	$(if $(strip $(NETWORK_ID)),, @$(DOCKER_NETWORK_CREATE))

create-registry:
	@$(K3D_REGISTRY_CREATE)

delete-registry:
	@$(K3D_REGISTRY_DELETE)

delete-cluster:
	@$(K3D_CLUSTER_DELETE)

create-cluster:
	@$(K3D_CLUSTER_CREATE)

stop: delete-cluster delete-registry delete-network
