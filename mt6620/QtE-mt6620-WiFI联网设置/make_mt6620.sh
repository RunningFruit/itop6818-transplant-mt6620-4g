#!/bin/bash
cat << EOF > /etc/init.d/mt6620
#!/bin/sh
#support MT6620 WIFI Module  
  mknod /dev/stpwmt c 190 0
  mknod /dev/stpgps c 191 0
  mknod /dev/fm c 193 0
  mknod /dev/wmtWifi c 194 0

  insmod /lib/modules/mt6620/mtk_hif_sdio.ko
  insmod /lib/modules/mt6620/mtk_stp_wmt.ko
  insmod /lib/modules/mt6620/mtk_stp_uart.ko
  insmod /lib/modules/mt6620/mtk_stp_gps.ko
  #insmod /lib/modules/mt6620/hci_stp.ko
  #insmod /lib/modules/mt6620/mt6620_fm_drv.ko
  #insmod /lib/modules/mt6620/mtk_fm_priv.ko
  insmod /lib/modules/mt6620/mtk_wmt_wifi.ko WIFI_major=194
  insmod /lib/modules/mt6620/wlan_mt6620.ko


  chmod 0666 /dev/stpwmt
  chmod 0666 /dev/stpgps
  chmod 0666 /dev/fm
  chmod 0666 /dev/wmtWifi
  chmod 0666 /dev/gps
  chmod 0660 /dev/ttySAC2
  
  /usr/bin/6620_launcher -m 1 -b 921600 -n /etc/firmware/mt6620_patch_hdr.bin -d /dev/ttySAC2 &
  sleep 4
  echo 1 > /dev/wmtWifi

  wpa_supplicant -iwlan0 -Dnl80211 -c/etc/wpa_supplicant.conf  &
  sleep 3
  udhcpc -i wlan0 >/var/udhcpc_log &

EOF
echo done

