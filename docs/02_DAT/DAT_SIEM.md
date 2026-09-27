# DAT – Architecture SIEM Elastic Stack

## 1. Contexte

TechnoVision souhaite centraliser les journaux de sécurité provenant de plusieurs
sources afin d'améliorer la détection et l'investigation des incidents.

La solution mise en place repose sur Elastic Stack et collecte actuellement les
journaux Linux, Windows, Nginx et pfSense.

## 2. Objectifs

Les principaux objectifs sont :

- centraliser les logs de plusieurs sources ;
- normaliser les événements avec Logstash ;
- stocker et rechercher les événements dans Elasticsearch ;
- visualiser les données avec Kibana ;
- détecter les comportements suspects avec Elastic Security ;
- disposer d'une architecture Elasticsearch distribuée ;
- sécuriser les échanges avec authentification et TLS ;
- permettre la corrélation de plusieurs sources de logs.

## 3. Architecture technique

### 3.1 Réseau SOC

Réseau interne VirtualBox :

- Réseau : SOC-NET
- Sous-réseau : 192.168.100.0/24

| Composant | Adresse IP | Rôle |
|---|---|---|
| pfSense | 192.168.100.1 | Pare-feu et source de logs réseau |
| ES-NODE-01 | 192.168.100.10 | Elasticsearch |
| ES-NODE-02 | 192.168.100.11 | Elasticsearch |
| SOC-SERVER | 192.168.100.12 | Kibana, Logstash, Filebeat, Nginx |
| Windows hôte | NAT / port forwarding | Winlogbeat et génération d'événements |

Chaque machine Linux dispose de deux interfaces :

- NAT pour l'accès Internet ;
- SOC-NET pour les communications internes du SOC.

## 4. Composants

### Elasticsearch

Version utilisée : 9.5.4.

Cluster :

- Nom : technovision-soc
- es-node-01 : 192.168.100.10
- es-node-02 : 192.168.100.11

Le cluster utilise deux nœuds Elasticsearch.

Les communications HTTP Elasticsearch utilisent HTTPS avec authentification.
Le transport inter-nœuds est également protégé par TLS.

Ports principaux :

- 9200/TCP : API Elasticsearch HTTPS
- 9300/TCP : communication entre les nœuds Elasticsearch

### Kibana

Kibana est installé sur SOC-SERVER.

- Adresse interne : 192.168.100.12
- Port : 5601/TCP
- Accès depuis Windows : http://127.0.0.1:5601 via redirection NAT

Kibana est utilisé pour :

- Discover ;
- création des Data Views ;
- Elastic Security ;
- création des règles de détection ;
- consultation et investigation des alertes.

Une clé `xpack.encryptedSavedObjects.encryptionKey` a été configurée afin
d'activer correctement les fonctions de détection Elastic Security.

### Logstash

Logstash est installé sur SOC-SERVER.

Il assure :

- la réception des événements Beats ;
- la réception Syslog pfSense ;
- la normalisation des événements ;
- l'envoi vers Elasticsearch.

Ports utilisés :

- 5044/TCP : Filebeat et Winlogbeat
- 5514/UDP : logs Syslog pfSense

### Filebeat

Filebeat est installé sur SOC-SERVER.

Il collecte notamment :

- logs système Linux ;
- logs d'authentification ;
- logs Nginx.

Les événements sont envoyés vers Logstash sur :

192.168.100.12:5044

Index utilisé :

linux-logs-*

### Winlogbeat

Winlogbeat est installé sur le poste Windows physique.

Les journaux suivants sont collectés :

- Application ;
- System ;
- Security ;
- Windows PowerShell ;
- Microsoft-Windows-PowerShell/Operational ;
- Sysmon si disponible.

Les événements sont transmis à Logstash via la redirection NAT :

127.0.0.1:5044 → 192.168.100.12:5044

Index utilisé :

windows-logs-*

### Nginx

Nginx est installé sur SOC-SERVER.

Les journaux d'accès et d'erreur sont collectés avec le module Nginx de Filebeat.

Ces événements permettent notamment de détecter :

- erreurs HTTP répétées ;
- reconnaissance Web ;
- accès à des chemins sensibles.

### pfSense

pfSense CE est utilisé comme pare-feu du réseau SOC.

Interfaces :

- WAN : NAT VirtualBox
- LAN : 192.168.100.1/24

pfSense transmet ses journaux via Syslog vers :

192.168.100.12:5514/UDP

Logstash analyse les journaux pfSense et extrait notamment :

