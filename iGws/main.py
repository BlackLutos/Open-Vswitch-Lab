import os

def ovs_port_select():
    port = input("Please input port number: ")
    return str(port)










if __name__=='__main__':
    # port = ovs_port_select()
    os.system('sudo bash create_linux_bridge.sh')
    os.system('sudo bash ovs_create.sh')

	