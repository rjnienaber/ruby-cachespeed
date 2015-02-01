# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4 
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
  end

  config.vm.provision "shell", inline: "sudo apt-get -y install ca-certificates"
  config.vm.provision "shell", path: "scripts/apt.postgresql.org.sh"

  config.vm.provision "shell", inline: %Q{
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    sudo add-apt-repository -y ppa:rwky/redis

    sudo apt-get -y update
    sudo apt-get -y upgrade
    
    export DEBIAN_FRONTEND=noninteractive
    echo "mysql-server-5.6 mysql-server/root_password password root" | sudo debconf-set-selections
    echo "mysql-server-5.6 mysql-server/root_password_again password root" | sudo debconf-set-selections

    #install mysql, postgresql, redis
    sudo apt-get -y install python-software-properties libpq-dev postgresql-9.4 postgresql-contrib-9.4 libmysqlclient-dev mysql-server-5.6 redis-server memcached

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

    #rvm
      }

    config.vm.provision "shell", privileged: false, path: "scripts/rvm.sh"
    config.vm.provision "shell", privileged: false, inline: %Q{
      source /home/vagrant/.rvm/scripts/rvm
      rvm install ruby-2.2.0
      cd /vagrant/code/
      bundle
    }

    # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3306, host: 33306 #mysql
  config.vm.network "forwarded_port", guest: 6379, host: 36379 #redis
  config.vm.network "forwarded_port", guest: 11211, host: 31211 #memcache
  config.vm.network "forwarded_port", guest: 5432, host: 35432 #postgresql
end
