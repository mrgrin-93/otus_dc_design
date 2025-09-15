#!/bin/bash
#

sudo clab deploy --runtime podman --topo evpnl2-l3.clab.yml

sudo podman exec clab-evpnl2-l3-leaf1 /setup.sh
sudo podman exec clab-evpnl2-l3-leaf2 /setup.sh
sudo podman exec clab-evpnl2-l3-spine /setup.sh
