# Ruby on Rails: Articles example
## By: Edwin Montoya - emontoya@eafit.edu.co
## 2018-1

# DEPLOYMENT ON DOCKER FOR TESTING in DCA  (10.131.137.x) or Dev

## Install Docker

### Ubuntu

    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu$(lsb_release -cs) stable"
    $ sudo apt-get update
    $ sudo apt-get install docker-ce

### Centos 7

    source: https://docs.docker.com/install/linux/docker-ce/centos/
    
    $ sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    $ sudo yum install docker-ce
    $ sudo systemctl start docker
    $ sudo systemctl enable docker

    instalar docker-compose: https://docs.docker.com/compose/install/

    $ sudo curl -L https://github.com/docker/compose/releases/download/1.20.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

    $ sudo chmod +x /usr/local/bin/docker-compose

### Windows

Download the official docker installer [Docker](https://docs.docker.com/docker-for-windows/install/)

### OSX

Download the official docker installer  [Docker](https://docs.docker.com/docker-for-mac/install/)

#### Download Git repository

      $ cd /tmp/
      $ mkdir apps
      $ cd apps
      $ git clone https://github.com/st0263eafit/appwebArticulosRails.git
      $ cd appwebArticulosRails

## Con Dockers independientes:

1. Adquirir el contenedor oficial de mongo:

            $ docker pull postgres
            $ docker run --name db -p 5432:5432 -e POSTGRES_USER=pguser -e POSTGRES_PASSWORD=123  -v $(pwd)/postgresdata:/var/lib/postgresql/data -d postgres:latest

2. Construir el contenedor nodejs+app:

            $ cd appwebArticulosRails
            $ docker image build -t <docker_user>/artrails:<version> .
            $ docker image push <docker_user>/artrails:<version>
            $ docker run --name app --link postgres-server:postgres -p 3000:3000 -d <docker_user>/artnode:<version>

3. Adquirir el contenedor oficial de nginx:

            $ docker pull nginx
            $ docker run --name webapp --link nodeapp:node -p 80:80 -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx:latest

4. comandos docker utiles:

* lista imagenes:

      $ docker image ls

* borrar una imagen:

      $ docker image rm <image_id>


* lista contenedores en ejecución: 

      $ docker container ls
      $ docker ps
  
* lista todos los contenedores estén o no ejecutando:

      $ docker container ls -a
      $ docker ps -a

* para la ejecución de un contenedor:

      $ docker container stop <container_id> 

* borrar un contenedor, despues que esta detenido:

      $ docker container rm <container_id> 

* ver los logs de un contenedor:

      $ docker container logs <container_id> 

#### Execute docker-compose

      $ sudo /usr/local/bin/docker-compose build

      $ sudo /usr/local/bin/docker-compose up

Open Browser and connect to the URL: [http://hostname](http://hostname) change the hostname (To NGINX port 80)

Open Browser and connect to the URL: [hostname:3000](hostname:3000) change the hostname (To Rails Puma Server port 3000)

## Configuración con HAPROXY en Docker, y apps en DOCKER:

Escenario: Tenemos 3 maquinas:

### maq1: ej: 10.131.137.204, con docker y docker-compose instalado, y corriendo la app (nginx, rails, postgress).

### maq2: ej: 10.131.137.183, con docker y docker-compose instalado, y corriendo la app (nginx, rails, postgress).

utilizaremos balanceador de carda: HAPROXY en docker, en una maquina3:

### maq3: ej: 10.131.137.50, con docker instalado.

en maq3, se ejecuta:

      $ sudo docker pull haproxy:1.8.5
      $ sudo docker run -d --name myhaproxy -p 80:80 -v $(pwd)/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro haproxy:1.8.5

en archivo de configuración [haproxy.cfg](haproxy.cfg) en la raiz de este repo.           
