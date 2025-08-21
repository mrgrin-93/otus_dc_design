#!/bin/bash
sleep 1
ip addr add 192.168.0.2/32 dev lo
ip -6 addr add fd00::2/128 dev lo

# spine - leaf1
ip addr add 172.16.2.0/31 dev eth1

# spine - leaf2
ip addr add 172.16.2.2/31 dev eth2

# spine - leaf3
ip addr add 172.16.2.4/31 dev eth3

ip link set eth0 down
