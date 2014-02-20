#!/bin/sh
# Attention a executer sous FFP (pas de squeeze ici)
# Patch le /bin/chmod pour empecher execution de la commande :
# "chmod -R 777 /mnt/USB/HD_cx"
# source : http://forum.dsmg600.info/viewtopic.php?id=6194
# adapté par le_candide le 23/04/2012
# pour desinstaller : 	ln -snf busybox /bin/chmod
# pour creer lien manuellement : [ -x /usr/local/config/chmod_usb.sh ] && ln -nfs /usr/local/config/chmod_usb.sh /bin/chmod

# 1- INIT VARIABLES
HD=HD_c1
echo $1|egrep -q ^HD && HD=$1
echo "Ce script va patcher le chmod pour $HD"

CHMOD_PATCHE=/usr/local/config/chmod_usb.sh
FIC_RCINIT=/usr/local/config/rc.init.sh

# 2- GENERATION DU FICHIER CHMOD PATCHE
cat <<EOF >$CHMOD_PATCHE
#!/bin/sh
# Point de montage a patcher 
# (modifier la varaible HD par la valeur souhaitée (HD_c2, HD_d1...))
HD=$HD
# Fichier de trace
log=/usr/local/config/chmod.log
args="\$@"
#Arguments du chmod a desactiver
suppress_args="777 -R /mnt/USB/\$HD"

if [ "\$args" != "\$suppress_args" ]; then
    /bin/busybox chmod \$@
else
   echo "[\`date +'%Y-%m-%d %T'\`] Desactivation du chmod sur /mnt/USB/\$HD">\$log
fi

EOF

chmod 777 $CHMOD_PATCHE

# 4- Modification si necessaire fichier rc.init.sh pour patcher le chmod a chaque reboot
[ ! -s $FIC_RCINIT.orig ] && cp -pf $FIC_RCINIT $FIC_RCINIT.orig
if ! egrep -q '^# Patch chmod USB' $FIC_RCINIT ; then
   echo "# Pach chmod USB" >>$FIC_RCINIT
   echo "[ -x $CHMOD_PATCHE ] && ln -nfs $CHMOD_PATCHE /bin/chmod">>$FIC_RCINIT
fi

