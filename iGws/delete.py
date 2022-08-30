import os

os.system('sudo mn -c')
os.system('sudo bash delete_linux_bridge.sh')
os.system('sudo bash ovs_delete.sh')