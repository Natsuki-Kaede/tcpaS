# tcpaS

A algorithm for congestion control modified from TCPA.

Only supported CentOS 7.x now.

Chinese-Simplified document: https://flymc.cc/2020/08/23/tcpaS/

---

# Intro

Modified from Tencent TCPA congestion control algorithm.It's more efficiency,more stable and safer,and improve the transmission capacity of large files.

---

# Get Started

**(One-click installation script see the bottom of this doc please.)**

(The installation process is similar to TCPA.)

(If you are installed TCPA,You can install tcpaS over it,so you don't need to uninstall TCPA.)

## 1.Install dependency

```shell
# yum install wget
# yum -y install net-tools
```

## 2.Change your kernel

```shell
# wget https://dl.flymc.cc/kernel-3.10.0-693.5.2.tcpa06.tl2.x86_64.rpm
# rpm -ivh kernel-3.10.0-693.5.2.tcpa06.tl2.x86_64.rpm --force
```

## 3.Reboot

```shell
# reboot
```

## 5.Download tcpaS

```shell
# wget https://dl.flymc.cc/tcpas/tcpas_packets.tar.gz
```

## 6.Install

```shell
# tar xf tcpas_packets.tar.gz
# cd tcpas_packets
# sh install.sh
```

## 7.Start tcpaS

```shell
# cd /usr/local/storage/tcpav2
# sh start.sh
```

## 8.Verify

```shell
# lsmod|grep tcpa
Output:
tcpa_engine           224249  0
```

---

# One-click installation

```shell
# wget https://dl.flymc.cc/tcpas/tcpas.sh
# chmod +x tcpas.sh
# sh tcpas.sh
```

---

# Uninstall

```shell
# cd /usr/local/storage/tcpav2
# bash uninstall.sh
```

---

# Lisense

MIT
