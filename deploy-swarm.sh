========== MANAGER NODE ==============
# ssh to the manager node
ssh root@203.205.22.35

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# enable swarm mode
docker swarm init --advertise-addr 203.205.22.35

=> docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.99.100:2377


# ADD WORKER NODE
========= NODE 2 ====================
docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.99.100:237


========= NODE 3 =====================
docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.99.100:237


# SO THAT'S NOW WE ALREADY ADD 3 NODE (INCLUDED NODE MANAGER to our 3-node swarm, we can also call it cluster).
# CREATE SECRET, ONLY WORKS IN MANAGER NODE
========= MANAGER ====================
echo "mypasswd" | docker secret create --name pg_password 
echo "dbuser" | docker secret create --name pg_user

========= MANAGER ====================
docker node ls

docker network create --driver overlay frontend
docker network create --driver overlay backend

docker service create --name database --replicas 1 --environment POSTGRES_PASSWORD=mypasswd --network backend postgres:9.4
docker service create --name redis --replicas 1 --network frontend --network backend redis
docker service create --name voteapp --replicas 2 -p 80:80 --network frontend bretfisher/voteapp
docker service create --name worker --replicas 2 --network backend bretfisher/worker

========= JUMP TO OTHER NODES & TEST ===========
docker container ls 


========= 