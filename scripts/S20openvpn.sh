#!/bin/sh
#
# Startup script for openvpn client on DNS-325
# Created by mrsmn (https://github.com/mrsmn)
#
# This script should be located at: /opt/etc/init.d/S20openvpn

# Make device if not present (not devfs)
if ( [ ! -c /dev/net/tun ] ) then
  # Make /dev/net directory if needed
  if ( [ ! -d /dev/net ] ) then
    mkdir -m 755 /dev/net
  fi
  mknod /dev/net/tun c 10 200
fi

# Make sure the tunnel driver is loaded
if ( !(lsmod | grep -wq "^tun") ); then
    insmod /usr/local/modules/driver/tun.ko
fi

# Start the openvpn daemon - add as many daemons as you want
/opt/sbin/openvpn --daemon --cd /opt/etc/openvpn --config 0_internal.conf
