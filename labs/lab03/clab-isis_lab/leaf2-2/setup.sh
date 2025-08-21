#!/bin/bash
sleep 1
ip addr add 192.168.12.2/32 dev lo
ip -6 addr add fd02::1:2/128 dev lo

# Leaf - spine2-1 leg
ip addr add 172.16.21.3/31 dev eth1

ip link set eth0 down
