# Incident 1 – Reconnaissance Web et activité réseau

## Contexte

Une activité suspecte a été simulée afin de vérifier la capacité du SIEM à
corréler plusieurs sources de logs.

Les sources utilisées sont :

- Nginx ;
- pfSense.

## Déroulement

Plusieurs requêtes HTTP ont été générées vers des chemins sensibles :

- /admin
- /phpmyadmin
- /wp-admin

Ces requêtes ont généré des événements Nginx dans Elastic.

Dans la même période, plusieurs tentatives réseau vers le port TCP 22 ont été
observées dans les logs pfSense.

## Sources corrélées

### Nginx

Les événements Nginx ont permis d'identifier :

- plusieurs réponses HTTP 404 ;
- des accès à des chemins sensibles ;
- une activité pouvant correspondre à une phase de reconnaissance Web.

### pfSense

Les logs pfSense ont montré :

- des connexions réseau vers le port 22 ;
- des événements bloqués par le pare-feu ;
- les adresses IP et ports source/destination.

## Chronologie

1. Requêtes HTTP vers plusieurs chemins sensibles.
2. Génération d'erreurs HTTP dans Nginx.
3. Détection par les règles Elastic Security.
4. Tentatives réseau vers le port TCP 22.
5. Blocage des connexions par pfSense.
6. Corrélation des événements dans Kibana.

## Analyse

Une seule source aurait fourni une vision partielle de l'activité.

Les logs Nginx donnent le contexte applicatif tandis que pfSense fournit le
contexte réseau.

La corrélation permet donc de mieux comprendre l'activité globale observée.

## MITRE ATT&CK

Techniques associées :

- T1595 – Active Scanning
- T1046 – Network Service Scanning

## Conclusion

L'incident montre l'intérêt de la corrélation multi-source pour identifier une
activité de reconnaissance combinant des événements Web et réseau.

Statut : simulé et analysé.# PDS – Plan de Surveillance SIEM

## 1. Objectif

Ce plan de surveillance décrit les modalités de supervision de la plateforme
SIEM mise en place pour TechnoVision.

L'objectif est de :

- vérifier que les différentes sources de logs remontent correctement ;
- surveiller les événements de sécurité ;
- détecter les comportements suspects ;
- prioriser les alertes ;
- faciliter les investigations.

## 2. Sources surveillées

| Source | Collecteur | Données surveillées |
|---|---|---|
| Linux | Filebeat | authentification, système, SSH |
| Windows | Winlogbeat | Security, System, Application, PowerShell |
| Nginx | Filebeat | accès Web, erreurs HTTP |
| pfSense | Syslog / Logstash | trafic réseau, connexions bloquées |

## 3. Contrôle de la collecte

Les contrôles suivants sont réalisés régulièrement :

- vérification de l'état des services Filebeat, Winlogbeat et Logstash ;
- vérification de la présence d'événements récents dans Kibana Discover ;
- contrôle des index `linux-logs-*`, `windows-logs-*` et `network-logs-*` ;
- vérification de l'absence d'erreur dans les pipelines Logstash ;
- contrôle de l'espace disque du serveur SOC ;
- vérification du bon fonctionnement du cluster Elasticsearch.

## 4. Surveillance des alertes

Les alertes Elastic Security sont classées selon leur niveau de criticité.

### Medium

Exemples :

- multiples erreurs HTTP 404 ;
- multiples échecs d'authentification Windows ;
- multiples échecs SSH Linux ;
- connexions bloquées pfSense ;
- accès Web à des chemins sensibles.

Ces alertes doivent être analysées afin de déterminer si elles correspondent
à une activité légitime ou suspecte.

### High

Exemples :

- activité PowerShell suspecte ;
- ajout d'un compte au groupe Administrateurs ;
- création d'un nouveau service Windows.

Ces alertes sont traitées en priorité car elles peuvent être associées à
des mécanismes d'exécution, de persistance ou d'élévation de privilèges.

## 5. Méthode d'analyse

Lorsqu'une alerte est générée :

1. identifier la règle déclenchée ;
2. vérifier la source de logs ;
3. consulter les événements associés dans Discover ;
4. analyser l'adresse IP, l'utilisateur, l'hôte et les ports concernés ;
5. rechercher des événements similaires dans les autres sources ;
6. reconstruire la chronologie dans une Timeline si nécessaire ;
7. qualifier l'événement comme légitime, faux positif ou incident.

## 6. Corrélation multi-source

Les investigations peuvent combiner plusieurs sources.

Exemples réalisés :

### Incident 1

Nginx + pfSense :

- accès à des chemins sensibles ;
- erreurs HTTP ;
- activité réseau vers un service sensible ;
- blocage par le pare-feu.

### Incident 2

Linux + pfSense :

- échecs d'authentification SSH ;
- trafic TCP vers le port 22 ;
- blocage réseau.

La corrélation améliore le contexte disponible pour l'analyste SOC.

## 7. Rétention des données

Une politique ILM nommée :

`soc-retention-7d`

est appliquée aux index du SOC.

La durée de rétention configurée est de 7 jours.

Les index concernés sont notamment :

- `linux-logs-*`
- `windows-logs-*`
- `network-logs-*`

## 8. Tableau de bord

Le dashboard :

`SOC - Supervision générale`

permet de suivre notamment :

- les événements Linux ;
- les événements Windows ;
- les actions réseau pfSense ;
- l'activité Web Nginx.

Ce dashboard fournit une vue générale de l'activité du SOC.

## 9. Fréquence de surveillance

Dans le cadre du laboratoire :

- les règles de détection sont exécutées toutes les minutes ;
- un look-back de plusieurs minutes est utilisé pour éviter de manquer des
  événements arrivant avec un léger retard ;
- les alertes sont consultées dans Elastic Security ;
- les sources sont vérifiées avec Kibana Discover.

Dans un environnement de production, ces contrôles seraient complétés par une
surveillance continue de la disponibilité et de la qualité de collecte.

## 10. Gestion des faux positifs

Une alerte ne signifie pas automatiquement qu'un incident est confirmé.

L'analyste doit :

- vérifier le contexte ;
- comparer plusieurs événements ;
- identifier les actions administratives légitimes ;
- ajuster la règle si nécessaire.

Exemple :

la création d'un service Windows peut être légitime lors de l'installation
d'un logiciel mais doit être investiguée si elle apparaît de manière
inhabituelle.

## 11. Améliorations prévues

Les améliorations suivantes peuvent être ajoutées :

- alerting externe par email ou Teams ;
- amélioration de la déduplication des alertes ;
- enrichissement automatique des IoCs ;
- intégration de sources de Threat Intelligence ;
- création de comptes Elasticsearch avec privilèges minimaux ;
- ajout d'indicateurs de disponibilité des collecteurs.