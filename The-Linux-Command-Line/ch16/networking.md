# The Linux Command Line, 2nd Edition, © 2019

## Chapter 16: Networking

* ping Send an ICMP ECHO\_REQUEST to network hosts
* traceroute Print the route packets trace to a network host
* ip Show/manipulate routing, devices, policy routing, and tunnels
* netstat Print network connections, routing tables, interface statistics, masquerade connetions, and multicast memberships
* ftp Internet file transfer program
* wget Non-interactive network downloader
* ssh OpenSSH SHH client (remote login program)

### Examining and Monitoring a Network

#### ping

The `ping` command sends a special network packet called an ICMP ECHO_REQUEST to a specified host.

```
$ ping linuxcommand.org
PING linuxcommand.org (216.105.38.11) 56(84) bytes of data.
64 bytes from secureprojects.sourceforge.net (216.105.38.11): icmp_seq=1 ttl=46 time=76.1 ms
...
```

#### traceroute

The `traceroute` program (some systems use the similar `tracepath` program instead) lists all the "hops" network traffic takes to get from the local system to a specified host.

```
$ traceroute slashdot.org
traceroute to slashdot.org (104.18.4.215), 30 hops max, 60 byte packets
 1  Linksys01376.rochester.rr.com (192.168.1.1)  0.400 ms  0.389 ms  13.322 ms
 2  syn-142-254-218-125.inf.spectrum.com (142.254.218.125)  11.294 ms  9.805 ms  11.316 ms
 3  lag-63.hnrtnyaf02h.netops.charter.com (24.58.232.213)  91.964 ms  91.861 ms  91.749 ms
 4  lag-46.mcr11rochnyei.netops.charter.com (24.58.49.64)  12.790 ms  12.885 ms  11.088 ms
 5  lag-28.rcr01rochnyei.netops.charter.com (24.58.32.74)  12.664 ms  14.227 ms  14.293 ms
 6  lag-15-10.chcgildt87w-bcr00.netops.charter.com (66.109.6.72)  26.892 ms * *
 7  lag-0.pr2.chi10.netops.charter.com (66.109.5.225)  25.318 ms lag-401.pr2.chi10.netops.charter.com (66.109.0.109)  35.768 ms  26.883 ms
 8  0.ae4.pr1.dca10.tbone.rr.com (66.109.1.113)  23.655 ms  26.874 ms  26.927 ms
 9  141.101.73.222 (141.101.73.222)  25.349 ms 141.101.73.202 (141.101.73.202)  25.253 ms 141.101.73.206 (141.101.73.206)  25.109 ms
10  104.18.4.215 (104.18.4.215)  28.564 ms  25.712 ms  24.848 ms
```
#### ip

The `ip` program is a multipurpose network configuration tool that makes use of the full range of networking features available in modern Linux kernels.

```
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether e0:69:95:c7:ad:84 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.150/24 brd 192.168.1.255 scope global dynamic noprefixroute enp6s0
       valid_lft 73894sec preferred_lft 73894sec
    inet6 2603:7080:9603:e32e:6c95:785:1bc1:3e00/64 scope global temporary dynamic 
       valid_lft 444235sec preferred_lft 77731sec
    inet6 2603:7080:9603:e32e:7d7f:ea2f:16c8:3a75/64 scope global temporary deprecated dynamic 
       valid_lft 444235sec preferred_lft 0sec
    inet6 2603:7080:9603:e32e:5f3f:2073:8d40:9e4/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 444235sec preferred_lft 444235sec
    inet6 fe80::7002:bfc8:1612:1d6c/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: wlp5s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether ac:81:12:76:ee:5c brd ff:ff:ff:ff:ff:ff
```

The network interface, called `lo`, is the _loopback interface_, a virtual interface that the system uses to "talk to itself", and the second enp6so (eth0?), is the Ethernet interface.

The presence of the word UP indicates that the network interface is enabled.