import os
import time
import sh
from mininet.topo import Topo
from mininet.net import Mininet
from mininet.link import TCLink
from mininet.cli import  CLI
from mininet.log import setLogLevel,info
from mininet.util import quietRun
from mininet.node import RemoteController
from mininet.term import makeTerm
from mininet.node import OVSSwitch


class design_Topo(Topo):
	def __init__(self,**opts):
		Topo.__init__(self,**opts)
		# h1 = self.addHost('h1',mac = '00:00:00:00:00:01')
		# h2 = self.addHost('h2',mac = '00:00:00:00:00:02')
		# h1 = self.addHost('h1', ip="192.168.15.2/24")
		# h2 = self.addHost('h2', ip="192.168.15.3/24")
		h1 = self.addHost('h1')
		h2 = self.addHost('h2')
		s1 = self.addSwitch('s1')
		s2 = self.addSwitch('s2')
		s3 = self.addSwitch('s3')
		self.addLink(h1,s1)
		self.addLink(h2,s2)
		self.addLink(s1,s2)
		self.addLink(s2,s3)
		self.addLink(s3,s1)
		# self.cmd('ifconfig h1-eth0 192.168.15.2/24 up')
def topo_start():
	topo = design_Topo()
	net = Mininet(topo=topo,controller = RemoteController,link = TCLink)
	net.start()
	sh.bash("topo_flow.sh")
	# insert automatically
	hosts = net.hosts
	h1 = hosts[0]
	h2 = hosts[1]
	h1.cmd('ifconfig h1-eth0 192.168.15.2/24 up')
	h2.cmd('ifconfig h2-eth0 192.168.15.3/24 up')

	switch = net.switches
	s1 = switch[0]
	s2 = switch[1]
	s3 = switch[2]

	s1.cmd('ifconfig s1-eth1 192.168.15.4/24 up')
	# print(hosts)
	CLI(net)
	net.stop()
if __name__=='__main__':
	#setLogLevel('info')
	sh.mn("-c")
	topo_start()

