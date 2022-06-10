# Open-Vswitch-Lab
Practice for ovs

### Bridge Operation

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

### Linux Namespace

* Add Namespace
```
$ ip netns add ns01
```
* Delete Namespace
```
$ ip netns del ns01
```
### Create Veth to connect bridge and namespace

* Create Veth pair
```
$ ip link add veth01 type veth peer name veth02
```
* Connect Namespace
```
$ ip link set veth01 netns ns01
```
* Connect bridge and enable port
```
$ ovs-vsctl add-port br-int veth02
$ ifconfig veth02 up
```
