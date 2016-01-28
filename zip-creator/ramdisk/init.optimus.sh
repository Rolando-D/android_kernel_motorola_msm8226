#!/system/bin/sh

# custom busybox installation shortcut
bb=/sbin/bb/busybox;

# Enable Fsync
	echo "Y" > /sys/module/sync/parameters/fsync_enabled

#enable arch_power
echo "ARCH_POWER" > /sys/kernel/debug/sched_features
echo "1" > /sys/kernel/sched/arch_power

#disable gentle fair sleepers
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "0" > /sys/kernel/sched/gentle_fair_sleepers


#Set default Min Freq
echo "300000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "300000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo "300000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo "300000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq

# Set default hotplug:
	echo "1" > /sys/module/intelli_plug/parameters/intelli_plug_active
	echo "1" > /sys/module/intelli_plug/parameters/touch_boost_active
	echo "787200" > /sys/module/intelli_plug/parameters/screen_off_max

# Set TCP westwood
	echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

# Set IOSched
        echo "bfq" > /sys/block/mmcblk0/queue/scheduler

# disable debugging on some modules
	echo "0" > /sys/module/kernel/parameters/initcall_debug
	echo "0" > /sys/module/alarm/parameters/debug_mask
	echo "0" > /sys/module/alarm_dev/parameters/debug_mask
	echo "0" > /sys/module/binder/parameters/debug_mask
	echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask

#Power Mode
 echo "1" > /sys/module/msm_pm/modes/cpu0/retention/idle_enabled
 echo "1" > /sys/module/msm_pm/modes/cpu1/retention/idle_enabled
 echo "1" > /sys/module/msm_pm/modes/cpu2/retention/idle_enabled
 echo "1" > /sys/module/msm_pm/modes/cpu2/retention/idle_enabled
 echo "512" > /sys/block/mmcblk0/bdi/read_ahead_kb

#Simple Gpu Algorithm
echo 1 > /sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate

