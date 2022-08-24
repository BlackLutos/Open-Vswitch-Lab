#!/bin/bash
brctl addbr br0

ip link add br-eth1 type veth peer name h-eth1
ip link add br-eth2 type veth peer name h-eth2
ip link add br-eth3 type veth peer name h-eth3

brctl addif br0 br-eth1 
brctl addif br0 br-eth2 
brctl addif br0 br-eth3 

brctl show
exec bash