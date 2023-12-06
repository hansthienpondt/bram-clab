#!/bin/bash
# Execute on docker host: sudo modprobe bonding mmiimon=100 mode=802.3ad lacp_rate=fast
# creating bond interface w/LACP
ip link add bond0 type bond mode 802.3ad
ip link set address 00:c1:00:dc:01:15 dev bond0
ip addr add 91.216.20.202/26 dev bond0
ip -6 addr add 2001:67c:1cc:2::15/64 dev bond0
ip link set eth1 down 
ip link set eth2 down
ip link set eth1 master bond0
ip link set eth2 master bond0
ip link set eth1 up 
ip link set eth2 up  
ip link set bond0 up
ip -6 r a fd00::/8 via 2001:67c:1cc:2::1 dev bond0
ip r a 10.0.0.0/8 via 91.216.20.192 dev bond0
ip r a 192.168.0.0/16 via 91.216.20.193 dev bond0
ip r a 2.59.64.0/22 via 91.216.20.193 dev bond0
ip r a 91.216.20.0/24 via 91.216.20.193 dev bond0
ip -6 r a 2a09:e940::/32 via 2001:67c:1cc:2::1 dev bond0
ip -6 r a 2001:67c:1cc::/48 via 2001:67c:1cc:2::1 dev bond0
# Fix SRLinux NDP unicast solicit (scope ll / gua) behavior -- TBC
sysctl -w net.ipv6.neigh.bond0.ucast_solicit=0
sysctl -w net.ipv6.neigh.bond0.mcast_resolicit=3