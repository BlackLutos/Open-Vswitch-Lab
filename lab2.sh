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

# Router-ns1 to link bridge
# ip link add veth-router-ns1 type veth peer name veth-v1-br
# ip link add veth-router-ns2 type veth peer name veth-v2-br
# ip link add veth-router-ns3 type veth peer name veth-v3-br
# ip link add veth-router-ns4 type veth peer name veth-v4-br

# Giving virtual interfaces to namespaces
ip link set veth-ns1 netns ns1
ip link set veth-ns2 netns ns2
ip link set veth-ns3 netns ns3
ip link set veth-ns4 netns ns4

# ip link set veth-router-ns1 netns router
# ip link set veth-router-ns2 netns router
# ip link set veth-router-ns3 netns router
# ip link set veth-router-ns4 netns router

# Giving virtual interfaces to bridge
ovs-vsctl add-port v-bridge veth-ns1-br
ovs-vsctl add-port v-bridge veth-ns2-br
ovs-vsctl add-port v-bridge veth-ns3-br
ovs-vsctl add-port v-bridge veth-ns4-br

# ovs-vsctl add-port v-bridge veth-v1-br
# ovs-vsctl add-port v-bridge veth-v2-br
# ovs-vsctl add-port v-bridge veth-v3-br
# ovs-vsctl add-port v-bridge veth-v4-br

#Enable the virtual interfaces of bridge and namespaces
ifconfig veth-ns1-br up
ifconfig veth-ns2-br up
ifconfig veth-ns3-br up
ifconfig veth-ns4-br up

# ifconfig veth-v1-br up
# ifconfig veth-v2-br up
# ifconfig veth-v3-br up
# ifconfig veth-v4-br up


ip netns exec ns1 ifconfig veth-ns1 192.168.15.1/24 up
# ip netns exec router ifconfig veth-router-ns1 192.168.11.1/24 up

ip netns exec ns2 ifconfig veth-ns2 192.168.15.2/24 up
# ip netns exec router ifconfig veth-router-ns2 192.168.12.1/24 up

ip netns exec ns3 ifconfig veth-ns3 192.168.15.3/24 up
# ip netns exec router ifconfig veth-router-ns3 192.168.13.1/24 up


ip netns exec ns4 ifconfig veth-ns4 192.168.15.4/24 up
# ip netns exec router ifconfig veth-router-ns3 192.168.14.1/24 up


ifconfig v-bridge up

# Set up nat rules and route rules to enable forwarding function
# ip netns exec router sysctl -w net.ipv4.ip_forward=1

# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.12.0/24 -o veth-router-ns1 -j MASQUERADE
# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.13.0/24 -o veth-router-ns1 -j MASQUERADE
# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.14.0/24 -o veth-router-ns1 -j MASQUERADE

# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.11.0/24 -o veth-router-ns2 -j MASQUERADE
# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.13.0/24 -o veth-router-ns2 -j MASQUERADE
# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.14.0/24 -o veth-router-ns2 -j MASQUERADE

# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.11.0/24 -o veth-router-ns3 -j MASQUERADE
# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.12.0/24 -o veth-router-ns3 -j MASQUERADE
# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.14.0/24 -o veth-router-ns3 -j MASQUERADE

# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.11.0/24 -o veth-router-ns4 -j MASQUERADE
# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.12.0/24 -o veth-router-ns4 -j MASQUERADE
# ip netns exec router iptables -t nat -A POSTROUTING -s 192.168.13.0/24 -o veth-router-ns4 -j MASQUERADE

# ip netns exec ns1 route add -net 0.0.0.0 gw 192.168.15.1 veth-ns1
# ip netns exec ns2 route add -net 0.0.0.0 gw 192.168.15.2 veth-ns2
# ip netns exec ns3 route add -net 0.0.0.0 gw 192.168.15.3 veth-ns3
# ip netns exec ns4 route add -net 0.0.0.0 gw 192.168.15.4 veth-ns4

# Add a vlan tag to isolate the broadcast domain
# ovs-vsctl set Port veth-ns1-br tag=3
# # ovs-vsctl set Port veth-v1-br tag=3

# ovs-vsctl set Port veth-ns2-br tag=4
# # ovs-vsctl set Port veth-v2-br tag=4

# ovs-vsctl set Port veth-ns3-br tag=5
# # ovs-vsctl set Port veth-v3-br tag=5

# ovs-vsctl set Port veth-ns4-br tag=6
# # ovs-vsctl set Port veth-v4-br tag=6

# Execute test cases
ip netns exec ns1 ping -c 1 192.168.15.2
ip netns exec ns1 ping -c 1 192.168.15.3
ip netns exec ns1 ping -c 1 192.168.15.4

ip netns exec ns2 ping -c 1 192.168.15.1
ip netns exec ns2 ping -c 1 192.168.15.3
ip netns exec ns2 ping -c 1 192.168.15.4

ip netns exec ns3 ping -c 1 192.168.15.1
ip netns exec ns3 ping -c 1 192.168.15.2
ip netns exec ns3 ping -c 1 192.168.15.3

ip netns exec ns4 ping -c 1 192.168.15.1
ip netns exec ns4 ping -c 1 192.168.15.2
ip netns exec ns4 ping -c 1 192.168.15.3











