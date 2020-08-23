#!/bin/bash

INSTALL_PATH="/usr/local/storage/tcpav2"
INSTALL_PATH_BAK="/usr/local/storage/tcpav2_bak"
LOG_FILE=$INSTALL_PATH/log.txt
SYSCTL_CONFIG="sysctl.conf"

tkernel_version=`uname -r`

cd `dirname $0`

if [ ! -f ko/$tkernel_version/tcpa_engine.ko ];then
	echo "Error:tcpa kernel module don't supoort $tkernel_version!"
	exit 1
fi


#install tcpa and initial service
rm -rf $INSTALL_PATH_BAK
mkdir -p $INSTALL_PATH
mv $INSTALL_PATH $INSTALL_PATH_BAK
mkdir -p $INSTALL_PATH
touch $LOG_FILE

#cp -r *  $INSTALL_PATH
chmod 755 start.sh  stop.sh tcpactl setpolicy uninstall.sh 
cp -r start.sh  stop.sh uninstall.sh sysctl.conf $INSTALL_PATH
cp -r tcpactl setpolicy  $INSTALL_PATH
cp -r ko $INSTALL_PATH

#1.2 auto start tcpa
echo "Auto start tcpa after system reboot." | tee -a $LOG_FILE
#use /etc/rc.d/rc.local not /etc/rc.local which is a soft link point to /etc/rc.d/rc.local
grep -q "$INSTALL_PATH/start.sh" /etc/rc.d/rc.local
if [ $? -ne 0 ]
then
        echo -e "\n\n/bin/sh $INSTALL_PATH/start.sh > /dev/null 2>&1" >> /etc/rc.d/rc.local
fi

: <<-  EOF

#1.3 add sysctl file
date >> $LOG_FILE
echo "Add sysctl file and configure them." | tee -a $LOG_FILE
sysctl -p $SYSCTL_CONFIG  2>&1 | tee -a $LOG_FILE
grep -q "tcpa sysctl config" /etc/sysctl.conf
if [ $? -ne 0 ]
then
	cat $SYSCTL_CONFIG >> /etc/sysctl.conf	
fi

EOF


#1.4 create tcpa ko link
date >> $LOG_FILE
if [ -f tcpa_engine.ko ];then
	unlink tcpa_engine.ko
fi

echo "ln -s ko/$tkernel_version/tcpa_engine.ko tcpa_engine.ko" | tee -a $LOG_FILE
ln -s ko/$tkernel_version/tcpa_engine.ko tcpa_engine.ko

echo "OK: succeed to install!" | tee -a $LOG_FILE 


