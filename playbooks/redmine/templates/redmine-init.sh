#!/bin/bash
#
### BEGIN INIT INFO
# Provides:          redmine
# Required-Start:    $mysql $nginx
# Required-Stop:     $mysql $nginx
# Should-Start:      $network
# Should-Stop:       $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start and stop the Puma server for Redmine
# Description:       Controls the Puma server for Redmine.
### END INIT INFO

USER="redmine"

SERVER_NAME="redmine"
RAILS_ENV="production"

SYSTEM_REDMINE_PATH="/usr/share/redmine"
REDMINE_HOME="/home/redmine"
REDMINE_PATH="$REDMINE_HOME/redmine"

CONFIG_FILE="/home/redmine/config/puma.rb"
PID_FILE="$REDMINE_PATH/tmp/pids/puma.pid"
SOCK_FILE="$REDMINE_PATH/tmp/sockets/redmine.sock"
BIND_URI="unix://$SOCK_FILE"
THREADS="0:8"
WORKERS=2

function start {
  echo "Starting the Puma server..."
  set -x
  su -l $USER -c "puma --daemon --preload --bind $BIND_URI \
    --environment $RAILS_ENV --dir $SYSTEM_REDMINE_PATH \
    --workers $WORKERS --threads $THREADS \
    --pidfile $PID_FILE --tag $SERVER_NAME \
    --config $CONFIG_FILE"
  echo "Done"
}

function stop {
  echo "Stopping the Puma server..."
  if [ -f $PID_FILE ] ; then
    su -l $USER -c "pumactl -P $PID_FILE stop"
    rm -f $PID_FILE
    rm -f $SOCK_FILE
  else
    echo "No PID file found."
  fi
  echo "Done"
}

function status {
  su -l $USER -c "pumactl -P $PID_FILE status"
}

case "$1" in
  start)
    start
  ;;
  stop)
    stop
  ;;
  status)
    status
  ;;
  restart)
    stop
    start
  ;;
  *)
    echo "Usage : service_puma.sh {start|stop|restart}"
  ;;
esac
