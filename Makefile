#!/usr/bin/env bash
.PHONY: default help

default: help
help: ## display make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m make %-20s ... %s\n\033[0m", $$1, $$2}'


.PHONY: install
install: ## Basic install
	go install sigs.k8s.io/kind@latest

.PHONY: up
up: ## setup local kind cluster. Install argo workflows and run workflow
	cd infra/local && ./create.sh
	kind create cluster --name argo --config infra/local/kind-config-with-mounts.yaml
	kubectl create ns argo
	kubectl apply -n argo -f infra/local/quick-start-postgres.yaml
	kubectl -n argo create rolebinding default-admin --clusterrole=admin --serviceaccount=argo:default
	echo 'kubectl -n argo port-forward deployment.apps/argo-server 2746:2746'
	echo 'This will serve the user interface on https://localhost:2746'
	echo 'To get past chome notice type:  thisisunsafe'
	kubectl get pods -n argo --watch

.PHONY: down
down: ## tear down local kind cluster
	kind delete cluster --name argo


.PHONY: down2
down2: ## tear down local kind cluster2
	kind delete cluster --name argo2


.PHONY: latest
latest: ## latest version
	cd infra/site && ./create.sh
	kind create cluster --name argo2 --config infra/site/kind-config-with-mounts.yaml
	kubectl create ns argo
	kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-workflows/master/manifests/quick-start-postgres.yaml
	kubectl -n argo create rolebinding default-admin --clusterrole=admin --serviceaccount=argo:default


.PHONY: examples
examples: ## examples
	argo submit -n argo --watch https://raw.githubusercontent.com/argoproj/argo-workflows/master/examples/coinflip-recursive.yaml
	argo list -n argo
	
