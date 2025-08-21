#!/bin/bash
sleep 1
ip addr add 192.168.21.1/32 dev lo
ip -6 addr add fd01::1/128 dev lo

# spine - leaf1
ip addr add 172.16.11.0/31 dev eth1

# spine - leaf2
ip addr add 172.16.11.2/31 dev eth2

# spine - leaf3
ip addr add 172.16.11.4/31 dev eth3

# to ss1
ip addr add 172.16.1.1/31 dev eth4

# to ss2
ip addr add 172.16.2.1/31 dev eth5

ip link set eth0 down
