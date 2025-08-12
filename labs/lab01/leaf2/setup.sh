#!/bin/bash
sleep 1
ip addr add 10.0.1.2/32 dev lo
ip -6 addr add fd00::1:2/128 dev lo

# Leaf - spine1 leg
ip addr add 192.168.0.3/31 dev eth1

# Leaf - spine2 leg
ip addr add 192.168.1.3/31 dev eth2

# Leaf - host leg
ip link add br2 type bridge
ip link set br2 addr aa:bb:cc:00:00:66
ip link set br2 up
ip link set eth3 master br2
ip addr add 172.16.2.1/24 dev br2
ip -6 addr add fd01:0:0:2::1/64 dev br2

ip link set eth0 down
