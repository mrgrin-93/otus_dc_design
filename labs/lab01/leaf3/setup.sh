#!/bin/bash
sleep 1
ip addr add 10.0.1.3/32 dev lo
ip -6 addr add fd00::1:3/128 dev lo

# Leaf - spine1 leg
ip addr add 192.168.0.5/31 dev eth1

# Leaf - spine2 leg
ip addr add 192.168.1.5/31 dev eth2

# Leaf - host leg
ip link add br3 type bridge
ip link set br3 addr aa:bb:cc:00:00:66
ip link set br3 up
ip link set eth3 master br3
ip link set eth4 master br3
ip addr add 172.16.3.1/24 dev br3
ip -6 addr add fd01:0:0:3::1/64 dev br3

ip link set eth0 down
