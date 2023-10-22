#! /bin/bash
# Add its repository to our repository list and update it.
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
# Install the Helm chart into a namespace called monitoring, which will be created automatically.
helm install prometheus \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
# The helm command will prompt you to check on the status of the deployed pods.
  kubectl --namespace monitoring get pods -l "release=prometheus"

  # kubectl port-forward --namespace monitoring svc/prometheus-kube-prometheus-prometheus 9090
  # kubectl port-forward --namespace monitoring svc/prometheus-grafana 8080:80