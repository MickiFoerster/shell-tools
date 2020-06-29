#!/bin/bash
sudo apt-get install pass
tmp=docker-credential-pass-v0.6.3-amd64.tar.gz
cd /tmp && \
  wget https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz && \
  tar xfz ${tmp} && \
  chmod 755 docker-credential-pass  && \
  echo "We need root credentials for installing docker-credential-pass to /usr/local/bin:" && \
  sudo mv docker-credential-pass /usr/local/bin && \
  echo "Next we create a GPG key:" && \
  echo "Please give username and email as shown in git configuration:" && \
  git config user.name && \
  git config user.email && \
  gpg2 --gen-key && \
  pass init "$(git config user.name)" && \
  sed -i '0,/{/s/{/{\n\t"credsStore": "pass",/' ~/.docker/config.json && \
  cd - && \
  echo "Now, you can use docker login and the credentials will be stored encrypted"
