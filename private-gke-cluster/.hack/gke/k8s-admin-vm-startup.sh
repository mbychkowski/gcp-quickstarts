#! /bin/bash
apt-get update -y
apt-get install kubectl \
    git \
    helm \
    netcat \
    google-cloud-sdk-kpt -y

apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

 apt-get update -y
 apt-get install \
    docker-ce \
    docker-ce-cli \
    containerd.io -y
