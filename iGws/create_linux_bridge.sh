#!/bin/bash
brctl addbr br0
ip netns add h1

ip link add br-eth1 type veth peer name h-eth1
ip link add br-eth2 type veth peer name h-eth2
ip link add br-eth3 type veth peer name h-eth3

brctl addif br0 br-eth1 
brctl addif br0 br-eth2     
brctl addif br0 br-eth3

ip link set h-eth1 netns h1

ifconfig br0 192.168.0.1/24 up
ifconfig br-eth1 up

sysctl -w net.ipv4.ip_forward=1
sysctl -p
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o ens33 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s 192.168.0.1/24 -o ens33 -j MASQUERADE
cp ./isc-dhcp-server /etc/default
cp ./dhcpd.conf /etc/dhcp
sudo systemctl restart isc-dhcp-server
# ip netns exec netns h1 udhcpc -i h-eth1

brctl show

# ip netns exec h1 /bin/bash udhcpc -i h-eth1
ip netns exec h1 /bin/bash --rcfile <(echo "PS1=\"namespace h1> \"")

exec bash