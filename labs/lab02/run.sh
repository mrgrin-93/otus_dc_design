#!/bin/bash

sudo clab deploy --runtime podman --topo lab2.clab.yaml

sudo podman exec clab-ospf_lab-leaf1 /setup.sh
sudo podman exec clab-ospf_lab-leaf2 /setup.sh
sudo podman exec clab-ospf_lab-leaf3 /setup.sh
sudo podman exec clab-ospf_lab-spine1 /setup.sh
sudo podman exec clab-ospf_lab-spine2 /setup.sh
