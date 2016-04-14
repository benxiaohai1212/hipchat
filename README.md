# Running HipChat in Docker

* 1. [Install Docker](https://docs.docker.com/engine/installation/)
* 2. Install [docker-compose](https://docs.docker.com/compose/install/)
```
# curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose
```


* 3. Run the [hipchat](https://hub.docker.com/r/andrey01/hipchat/)
```
git clone https://github.com/arno01/hipchat.git
cd hipchat
docker-compose run -d
```

