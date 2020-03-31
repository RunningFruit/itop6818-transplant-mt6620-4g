#!/bin/sh

chmod +x pppd;chmod +x chat;chmod +x pppd_conf.sh;

cp pppd /usr/sbin/
cp chat /usr/sbin/

cp wcdma /etc/ppp/peers/
cp wcdma-chat-connect /etc/ppp/peers/
cp wcdma-chat-disconnect /etc/ppp/peers/

#建立软连接
ln /lib/ld-linux-armhf.so.3 /lib/ld-linux.so.3

#测试
cp pppd_conf.sh /;cd /

./pppd_conf.sh
#显示
#ping www.baidu.com -c 4 -I ppp0