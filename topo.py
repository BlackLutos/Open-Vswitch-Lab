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
		h1 = self.addHost('h1',mac = '00:00:00:00:00:01')
		h2 = self.addHost('h2',mac = '00:00:00:00:00:02')
		s1 = self.addSwitch('s1')
		s2 = self.addSwitch('s2')
		s3 = self.addSwitch('s3')
		self.addLink(h1,s1)
		self.addLink(h2,s2)
		self.addLink(s1,s2)
		self.addLink(s2,s3)
		self.addLink(s3,s1)
def topo_start():
	topo = design_Topo()
	net = Mininet(topo=topo,controller = RemoteController,link = TCLink)
	net.start()
	CLI(net)
	# insert automatically
	net.stop()
if __name__=='__main__':
	#setLogLevel('info')
	sh.mn("-c")
	topo_start()

