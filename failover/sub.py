from operator import ne
from re import S
import time
from mininet.topo import Topo
from mininet.net import Mininet
from mininet.link import TCLink
from mininet.cli import  CLI
import os

class design_Topo(Topo):
    def __init__(self):
        Topo.__init__(self)
        h1 = self.addHost('h1',mac = '00:00:00:00:00:01',ip="0.0.0.0")
        s1 = self.addSwitch('s1')
        s2 = self.addSwitch('s2')
        s3 = self.addSwitch('s3')
        self.addLink(h1,s1)
        self.addLink(s1,s2)
        self.addLink(s2,s3)
        # self.addLink(s1,s3)
def topo_start():
    topo = design_Topo()
    net = Mininet(topo=topo,link = TCLink)
    net.start()
    switch = net.switches
    hosts = net.hosts
    h1 = hosts[0]
    s1 = switch[0]
    s2 = switch[1]
    s3 = switch[2]
    s1.cmd('ifconfig s1 192.168.0.1/24') # Configure IP Address to S1
    s1.cmd('sysctl -w net.ipv4.ip_forward=1') # Open IP forwarding
    s1.cmd('sysctl -p') # Make configuration become effective instantly
    s1.cmd('iptables -t nat -A POSTROUTING -s 192.168.0.1/24 -o ens33 -j MASQUERADE')
    # s1.cmd('cp ./isc-dhcp-server /etc/default')
    # s1.cmd('cp ./dhcpd.conf /etc/dhcp')
    # s1.cmd('sudo systemctl restart isc-dhcp-server')
    time.sleep(5)
    # h1.cmd("udhcpc -i h1-eth0") # To configure ip by DHCP Server
    h1.cmd('ifconfig h1-eth0 192.168.0.2/24')
    s2.cmd('ifconfig s2 192.168.1.1/24')
    s3.cmd('ifconfig s3 192.168.2.1/24')
    CLI(net)
    net.stop()
if __name__=='__main__':
    os.system("mn -c")
    topo_start()

        