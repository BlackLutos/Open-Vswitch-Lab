#!/bin/bash
ip link set br0 down
brctl delbr br0
ip netns del h1
brctl show

mn -c
exec bash