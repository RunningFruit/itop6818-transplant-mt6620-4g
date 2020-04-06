
执行
```
tar xvf compiled.tgz -C /
wpa_passphrase XXX "YYY" > /etc/wpa_supplicant.conf
chmod a+x /etc/init.d/mt6620
chmod a+x /usr/bin/6620_launcher
/etc/init.d/mt6620 &

ping "www.baidu.com" -c 4
```
