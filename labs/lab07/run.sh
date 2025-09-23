#!/bin/bash

sudo clab deploy --runtime podman --topo evpn_mh.clab.yml

sudo podman exec clab-evpn_mh-spine1-1 /setup.sh
sudo podman exec clab-evpn_mh-spine1-2 /setup.sh
