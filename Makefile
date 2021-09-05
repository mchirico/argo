.PHONY: default help

default: help
help: ## display make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m make %-20s ... %s\n\033[0m", $$1, $$2}'



.PHONY: up-kind
up-kind: ## setup local kind cluster. Install argo workflows and run workflow
	@bash -c "cd infra/local && ./create.sh"
	@bash -c "kind create cluster --name argo --config infra/local/kind-config-with-mounts.yaml"
	@bash -c "kubectl create ns argo"
	@bash -c "kubectl apply -n argo -f infra/local/quick-start-postgres.yaml"
	@bash -c "kubectl -n argo create rolebinding default-admin --clusterrole=admin --serviceaccount=argo:default"
	@bash -c "echo 'kubectl -n argo port-forward deployment.apps/argo-server 2746:2746'"	
	@bash -c "echo 'This will serve the user interface on https://localhost:2746'"
	@bash -c "echo 'To get past chome notice type:  thisisunsafe'"
	@bash -c "kubectl get pods -n argo --watch"

.PHONY: down-kind
down-kind: ## tear down local kind cluster
	@bash -c "kind delete cluster --name argo"


.PHONY: why-not-work
why-not-work: ## rights issues on site
	@bash -c "cd infra/site && ./create.sh"
	@bash -c "kind create cluster --name argo --config infra/site/kind-config-with-mounts.yaml"
	@bash -c "kubectl create ns argo"
	@bash -c "kubectl apply -n argo -f infra/site/install.yaml"
	@bash -c "kubectl apply -n argo -f infra/site/quick-start-postgres.yaml"
	@bash -c "kubectl -n argo create rolebinding default-admin --clusterrole=admin --serviceaccount=argo:default"
