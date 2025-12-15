#!/bin/bash
set -euo pipefail

echo "🧹 Deleting remaining Argo CD CRDs..."
kubectl get crd | grep 'argoproj.io' | awk '{print $1}' | xargs -r kubectl delete crd

echo "🧹 Deleting remaining Nginx CRDs..."
kubectl get crd | grep 'nginx.org' | awk '{print $1}' | xargs -r kubectl delete crd

echo "🧹 Deleting External DNS CRDs..."
kubectl get crd | grep 'externaldns.k8s.io' | awk '{print $1}' | xargs -r kubectl delete crd

echo "🧹 Deleting leftover namespaces..."
kubectl delete ns argocd --ignore-not-found
kubectl delete ns apps --ignore-not-found
kubectl delete ns cert-manager --ignore-not-found
kubectl delete ns nginx-ingress --ignore-not-found
kubectl delete ns external-dns --ignore-not-found

echo "✅ Final cleanup complete!"
kubectl get all --all-namespaces
kubectl get ns
kubectl get crd
