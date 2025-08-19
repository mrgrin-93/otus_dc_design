#!/bin/bash
#

sleep 3
ip addr add 172.16.1.2/24 dev eth1
ip -6 addr add fd01:0:0:1::2/64 dev eth1

# set the default gw via eth1
ip r del default
ip r add default via 172.16.1.1
ip -6 r add default via fd01:0:0:1::1 dev eth1
sleep INF
