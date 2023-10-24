# DNSSEC implementation with Katharà

My network scheme is made of the following zones:
  - root
  - *.com
    - *.google.com
  - *.net
    - *.test.net
      - *.tzone.test.net

## Device configuration
**Named.conf.*** defines each zone for which the server is responsible and provides configuration information per zone
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

## DNSSEC configuration 
### Master configuration
Each authority DNS server creates two pair of keys, a private used to digitally sign each record in the zone and a public published on the internet used to verify the signatures.

In this environtment the DNSSEC extension will be configurated in the "test.net" domain

The first step is to create the keys. In order to do it we have to move in:
 > cd /var/cache/bind/keys
>

and execute the commands:
> dnssec-keygen -a RSASHA256 -b 1280 test.net
> 
> dnssec-keygen -a RSASHA256 -b 2048 -f KSK test.net
![Schermata del 2023-10-21 19-30-31](https://github.com/Ayaril/KathaDNSSEC/assets/80338147/c28678ca-67c9-413e-a3d8-4de711b54c6b)

Those commands will create two files named Ktest.net.+.key and two files named Ktest.net.+.private

Once we have the keys we have to concatenate the public one to the zone file. In our environment we have to do:
> cat /etc/bind/keys/Ktest.net.+008*.key >> db.net.test
>
Now our db.net.test will be something like this: 
![Schermata del 2023-10-15 14-44-21](https://github.com/Ayaril/KathaDNSSEC/assets/80338147/9b3d3725-5c2c-420e-be50-af4eeba4d33d)

Once the file is setted we can configure the sign zone:
> dnssec-signzone -t -g -o test.net db.net.test /etc/bind/keys/Ktest.net.+008+*.private
>
If the configuration was successful, we will get this result:
![Schermata del 2023-10-15 14-48-11](https://github.com/Ayaril/KathaDNSSEC/assets/80338147/d40a1f16-ec30-4aa6-843a-10a8b317c09f)
In /etc/bind there will be two new files: **db.net.test.signed** and **dsset-test.net.**
db.net.test.signed is the signed version of the zone file. To ensure the authenticity of DNS reply each resource record of a zone is signed using Publik Key Infrastructure.
Now we have to include the new file in *etc/bind/named.conf*
  > zone "test.net" {
  >
  > type master;
  >
  > file "/etc/bind/db.net.test.signed";
  >
  > };
>
![Schermata del 2023-10-21 19-42-26](https://github.com/Ayaril/KathaDNSSEC/assets/80338147/60af3f47-177b-47b1-8f7b-f45e9613e58f)

Once we have modified the *named.conf* file we can use *systemctl restart named* to reload the file.

## Testing
The testing of the network can be made with the command **dig**, a lookup utility used to query DNS servers and retrieve DNS information for domain names
To test DNSSEC we can use:
> dig DNSKEY test.net. @192.168.0.30
>
But it won't show the RRSIG
> dig A test.net @localhost + noadditional +dnssec +multiline
Will show every information about the DNSSEC configuration
![Schermata del 2023-10-21 19-43-39](https://github.com/Ayaril/KathaDNSSEC/assets/80338147/7bb311e0-0d0a-496c-821d-b5e7cfeff6ca)

To ensure that dnssec works we can also use the command **dnssec-verify**
![Schermata del 2023-10-21 19-50-35](https://github.com/Ayaril/KathaDNSSEC/assets/80338147/f11b317d-07f1-4a0b-8c3b-4dc82694c469)

