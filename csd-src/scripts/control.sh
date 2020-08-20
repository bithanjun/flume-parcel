#!/bin/sh

export FLUME_HOME=/opt/cloudera/parcels/FLUME

PROGNAME=`basename "$0"`

start(){
    $FLUME_HOME/bin/flume-ng agent -n ${agent_name} -c ${CONF_DIR} -f ${CONF_DIR}/flume.conf
}
stop(){
    ps -ef | grep -i flume | grep -v grep | awk '{print $2}' | xargs kill -9
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
    ;;
    restart)
        stop
        start
        ;;
esac
