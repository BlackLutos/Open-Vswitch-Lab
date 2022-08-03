#!/bin/bash
# Creating bridge and namespaces
ovs-vsctl add-br br-int
ip netns add ns01
ip netns add ns02 
ip netns add router-ns1

# Create virtual interfaces to link the bridge and the namespaces
ip link add veth01 type veth peer name veth02
ip link add veth03 type veth peer name veth04
ip link add veth05 type veth peer name veth06
ip link add veth07 type veth peer name veth08

# Giving virtual interfaces to namespaces
ip link set veth01 netns ns01
ip link set veth03 netns router-ns1
ip link set veth05 netns router-ns1
ip link set veth07 netns ns02

# Giving virtual interfaces to bridge
ovs-vsctl add-port br-int veth02
ovs-vsctl add-port br-int veth04
ovs-vsctl add-port br-int veth06
ovs-vsctl add-port br-int veth08

#Enable the virtual interfaces of bridge and namespaces
ifconfig veth02 up
ifconfig veth04 up
ifconfig veth06 up
ifconfig veth08 up
ip netns exec ns01 ifconfig  veth01 192.168.10.100/24 up
ip netns exec router-ns1 ifconfig  veth03 192.168.10.1/24 up
ip netns exec router-ns1 ifconfig  veth05 192.168.11.1/24 up
ip netns exec ns02 ifconfig veth07 192.168.11.110/24 up
ifconfig br-int up

# Set up nat rules and route rules to enable forwarding function
ip netns exec router-ns1  sysctl -w net.ipv4.ip_forward=1
ip netns exec router-ns1  iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o veth05 -j MASQUERADE
ip netns exec router-ns1  iptables -t nat -A POSTROUTING -s 192.168.11.0/24 -o veth03 -j MASQUERADE
ip netns exec ns01 route add -net 0.0.0.0 gw 192.168.10.1 veth01
ip netns exec ns02 route add -net 0.0.0.0 gw 192.168.11.1 veth07

# Add a vlan tag to isolate the broadcast domain
ovs-vsctl set Port veth02 tag=3
ovs-vsctl set Port veth04 tag=3
ovs-vsctl set Port veth06 tag=4
ovs-vsctl set Port veth08 tag=4

# Execute test cases
ip netns exec ns01 ping -c 1 192.168.11.110
ip netns exec ns02 ping -c 1 192.168.10.100
