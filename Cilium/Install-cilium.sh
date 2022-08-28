#!/bin/bash

# Install cilium CLI
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz{,.sha256sum}

# Install Cilium
cilium install
flag=${echo $?}

# Test the deployment
if [flag!=0]
then  
    echo "Deployment failed, there is something not right!"
    exit 1
else
    echo "Cilium Deployed Successfully!"
    exit 0
fi
