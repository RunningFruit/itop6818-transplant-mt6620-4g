

4G、有线网络 开启热点

执行
```
apt-get install -y dos2unix
dos2unix placeAll.sh
chmod a+x placeAll.sh
sh placeAll.sh
```

wifi
```
wpa_passphrase XXX "YYY" > /etc/wpa_supplicant.conf
/etc/init.d/mt6620 &
ping "www.baidu.com" -c 4
```

4g网络热点
```
#修改 ssid 和 wpa_passphrase
vim /etc/hostapd/hostapd.conf

#插上4G卡后，执行
/etc/init.d/mt6620_AP_4G &
```

有线网络热点
```
#修改 ssid 和 wpa_passphrase 即可修改热点的名称和密码
vim /etc/hostapd/hostapd.conf

#启动
/etc/init.d/mt6620_AP_eth0 &
```


原移植过程
1.移植openssl
```
sudo su
mv *tar* /usr/local;cd /usr/local


apt-get install -y libcrypto++-dev libcrypto++-doc libcrypto++-utils
apt-get install -y libcrypto++
apt-get install -y python-crypto
tar -vxf openssl-1.0.1s.tar.gz;cd openssl-1.0.1s
./config no-asm shared

#注意引用库的顺序为：-lssl -lcrypto

vim Makefile
INSTALLTOP=/usr/local/openssl
OPENSSLDIR=/usr/local/openssl
#删除 CFLAG 中的“-m64”参数
CC= arm-none-linux-gnueabi-gcc
EX_LIBS= -ldl
AR= arm-none-linux-gnueabi-ar $(ARFLAGS) r
RANLIB= arm-none-linux-gnueabi-ranlib
NM= arm-none-linux-gnueabi-nm

make
make install
```

2.移植libnl
```
cd /usr/local
tar -vxf libnl-1.1.4.tar.gz;cd libnl-1.1.4

./configure --prefix=/usr/local/libnl1.1
make CC=arm-none-linux-gnueabi-gcc
make install
```

3.移植hostapd
```
cd /usr/local
tar -vxf hostapd_topeet.tar.gz;cd hostapd_topeet/hostapd
cp defconfig .config

vim .config
CONFIG_DRIVER_HOSTAP=y
CONFIG_DRIVER_NL80211=y

vim Makefile
make;make install
```

4.移植iptables
```
cd /usr/local
tar -vxf iptables-1.4.19.tar.bz2;cd iptables-1.4.19
mkdir install
./configure --host=arm-none-linux-gnueabi --prefix=/usr/local/iptables-1.4.19/install/ --enable-static --disable-shared
make;make install

cd install/lib;
tar zcvf lib_iptables.tar.gz *
```

5.整理文件
```
ls /usr/local/openssl/lib
libcrypto.so.1.0.0
libssl.so.1.0.0

ls /usr/local/iptables-1.4.19/install/lib/ib_iptables.tar.gz

ls /usr/local/hostapd_topeet/hostapd/hostapd
ls /usr/local/iptables-1.4.19/install/sbin/xtables-multi
```

6.修改串口设备
vi etc/init.d/mt6620_AP_4G
```
#修改
chmod 0660 /dev/ttymxc1
/usr/bin/6620_launcher -m 1 -b 921600 -n /etc/firmware/mt6620_patch_hdr.bin -d /dev/ttymxc1 &

#4418 成以下内容：
chmod 0660 /dev/ttyAMA2
/usr/bin/6620_launcher -m 1 -b 921600 -n /etc/firmware/mt6620_patch_hdr.bin -d /dev/ttyAMA2 &

#6818 成以下内容：
chmod 0660 /dev/ttySAC2
/usr/bin/6620_launcher -m 1 -b 921600 -n /etc/firmware/mt6620_patch_hdr.bin -d /dev/ttySAC2 &
```