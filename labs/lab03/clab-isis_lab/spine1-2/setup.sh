#!/bin/bash
sleep 1
ip addr add 192.168.21.2/32 dev lo
ip -6 addr add fd01::2/128 dev lo

# spine - leaf1
ip addr add 172.16.12.0/31 dev eth1

# spine - leaf2
ip addr add 172.16.12.2/31 dev eth2

# spine - leaf3
ip addr add 172.16.12.4/31 dev eth3

# to ss1
ip addr add 172.16.1.3/31 dev eth4

# to ss2
ip addr add 172.16.2.3/31 dev eth5

ip link set eth0 down
