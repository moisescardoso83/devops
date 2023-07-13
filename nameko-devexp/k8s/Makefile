HOST ?= localhost
NAMESPACE ?= nameko
CONTEXT ?= kind-$(NAMESPACE)
TAG ?= dev

kind-create-cluster:
	kind create cluster --config kind-config.yaml --name $(NAMESPACE)
	kind export kubeconfig --name $(NAMESPACE)
	NEWURL=$$(kubectl config view | grep -B1 'name: $(CONTEXT)' | grep server: | awk '{print $$2}' | sed -e 's/0.0.0.0/$(HOST)/') ; \
		kubectl config set-cluster $(CONTEXT) --server=$${NEWURL} --insecure-skip-tls-verify=true
	$(MAKE) deploy-metallb
	$(MAKE) deploy-cert-manager
	$(MAKE) kind-setup-ingress
	$(MAKE) deploy-epinio

kind-setup-ingress:
	$(MAKE) init-helm
	helm upgrade --install nginx-ingress --namespace nginx-ingress nginx-stable/nginx-ingress --set controller.setAsDefaultIngress=true --create-namespace
	kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=90s

undeployK8:
	# $(MAKE) delete-namespace
	kind delete cluster --name $(NAMESPACE)

deployK8: kind-create-cluster kind-setup-ingress
	$(MAKE) create-namespace
	$(MAKE) deploy-dependencies
	$(MAKE) install-charts

smoke-test:
	../test/nex-smoketest.sh http://localhost

perf-test:
	cd ..; ./test/nex-bzt.sh http://localhost

get-nodes:
	kubectl --context=$(CONTEXT) --namespace $(NAMESPACE) get nodes

get-services:
	kubectl --context=$(CONTEXT) --namespace $(NAMESPACE) get services -o wide

get-pods:
	kubectl --context=$(CONTEXT) --namespace $(NAMESPACE) get pods -o wide

watch-svcs-pods:
	watch -n 0 \
	'kubectl --context=$(CONTEXT) --namespace $(NAMESPACE) get services -o wide; echo "---"; \
	 kubectl --context=$(CONTEXT) --namespace $(NAMESPACE) get pods -o wide'

get-logs:
	kubectl get pods --context=$(CONTEXT) --namespace $(NAMESPACE) --no-headers=true | awk '{print $$1}' | grep $(name) | xargs kubectl --context=$(CONTEXT) --namespace $(NAMESPACE) logs -f

describe-pod:
	kubectl get pods --context=$(CONTEXT) --namespace $(NAMESPACE) --no-headers=true | awk '{print $$1}' | grep $(name) | xargs kubectl --context=$(CONTEXT) --namespace $(NAMESPACE) describe pod

describe-svc:
	kubectl get services --context=$(CONTEXT) --namespace $(NAMESPACE) --no-headers=true | awk '{print $$1}' | grep $(name) | xargs kubectl --context=$(CONTEXT) --namespace $(NAMESPACE) describe service

create-namespace:
	kubectl --context=$(CONTEXT) apply -f namespace.yaml

delete-namespace:
	kubectl --context=$(CONTEXT) delete -f namespace.yaml

init-helm:
	helm repo add stable https://charts.helm.sh/stable
	helm repo update

list-charts:
	helm --kube-context=$(CONTEXT) list --namespace=$(NAMESPACE)

deploy-dependencies:
	$(MAKE) init-helm
	helm upgrade broker stable/rabbitmq --install --namespace $(NAMESPACE) --kube-context=$(CONTEXT)
	helm upgrade db stable/postgresql --install --set postgresqlDatabase=orders --namespace $(NAMESPACE) --kube-context=$(CONTEXT)
	helm upgrade cache stable/redis --install --namespace $(NAMESPACE) --kube-context=$(CONTEXT)
	kubectl --context=$(CONTEXT) --namespace=$(NAMESPACE) get pods

deploy-cert-manager:
	helm upgrade --install cert-manager jetstack/cert-manager \
		--namespace cert-manager \
		--set installCRDs=true \
		--set extraArgs={--enable-certificate-owner-ref=true} \
		--create-namespace \
		--kube-context=$(CONTEXT)

deploy-epinio:
	helm upgrade --install epinio epinio/epinio \
		--namespace epinio \
		--create-namespace \
		--set global.domain=127.0.0.1.sslip.io


deploy-metallb:
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml ; kubectl apply -f metallb-ipaddress-l2adv.yaml

install-orders:
	kind load docker-image $(NAMESPACE)/nameko-example-orders:$(TAG) --name $(NAMESPACE)
	$(MAKE) SERVICE_NAME=orders install-chart

install-charts:
	cd ..; $(MAKE) build
	kind load docker-image $(NAMESPACE)/nameko-example-gateway:$(TAG) --name $(NAMESPACE)
	kind load docker-image $(NAMESPACE)/nameko-example-orders:$(TAG) --name $(NAMESPACE)
	kind load docker-image $(NAMESPACE)/nameko-example-products:$(TAG) --name $(NAMESPACE)
	$(MAKE) SERVICE_NAME=gateway install-chart
	$(MAKE) SERVICE_NAME=orders install-chart
	$(MAKE) SERVICE_NAME=products install-chart

install-charts-only:
	$(MAKE) SERVICE_NAME=gateway install-chart
	$(MAKE) SERVICE_NAME=orders install-chart
	$(MAKE) SERVICE_NAME=products install-chart

test-charts:
	$(MAKE) SERVICE_NAME=gateway test-chart
	$(MAKE) SERVICE_NAME=orders test-chart
	$(MAKE) SERVICE_NAME=products test-chart

lint-charts:
	$(MAKE) SERVICE_NAME=gateway lint-chart
	$(MAKE) SERVICE_NAME=orders lint-chart
	$(MAKE) SERVICE_NAME=products lint-chart

test-chart:
	helm upgrade $(SERVICE_NAME) charts/$(SERVICE_NAME) --install \
	--namespace=$(NAMESPACE) --kube-context $(CONTEXT) \
	--dry-run --debug --set image.tag=$(TAG)

install-chart:
	helm upgrade $(SERVICE_NAME) charts/$(SERVICE_NAME) --install \
	--namespace=$(NAMESPACE) --kube-context=$(CONTEXT) \
	--set image.tag=$(TAG)

lint-chart:
	helm lint charts/$(SERVICE_NAME) --strict