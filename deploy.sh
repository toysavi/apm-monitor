#!/bin/bash
set -e

NAMESPACE=observability

# echo "✅ Deploying Namespace..."
# kubectl apply -f ./deploy/namespace.yaml

echo "✅ Deploying Elasticsearch..."
kubectl apply -f ./deploy/elasticsearch.yaml -n $NAMESPACE
kubectl rollout status deployment/elasticsearch -n $NAMESPACE

echo "✅ Deploying Jaeger..."
kubectl apply -f ./deploy/jaeger.yaml -n $NAMESPACE
# Wait for Collector & Query pods
kubectl rollout status deployment/jaeger-collector -n $NAMESPACE || true
kubectl rollout status deployment/jaeger-query -n $NAMESPACE || true

echo "✅ Deploying Kibana..."
kubectl apply -f ./deploy/kibana.yaml -n $NAMESPACE
kubectl rollout status deployment/kibana -n $NAMESPACE

echo "✅ Deploying OAuth2 Proxy (LDAP)..."
kubectl apply -f ./deploy/oauth2-proxy.yaml -n $NAMESPACE
kubectl rollout status deployment/jaeger-oauth2-proxy -n $NAMESPACE

echo "✅ Deploying Ingress..."
kubectl apply -f ./deploy/ingress.yaml -n $NAMESPACE

echo "✅ All observability components deployed successfully!"
