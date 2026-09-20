# Plan réseau

## Principe

Chaque serveur possède deux interfaces réseau :

- Une interface NAT pour l'accès Internet.
- Une interface SOC interne pour la communication entre les composants.

## Réseau SOC

Réseau : `192.168.100.0/24`

| Machine | Hostname | Adresse SOC | Rôle |
|---|---|---|---|
| ES-NODE-01 | es-node-01 | 192.168.100.10 | Elasticsearch |
| ES-NODE-02 | es-node-02 | 192.168.100.11 | Elasticsearch |
| SOC-SERVER | soc-server | 192.168.100.12 | Kibana + Logstash |

## Interfaces Elasticsearch

### ES-NODE-01

- enp0s3 : NAT / DHCP
- enp0s8 : 192.168.100.10/24

### ES-NODE-02

- enp0s3 : NAT / DHCP
- enp0s8 : 192.168.100.11/24

## Ports actuellement utilisés

| Port | Usage |
|---|---|
| 22/TCP | SSH |
| 9200/TCP | API HTTPS Elasticsearch |
| 9300/TCP | Communication inter-nœuds Elasticsearch |