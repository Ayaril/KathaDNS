$TTL    60000
@               IN      SOA     rcom.com.    root.rcom.com. (
                        2023090301 ; serial
                        28800 ; refresh
                        14400 ; retry
                        3600000 ; expire
                        0 ; negative cache ttl
                        )
@               IN      NS      rcom.com.
rcom            IN      A       192.168.0.2
google         IN      NS       rgoogle.google.com.
rgoogle.google IN      A        192.168.0.20
mymail         IN      NS       rmail.mymail.com.
rmail.mymail   IN      A	192.168.0.30

