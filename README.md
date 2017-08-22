# trace_extractor
File I/O trace extractor for smart device apps

* I/O extraction with ftrace
1. Push the files to device.

>>desktop@Workstation$ adb push block_io_debugfs.sh /sdcard/

2. Extract trace from the device.

>>desktop@Workstation$ adb shell  

>root@android# cd /sdcard

>>root@android:/sdcard# source block_io_debugfs.sh start

3. Stop trace from the device.

>>root@android:/sdcard# source block_io_debugfs.sh end [file name]

* I/O extraction with blktrace

This shell script runs applications every 60s and then collects I/O trace with blktrace.


>>desktop@Workstation$ adb push block_io_nexus5.sh /sdcard/

>>root@android# cd /sdcard

>>root@android:/sdcard # source block_io_nexus5.sh 1 2 3 4 5

