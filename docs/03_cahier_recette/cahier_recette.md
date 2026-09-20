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