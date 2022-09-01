#!/bin/bash

# Check Kernel Version.
KerVer=$(uname -r | cut -c1-3)
if [[ $KerVer > '4.9' ]]; then
    echo "Kernel Verion supported, heading towards cilium install."
else
    echo "Kernel Version not supported, Update your kernel version first!!"
    exit 1
fi

# Clang Version Check
ClangVersion=$(clang --version | grep 'clang version' | cut -c15-16)

if [[ $ClangVersion -ge '10' ]]; then
    echo "Clang version supported."
else
    echo "clang Version not supported or not installed, Update your clang first!!"
    exit 2
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


echo "Currently Cilium offers the following advanced features."
echo "Required Kernel Versions for Advanced Features"
echo "      Cilium Feature                                              |  Minimum Kernel Version"
echo "      ------------------------------------------------------------+------------------------------"
echo "      IPv4 fragment handling                                      | >= 4.10"
echo "      Restrictions on unique prefix lengths for CIDR policy rules | >= 4.11"
echo "      IPsec Transparent Encryption in tunneling mode              | >= 4.19"
echo "      WireGuard Transparent Encryption                            | >= 5.6"
echo "      Host-Reachable Services                                     | >= 4.19.57, >= 5.1.16, >= 5.2"
echo "      Kubernetes Without kube-proxy                               | >= 4.19.57, >= 5.1.16, >= 5.2"
echo "      Bandwidth Manager (beta)                                    | >= 5.1"
echo "      Local Redirect Policy (beta)                                | >= 4.19.57, >= 5.1.16, >= 5.2"
echo "      Full support for Session Affinity                           | >= 5.7"
echo "      BPF-based proxy redirection                                 | >= 5.7"
echo "      BPF-based host routing                                      | >= 5.10"
echo "      Socket-level LB bypass in pod netns                         | >= 5.7"
echo "      Egress Gateway (beta)                                       | >= 5.2"
echo "      -------------------------------------------------------------------------------------------"
