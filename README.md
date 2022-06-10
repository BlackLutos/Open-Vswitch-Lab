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
