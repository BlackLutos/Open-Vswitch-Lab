#!/bin/bash
ovs-ofctl del-flows s1
ovs-ofctl del-flows s2
ovs-ofctl del-flows s3

# rule 1
ovs-ofctl add-flow s1 priority=1,in_port=1,actions=output:2
ovs-ofctl add-flow s1 priority=1,in_port=2,actions=output:1
ovs-ofctl add-flow s2 priority=1,in_port=2,actions=output:1
ovs-ofctl add-flow s2 priority=1,in_port=1,actions=output:2

#rule 2
ovs-ofctl add-flow s1 priority=2,in_port=1,actions=output:3
ovs-ofctl add-flow s1 priority=2,in_port=3,actions=output:1
ovs-ofctl add-flow s3 priority=2,in_port=2,actions=output:1
ovs-ofctl add-flow s3 priority=2,in_port=1,actions=output:2
ovs-ofctl add-flow s2 priority=2,in_port=3,actions=output:1
ovs-ofctl add-flow s2 priority=2,in_port=1,actions=output:3