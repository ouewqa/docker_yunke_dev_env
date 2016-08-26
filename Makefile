# specifically designed for ubuntu 16.04

init:
	install-docker-compose
	make dl
	make pull

install-docker:
	sudo apt-get update
	sudo apt-get install apt-transport-https ca-certificates
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	sudo echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/sources.list.d/docker.list
	sudo apt-get update
	sudo apt-get purge lxc-docker
	sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
	sudo apt-get install docker-engine
	sudo service docker start
	sudo groupadd docker
	sudo usermod -aG docker $USER

install-docker-compose:
	sudo apt install python-pip
	sudo pip install --upgrade pip
	sudo pip install docker-compose

pull:
	docker pull nginx:1.9.0
	docker pull php:5.6.21-fpm
	docker pull mysql:5.6
	docker pull redis:3.0
	docker pull memcached:1.4
	docker pull node:0.12

dl:
	wget -c https://pecl.php.net/get/gearman-1.1.2.tgz -O php/gearman.tgz
	wget -c https://pecl.php.net/get/redis-2.2.7.tgz -O php/redis.tgz
	wget -c https://pecl.php.net/get/memcached-2.2.0.tgz -O php/memcached.tgz
	wget -c https://pecl.php.net/get/xdebug-2.3.2.tgz -O php/xdebug.tgz
	wget -c https://pecl.php.net/get/msgpack-0.5.6.tgz -O php/msgpack.tgz
	wget -c https://pecl.php.net/get/memcache-2.2.7.tgz -O php/memcache.tgz
	wget -c https://pecl.php.net/get/xhprof-0.9.4.tgz -O php/xhprof.tgz
	wget -c https://getcomposer.org/composer.phar -O php/composer.phar

build:
	make build-nginx
	make build-php
	make build-node

build-nginx:
	docker build -t eva/nginx ./nginx

run-nginx:
	docker run -i -d -p 80:80 -v ~/opt:/opt -t eva/nginx

in-nginx:
	docker run -i -p 80:80 -v ~/opt:/opt -t eva/nginx /bin/bash

build-php:
	docker build -t eva/php ./php

run-php:
	docker run -i -d -p 9000:9000 -v ~/opt:/opt -t eva/php

in-php:
	docker run -i -p 9000:9000 -v ~/opt:/opt -t eva/php /bin/bash

build-mysql:
	docker build -t eva/mysql ./mysql

run-mysql:
	docker run -i -d -p 3306:3306 -v ~/opt/data/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -t eva/mysql

in-mysql:
	docker run -i -p 3306:3306  -v ~/data/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -t eva/mysql /bin/bash

build-node:
	docker build -t eva/node ./node

run-node:
	docker run -i -d -p 8001:8001 -v ~/opt:/opt -t eva/node

in-node:
	docker run -i -p 8001:8001 -v ~/opt:/opt -t eva/node /bin/bash

build-elasticsearch:
	docker build -t eva/elasticsearch ./elasticsearch

run-elasticsearch:
	docker run -i -d -p 9200:9200 -p 9300:9300 -v ~/opt/data/elasticsearch:/usr/share/elasticsearch/data -t eva/elasticsearch

in-elasticsearch:
	docker run -i -p 9200:9200 -p 9300:9300 -v ~/opt/data/elasticsearch:/usr/share/elasticsearch/data -t eva/elasticsearch /bin/bash

build-gearman:
	docker build -t eva/gearman ./gearman

run-gearman:
	docker run -d -p 4730:4730 -v ~/opt:/opt -it eva/gearman

clean:
	docker rmi -f $(shell docker images | grep "<none>" | awk "{print \$3}")
