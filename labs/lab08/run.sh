#!/bin/bash

sudo clab deploy --runtime podman --topo evpn_routing.clab.yml

sudo podman exec clab-evpn_routing-edge1 /setup.sh
