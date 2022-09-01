
# Enable Hubble in Cilium
cilium hubble enable
flag1=$(echo $?)

# Test the deployment
if [ $flag1 != 0 ]; then
    echo "Deployment failed, there is something not right!"
    exit 1
else
    echo "Cilium Deployed Successfully!"
    exit 0
fi

# In order to access the observability data collected by Hubble, install the Hubble CLI
export HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
curl -L --remote-name-all https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-linux-amd64.tar.gz{,.sha256sum}
sha256sum --check hubble-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC hubble-linux-amd64.tar.gz /usr/local/bin
rm hubble-linux-amd64.tar.gz{,.sha256sum}

echo "Hubble enabled successfully!"
