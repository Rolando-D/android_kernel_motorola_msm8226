#!/bin/bash
# Base by Caio Oliveira aka Caio99BR <caiooliveirafarias0@gmail.com>
# ReWritten by RolanDroid 

# You need to download https://github.com/RolanDroid/android_prebuilt_toolchains
# Clone in the same folder as the kernel to choose a toolchain and not specify a location

# Prepare output customization commands - Start

customoutput() {
if [ "$coloroutput" == "" ]; then
	coloroutput="ON"
fi
if [ "$coloroutput" == "ON" ]; then
	# Stock Color
	txtrst=$(tput sgr0)
	# Bold Colors
	txtbld=$(tput bold) # Bold
	bldred=${txtbld}$(tput setaf 1) # red
	bldgrn=${txtbld}$(tput setaf 2) # green
	bldyel=${txtbld}$(tput setaf 3) # yellow
	bldblu=${txtbld}$(tput setaf 4) # blue
	bldmag=${txtbld}$(tput setaf 5) # magenta
	bldcya=${txtbld}$(tput setaf 6) # cyan
	bldwhi=${txtbld}$(tput setaf 7) # white
	coloroutputcheck="${bldcya}ON${txtrst}"
	coloroutputzip="--color=auto"
else
	unset txtbld bldred bldgrn bldyel bldblu bldmag bldcya bldwhi
	coloroutputcheck="OFF"
	coloroutputzip="--color=never"
fi
}

setcustomoutput() {
if [ "$coloroutput" == "ON" ]; then
	coloroutput="OFF"
else
	coloroutput="ON"
fi
}

# Prepare output customization commands - End

# Clean - Start

cleanzip() {
rm -rf zip-creator/*.zip zip-creator/kernel/zImage zip-creator/system/lib/modules/*.ko
cleanzipcheck="Done"
unset zippackagecheck adbcopycheck
}

cleankernel() {
make clean mrproper &> /dev/null
cleankernelcheck="Done"
unset buildprocesscheck target serie variant maindevicecheck BUILDTIME
}

# Clean - End

# Main Process - Start

maindevice() {
echo "${bldred}Motorola device...${txtrst}"
echo "1) thea/titan"
read -p "Choice: " -n 1 -s choice
case "$choice" in
	1 ) target="thea/titan"; variant="thea" echo "$choice - $target$variant"; make thea_defconfig &> /dev/null; maindevicecheck="On";;
	* ) echo "$choice - This option is not valid"; sleep 2;;
esac
}

maintoolchain() {
if [ -d ../android_prebuilt_toolchains ]; then
	echo "1) 4.7 Google GCC"
	echo "2) 4.8 Google GCC"
	read -p "Choice: " -n 1 -s toolchain
	case "$toolchain" in
		1 ) export CROSS_COMPILE="../android_prebuilt_toolchains/arm-eabi-4.7/bin/arm-eabi-";;
		2 ) export CROSS_COMPILE="../android_prebuilt_toolchains/arm-eabi-4.8/bin/arm-eabi-";;
		* ) echo "$toolchain - This option is not valid"; sleep 2;;
	esac
else
	echo "Script says: You don't have RolanDroid Prebuilt Toolchains"
	echo ""
	echo "Script says: Please specify a location"
	echo "Script says: and the prefix of the chosen toolchain at the end"
	echo "RolanDroid says: GCC 4.6 ex. ../arm-eabi-4.6/bin/arm-eabi-"
	read -p "Place: " CROSS_COMPILE
fi
}

echo "${bldgrn}now building the kernel${txtrst}"

START=$(date +%s)

# Main Process - End

# Build Process - Start

buildprocess() {
START=$(date +"%s")
# Check cpu's
NR_CPUS=$(grep -c ^processor /proc/cpuinfo)
if [ "$NR_CPUS" -le "2" ]; then
	NR_CPUS=4
fi
echo "${bldblu}Building $customkernel with $NR_CPUS jobs at once${txtrst}"
make -j ${NR_CPUS}
END=$(date +"%s")
BUILDTIME=$(($END - $START))
if [ -f arch/arm/boot/zImage ]; then
	buildprocesscheck="Done"
	unset cleankernelcheck
else
	buildprocesscheck="Something goes wrong"
fi
}

# Build Process - End

zippackage() {
if [ "$target" == "thea/titan-" ]; then
	tothea/titan
fi

cp arch/arm/boot/zImage zip-creator/kernel
find . -name *.ko | xargs cp -a --target-directory=zip-creator/system/lib/modules/ &> /dev/null

cd zip-creator
zip -r $zipfile * -x */.gitignore *.zip &> /dev/null
cd ..

if [ "$target" == "thea/titan-" ]; then
	ofthea/titan
fi

zippackagecheck="Done"
unset cleanzipcheck
}

# Menu - Start

customkernel=MonsterKernel
version=V1
export ARCH=arm
daytime=$(date +%d""%m""%Y)

