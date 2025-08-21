#!/bin/bash
sleep 1
ip addr add 192.168.11.1/32 dev lo
ip -6 addr add fd01::1:1/128 dev lo

# Leaf - spine1-1 leg
ip addr add 172.16.11.1/31 dev eth1

# Leaf - spine2-1 leg
ip addr add 172.16.12.1/31 dev eth2

ip link set eth0 down
