#!/bin/bash

set -euo pipefail

echo "⚠️  This will delete all your Argo CD, apps, Ingress, Cert-Manager, External DNS, Nginx Ingress, and related resources."

read -p "Do you want to continue? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "Aborting."
    exit 0
fi

echo "🧹 Deleting Argo CD applications and apps namespace..."
kubectl -n argocd delete application apps --ignore-not-found
kubectl delete ns apps --ignore-not-found

echo "🧹 Uninstalling Argo CD..."
helm uninstall argocd -n argocd || true
kubectl delete ns argocd --ignore-not-found

echo "🧹 Deleting app Ingress and TLS secret..."
kubectl delete ingress the-app-hub-ingress -n apps --ignore-not-found
kubectl delete certificate the-hub-tls -n apps --ignore-not-found

echo "🧹 Uninstalling Cert-Manager..."
helm uninstall cert-manager -n cert-manager || true
kubectl delete ns cert-manager --ignore-not-found
kubectl get crd | grep cert-manager.io | awk '{print $1}' | xargs -r kubectl delete crd

echo "🧹 Uninstalling External DNS..."
helm uninstall external-dns -n external-dns || true
kubectl delete ns external-dns --ignore-not-found

echo "🧹 Uninstalling Nginx Ingress..."
helm uninstall nginx-ingress -n nginx-ingress || true
kubectl delete ns nginx-ingress --ignore-not-found

echo "🧹 Deleting ClusterIssuer..."
kubectl delete clusterissuer issuer --ignore-not-found

echo "🧹 Deleting leftover Argo CD CRDs..."
kubectl get crd | grep argoproj.io | awk '{print $1}' | xargs -r kubectl delete crd

echo "✅ Cleanup complete! You can check remaining resources with:"
echo "kubectl get all --all-namespaces"
echo "kubectl get ns"
echo "kubectl get crd"
