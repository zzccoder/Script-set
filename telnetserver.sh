#!/bin/bash
#
# install telnetserver
if [ $# -ne 1 ];then
  echo "usage:$0 {start|stop}"
  exit 1
fi

# Install telnet-server
install() {
  rpm -qa | grep telnet-server &> /dev/null
  RESULT="$?"
  if [ $RESULT -ne 0 ];then
    echo "Install telnet-server..."
    yum -y install telnet-server &> /dev/null
    if [ $? -eq 0 ];then
      echo "Install telnet-server success."
    else
      echo "Install telnet-server failed."
      return 1
    fi
  fi
  # config telnet-server
  echo "Config telnet-server..."
  sed -i "s/\([[:space:]]disable[[:space:]][[:space:]]=\).*/\1 no/g" /etc/xinetd.d/telnet
  mv /etc/securetty /etc/securetty.old
  chkconfig xinetd on
  service xinetd start
  return 0
}

# Stop telnet-server
uninstall() {
  # config telnet-server
  sed -i "s/\([[:space:]]disable[[:space:]][[:space:]]=\).*/\1 yes/g" /etc/xinetd.d/telnet
  mv /etc/securetty.old /etc/securetty
  chkconfig  xinetd off
  service xinetd stop
  return 0
}

# help
usage() {
  echo "Usage:$0 {start|stop}"
  return 0
}

case $1 in
  start)
    install;;
  stop)
    uninstall;;
  *)
  usage;;
esac
