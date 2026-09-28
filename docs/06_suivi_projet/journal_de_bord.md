# Journal de bord

## Mise en place de l'architecture

Création du réseau interne VirtualBox `SOC-NET` :

- pfSense : 192.168.100.1
- ES-NODE-01 : 192.168.100.10
- ES-NODE-02 : 192.168.100.11
- SOC-SERVER : 192.168.100.12

Les VM utilisent également une interface NAT pour l'accès Internet.

## Cluster Elasticsearch

Installation et configuration d'Elasticsearch 9.5.4.

Le second nœud ne rejoignait initialement pas correctement le cluster car
il publiait son adresse NAT.

Configuration de `transport.publish_host` et `http.publish_host` sur
l'adresse SOC.

Le cluster à deux nœuds a ensuite fonctionné correctement.

## Kibana et Logstash

Installation de Kibana et Logstash sur SOC-SERVER.

Configuration de Kibana avec Elasticsearch sécurisé.

Ajout de la clé `xpack.encryptedSavedObjects.encryptionKey` pour permettre
le fonctionnement d'Elastic Security.

## Collecte Linux

Installation et configuration de Filebeat.

Activation du module système.

Validation des logs Linux dans Kibana.

## Incident disque

La partition racine de SOC-SERVER a atteint 100 % d'utilisation.

Extension du volume logique LVM.

Une seconde saturation a été provoquée par une boucle de logs entre
Filebeat, Logstash et syslog.

Suppression de la sortie `stdout { codec => rubydebug }`.

Le fonctionnement est ensuite redevenu normal.

## Collecte Windows

Installation de Winlogbeat sur Windows.

Collecte de :

- Security
- System
- Application
- Windows PowerShell
- PowerShell Operational

Configuration du forwarding NAT vers Logstash sur le port 5044.

Les événements Windows ont été séparés des événements Linux avec une
condition basée sur `[agent][type]`.

## Collecte Nginx

Installation de Nginx sur SOC-SERVER.

Activation du module Nginx dans Filebeat.

Validation des accès Web, erreurs 404 et chemins sensibles dans Kibana.

## Collecte pfSense

Installation et configuration de pfSense.

LAN :

`192.168.100.1/24`

Activation du Syslog distant vers :

`192.168.100.12:5514/UDP`

Création d'une pipeline Logstash dédiée.

Parsing des événements `filterlog` avec extraction des IP, ports, action,
protocole, interface et direction réseau.

## Elastic Security

Création progressive de 10 règles de détection.

Tests réalisés sur :

- erreurs HTTP répétées ;
- échecs de connexion Windows ;
- activité PowerShell ;
- création de compte ;
- ajout au groupe Administrateurs ;
- création de service ;
- échecs SSH Linux ;
- événements pfSense ;
- accès à des chemins Web sensibles.

Les alertes ont été validées dans Elastic Security.

## Rétention

Création de la politique ILM :

`soc-retention-7d`

Application aux index Linux, Windows et réseau.

Vérification réussie dans les settings des index.

## Sigma et MITRE ATT&CK

Création de deux règles Sigma :

- PowerShell suspect ;
- création de compte Windows.

Mapping des principales règles Elastic vers les techniques MITRE ATT&CK.

## Corrélation multi-source

Deux scénarios ont été analysés :

### Incident 1

Nginx + pfSense :

- chemins Web sensibles ;
- erreurs HTTP ;
- activité réseau vers SSH ;
- blocage par le pare-feu.

### Incident 2

Linux + pfSense :

- échecs SSH Linux ;
- trafic TCP vers le port 22 ;
- blocage réseau.

Une Timeline Elastic a été utilisée pour rapprocher les événements.

## Dashboard SOC

Création du dashboard :

`SOC - Supervision générale`

Visualisations principales :

- événements Linux dans le temps ;
- Event IDs Windows ;
- actions réseau pfSense ;
- activité Nginx.

Le dashboard a été exporté au format NDJSON.

## État final

Le scénario 2 est largement opérationnel et démontrable.

Les principales fonctions suivantes sont validées :

- centralisation multi-source ;
- normalisation ;
- stockage ;
- visualisation ;
- détection ;
- corrélation ;
- investigation ;
- rétention ;
- documentation.