# Open-Vswitch-Lab
Practice for ovs

### Bridge operation

* Add Bridge
```
$ ovs-vsctl --may-exist add-br br0
```
* Delete Bridge
```
$ ovs-vsctl --if-exists del-br br0
```
* List Bridge
```
$ ovs-vsctl list-br
```
