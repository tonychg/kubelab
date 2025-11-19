KIND = kind
KIND_CONFIG = ./kind/config-ingress.yaml
KIND_CLUSTER = kind-local
KIND_CLUSTER_ARGUMENT = --name=$(KIND_CLUSTER)
KIND_CONTEXT = kind-$(KIND_CLUSTER)
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
	$(KIND) create cluster $(KIND_CLUSTER_ARGUMENT) --config=$(KIND_CONFIG)

start:
	create apply

stop:
	$(KIND) delete cluster  $(KIND_CLUSTER_ARGUMENT)
