#!/bin/sh
#
# Script .bootstrap/setup.sh
#
# Called by fun_plug to prepare USB key execution environment
# If everything is ok, fun_plug will run from the USB key
#
# 05/09/2012 - V1.0 by Nicolas Bernaerts

# Set default path
PATH=/usr/sbin:/sbin:/usr/bin:/bin
CONTINUE=1

# Environment variables. You may adjust them
FFP_HD="/mnt/HD/HD_a2"
FFP_USB="/mnt/USB/HD_c1"
BCK_FLAG=${FFP_USB}/ffp/home/root/backup.do

# Check if a USB removable disk has been detected. If not, exit
if [ "$CONTINUE" -eq 1 ]; then
  # get the USB key partition
  USB_PARTITION=`df | grep "${FFP_USB}" | sed 's/^\([a-z0-9\/]*\).*$/\1/g'`

  # if partition has been mounted, remount it with noatime, else exit
  if [ -z "${USB_PARTITION}" ]; then
    CONTINUE=0
    echo "ERROR - USB device has not been detected as Mass Storage"
  else
    umount ${USB_PARTITION}
    mount ${USB_PARTITION} -t ext2 ${FFP_USB} -o noatime 2>/dev/null
    echo "USB - USB disk mounted under ${FFP_USB}"
  fi
fi

# Check presence of ffp directory at the USB key root. If not present, exit
if [ "$CONTINUE" -eq 1 ]; then
  if [ ! -d "${FFP_USB}/ffp" ] ; then
    CONTINUE=0
    echo "ERROR - Directory ${FFP_PATH} doesn't exist"
  else
    echo "USB - Directory ${FFP_PATH} present"
  fi
fi

# Check if a backup of USB key ffp directory is needed
if [ "$CONTINUE" -eq 1 ]; then
  if [ -f ${BCK_FLAG} ] ; then
    echo "USB - Backup of ${FFP_USB}/ffp needed. Target is ${FFP_HD}/ffp"
    rm -r ${FFP_HD}/ffp
    cp -a ${FFP_USB}/ffp ${FFP_HD}/ffp
    rm ${BCK_FLAG}
    echo "USB - Backup of ${FFP_USB}/ffp done. Backup flag deleted"
  fi
fi

# Declare USB key ffp directory as ffp root
if [ "$CONTINUE" -eq 1 ]; then
  FFP_PATH=${FFP_USB}/ffp
  echo "USB - Fun_Plug is running from USB key under ${FFP_PATH}, accessible thru /ffp"
else
  echo "ERROR - Fun_Plug root can't be moved to USB Key"
fi

