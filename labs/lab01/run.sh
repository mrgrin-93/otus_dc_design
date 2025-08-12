#!/bin/bash

sudo clab deploy --runtime podman --topo lab.yaml

sudo podman exec clab-address_space-leaf1 /setup.sh
sudo podman exec clab-address_space-leaf2 /setup.sh
sudo podman exec clab-address_space-leaf3 /setup.sh
sudo podman exec clab-address_space-spine1 /setup.sh
sudo podman exec clab-address_space-spine2 /setup.sh
