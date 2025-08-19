#!/bin/bash
sleep 1
ip addr add 10.0.1.1/32 dev lo
ip -6 addr add fd00::1:1/128 dev lo

# Leaf - spine1 leg
ip addr add 192.168.0.1/31 dev eth1

# Leaf - spine2 leg
ip addr add 192.168.1.1/31 dev eth2

# Leaf - host leg
ip link add br1 type bridge
ip link set br1 addr aa:bb:cc:00:00:65
ip link set br1 up
ip link set eth3 master br1
ip addr add 172.16.1.1/24 dev br1
ip -6 addr add fd01:0:0:1::1/64 dev br1

ip link set eth0 down
