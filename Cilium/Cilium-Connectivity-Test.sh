#!/bin/bash

# Cilium test for connectivity.
cilium connectivity test
flag=$(echo $?)

# Test the deployment
if [ flag != 0 ]; then
    echo "Connectivity Test failed!, please reinstall cilium or check your K8s cluster!"
    exit 1
else
    echo "Connectivity test successfull!"
    exit 0
fi
