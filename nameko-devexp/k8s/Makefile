HOST ?= localhost
NAMESPACE ?= nameko
CONTEXT ?= kind-$(NAMESPACE)
TAG ?= dev

init-helm:
	helm repo add stable https://charts.helm.sh/stable
	helm repo update
	@echo -e '\n --> ......\e[0m'

check-cluster:
	@test "kind get clusters" | grep -q ^nameko$ && echo "Cluster $(NAMESPACE) ... Ok" || echo "Cluster NOK" || exit 1
	@echo -e '\n --> ......\e[0m'

deployK8: kind-create-cluster
	$(MAKE) create-namespace
	@echo -e '\n --> ......\e[0m'
	$(MAKE) deploy-dependencies
	@echo -e '\n --> ......\e[0m'
	$(MAKE) install-charts
	@echo -e '\n --> ......\e[0m'

undeployK8:
	# $(MAKE) delete-namespace
	kind delete cluster --name $(NAMESPACE)

kind-create-cluster:
	@echo -e '\n\e[31m --> Creating Cluster ......\e[0m'
	kind create cluster --config kind-config.yaml --name $(NAMESPACE)
	@echo -e '\n\e[31m --> Exporting kubeconfig......\e[0m'
	kind export kubeconfig --name $(NAMESPACE)
	#NEWURL=$$(kubectl config view | grep -B1 'name: $(CONTEXT)' | grep server: | awk '{print $$2}' | sed -e 's/0.0.0.0/$(HOST)/')
#	@echo -e '\n --> Setting Cluster......'
#	kubectl config set-cluster $(CONTEXT) --server=$${NEWURL} --insecure-skip-tls-verify=true
#	@echo -e '\n --> Initializing Helm ......'
#	$(MAKE) init-helm
	@echo -e '\n\e[32m --> Deploying Metal LB ......\e[0m'
	$(MAKE) metallb-deploy
	@echo -e '\n\e[32m --> Deploying Cert Manager ......\e[0m'
	$(MAKE) cert-manager-deploy
	@echo -e '\n\e[32m --> Deploying NGINX Ingress Controller......\e[0m'
	$(MAKE) ingress-nginx-install
	@echo -e '\n\e[32m --> Deploying Epinio ......\e[0m'
	$(MAKE) epinio-deploy
	@echo -e '\n\e[33m --> ......\e[0m'

metallb-deploy:
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
	@echo -e '\n\e[33m --> Waiting 20 seconds\e[0m'
	@sleep 20
	@echo -e '\n\e[32m  --> Waiting MetalLB to be ready ...\e[0m'
	kubectl wait --namespace metallb-system --for=condition=ready pod --selector=component=speaker --timeout=90s
	kubectl apply -f metallb-config.yaml
	@echo -e '\n\e[33m --> ......\e[0m'

cert-manager-deploy:
	helm upgrade --install cert-manager jetstack/cert-manager \
	--namespace cert-manager \
	--set installCRDs=true \
	--set extraArgs={--enable-certificate-owner-ref=true} \
	--create-namespace \
	--kube-context=$(CONTEXT)
	@echo -e '\n\e[33m --> ......\e[0m'


ingress-nginx-check:
	kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/instance=ingress-nginx --timeout=90s

ingress-nginx-install:
	helm upgrade --install ingress-nginx \
	--namespace ingress-nginx nginx-stable/nginx-ingress \
	--set controller.setAsDefaultIngress=true \
	--create-namespace
	@echo -e '\n\e[32m --> Waiting Ingress to be ready ...\e[0m'
	$(MAKE) ingress-nginx-check
	@echo -e '\n\e[33m --> ......\e[0m'

epinio-deploy:
	IPEXT=$$(kubectl get svc --namespace ingress-nginx --selector=app.kubernetes.io/instance=ingress-nginx -o json | egrep -o '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | grep -v 10.) ; \
	helm upgrade --install epinio epinio/epinio \
	--namespace epinio \
	--create-namespace \
	--set global.domain=$$IPEXT.sslip.io ; \
	epinio login -u admin -p password https://epinio.$$IPEXT.sslip.io --trust-ca

epinio-push-webserver-example:
	@echo -e '\n\e[32m --> Pushing one application sample to Epinio:\e[0m'
	appName="webserver-example" ; \
	cd epinio-samples/pure-nodejs-web-server ; epinio push --name $$appName ; open $$appName ; \
	epinio app list ; \
	curl -sk https://$$appName.$$IPEXT.sslip.io | sed 's/<[^>]*>//g'
	@echo -e '\n\e[33m --> ......\e[0m'

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

list-charts:
	helm --kube-context=$(CONTEXT) list --namespace=$(NAMESPACE)

deploy-dependencies: init-helm
	@echo -e '\n --> Deploying RabbitMQ ......'
	helm upgrade broker stable/rabbitmq --install --namespace $(NAMESPACE) --kube-context=$(CONTEXT)
	@echo -e '\n --> Deploying PostgreSQL ......'
	helm upgrade db stable/postgresql --install --set postgresqlDatabase=orders --namespace $(NAMESPACE) --kube-context=$(CONTEXT)
	@echo -e '\n --> Deploying Redis ......'
	helm upgrade cache stable/redis --install --namespace $(NAMESPACE) --kube-context=$(CONTEXT)
	@echo -e '\n --> ......'
	kubectl --context=$(CONTEXT) --namespace=$(NAMESPACE) get pods

install-orders:
	kind load docker-image $(NAMESPACE)/nameko-example-orders:$(TAG) --name $(NAMESPACE)
	$(MAKE) SERVICE_NAME=orders install-chart

install-charts:
	@echo -e '\n --> Building Images ......'
	cd ..; $(MAKE) build
	@echo -e '\n --> Loading docker image "nameko-example-gateway" to registry  ......'
	kind load docker-image $(NAMESPACE)/nameko-example-gateway:$(TAG) --name $(NAMESPACE)
	@echo -e '\n --> Loading docker image "nameko-example-orders" to registry  ......'
	kind load docker-image $(NAMESPACE)/nameko-example-orders:$(TAG) --name $(NAMESPACE)
	@echo -e '\n --> Loading docker image "nameko-example-products" to registry  ......'
	kind load docker-image $(NAMESPACE)/nameko-example-products:$(TAG) --name $(NAMESPACE)
	@echo -e '\n --> Installing Chart docker image "nameko-example-gateway" to registry  ......'
	$(MAKE) SERVICE_NAME=gateway install-chart
	@echo -e '\n --> Installing Chart docker image "nameko-example-orders" to registry  ......'
	$(MAKE) SERVICE_NAME=orders install-chart
	@echo -e '\n --> Installing Chart docker image "nameko-example-products" to registry  ......'
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
