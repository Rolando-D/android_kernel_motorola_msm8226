#!/system/bin/sh

# custom busybox installation shortcut
bb=/sbin/bb/busybox;

# Set TCP westwood
	echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

# Set IOSched
 echo "zen" > /sys/block/mmcblk0/queue/scheduler
 echo "512" > /sys/block/mmcblk0/bdi/read_ahead_kb

# MSM Hotplug tweaks
echo 1 > /sys/module/msm_hotplug/msm_enabled
echo 1 > /sys/module/msm_hotplug/min_cpus_online
echo 500 > /sys/module/msm_hotplug/down_lock_duration
echo 2500 > /sys/module/msm_hotplug/boost_lock_duration
echo "200 5:100 50:50 350:200" > /sys/module/msm_hotplug/update_rates
echo 100 > /sys/module/msm_hotplug/fast_lane_load

# CPU BOOST

echo 20 > /sys/module/cpu_boost/parameters/boost_ms
echo 500 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 998400 > /sys/module/cpu_boost/parameters/input_boost_freq
echo 1094400 > /sys/module/cpu_boost/parameters/sync_threshold
echo 1 > /sys/module/cpu_boost/parameters/hotplug_boost
echo 1 > /sys/module/cpu_boost/parameters/wakeup_boost
echo 1 > /sys/module/cpu_boost/parameters/load_based_syncs 
echo 20 > /sys/module/cpu_boost/parameters/migration_load_threshold

#Background Writeout
echo 200 > /proc/sys/vm/dirty_expire_centisecs
echo 40 > /proc/sys/vm/dirty_ratio
echo 5 > /proc/sys/vm/dirty_background_ratio
echo 10 > /proc/sys/vm/swappiness

#Misc Tweaks
echo 0 > /sys/kernel/sched/gentle_fair_sleepers
echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo "0" > /sys/module/kernel/parameters/initcall_debug;
echo "0" > /sys/module/alarm_dev/parameters/debug_mask;
echo "0" > /sys/module/binder/parameters/debug_mask;
echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask;
