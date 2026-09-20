# Dossier d'Architecture Technique - SIEM

## 1. Objet

Ce document décrit l'architecture technique de la solution SIEM mise
en place pour TechnoVision.

## 2. Périmètre

Le périmètre couvre actuellement :

- Infrastructure virtualisée
- Réseau SOC
- Cluster Elasticsearch
- Sécurisation des communications Elasticsearch

Les composants Kibana, Logstash et les sources de logs seront ajoutés
progressivement.

## 3. Architecture actuelle

Cluster Elasticsearch :

- ES-NODE-01 : 192.168.100.10
- ES-NODE-02 : 192.168.100.11

Nom du cluster :

technovision-soc

Version :

Elasticsearch 9.5.4

## 4. Réseau

Réseau interne SOC :

192.168.100.0/24

Les machines disposent également d'une interface NAT dédiée à
l'accès Internet.

## 5. Sécurité

Les accès HTTP Elasticsearch utilisent HTTPS.

L'authentification Elasticsearch est activée.

Les communications inter-nœuds utilisent TLS sur le transport
Elasticsearch.

## 6. Haute disponibilité

Elasticsearch est déployé sur deux nœuds distincts.

Le cluster permet la répartition et la réplication des données.

## 7. Architecture cible

À compléter avec :

- Kibana
- Logstash
- Winlogbeat
- Filebeat
- pfSense
- Apache/Nginx