#!/sbin/sh
cd /tmp/
dd if=/dev/block/platform/msm_sdcc.1 of=/tmp/boot.img
/tmp/unpackbootimg /tmp/boot.img
/tmp/mkbootimg --kernel /tmp/zImage --ramdisk /tmp/boot.img-ramdisk.gz --cmdline 'androidboot.hardware=qcom' --base 0x00000000 --ramdiskaddr 0x01000000 -o /tmp/newboot.img
dd if=/tmp/newboot.img of=/dev/block/platform/msm_sdcc.1
busybox chmod 644 /system/lib/modules/*
