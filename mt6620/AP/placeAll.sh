#!/bin/sh

tar xvf lib_iptables.tar.gz -C ./bin
chmod 777 xtables-multi
cp xtables-multi bin/iptables

cp -r bin/* /bin/
cp -r etc/* /etc/
cp -r lib/* /lib/

tar xvf compiled.tgz -C /