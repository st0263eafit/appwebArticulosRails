# rubyArticulosEM
## By: Edwin Montoya - emontoya@eafit.edu.co

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

#### Execute docker-compose

    $ docker-compose up

Open Browser and connect to the URL: [http://hostname](http://hostname) change the hostname (To NGINX port 80)

Open Browser and connect to the URL: [hostname:3000](hostname:3000) change the hostname (To Rails Puma Server port 3000)

@20181            
