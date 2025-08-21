#!/bin/bash

sudo clab deploy --runtime podman --topo isis_lab.clab.yml

sudo podman exec clab-isis_lab-leaf1-1 /setup.sh
sudo podman exec clab-isis_lab-leaf1-2 /setup.sh
sudo podman exec clab-isis_lab-leaf1-3 /setup.sh
sudo podman exec clab-isis_lab-spine1-1 /setup.sh
sudo podman exec clab-isis_lab-spine1-2 /setup.sh
sudo podman exec clab-isis_lab-leaf2-1 /setup.sh
sudo podman exec clab-isis_lab-leaf2-2 /setup.sh
sudo podman exec clab-isis_lab-spine2-1 /setup.sh
sudo podman exec clab-isis_lab-ss1 /setup.sh
sudo podman exec clab-isis_lab-ss2 /setup.sh
