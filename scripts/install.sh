#!/usr/bin/env bash

gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
sudo add-apt-repository -y ppa:rwky/redis
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

sudo apt-get -y update
sudo apt-get -y upgrade

export DEBIAN_FRONTEND=noninteractive
echo "mysql-server-5.6 mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password root" | sudo debconf-set-selections

#install mysql, postgresql, redis
sudo apt-get -y install python-software-properties git maven libmaven-compiler-plugin-java openjdk-7-jdk libpq-dev postgresql-9.4 postgresql-contrib-9.4 libmysqlclient-dev mysql-server-5.6 redis-server memcached mongodb-org

#redis config
sudo sh -c "echo appendfsync everysec >> /etc/redis/conf.d/local.conf"
sudo sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
sudo killall redis-server

#mysql
mysql -u root -proot mysql -e "GRANT ALL ON *.* to root@'%' IDENTIFIED BY 'root'; FLUSH PRIVILEGES;"
mysql -u root -proot mysql < /vagrant/scripts/mysql_db.sql
sudo sed -i "s/bind-address.*/bind-address\ \=\ 0.0.0.0/" /etc/mysql/my.cnf
sudo service mysql restart

#postgresql
sudo sed -i "s/.*listen_addresses.*/listen_addresses\ =\ '*'/" /etc/postgresql/9.4/main/postgresql.conf
sudo sh -c "echo host all all 0.0.0.0/0 md5 >> /etc/postgresql/9.4/main/pg_hba.conf"
sudo -H -u postgres bash -c 'psql -f /vagrant/scripts/postgres_db.sql'
sudo service postgresql restart

#memcache
sudo sed -i "s/-l.*/\-l\ 0.0.0.0/" /etc/memcached.conf
sudo /etc/init.d/memcached restart

#infinispan
wget -P /tmp http://downloads.jboss.org/infinispan/7.0.3.Final/infinispan-server-7.0.3.Final-bin.zip
cd /tmp
unzip infinispan-server-7.0.3.Final-bin.zip
sudo mv infinispan-server-7.0.3.Final /opt
cd