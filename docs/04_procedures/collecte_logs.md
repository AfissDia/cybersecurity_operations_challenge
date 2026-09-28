# Documentation de la collecte des logs

## Linux

Collecteur : Filebeat

Sources principales :

- syslog ;
- auth.log ;
- Nginx.

Module système activé :

- system/syslog ;
- system/auth.

Destination :

`Logstash 192.168.100.12:5044`

## Windows

Collecteur : Winlogbeat

Journaux collectés :

- Application ;
- System ;
- Security ;
- Windows PowerShell ;
- Microsoft-Windows-PowerShell/Operational.

Destination :

`127.0.0.1:5044`

Une redirection NAT VirtualBox transmet ce trafic vers SOC-SERVER.

## Nginx

Les logs Nginx sont collectés à l'aide du module Nginx de Filebeat.

Sources :

- access.log ;
- error.log.

Les événements permettent notamment l'analyse :

- des codes HTTP ;
- des chemins demandés ;
- des erreurs 404 ;
- des accès à des chemins sensibles.

## pfSense

pfSense transmet ses journaux à distance via Syslog.

Destination :

`192.168.100.12:5514/UDP`

Les journaux sélectionnés comprennent :

- System Events ;
- Firewall Events.

Logstash normalise ensuite ces événements avant stockage dans Elasticsearch.super c'est bon pour le 