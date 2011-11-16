#!/bin/bash -x
sudo apt-get update
sudo apt-cache search xslt
sudo apt-get -y -V install gcc ruby-dev libxml2 libxml2-dev make libxslt1-dev ri
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.zip
unzip rubygems-1.3.7.zip
cd rubygems-1.3.7
sudo ruby setup.rb
sudo gem1.8 install aws-sdk -y --no-rdoc   
