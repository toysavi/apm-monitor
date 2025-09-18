#!/bin/bash
set -e

NAMESPACE=monitoring

echo "✅ Deploying Elasticsearch..."
kubectl apply -f deployment/elasticsearch/elasticsearch-pv-pvc.yaml -n $NAMESPACE
kubectl apply -f deployment/elasticsearch/elasticsearch-deployment.yaml -n $NAMESPACE
kubectl apply -f deployment/elasticsearch/elasticsearch-service.yaml -n $NAMESPACE

# Wait for rollout to complete (health check)
kubectl rollout status deployment/elasticsearch -n $NAMESPACE

echo "✅ Deploying Kibana..."
kubectl apply -f deployment/kibana/kibana-deployment.yaml -n $NAMESPACE
kubectl apply -f deployment/kibana/kibana-service.yaml -n $NAMESPACE
kubectl apply -f deployment/kibana/kibana-ingress.yaml -n $NAMESPACE
kubectl rollout status deployment/kibana -n $NAMESPACE

echo "✅ Deploying APM Server..."
kubectl apply -f deployment/apm-server/apm-deployment.yaml -n $NAMESPACE
kubectl apply -f deployment/apm-server/apm-service.yaml -n $NAMESPACE
kubectl apply -f deployment/apm-server/apm-ingress.yaml -n $NAMESPACE
kubectl rollout status deployment/apm-server -n $NAMESPACE

echo "✅ Deployment step completed."
