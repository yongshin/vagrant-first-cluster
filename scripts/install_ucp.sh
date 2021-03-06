export UCP_IPADDR=$(cat /vagrant/centos-ucp-node1)
export UCP_PASSWORD=$(cat /vagrant/ucp_password)
docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.1.4 install --host-address ${UCP_IPADDR} --admin-password ${UCP_PASSWORD} --san ucp.local --license $(cat /vagrant/docker_subscription.lic) --debug
docker swarm join-token manager | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-mgr
docker swarm join-token worker | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-worker
docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.1.4 id | awk '{ print $1}' > /vagrant/centos-ucp-id
export UCP_ID=$(cat /vagrant/centos-ucp-id)
docker run --rm -i --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.1.4 backup --id ${UCP_ID} --root-ca-only --passphrase "secret" > /vagrant/backup.tar
