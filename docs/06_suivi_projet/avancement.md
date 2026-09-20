# État d'avancement

Dernière mise à jour : 20/09/2026

## Terminé

- [x] Création de ES-NODE-01
- [x] Création de ES-NODE-02
- [x] Configuration du réseau SOC interne
- [x] Adresse IP ES-NODE-01 : 192.168.100.10
- [x] Adresse IP ES-NODE-02 : 192.168.100.11
- [x] Configuration SSH
- [x] Installation Elasticsearch 9.5.4
- [x] Activation de la sécurité Elasticsearch
- [x] Configuration HTTPS
- [x] Création du cluster technovision-soc
- [x] Intégration de ES-NODE-02 au cluster
- [x] Validation du cluster Elasticsearch à deux nœuds

## En cours

- [ ] Documentation de l'architecture
- [ ] Cahier de recette

## Prochaines étapes

- [ ] Création de SOC-SERVER
- [ ] Installation Kibana
- [ ] Installation Logstash
- [ ] Configuration de la rétention des données
- [ ] Intégration des premières sources de logs

## Blocages rencontrés

- Doublons dans elasticsearch.yml
- Mauvaise adresse de publication du transport Elasticsearch
- ES-NODE-02 publiait initialement 10.0.2.15 au lieu de 192.168.100.11

## État actuel

Le cluster Elasticsearch fonctionne avec deux nœuds :

- es-node-01 : 192.168.100.10
- es-node-02 : 192.168.100.11