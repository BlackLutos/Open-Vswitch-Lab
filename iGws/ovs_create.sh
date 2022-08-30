#!/bin/bash
ovs-vsctl add-br ovs-br0
ovs-vsctl show

exec bash
