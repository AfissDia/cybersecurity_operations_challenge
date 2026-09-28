# Avancement du projet

## Scénario 2 – Centralisation et corrélation des logs

### Architecture

- [x] Réseau interne `SOC-NET`
- [x] ES-NODE-01 configuré
- [x] ES-NODE-02 configuré
- [x] SOC-SERVER configuré
- [x] pfSense déployé
- [x] Cluster Elasticsearch à 2 nœuds
- [x] Authentification Elasticsearch
- [x] TLS HTTP et transport
- [x] Kibana opérationnel
- [x] Logstash opérationnel

### Collecte des logs

- [x] Linux via Filebeat
- [x] Windows via Winlogbeat
- [x] Nginx via Filebeat
- [x] pfSense via Syslog
- [x] Pipelines Logstash
- [x] Parsing et normalisation pfSense

### Index et Data Views

- [x] `linux-logs-*`
- [x] `windows-logs-*`
- [x] `network-logs-*`

### Rétention

- [x] Politique ILM `soc-retention-7d`
- [x] Rétention configurée à 7 jours
- [x] Politique appliquée aux index Linux, Windows et réseau

### Détection Elastic Security

10 règles ont été créées, testées et validées :

1. Nginx - multiples erreurs HTTP 404
2. Windows - multiples échecs de connexion 4625
3. pfSense - multiples connexions bloquées
4. Windows - activité PowerShell suspecte 4104
5. Windows - création d'un utilisateur 4720
6. Windows - ajout au groupe Administrateurs 4732
7. Linux - multiples échecs SSH
8. Windows - création d'un nouveau service 7045
9. pfSense - tentative SSH bloquée vers le port 22
10. Nginx - accès à des chemins sensibles

### Sigma et MITRE ATT&CK

- [x] 2 règles Sigma documentées
- [x] mapping MITRE ATT&CK réalisé pour les règles principales
- [x] techniques utilisées notamment :
  - T1110 Brute Force
  - T1059.001 PowerShell
  - T1136.001 Create Account
  - T1543.003 Windows Service
  - T1046 Network Service Scanning
  - T1595 Active Scanning

### Corrélation et incidents

- [x] Incident 1 : Nginx + pfSense
- [x] Incident 2 : Linux + pfSense
- [x] Timeline multi-source créée
- [x] Chronologie des événements analysée

### Dashboard

- [x] Dashboard `SOC - Supervision générale`
- [x] Visualisation Linux
- [x] Visualisation Windows
- [x] Visualisation pfSense
- [x] Visualisation Nginx
- [x] Export NDJSON du dashboard

### Documentation

- [x] DAT SIEM
- [x] PDS SIEM
- [x] Cahier de recette jusqu'à CAP-36
- [x] Documentation pipelines Logstash
- [x] Documentation collecte logs
- [x] Points bloquants
- [x] Rapports des 2 incidents
- [x] Journal de bord
- [x] Avancement projet

## État final du scénario 2

Le cœur du SIEM est opérationnel.

Les événements Linux, Windows, Nginx et pfSense sont centralisés dans
Elasticsearch, visualisables dans Kibana et exploités par Elastic Security.

Les règles de détection ont été testées avec des événements générés
volontairement.

Deux scénarios multi-sources ont été analysés.

Le dashboard SOC permet d'obtenir une vue synthétique de l'activité.

## Améliorations restantes

- alerting externe email / Teams ;
- amélioration de la déduplication ;
- compte Logstash dédié avec moindre privilège ;
- enrichissement Threat Intelligence ;
- automatisation plus poussée des investigations.