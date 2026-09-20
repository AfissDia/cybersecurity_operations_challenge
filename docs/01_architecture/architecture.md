# Architecture SIEM

## Architecture actuelle

Internet
   |
 VirtualBox NAT
   |
   +-----------------------+
   |                       |
ES-NODE-01             ES-NODE-02
10.0.2.x               10.0.2.x
   |                       |
192.168.100.10          192.168.100.11
   |                       |
   +-------- SOC-NET ------+

Cluster : technovision-soc
Version Elasticsearch : 9.5.4

## Architecture cible

                 Kibana
                    |
                 Logstash
                    |
          Cluster Elasticsearch
           /              \
      ES-NODE-01       ES-NODE-02

                    |
       --------------------------------
       |          |         |          |
     Windows     Linux    pfSense    Apache/Nginx
    Winlogbeat Filebeat   Syslog       Logs Web