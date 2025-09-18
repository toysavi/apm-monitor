#!/bin/bash
set -e

NAMESPACE=monitoring

# List of namespaces to ensure exist
namespaces=("ingress-nginx" "metallb-system" "monitoring")

for ns in "${namespaces[@]}"; do
    if kubectl get namespace "$ns" >/dev/null 2>&1; then
        echo "Namespace $ns already exists, skipping..."
    else
        echo "Creating namespace $ns..."
        kubectl create namespace "$ns"
    fi
done



echo "✅ Applying TLS secret..."
kubectl create secret tls kibana-tls \
  --cert=certs/tls.crt \
  --key=certs/tls.key \
  -n $NAMESPACE \
  --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Applying Elastic credentials secret..."
kubectl apply -f build/elastic-secret.yaml

echo "✅ Installing Ingress-NGINX..."
sudo build/ingress-nginx.sh

echo "✅ Applying MetalLB configuration..."
kubectl apply -f build/metallb-system.yaml

echo "✅ Build step completed