- event.action ;
- network.transport ;
- network.direction ;
- source.ip ;
- source.port ;
- destination.ip ;
- destination.port ;
- interface réseau.

Index utilisé :

network-logs-*

## 5. Flux de données

### Logs Linux

Linux
→ Filebeat
→ Logstash :5044
→ Elasticsearch
→ Kibana / Elastic Security

### Logs Windows

Windows Event Logs
→ Winlogbeat
→ NAT 127.0.0.1:5044
→ Logstash :5044
→ Elasticsearch
→ Kibana / Elastic Security

### Logs Nginx

Nginx
→ Filebeat
→ Logstash
→ Elasticsearch
→ Kibana

### Logs réseau

pfSense
→ Syslog UDP :5514
→ Logstash
→ Elasticsearch
→ Kibana / Elastic Security

## 6. Sécurité

Les mécanismes suivants sont actuellement utilisés :

- authentification Elasticsearch ;
- HTTPS pour l'API Elasticsearch ;
- TLS pour les communications inter-nœuds ;
- autorité de certification utilisée par Logstash ;
- accès au réseau SOC isolé par VirtualBox Internal Network ;
- accès depuis le poste Windows limité à des redirections NAT nécessaires.

Les mots de passe, certificats privés et tokens ne doivent pas être stockés
dans le dépôt GitHub.

Une amélioration prévue consiste à remplacer le compte Elasticsearch
administrateur utilisé temporairement par Logstash par un compte dédié avec
des privilèges minimaux.

## 7. Sources actuellement intégrées

| Source | Collecteur | Statut |
|---|---|---|
| Linux | Filebeat | OK |
| Windows | Winlogbeat | OK |
| Nginx | Filebeat | OK |
| pfSense | Syslog / Logstash | OK |

## 8. Règles de détection Elastic Security

Dix règles de détection ont été mises en place et testées :

1. Nginx – multiples erreurs HTTP 404
2. Windows – multiples échecs d'authentification (4625)
3. pfSense – multiples connexions bloquées
4. Windows – activité PowerShell suspecte (4104)
5. Windows – création d'un compte utilisateur (4720)
6. Windows – ajout d'un utilisateur au groupe Administrateurs (4732)
7. Linux – multiples échecs d'authentification SSH
8. Windows – création d'un nouveau service (7045)
9. pfSense – tentative SSH bloquée vers le port 22
10. Nginx – accès à des chemins Web sensibles

Chaque règle a été testée en générant volontairement les événements associés
puis en vérifiant l'apparition de l'alerte dans Elastic Security.

Les preuves sont conservées dans le dossier `evidence/screenshots/`.

## 9. Incidents techniques rencontrés

### Cluster Elasticsearch

ES-NODE-02 publiait initialement son adresse NAT 10.0.2.15 sur le port
de transport Elasticsearch.

Correction :

- transport.publish_host = 192.168.100.11
- http.publish_host = 192.168.100.11

Le cluster a ensuite pu fonctionner avec deux nœuds.

### Saturation du disque SOC-SERVER

La partition racine du serveur SOC était saturée.

Le volume logique LVM a été étendu afin d'utiliser l'espace disponible
du disque virtuel.

### Boucle de logs Filebeat / Logstash

Une sortie Logstash `stdout` envoyait les événements vers syslog.

Filebeat relisait ensuite ces événements, provoquant une boucle :

Filebeat
→ Logstash
→ stdout/systemd/syslog
→ Filebeat

Cela a provoqué une croissance importante du fichier `/var/log/syslog`.

La sortie `stdout { codec => rubydebug }` a été supprimée de la pipeline
de production.

### Elastic Security

Le moteur de détection ne pouvait initialement pas fonctionner car Kibana
ne disposait pas de clé de chiffrement pour les Saved Objects.

Une clé `xpack.encryptedSavedObjects.encryptionKey` a été générée puis
configurée dans Kibana.

## 10. État actuel

Fonctionnalités opérationnelles :

- cluster Elasticsearch à deux nœuds ;
- authentification et TLS ;
- Kibana ;
- Logstash ;
- Filebeat Linux ;
- Winlogbeat Windows ;
- collecte Nginx ;
- collecte et parsing pfSense ;
- Data Views ;
- dix règles Elastic Security ;
- génération et validation d'alertes.

Travaux restant à finaliser :

- politique de rétention minimum 7 jours ;
- règles Sigma ;
- mapping MITRE ATT&CK ;
- corrélation multi-source ;
- dashboard SOC ;
- investigation de deux incidents complexes ;
- alerting externe et amélioration de la déduplication.