import os
import sh

print('deleting...')
sh.bash('delete_linux_bridge.sh')
sh.bash('ovs_delete.sh')
sh.mn('-c')
print('Finish !!!')