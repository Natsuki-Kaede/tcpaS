# tcpaS

A algorithm for congestion control from TCPA.

Only supported CentOS 7.x now.

---

# Intro

Modified from Tencent TCPA congestion control algorithm.It's more efficiency,more stable and safer.

---

# Get Started

**(One-click installation script see the bottom of this doc please.)**

(The installation process is similar to TCPA.)

(If you are installed TCPA,You can install tcpaS over it,so you don't need to uninstall TCPA.)

## 1.Install dependency

```shell
yum -y install net-tools
```

## 2.Change your kernel

```shell
wget https://dl.flymc.cc/kernel-3.10.0-693.5.2.tcpa06.tl2.x86_64.rpm
rpm -ivh kernel-3.10.0-693.5.2.tcpa06.tl2.x86_64.rpm --force
```

## 3.Reboot

```shell
reboot
```

## 5.Download tcpaS

```shell
wget https://dl.flymc.cc/tcpas/tcpas_packets.tar.gz
```

## 6.Install

```shell
tar xf tcpas_packets.tar.gz
cd tcpas_packets
sh install.sh
```

## 7.Start tcpaS

```shell
cd /usr/local/storage/tcpav2
sh start.sh
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
# bash tcpas.sh
```

---

# Lisense

MIT
