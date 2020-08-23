#!/bin/bash

INSTALL_PATH="/usr/local/storage/tcpav2"
INSTALL_PATH_BAK="/usr/local/storage/tcpav2_bak"
SYSCTL_CONFIG="sysctl.conf"

tkernel_version=`uname -r`

cd `dirname $0`

grep -q "$INSTALL_PATH/start.sh" /etc/rc.local
if [ $? -eq 0 ]
then
	sed -ie '/storage\/tcpav*/d' /etc/rc.local
fi

#other scripts handle sysctl setting. so, we ingore it .
: <<-  EOF

grep -q "tcpa sysctl config" /etc/sysctl.conf
if [ $? -eq 0 ]
then

	while read line 
	do
		if [ -z $line ];then
			continue;
		fi

		echo $line | grep -q "tcpa sysctl config"
		if [ $? -eq 0 ];then
			sed -ie "/tcpa sysctl config/d" /etc/sysctl.conf
			continue;
		fi

		sed -ie "/$line/d" /etc/sysctl.conf
	done < $SYSCTL_CONFIG

fi

EOF


echo "OK: succeed to uninstall!"


