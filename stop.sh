#!/bin/bash

MODNAME=tcpa_engine
PARADIR=/sys/module/$MODNAME/parameters

cd `dirname $0`	
echo "Firstly disable tcpaS."
echo 0 > $PARADIR/tcpa_en


lsmod | grep tcpa_engine
if [ $? -eq 0 ];then
	echo "delete tcpa_engine.ko"
	rmmod tcpa_engine
fi

sysctl -w net.ipv4.tcp_rmem="4096 87380 6291456"
sysctl -w net.ipv4.tcp_wmem="4096 16384 4194304"
sysctl -w net.ipv4.tcp_congestion_control=cubic
echo "Succeed to disable tcpa."
	
