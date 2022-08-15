#!/bin/bash
ovs-ofctl del-flows s1

ovs-ofctl add-flow s1 priority=1,in_port=1,actions=output:2
ovs-ofctl add-flow s1 priority=1,in_port=2,actions=output:1