import time
from mininet.topo import Topo
from mininet.net import Mininet
from mininet.link import TCLink
from mininet.cli import  CLI
import os

class design_Topo(Topo):
    def __init__(self,**opts):
        Topo.__init__(self,**opts)
        h1 = self.addHost('h1',mac = '00:00:00:00:00:01',ip="0.0.0.0")
        s1 = self.addSwitch('s1')
        self.addLink(h1,s1)
def topo_start():
    topo = design_Topo()
    net = Mininet(topo=topo,link = TCLink)
    net.start()
    switch = net.switches
    hosts = net.hosts
    s1 = switch[0]
    h1 = hosts[0]
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
    #CLI(net)
    net.stop()
if __name__=='__main__':
    #setLogLevel('info')
    os.system("mn -c")
    topo_start()