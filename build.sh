#!/bin/bash
set -e

NAMESPACE=monitoring

echo "✅ Applying TLS secret..."
kubectl apply -f build/build-tls.sh
kubectl apply -f build/elastic-secret.yaml

echo "✅ Installing Ingress-NGINX..."
kubectl apply -f build/ingress-nginx.sh

echo "✅ Applying MetalLB configuration..."
kubectl apply -f build/metallb-system.yaml

echo "✅ Build step completed."
