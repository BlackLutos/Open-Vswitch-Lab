#!/bin/bash
ovs-vsctl del-br br-int
ip netns del ns01
ip netns del ns02
ip netns del router-ns1
exec bash