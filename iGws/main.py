import os
import sh

def ovs_port_select():
    port = input("Please input port number (like ex. eth3): ")
    return str(port)

if __name__=='__main__':
    port = ovs_port_select()

    eth_port = 'br-' + port
    h_eth_port = 'h-' + port

    diable_eth_port = 'ifconfig ' + eth_port + ' down'
    del_eth_port = 'brctl delif br0 ' + eth_port
    # add_eth_port = 'ip link add ' + eth_port + ' type veth peer name ' + h_eth_port
    ovs_add_port = 'ovs-vsctl add-port ovs-br0 ' + eth_port

    os.system(diable_eth_port)
    os.system(del_eth_port)
    # os.system(add_eth_port)
    os.system(ovs_add_port)
    os.system('ifconfig br0 0.0.0.0/24')
    os.system('ifconfig ovs-br0 192.168.0.1/24 up')
    os.system('ifconfig ' + eth_port + ' up')

    os.system('brctl show')
    os.system('ovs-vsctl show') 

    # print(diable_eth_port)
    # os.system('ip link add ' + eth_port + 'type veth peer name ' + h_eth_port)
    # os.system('ovs-vsctl add-port ovs-br0 ' + port)
    # ip netns exec h1 /bin/bash --rcfile <(echo "PS1=\"namespace h1> \"")
    # ip netns exec h1 ping google.com -c 3
    # os.system('python3 delete.py')

	