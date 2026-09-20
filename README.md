# Cybersecurity Operations Challenge

Projet de cybersécurité opérationnelle portant sur la mise en place
d'un environnement SOC pour l'entreprise fictive TechnoVision.

## Scénario traité

Scénario 2 : Centralisation et corrélation des logs de sécurité.

## Objectifs

- Déployer un cluster Elasticsearch distribué
- Centraliser les logs de plusieurs sources
- Mettre en place Logstash et Kibana
- Collecter les logs Windows et Linux
- Intégrer des logs réseau et Web
- Développer des règles de détection
- Utiliser Sigma et MITRE ATT&CK
- Réaliser des corrélations multi-sources
- Construire des dashboards SOC
- Analyser des incidents complexes

## État actuel

### Terminé

- Infrastructure réseau du SOC
- ES-NODE-01
- ES-NODE-02
- Elasticsearch 9.5.4
- HTTPS et authentification
- Cluster Elasticsearch à deux nœuds
- Communication inter-nœuds sur le port 9300

### Prochaine étape

Déploiement du serveur SOC avec Kibana et Logstash.

## Architecture actuelle

| Machine | Rôle | Adresse SOC |
|---|---|---|
| ES-NODE-01 | Elasticsearch | 192.168.100.10 |
| ES-NODE-02 | Elasticsearch | 192.168.100.11 |
| SOC-SERVER | Kibana + Logstash | 192.168.100.12 |

## Documentation

La documentation technique se trouve dans le dossier `docs/`.

Les preuves de fonctionnement sont stockées dans `evidence/`.