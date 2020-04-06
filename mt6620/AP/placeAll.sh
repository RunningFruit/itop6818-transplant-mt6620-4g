#!/bin/sh

mkdir ./bin
tar xvf lib_iptables.tar.gz -C ./bin

cp xtables-multi bin/iptables

cp -r bin/* /bin/
cp -r etc/* /etc/
cp -r lib/* /lib/

tar xvf compiled.tgz -C /

chmod a+x /bin/*
chmod a+x /usr/bin/6620_launcher
chmod a+x /etc/init.d/mt6620
chmod a+x /etc/init.d/mt6620_AP_4G
chmod a+x /etc/init.d/mt6620_AP_eth0

sed -i 's/ttyAMA2/ttySAC2/g' /etc/init.d/mt6620
sed -i 's/ttyAMA2/ttySAC2/g' /etc/init.d/mt6620_AP_4G
sed -i 's/ttyAMA2/ttySAC2/g' /etc/init.d/mt6620_AP_eth0
