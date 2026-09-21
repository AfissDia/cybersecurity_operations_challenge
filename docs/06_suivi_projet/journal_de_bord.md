# Journal de bord

## Phase 1 - Préparation de l'infrastructure

Création des machines ES-NODE-01 et ES-NODE-02 sous Ubuntu Server.

Mise en place de deux interfaces réseau :
- NAT pour Internet
- SOC-NET pour le réseau interne

Adresses configurées :
- ES-NODE-01 : 192.168.100.10
- ES-NODE-02 : 192.168.100.11

## Phase 2 - Administration distante

Installation et activation de SSH.

Accès depuis Windows PowerShell via redirection de ports VirtualBox.

## Phase 3 - Elasticsearch

Installation d'Elasticsearch 9.5.4 sur les deux serveurs.

Activation de la sécurité Elasticsearch et du HTTPS.

Création du cluster :

technovision-soc

## Phase 4 - Problèmes rencontrés

### Doublon YAML

Une configuration `cluster.initial_master_nodes` apparaissait deux fois.

Impact :
Elasticsearch refusait de démarrer.

Correction :
suppression de la configuration dupliquée.

### Bootstrap du cluster

Le cluster ne parvenait initialement pas à élire de master.

Correction :
bootstrap initial de ES-NODE-01.

### ES-NODE-02 non intégré

ES-NODE-02 publiait :

10.0.2.15:9300

au lieu de :

192.168.100.11:9300

Correction :

```yaml
transport.publish_host: 192.168.100.11
http.publish_host: 192.168.100.11
```
## Phase 5 - Validation de la chaîne Logstash

Un pipeline de test Logstash a été configuré sur SOC-SERVER.

Un événement JSON a été envoyé sur le port TCP 5000.

L'événement a été indexé dans Elasticsearch dans l'index :

soc-test-2026.09.21

Le document a ensuite été retrouvé dans Kibana Discover avec les champs :

- event : Premier log SOC
- source : soc-server
- status : success

Résultat : chaîne Logstash → Elasticsearch → Kibana validée.