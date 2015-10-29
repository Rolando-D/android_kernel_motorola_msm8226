#!/sbin/sh

mkdir /tmp/out

# Unpack boot.img
if [ -e /tmp/boot.img ]; then
	/tmp/unpackbootimg -i /tmp/boot.img -o /tmp/out
	rm -rf /tmp/boot.img
else
	echo "[AnyKernel] boot.img dump failed!" | tee /dev/kmsg
	exit 1
fi

if [ -e /tmp/out/boot.img-ramdisk.gz ]; then
	rdcomp=/tmp/out/boot.img-ramdisk.gz
	echo "[AnyKernel] New ramdisk uses GZ compression." | tee /dev/kmsg
elif [ -e /tmp/out/boot.img-ramdisk.lz4 ]; then
	rdcomp=/tmp/out/boot.img-ramdisk.lz4
	echo "[AnyKernel] New ramdisk uses LZ4 compression." | tee /dev/kmsg
else
	echo "[AnyKernel] Unknown ramdisk format!" | tee /dev/kmsg
	exit 1
fi

/tmp/mkbootimg --kernel /tmp/kernel/zImage --ramdisk $rdcomp --cmdline "$(cat /tmp/out/boot.img-cmdline)" --base $(cat /tmp/out/boot.img-base) --pagesize $(cat /tmp/out/boot.img-pagesize) --ramdisk_offset $(cat /tmp/out/boot.img-ramdisk_offset) --tags_offset $(cat /tmp/out/boot.img-tags_offset) --dt /tmp/kernel/dt.img --output /tmp/boot.img

if [ -e /tmp/boot.img ]; then
	echo "[AnyKernel] boot.img created successfully!" | tee /dev/kmsg
	exit 0
else
	echo "[AnyKernel] boot.img failed to create!" | tee /dev/kmsg
	exit 1
fi
