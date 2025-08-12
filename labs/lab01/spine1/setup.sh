#!/bin/bash
sleep 1
ip addr add 10.0.0.1/32 dev lo
ip -6 addr add fd00::1/128 dev lo

# spine - leaf1
ip addr add 192.168.0.0/31 dev eth1

# spine - leaf2
ip addr add 192.168.0.2/31 dev eth2

# spine - leaf3
ip addr add 192.168.0.4/31 dev eth3

ip link set eth0 down
