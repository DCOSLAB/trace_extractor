#!/bin/bash

#STORAGE_PATH=/sdcard
STORAGE_PATH=/data/local
SWAPFILE_NAME=swapfile
CMD_PATH=/system/bin

if [ $1 = on ];
then
    if [ $2 ];
    then
        dd if=/dev/zero of=$STORAGE_PATH/$SWAPFILE_NAME bs=1024 count=$2
        echo create swapfile.swap...
        $CMD_PATH/mkswap $STORAGE_PATH/$SWAPFILE_NAME
        echo mkswap...
        $CMD_PATH/swapon $STORAGE_PATH/$SWAPFILE_NAME
        echo swapon...
    else
        echo File Size inputs...
    fi
elif [ $1 = off ];
then
    $CMD_PATH/swapoff $STORAGE_PATH/$SWAPFILE_NAME
    rm $STORAGE_PATH/$SWAPFILE_NAME
    echo swapoff...
else
   echo missing operand...
fi


