#!/bin/bash

DEBUGFS_PATH=/sys/kernel/debug/tracing

if [ $1 = start ]; 
then   
    #swapon /sdcard/swapfile
    #echo 100 > /proc/sys/vm/swappiness

    mount -t debugfs debugfs /sys/kernel/debug/

    echo 0 > $DEBUGFS_PATH/tracing_on

    echo block:block_rq_complete > $DEBUGFS_PATH/set_event
    echo block:block_bio_queue >> $DEBUGFS_PATH/set_event
    echo block:block_bio_remap >> $DEBUGFS_PATH/set_event
    cat $DEBUGFS_PATH/set_event
    sleep 3

    echo blk > $DEBUGFS_PATH/current_tracer
    cat $DEBUGFS_PATH/current_tracer
    sleep 1

    #echo 8192 > $DEBUGFS_PATH/buffer_size_kb
    echo 32768 > $DEBUGFS_PATH/buffer_size_kb
    echo latency-format > $DEBUGFS_PATH/trace_options
    echo notrace_printk > $DEBUGFS_PATH/trace_options

    echo 1 > $DEBUGFS_PATH/tracing_on

    echo tracing start...
elif [ $1 = end ]; 
then
    if [ $2 ];
    then
        echo 0 > $DEBUGFS_PATH/tracing_on
        cat $DEBUGFS_PATH/trace > $2

        # swapoff /sdcard/swapfile
   else
        echo output_filename NULL
   fi
else
    echo select option....
    echo start / end
fi
