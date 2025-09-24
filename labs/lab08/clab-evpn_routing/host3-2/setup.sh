#!/bin/bash
#

sleep 3
ip link add name bond0 type bond mode 802.3ad
ip link set dev eth1 down master bond0
ip link set dev eth2 down master bond0

ip addr add 172.17.1.2/24 dev bond0

ip link set dev bond0 up
ip link set dev eth1 up
ip link set dev eth2 up

# set the default gw via eth1
ip r del default
ip r add default via 172.17.1.1
sleep INF
