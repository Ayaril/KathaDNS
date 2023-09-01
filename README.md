# KathaDNS
DNS implementation with Katharà

Network: 

![retebase](https://github.com/Ayaril/KathaDNS/assets/80338147/4ea547c7-1042-4857-b528-5e069e938c13)

The configuration file of each DNS server consist of: 
  - Zone
  - Domain
  - Class (omitted, by default setted as "Internet class")
  - Type (master, slave, hint)
  - File

Each server have to implement **root zone** as hint type server and with **"."** domain.

For each server there is a **Database file** that begins with a **SOA (Start Of Authority)** record.
DB files include the following data:
  - TTL
  - SOA
  - Serial
  - Refresh time
  - Retry time
  - Expire time
  - Negative cache TTL
They also include additional data regarding devices in the same zone.

