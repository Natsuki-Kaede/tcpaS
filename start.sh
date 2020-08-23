#!/bin/bash


DIRNAME=`dirname $0`
MODNAME=tcpa_engine
MODDIR="/usr/local/storage/tcpav2/ko/"
BINDIR=$DIRNAME
SETAPP=""
CTLAPP=""
PARADIR=/sys/module/$MODNAME/parameters
SYSCTL_CONFIG=sysctl.conf
SETAPP=setpolicy
CTLAPP=tcpactl

lsmod | grep tcpa_engine
if [ $? -eq 0 ];then
	echo 0 > $PARADIR/tcpa_en
	rmmod tcpa_engine
fi

cd `dirname $0`
insmod  $MODDIR/`uname -r`/tcpa_engine.ko 
if [ $? -eq 1 ];then
	echo "install tcpaS module fail."
	exit 1

fi


devs=`ip link show |grep BROADCAST | awk '{print $2}' | cut -d ':' -f1`
for dev in $devs
do
	ntuple_status=`ethtool -k $dev | grep ntuple-filters | awk '{print $2}'`
	if [ "$ntuple_status" == "off" ];then
	    ethtool -K $dev ntuple on
	fi
done


ips=`ifconfig |grep "inet" | awk '{print $2}'| cut -d ':' -f2`
for ip in $ips
do
	if [ "$ip" != "127.0.0.1" ];then
		$BINDIR/$CTLAPP access add tip $ip tport 80
		$BINDIR/$CTLAPP access add tip $ip tport 8080
		$BINDIR/$CTLAPP access add tip $ip tport 443
	fi

done

echo 1 > $PARADIR/tcpa_en
echo 0 > $PARADIR/file_thresh


#configure tcpa parameter
$BINDIR/$SETAPP 1 0.0.0.0 65535 60
$BINDIR/$SETAPP 2 0.0.0.0 65535 0 0
$BINDIR/$SETAPP 4 0.0.0.0 65535 0
$BINDIR/$SETAPP 5 0.0.0.0 65535 0

#just print err and warn. set with 15, so print all.
echo 12 > $PARADIR/log_level

echo 0 > $PARADIR/probe_exwnd
echo 0 > $PARADIR/extend_wnd
echo 0 > $PARADIR/cwnd_multiple
echo 0 > $PARADIR/ack_200
echo 1600000 > $PARADIR/init_windows 
echo 60 > $PARADIR/min_cwnd
echo 1 > $PARADIR/reo_factor
echo 1 > $PARADIR/rto_factor
echo 2 > $PARADIR/probe_interval
echo 0 > $PARADIR/wnd_extend

#disable tso/gso
ethtool -K eth0 tso off gso off
ethtool -K eth1 tso off gso off

#enable irtt 
modprobe tcp_irtt
sysctl -w net.ipv4.tcp_congestion_control=irtt

#set irtt paras
echo 450000 > /sys/module/tcp_irtt/parameters/min_pacing 
echo 5076000 >  /sys/module/tcp_irtt/parameters/init_bytes


#configure sysctem config
sysctl -p $SYSCTL_CONFIG
if [ $? -eq 1 ];then
	echo "Fail to set sysctl configure."
	exit 1
fi


echo "Configure ok"
	
