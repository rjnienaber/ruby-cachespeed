#!/usr/bin/env bash

source /home/vagrant/.rvm/scripts/rvm
cd /vagrant/code/

rvm install ruby-2.2.0
rvm ruby-2.2.0 do rvm gemset create cache_speed
rvm ruby-2.2.0@cache_speed do bundle

rvm install jruby-1.7.19
rvm jruby-1.7.19 do rvm gemset create cache_speed
rvm jruby-1.7.19@cache_speed do bundle
