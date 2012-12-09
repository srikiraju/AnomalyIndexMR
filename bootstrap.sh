#!/bin/bash -x
sudo apt-get update
sudo apt-get -y -V install gcc ruby-dev libxml2 libxml2-dev make libxslt1-dev ri
wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.12.zip
unzip rubygems-1.8.12.zip
cd rubygems-1.8.12
sudo ruby setup.rb
sudo gem1.8 install aws-sdk statsample -y --no-rdoc