buildsh() {
kernelversion=`cat Makefile | grep VERSION | cut -c 11- | head -1`
kernelpatchlevel=`cat Makefile | grep PATCHLEVEL | cut -c 14- | head -1`
kernelsublevel=`cat Makefile | grep SUBLEVEL | cut -c 12- | head -1`
kernelname=`cat Makefile | grep NAME | cut -c 8- | head -1`
zipfile="$customkernel-$version$target$variant-$daytime.zip"
lszip=`ls zip-creator/*.zip 2>/dev/null | wc -l`
customoutput
clear
echo "RolanDroid says: Simple Kernel Build Script."
echo "This is an open source script, feel free to use, edit and share it."
echo "Linux Kernel $kernelversion.$kernelpatchlevel.$kernelsublevel - $kernelname"
echo
echo "${bldred}Clean:${txtrst}"
echo "1) Last Zip Package (${bldred}$cleanzipcheck${txtrst})"
echo "2) Kernel (${bldred}$cleankernelcheck${txtrst})"
echo "${bldgrn}Main Process:${txtrst}"
echo "3) Device Choice (${bldgrn}$target$variant${txtrst})"
echo "4) Toolchain Choice (${bldgrn}$CROSS_COMPILE${txtrst})"
echo "${bldyel}Build Process:${txtrst}"
if ! [ "$maindevicecheck" == "" ]; then
	if ! [ "$CROSS_COMPILE" == "" ]; then
		echo "5) Build $customkernel (${bldyel}$buildprocesscheck${txtrst})"
	else
		echo "Use "4" first."
	fi
else
	echo "Use "3" first."
fi
if [ -f arch/arm/boot/zImage ]; then
	echo "6) Build Zip Package (${bldyel}$zippackagecheck${txtrst})"
fi
if [ -f zip-creator/$zipfile ]; then
	echo "${bldblu}Test Process:${txtrst}"
	echo "7) Copy to device - Via Adb (${bldblu}$adbcopycheck${txtrst})"
	if [ "$adbcopycheck" == "Done" ]; then
		echo "8) Reboot device to recovery"
	fi
fi
echo "${bldmag}Status:${txtrst}"
if ! [ "$BUILDTIME" == "" ]; then
	echo "${bldgrn}Build Time: $(($BUILDTIME / 60)) minutes and $(($BUILDTIME % 60)) seconds.${txtrst}"
fi
if [ "$maindevicecheck" == "" ]; then
	if [ -f arch/arm/boot/zImage ]; then
		echo "${bldblu}You have old Kernel build!${txtrst}"
		buildprocesscheck="Old build"
	fi
elif [ "$CROSS_COMPILE" == "" ]; then
	if [ -f arch/arm/boot/zImage ]; then
		echo "${bldblu}You have old Kernel build!${txtrst}"
		buildprocesscheck="Old build"
	fi
fi
if [ -f zip-creator/$zipfile ]; then
	echo "${bldyel}Zip Saved to zip-creator/$zipfile ${txtrst}"
elif [ "$lszip" -ge 2 ]; then
	echo "${bldblu}You have old Zips Saved on zip-creator folder!${txtrst}"
	ls zip-creator/*.zip ${coloroutputzip}
elif [ "$lszip" -ge 1 ]; then
	echo "${bldblu}You have old Zip Saved on zip-creator folder!${txtrst}"
	ls zip-creator/*.zip ${coloroutputzip}
fi
echo "${bldcya}Menu:${txtrst}"
echo "c) Color ($coloroutputcheck)"
echo "q) Quit"
read -n 1 -p "${txtbld}Choice: ${txtrst}" -s x
case $x in
	1) echo "$x - Cleaning Zips..."; cleanzip; buildsh;;
	2) echo "$x - Cleaning $customkernel..."; cleankernel; buildsh;;
	3) echo "$x - Device choice"; maindevice; buildsh;;
	4) echo "$x - Toolchain choice"; maintoolchain; buildsh;;
	5) if [ -f .config ]; then
		echo "$x - Building Kernel..."; buildprocess; buildsh
	else
		echo "$x - This option is not valid"; sleep 2; buildsh
	fi;;
	6) if [ -f arch/arm/boot/zImage ]; then
		echo "$x - Ziping $customkernel..."; zippackage; buildsh
	else
		echo "$x - This option is not valid"; sleep 2; buildsh
	fi;;
	7) if [ -f zip-creator/*.zip ]; then
		echo "$x - Coping $customkernel..."; adbcopy; buildsh
	else
		echo "$x - This option is not valid"; sleep 2; buildsh
	fi;;
	8) if [ "$adbcopycheck" == "Done" ]; then
		echo "$x - Rebooting to Recovery..."; adb reboot recovery; buildsh
	else
		echo "$x - This option is not valid"; sleep 2; buildsh
	fi;;
	c) setcustomoutput; buildsh;;
	q) echo "Ok, Bye!"; unset zippackagecheck;;
	*) echo "$x - This option is not valid"; sleep 2; buildsh;;
esac
}

# Menu - End

# The core of script is here!

if ! [ -e build.sh ]; then
	echo
	echo "Ensure you run this file from the SAME folder as where it was,"
	echo "otherwise the script will have problems running the commands."
	echo "After you 'cd' to the correct folder, start the build script"
	echo "with the ./build.sh command, NOT with any other command!"
	echo; sleep 3
else
	if [ -f zip-creator/*.zip ]; then
		unset cleanzipcheck
	else
		cleanzipcheck="Done"
	fi

	if [ -f .config ]; then
		unset cleankernelcheck
	else
		cleankernelcheck="Done"
	fi

	buildsh
fi
