# Cahier de recette

| ID | Exigence testée | Test | Résultat attendu | Résultat | Statut | Preuve |
|---|---|---|---|---|---|---|
| REC-01 | Réseau SOC | Ping ES01 → ES02 | Réponse ICMP | Conforme | OK | CAP-03 |
| REC-02 | Réseau SOC | Ping ES02 → ES01 | Réponse ICMP | Conforme | OK | CAP-04 |
| REC-03 | Elasticsearch | Test HTTPS port 9200 | API accessible | HTTP 401 sans authentification | OK | CAP-05 |
| REC-04 | Sécurité | Authentification elastic | Accès autorisé | Conforme | OK | Commande |
| REC-05 | Cluster | `_cat/nodes` | 2 nœuds | 2 nœuds | OK | CAP-06 |
| REC-06 | Cluster | Élection master | 1 master | es-node-01 | OK | CAP-06 |
| REC-07 | Transport | Port TCP 9300 | Accessible | Accessible | OK | CAP-08 |
| REC-08 | Santé cluster | `_cluster/health` | Cluster opérationnel | À consigner | À valider | CAP-07 |
| REC-09 | Kibana | Vérifier le service Kibana | Service actif | Conforme | OK | CAP-10 |
| REC-10 | Kibana | Accès Web depuis Windows | Interface Kibana accessible sur le port 5601 | Conforme | OK | CAP-11 |
| REC-11 | Logstash | Envoi d'un événement test vers Logstash | Création de l'événement dans Elasticsearch | 1 document indexé dans soc-test-* | OK | CAP-12 |

## Références des preuves

- CAP-01 : `evidence/screenshots/01_es-node-01_network.png`
- CAP-02 : `evidence/screenshots/02_es-node-02_network.png`
- CAP-03 : `evidence/screenshots/03_ping_es01_es02.png`
- CAP-04 : `evidence/screenshots/04_ping_es02_es01.png`
- CAP-05 : `evidence/screenshots/05_elasticsearch_https_401.png`
- CAP-06 : `evidence/screenshots/06_cluster_two_nodes.png`
- CAP-07 : `evidence/screenshots/07_cluster_health.png`
- CAP-08 : `evidence/screenshots/08_transport_9300.png`

