# Connections

The network module looks for 3 web server log files, nGinX, Apache, and the RHEL Apache (httpd). If these files do not exist, it will abort and ask you to point to the log file. If you would like to look at other log files, other then a web server, see [logview](../etc/wiki/logview.md)

There are 2 commands that may be used with the networking module, ``ip`` and ``connections``

## IP

Just like the ip command that is native to Linux, you may use it as normal, with some new features.

* external4 or external
  * Will return your external IP4 address
* external6
  * Will return your external IP6 address
* internal will use ip, or ifconfig to return your internal IP address

## CONNECTIONS

* 80
  * View all 80 Port Connections
* 404
  * Statistical connections 404
* ip
  * On the connected IP sorted by the number of connections
* req [nn] (Optional)
  * top nn of find the number of requests on 80 port, default is 20
* tcp4 [nn] (Optional)
  * top nn of using tcpdump ip 4 port 80 access to view, default is 20
* tcp6 [nn] (Optional)
  * top nn of using tcpdump ip 6 port 80 access to view, default is 20
* wait [nn]
  * top nn of Find time_wait connection, default is 20
* syn [nn]
  * top nn of Find SYN connection, default is 20
* proc
  * Printing process according to the port number
* access [nn] (Optional)
  * top nn who have gained access to the ip address, default is 10
* visits [nn] (Optional)
  * top nn of most Visited file or page, default is 20
* pages [nn] (Optional)
  * top nn of page lists the most time-consuming (more than 60 seconds) as well as the corresponding page number of occurrences, default is 100
* traffic
  * Website traffic statistics (G)
* status
  * Statistical http status.
