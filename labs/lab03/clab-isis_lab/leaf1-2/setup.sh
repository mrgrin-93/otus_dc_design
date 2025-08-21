#!/bin/bash
sleep 1
ip addr add 192.168.11.2/32 dev lo
ip -6 addr add fd01::1:2/128 dev lo

# Leaf - spine1 leg
ip addr add 172.16.11.3/31 dev eth1

# Leaf - spine2 leg
ip addr add 172.16.12.3/31 dev eth2

ip link set eth0 down
