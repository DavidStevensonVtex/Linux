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