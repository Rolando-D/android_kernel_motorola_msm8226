#!/bin/bash

cleanzip() {
rm -rf zip-creator/*.zip zip-creator/zImage zip-creator/system/lib/modules/*.ko
}

mkdir -p zip-creator/system/lib/modules
cp arch/arm/boot/zImage zip-creator/kernel
find . -name *.ko | xargs cp -a --target-directory=zip-creator/system/lib/modules/ &> /dev/null

customkernel=MonsterKernel
version=V3
device=TheaTitan
daytime=$(date +%d""%m""%Y)
zipfile="$customkernel-$version-$device-$daytime.zip"

cd zip-creator
zip -r $zipfile * -x */.gitignore *.zip &> /dev/null
cd ..
