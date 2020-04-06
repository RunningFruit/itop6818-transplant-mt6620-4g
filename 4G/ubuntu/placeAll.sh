#!/bin/sh

chmod a+x pppd;
chmod a+x chat;
chmod a+x pppd_conf.sh;
chmod a+x wcdma*

cp pppd /usr/sbin/
cp chat /usr/sbin/

mkdir -p /etc/ppp/peers/
cp wcdma* /etc/ppp/peers/

#建立软连接
ln /lib/ld-linux-armhf.so.3 /lib/ld-linux.so.3

#测试
cp pppd_conf.sh /;cd /

sh pppd_conf.sh
#显示
#ping www.baidu.com -c 4 -I ppp0
