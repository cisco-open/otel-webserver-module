#!/bin/bash


git clone https://github.com/cisco-open/otel-webserver-module.git
cp -r /dependencies /otel-webserver-module/ 

# creating build-dependencies

mkdir build-dependencies
wget --no-check-certificate https://archive.apache.org/dist/apr/apr-1.5.2.tar.gz
tar -xf apr-1.5.2.tar.gz
cp -r apr-1.5.2 build-dependencies
wget --no-check-certificate https://archive.apache.org/dist/apr/apr-util-1.5.4.tar.gz
tar -xf apr-util-1.5.4.tar.gz 
cp -r apr-util-1.5.4 build-dependencies
wget --no-check-certificate http://archive.apache.org/dist/httpd/httpd-2.2.31.tar.gz
tar -xf httpd-2.2.31.tar.gz
cp -r httpd-2.2.31 build-dependencies
wget --no-check-certificate http://archive.apache.org/dist/httpd/httpd-2.4.23.tar.gz
tar -xf httpd-2.4.23.tar.gz
cp -r httpd-2.4.23 build-dependencies

cp -r /build-dependencies /otel-webserver-module/

# change gradle script to include build-dependencies folder 

# Building the otel-webserver-module

cd otel-webserver-module 
./gradlew assembleApacheModule -PbuildType=debug

#Changing the httpd.conf and Adding Opentelemetry.conf
cd build 
tar -xf opentelemetry-webserver-sdk-x64-linux.tgz
mv opentelemetry-webserver-sdk /opt/ 
mv opentelemetry_module.conf /etc/httpd/conf.d 

# Installing

cd /opt/opentelemetry-webserver-sdk
./install.sh 

# Runing Apache

httpd
curl localhost:80



