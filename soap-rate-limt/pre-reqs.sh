if echo $AWS_REGION | grep 'us-east-2'; then
    mkdir -p $HOME/bin
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    echo "..........Installing EKSCTL now ............"
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
    eksctl version
    echo "..........Installing KUBECTL now ............"
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.17/2024-01-04/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
    kubectl version --short --client
    echo "..........Installing HELM now ............"
    wget https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz
    tar -zxvf helm-v3.7.1-linux-amd64.tar.gz
    cp linux-amd64/helm $HOME/bin/helm
    sudo mv linux-amd64/helm /usr/local/bin/helm
    helm version
    echo "..........Installing OPENSSL and JQ ............"
    sudo yum -y install openssl jq 
    echo "..........Utilities Installed Successfully!!............"
else
    echo "This AWS CloudShell Environment is not in US-EAST-2 region."
fi
