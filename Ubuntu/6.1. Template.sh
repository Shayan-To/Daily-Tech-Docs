#!/bin/sh
### BEGIN INIT INFO
# Provides:            SERVICE_NAME
# Required-Start:      $local_fs $network $named $portmap $remote_fs $syslog $time
# Required-Stop:       $local_fs $network $named $portmap $remote_fs $syslog $time
# Default-Start:       2 3 4 5
# Default-Stop:        0 1 6
# Short-Description:   DESCRIPTION
# Description:         DESCRIPTION
### END INIT INFO

svcfile=SERVICE_FILE_FULL_PATH
args=ARGUMENTS

case "$1" in
	start)
		echo "Starting service..."
		$svcfile $args start
		echo "Service started."
		;;
	stop)
		echo "Stopping service..."
		$svcfile stop
		echo "Service stopped."
		;;
	restart)
		echo "Stopping service..."
		$svcfile stop
		echo "Service stopped."

		echo "Starting service..."
		$svcfile $args start
		echo "Service started."
		;;
	uninstall)
		echo "Currently not supported."
		;;
	status)
		/bin/ps aux | /bin/grep $svcfile
		;;
	*)
		echo "Usage: $0 {start|stop|restart|uninstall|status}"
		;;
esac
