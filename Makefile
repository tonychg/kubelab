KIND = kind
KIND_CONFIG = ./kind/config-ingress.yaml
KIND_CONFIG_ARG = --config=$(KIND_CONFIG)
KIND_CLUSTER = kind-local
KIND_CLUSTER_ARG = --name=$(KIND_CLUSTER)
KIND_CONTEXT = kind-$(KIND_CLUSTER)
KIND_CREATE_ARG = create cluster $(KIND_CLUSTER_ARG)
KIND_DELETE_ARG = delete cluster

KUBECTL = kubectl --context=$(KIND_CONTEXT)
KUBECTL_APPLY = $(KUBECTL) apply --server-side=true -f-
KUBECTL_DELETE = $(KUBECTL) delete --ignore-not-found=true -f-

KUSTOMIZE = kustomize build --enable-helm
APPS_DIRECTORY = ./apps

HELM = helm

apply:
	$(KUSTOMIZE) $(APPS_DIRECTORY) | $(KUBECTL_APPLY)

delete:
	$(KUSTOMIZE) $(APPS_DIRECTORY) | $(KUBECTL_DELETE)

create:
	$(KIND) $(KIND_CREATE_ARG) $(KIND_CONFIG_ARG)

stop:
	$(KIND) $(KIND_DELETE_ARG) $(KIND_CLUSTER_ARG)

start: create apply
