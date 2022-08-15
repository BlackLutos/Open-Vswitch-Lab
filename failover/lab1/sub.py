from mininet.topo import Topo
from mininet.net import Mininet
from mininet.link import TCLink
from mininet.cli import  CLI
from mininet.node import Controller, OVSKernelSwitch, RemoteController
import time
import os
import sh

class design_Topo(Topo):
    def __init__(self):
        Topo.__init__(self)
        h1 = self.addHost('h1',mac = '00:00:00:00:00:01')
        h2 = self.addHost('h2')
        s1 = self.addSwitch('s1')
        s2 = self.addSwitch('s2')
        self.addLink(h1,s1)
        self.addLink(s1,h2)
        self.addLink(s1,s2)
        #self.addLink(s2,h2)
def topo_start():
    topo = design_Topo()
    net = Mininet(controller=RemoteController,topo=topo,link = TCLink)
    #c1 = net.addController( 'c1', port=6633 )
    net.start()
    sh.bash('oflow.sh')
    switch = net.switches
    hosts = net.hosts
    h1 = hosts[0]
    h2 = hosts[1]
    s1 = switch[0]
    h1.cmd('ifconfig h1-eth0 192.168.1.100/24 up')
    h2.cmd('ifconfig h2-eth0 192.168.1.200/24 up')
    s1.cmd('ip addr add 192.168.1.1/24 dev s1')
    s1.cmd('ifconfig s1 up')
    s1.cmd('sysctl -w net.ipv4.ip_forward=1')
    s1.cmd('sysctl -p')
    s1.cmd('iptables -t nat -A POSTROUTING -s 192.168.1.0 -o ens33 -j MASQUERADE')
    s1.cmd('iptables -F')
    s1.cmd('iptables -P FORWARD ACCEPT')
    CLI(net)
    net.stop()
if __name__=='__main__':
    topo_start()
    os.system("mn -c")
    print('Clean Finish !')