#!/bin/bash
# Delete bridge and namespaces
ip netns del ns1
ip netns del ns2
ip netns del ns3
ip netns del ns4

# ip netns del router

ovs-vsctl del-br v-bridge