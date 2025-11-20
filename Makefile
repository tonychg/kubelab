KIND = kind
KIND_CONFIG = ./kind/config-ingress.yaml
KIND_CONFIG_ARG = --config=$(KIND_CONFIG)
KIND_CLUSTER = kind-local
KIND_CLUSTER_ARG = --name=$(KIND_CLUSTER)
KIND_CONTEXT = kind-$(KIND_CLUSTER)
KIND_CREATE_ARG = create cluster $(KIND_CLUSTER_ARG)
KIND_DELETE_ARG = delete cluster
KIND_NETWORK = kind
KIND_NETWORK_SUBNET = 172.19.0.0/16
KIND_NETWORK_GATEWAY = 172.19.0.1

DOCKER = docker
DOCKER_NETWORK_ARG = --gateway $(KIND_NETWORK_GATEWAY) --subnet $(KIND_NETWORK_SUBNET)
DOCKER_CREATE_NETWORK_ARG = network create $(DOCKER_NETWORK_ARG) $(KIND_NETWORK)
DOCKER_DELETE_NETWORK_ARG = network rm -f $(KIND_NETWORK)

KUBECTL = kubectl --context=$(KIND_CONTEXT)
KUBECTL_APPLY = $(KUBECTL) apply --server-side=true --wait=true -f-
KUBECTL_DELETE = $(KUBECTL) delete --ignore-not-found=true -f-
KUBECTL_WAIT_READY = $(KUBECTL) wait deploy --all --all-namespaces --for=condition=Available --timeout=5m

KUSTOMIZE = kustomize build --enable-helm
KUSTOMIZE_APPS_DIRECTORY = ./kustomize/overlays/apps
KUSTOMIZE_CONTROLLERS_DIRECTORY = ./kustomize/overlays/controllers
KUSTOMIZE_BUILD_APPS = $(KUSTOMIZE) $(KUSTOMIZE_APPS_DIRECTORY)
KUSTOMIZE_BUILD_CONTROLLERS = $(KUSTOMIZE) $(KUSTOMIZE_CONTROLLERS_DIRECTORY)

HELM = helm

build:
	$(KUSTOMIZE_BUILD_APPS)

wait:
	$(KUBECTL_WAIT_READY)

apply-controllers:
	$(KUSTOMIZE_BUILD_CONTROLLERS) | $(KUBECTL_APPLY)

apply-apps: wait
	$(KUSTOMIZE_BUILD_APPS) | $(KUBECTL_APPLY)

delete-controllers:
	$(KUSTOMIZE_BUILD_CONTROLLERS) | $(KUBECTL_DELETE)

delete-apps:
	$(KUSTOMIZE_BUILD_APPS) | $(KUBECTL_DELETE)

create:
	$(DOCKER) $(DOCKER_CREATE_NETWORK_ARG)
	$(KIND) $(KIND_CREATE_ARG) $(KIND_CONFIG_ARG)

stop:
	$(KIND) $(KIND_DELETE_ARG) $(KIND_CLUSTER_ARG)
	$(DOCKER) $(DOCKER_DELETE_NETWORK_ARG)

apply: apply-controllers apply-apps

delete: delete-apps delete-controllers

start: create apply

.PHONY: apply delete start create wait
