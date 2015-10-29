#!/sbin/sh

buildflag=0
partflag=0

if [ "$1" = "qcom" ]; then
	buildflag=1
else
	echo "[-] Usage: ./write_image.sh <build> <partition> <dir_of_img>" | tee /dev/kmsg
	exit 1
fi

if [ $buildflag == 1 ]; then
	if [ -e "$3"/"$2".img ]; then
		dd if="$3"/"$2".img of=/dev/block/platform/msm_sdcc.1/by-name/"$2"
		echo "[+] Output: /dev/block/platform/msm_sdcc.1/by-name/$2" | tee /dev/kmsg
		exit 0
	else
		echo "[-] Output: imgfile not found!" | tee /dev/kmsg
		partflag=1
	fi
fi

if [ $partflag == 1 ]; then
	echo "[-] Usage: ./write_image.sh <build> <partition> <dir_of_img>" | tee /dev/kmsg
	exit 1
fi
