#!/bin/bash

DEBUGFS_PATH=/sys/kernel/debug/tracing
DEVICE_PATH=/dev/block/platform/msm_sdcc.1/by-name
CPU_FREQ_PATH=/sys/devices/system/cpu
MMCBLK_PATH=/dev/block/mmcblk0

function block_io_tracing_setting()
{
    #setting for block I/O tracing
    mount -t debugfs debugfs /sys/kernel/debug/

    mount -o remount,rw $DEVICE_PATH/system /system
    #/data/local/busybox --install -s /system/xbin
    sleep 30

    stop mpdecision
    echo 1 > $CPU_FREQ_PATH/cpu1/online
    echo 1 > $CPU_FREQ_PATH/cpu2/online
    echo 1 > $CPU_FREQ_PATH/cpu3/online

    blktrace $MMCBLK_PATH -a fs -o - | blkparse -f "%s %p %d %n %S %C\n" -i - > android.trc &

    free -m
}

function app_start()
{
    case $1 in
        1)  time am start -W com.rovio.angrybirds/com.rovio.fusion.App
            ;;
        2)  time am start -W bbc.mobile.news.ww/.HomeWwActivity
            ;;
        3)  time am start -W com.zumobi.msnbc/com.nbcnews.newsappcommon.activities.SplashActivity
            ;;
        4)  time am start -W com.android.browser/.BrowserActivity
            ;;
        5)  time am start -W com.king.candycrushsaga/.CandyCrushSagaActivity
            ;;
    esac

    free -m
    sleep 60
}

function launcher_start()
{
	am start -n com.android.launcher3/.Launcher
	sleep 10
}


##########################Test 


count=1
total=$#

while [ $# -gt 0 ]
do
    array[$count]=$1
    count=$(($count+1))
    shift
done

block_io_tracing_setting
#echo tracing start...

var0=0
LIMIT=2

while [ "$var0" -lt "$LIMIT" ]
do
    for index in ${!array[*]}; do
        app_start ${array[$index]}
        #launcher_start
    done

	var0=`expr $var0 + 1`
done
  
free -m
sleep 30

kill -9 $(ps | grep blktrace | tr -s ' ' | cut -d' ' -f2)
#echo tracing end...

