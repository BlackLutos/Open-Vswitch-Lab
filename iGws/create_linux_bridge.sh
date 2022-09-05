#!/bin/bash
# brctl addbr br0
sudo service network-manager start
sudo nmcli con add ifname br0 type bridge con-name br0

ip netns add h1

ip link add br-eth1 type veth peer name h-eth1
ip link add br-eth2 type veth peer name h-eth2
ip link add br-eth3 type veth peer name h-eth3

# brctl addif br0 br-eth1 
# brctl addif br0 br-eth2     
# brctl addif br0 br-eth3
nmcli con add type bridge-slave ifname br-eth1 master br0
nmcli con add type bridge-slave ifname br-eth2 master br0
nmcli con add type bridge-slave ifname br-eth3 master br0

ip link set h-eth3 netns h1

# ifconfig br0 192.168.0.1/24 up
sudo nmcli connection modify br0 ipv4.addresses '192.168.0.1/24'
sudo nmcli con modify br0 ipv4.method manual
sudo nmcli con up br0 

ifconfig br-eth3 up

sysctl -w net.ipv4.ip_forward=1
sysctl -p
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o ens33 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s 192.168.0.1/24 -o ens33 -j MASQUERADE
cp ./isc-dhcp-server /etc/default
cp ./dhcpd.conf /etc/dhcp
sudo systemctl restart isc-dhcp-server
# ip netns exec h1 udhcpc -i h-eth3

# brctl show
nmcli connection show

# ip netns exec h1 /bin/bash udhcpc -i h-eth3
# ip netns exec h1 /bin/bash --rcfile <(echo "PS1=\"namespace h1> \"")


# echo 'waiting for h1 ping google.com...'
# ip netns exec h1 ping google.com -c 3 > ping_result.log
# cat ping_result.log

exec bash