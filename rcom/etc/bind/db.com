$TTL   60000
@               IN      SOA     rcom.com.    root.rcom.com. (
                        2023090200 ; serial
                        3600 ; refresh
                        900; retry
                        3600000 ; expire
                        86400 ; minimum ttl
                        0 ; negative cache ttl
                        )
@                   IN      NS      rcom.com.
rcom           	    IN      A       192.168.0.3

amazon              IN      NS      ramazon.amazon.com.
ramazon.amazon      IN      A       192.168.0.31 

google              IN      NS      rgoogle.google.com.
rgoogle.google      IN      A       192.168.0.32 
