import time
from mininet.topo import Topo
from mininet.net import Mininet
from mininet.link import TCLink
from mininet.cli import  CLI
import os
from mininet.node import RemoteController
class design_Topo(Topo):
    def __init__(self,**opts):
        Topo.__init__(self,**opts)
        h1 = self.addHost('h1',mac = '00:00:00:00:00:01',ip="0.0.0.0")
        s1 = self.addSwitch('s1')
        s2 = self.addSwitch('s2')
        self.addLink(h1,s1)
        self.addLink(s1,s2)
def topo_start():
    topo = design_Topo()
    net = Mininet(topo=topo,controller = RemoteController,link = TCLink)
    net.start()
    switch = net.switches
    hosts = net.hosts
    s1 = switch[0]
    s2 = switch[1]
    h1 = hosts[0]
    s1.cmd('ovs-ofctl add-flow s1 priority=0,in_port=1,actions=NORMAL')
    s1.cmd('ovs-ofctl add-flow s1 priority=0,in_port=LOCAL,actions=NORMAL')
    s1.cmd('ifconfig s1 192.168.0.1/24')
    s1.cmd('sysctl -w net.ipv4.ip_forward=1')
    s1.cmd('sysctl -p')
    s1.cmd('iptables -t nat -A POSTROUTING -s 192.168.0.1/24 -o ens4 -j MASQUERADE')
    s1.cmd('cp ./isc-dhcp-server /etc/default')
    s1.cmd('cp ./dhcpd.conf /etc/dhcp')
    s1.cmd('sudo systemctl restart isc-dhcp-server')
    time.sleep(5)
    h1.cmd("udhcpc -i h1-eth0")
    h1.cmd("ping -c 4 8.8.8.8 > ping_result.log")
    time.sleep(5)
    print("forwarding to s2")
    s1.cmd('ifconfig s1 0.0.0.0')
    s2.cmd('ifconfig s2 192.168.0.1/24')
    s1.cmd('ovs-ofctl add-flow s1 priority=1,in_port=1,action=output:2')
    s1.cmd('ovs-ofctl add-flow s1 priority=1,in_port=2,action=output:NORMAL')
    s2.cmd('ovs-ofctl add-flow s2 priority=1,in_port=1,actions=NORMAL')
    s2.cmd('ovs-ofctl add-flow s2 priority=1,in_port=LOCAL,actions=output:1')
    h1.cmd("ping -c 50 8.8.8.8 > ping_result2.log")
    CLI(net)
    net.stop()
if __name__=='__main__':
    os.system("mn -c")
    topo_start()