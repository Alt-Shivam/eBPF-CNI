#!/bin/bash

# Check Kernel Version.
KerVer=$(uname -r | cut -c1-3)
if [[ $KerVer > '4.9' ]]; then
    echo "Kernel Verion supported, heading towards cilium install."
else
    echo "Kernel Version not supported, Update your kernel version first!!"
    exit 1
fi

# Add Cilium remote repo for helm
helm repo add cilium https://helm.cilium.io/

# Deploy Cilium in Kube-System Namespace with specified release
helm install cilium cilium/cilium --version 1.10.14 \
  --namespace kube-system

# wait for pods to come up
sleep 20

# Cilium installation test
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz{,.sha256sum}

# Run Tests
cilium connectivity test
flag=$(echo $?)

# Test the deployment
if [ flag != 0 ]; then
    echo "Deployment failed, there is something not right!"
    exit 1
else
    echo "Cilium Deployed Successfully!"
    exit 0
fi
