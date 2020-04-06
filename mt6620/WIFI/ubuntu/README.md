

ubuntu使用的动态分配ip地址的工具是dhclient
```
cd /root
chmod a+x /system/lib/modules/*
wpa_passphrase XXX "YYY" > /etc/wpa_supplicant.conf
sh setwifi_6818.sh
```

setwifi_6818.sh
```sh
#!/bin/bash
mknod /dev/stpwmt c 190 0
mknod /dev/stpgps c 191 0
mknod /dev/fm c 193 0
mknod /dev/wmtWifi c 194 0

insmod /system/lib/modules/mtk_hif_sdio.ko
insmod /system/lib/modules/mtk_stp_wmt.ko
insmod /system/lib/modules/mtk_stp_uart.ko
insmod /system/lib/modules/mtk_stp_gps.ko

insmod /system/lib/modules/mtk_wmt_wifi.ko WIFI_major=194
insmod /system/lib/modules/wlan_mt6620.ko

chmod 0666 /dev/stpwmt
chmod 0666 /dev/stpgps
chmod 0666 /dev/fm
chmod 0666 /dev/wmtWifi
chmod 0660 /dev/ttySAC2
chmod 0666 /dev/gps

/system/bin/6620_launcher -m 1 -b 921600 -n /system/etc/firmware/mt6620_patch_hdr.bin -d /dev/ttySAC2 &

sleep 3
oput=`echo 1 > /dev/wmtWifi`
wpa_supplicant -iwlan0 -Dnl80211 -c/etc/wpa_supplicant.conf  &
pid=$!
sleep 2

kill $pid
wpa_supplicant  -i wlan0 -Dwext -c /etc/wpa_supplicant.conf &
dhclient wlan0 &
```

开机启动
wifi_instart.sh
```sh
#!/bin/bash
yellow() {
    echo  "\033[33m $1 \033[0m"
}

echo
yellow 'setting up wlan_mt6620...'
cat << ED > /etc/init.d/itop-set
#!/bin/bash

#turn on 4.3 inch screen
echo 60 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio60/direction
echo 1 > /sys/class/gpio/gpio60/value

#Configure audio route as :-
amixer cset numid=7 127
amixer cset numid=8 1
amixer cset numid=40 1
amixer cset numid=45 1

#chown root:tty /dev/ttySAC*
#chmod 777 /dev/ttySAC*

echo 0 > /proc/sys/kernel/hung_task_timeout_secs

#################################################################################################################
######################### support MT6620 WIFI Module ########################

mknod /dev/stpwmt c 190 0
mknod /dev/stpgps c 191 0
mknod /dev/fm c 193 0
mknod /dev/wmtWifi c 194 0

insmod /system/lib/modules/mtk_hif_sdio.ko
insmod /system/lib/modules/mtk_stp_wmt.ko
insmod /system/lib/modules/mtk_stp_uart.ko
insmod /system/lib/modules/mtk_stp_gps.ko

insmod /system/lib/modules/mtk_wmt_wifi.ko WIFI_major=194
insmod /system/lib/modules/wlan_mt6620.ko

chmod 0666 /dev/stpwmt
chmod 0666 /dev/stpgps
chmod 0666 /dev/fm
chmod 0666 /dev/wmtWifi
chmod 0660 /dev/ttySAC2
chmod 0666 /dev/gps

/system/bin/6620_launcher -m 1 -b 921600 -n /system/etc/firmware/mt6620_patch_hdr.bin -d /dev/ttySAC2 &

sleep 3
oput=\`echo 1 > /dev/wmtWifi\`
wpa_supplicant -iwlan0 -Dnl80211 -c /etc/wpa_supplicant.conf &
pid=$!
sleep 2

kill $pid
wpa_supplicant  -i wlan0 -Dwext -c /etc/wpa_supplicant.conf &
dhclient wlan0 &


######################## end support ########################

#################################################################################################################
######################## support ath6kl wifi module ########################

#   insmod /lib/firmware/ath6k/AR6003/hw2.1.1/cfg80211.ko
#   insmod /lib/firmware/ath6k/AR6003/hw2.1.1/ath6kl_sdio.ko

#   sleep 1
############################ endf support ############################

ED
echo
yellow 'done'
echo
echo ' use "wpa_passphrase ssid [passphrase] /etc/wpa_supplicant.conf" to preset wifi'
echo
yellow  'then reboot or run "sh /etc/init.d/itop-set" to set up wifi'
```

pppd_conf.sh
```sh
#!/bin/sh
pwd
cd `dirname $0` || exit 0
pwd
pppd call wcdma  | tee  /usr/ppp.log &
sleep 4
vgw=`tail /usr/ppp.log |   grep  'remote IP address' | grep -m 1 -o '\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}'`
vnamenserver=`tail /usr/ppp.log |  grep  primary | grep -m 1 -o '\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}'`
echo $vgw
echo $vnamenserver
echo "nameserver $vnamenserver" > /etc/resolv.conf
route add default gw $vgw
```
