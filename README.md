# Open-Vswitch-Lab
## Practice for ovs

### Clone this Repo
```
$ git clone https://github.com/BlackLutos/Open-Vswitch-Lab.git
```

### Install OVS
```
$ sudo apt-get install openvswitch-switch
```
### DNS Setting
[DNS-Setting](https://blog.gtwang.org/tips/google-public-dns/)
[Edit resolv.conf forever](https://blog.csdn.net/u010879745/article/details/122764724)

### Bridge Operation

* Add Bridge
```
$ ovs-vsctl --may-exist add-br ${bridege_name} 
```
* Delete Bridge
```
$ ovs-vsctl --if-exists del-br ${bridege_name} 
```
* List Bridge
```
$ ovs-vsctl list-br
```

### Linux Ip Namespace

* Add Namespace
```
$ ip netns add ${namespace_name} 
```
* Delete Namespace
```
$ ip netns del ${namespace_name} 
```
* List Namespace
```
$ ip netns list
```
### Create Veth to connect bridge and namespace

* Create Veth pair
```
$ ip link add ${veth_name_1} type veth peer name ${veth_name_2}
```
* Connect Namespace
```
$ ip link set ${veth_name} netns ${namespace_name}
```
* Connect bridge and enable port
```
$ ovs-vsctl add-port br-int ${veth_name}
$ ifconfig ${veth_name} up
```
