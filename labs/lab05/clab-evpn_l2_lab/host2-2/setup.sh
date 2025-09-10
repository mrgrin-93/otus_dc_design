#!/bin/bash
#

sleep 3
ip addr add 172.16.2.2/24 dev eth1


# set the default gw via eth1
ip r del default
ip r add default via 172.16.2.1
sleep INF
