#!/bin/bash
sleep 1
ip addr add 192.168.22.1/32 dev lo
ip -6 addr add fd02::1/128 dev lo

# spine - leaf1
ip addr add 172.16.21.0/31 dev eth1

# spine - leaf2
ip addr add 172.16.21.2/31 dev eth2

# to ss1
ip addr add 172.16.1.5/31 dev eth3

# to ss2
ip addr add 172.16.2.5/31 dev eth4

ip link set eth0 down
