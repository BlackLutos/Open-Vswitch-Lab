#!/bin/bash
# Creating bridge and namespaces
ovs-vsctl add-br v-bridge
ip netns add ns1
ip netns add ns2
ip netns add ns3
ip netns add ns4
# ip netns add router

# Create virtual interfaces to link the bridge and the namespaces
ip link add veth-ns1 type veth peer name veth-ns1-br
ip link add veth-ns2 type veth peer name veth-ns2-br
ip link add veth-ns3 type veth peer name veth-ns3-br
ip link add veth-ns4 type veth peer name veth-ns4-br



# Giving virtual interfaces to namespaces
ip link set veth-ns1 netns ns1
ip link set veth-ns2 netns ns2
ip link set veth-ns3 netns ns3
ip link set veth-ns4 netns ns4



# Giving virtual interfaces to bridge
ovs-vsctl add-port v-bridge veth-ns1-br
ovs-vsctl add-port v-bridge veth-ns2-br
ovs-vsctl add-port v-bridge veth-ns3-br
ovs-vsctl add-port v-bridge veth-ns4-br



#Enable the virtual interfaces of bridge and namespaces
ifconfig veth-ns1-br up
ifconfig veth-ns2-br up
ifconfig veth-ns3-br up
ifconfig veth-ns4-br up




ip netns exec ns1 ifconfig veth-ns1 192.168.15.1/24 up
# ip netns exec router ifconfig veth-router-ns1 192.168.11.1/24 up

ip netns exec ns2 ifconfig veth-ns2 192.168.15.2/24 up
# ip netns exec router ifconfig veth-router-ns2 192.168.12.1/24 up

ip netns exec ns3 ifconfig veth-ns3 192.168.15.3/24 up
# ip netns exec router ifconfig veth-router-ns3 192.168.13.1/24 up


ip netns exec ns4 ifconfig veth-ns4 192.168.15.4/24 up
# ip netns exec router ifconfig veth-router-ns3 192.168.14.1/24 up


ifconfig v-bridge up



sudo ip netns exec ns1 ip route
sudo ip netns exec ns2 ip route
sudo ip netns exec ns3 ip route
sudo ip netns exec ns4 ip route

ip netns exec ns1 ip route add default via 192.168.15.254
ip addr add 10.0.0.254/24 dev v-bridge

# Execute test cases
ip netns exec ns1 ping -c 1 8.8.8.8
# ip netns exec ns1 ping -c 1 192.168.15.3
# ip netns exec ns1 ping -c 1 192.168.15.4

# ip netns exec ns2 ping -c 1 192.168.15.1
# ip netns exec ns2 ping -c 1 192.168.15.3
# ip netns exec ns2 ping -c 1 192.168.15.4

# ip netns exec ns3 ping -c 1 192.168.15.1
# ip netns exec ns3 ping -c 1 192.168.15.2
# ip netns exec ns3 ping -c 1 192.168.15.3

# ip netns exec ns4 ping -c 1 192.168.15.1
# ip netns exec ns4 ping -c 1 192.168.15.2
# ip netns exec ns4 ping -c 1 192.168.15.3











