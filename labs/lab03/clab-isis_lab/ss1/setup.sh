#!/bin/bash
sleep 1
ip addr add 192.168.0.1/32 dev lo
ip -6 addr add fd00::1/128 dev lo

# to spine1-1
ip addr add 172.16.1.0/31 dev eth1

# to spine1-2
ip addr add 172.16.1.2/31 dev eth2

# to spine2-1
ip addr add 172.16.1.4/31 dev eth3

ip link set eth0 down
