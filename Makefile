SHELL := /bin/bash
up:
	./scripts/up.sh
build:
	./scripts/build.sh 1.9.0
build-bad:
	docker build -t settle-api:1.9.1-rc -f app/Dockerfile.faulty app/
import:
	./scripts/import.sh 1.9.0
import-bad:
	./scripts/import.sh 1.9.1-rc
migrate:
	./scripts/migrate.sh
deploy:
	./scripts/deploy.sh 1.9.0
smoke:
	./scripts/verify.sh
evidence:
	./scripts/evidence.sh
monitoring:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts; helm repo update; kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -; helm upgrade --install monitoring prometheus-community/kube-prometheus-stack -n monitoring
down:
	k3d cluster delete tidewater
