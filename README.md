# DNS implementation with Katharà


![retebase](https://github.com/Ayaril/KathaDNS/assets/80338147/4ea547c7-1042-4857-b528-5e069e938c13)

My network scheme is made of the following zones:
  - root 
  - *.org
    - *.wikipedia.org
  - *.com
    - *.amazon.com
    - *.google.com
  - *.net

## Device configuration

The configuration file of each DNS server consist of: 
  - Zone
  - Domain
  - Class (omitted, by default setted as "Internet class")
  - Type (master, slave, hint)
  - File

Each server have to implement **root zone** as hint type server and with **"."** domain.

For each server there is a **Database file** that begins with a **SOA (Start Of Authority)** record.
DB files include the following data:
  - **TTL**:
    Time to Live specifies the amount of time a DNS record can be cached by a resolver or intermediary DNS server.
  - **SOA**:
    The SOA record defines administrative information about the zone, including the primary nameserver, the email address of the administrator, and various timing values
  - **Serial**:
    A version number for the zone file. Increment this value whenever you make changes to the zone.
  - **Refresh time**:
    How often secondary DNS servers should check for updates (in seconds)
  - **Retry time**:
    How often secondary DNS servers should retry if the refresh fails (in seconds)
  - **Expire time**:
    The maximum time a secondary DNS server should keep the zone data if it cannot refresh (in seconds)
  - **Negative cache TTL**

  - **NS**:
    Name server records specify the authoritative DNS servers for the zone
  - **A**:
    Address records map hostnames to IP addresses
  - **MX**:
    Mail Exchange records specify the mail servers responsible for receiving email on behalf of the domain.
    
They also include additional data regarding devices in the same zone.

**Statup files** are necessary to configure devices to send and receive correctly ping requests.
