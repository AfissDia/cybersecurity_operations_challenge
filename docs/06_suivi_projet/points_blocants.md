# Points bloquants rencontrés

## PB-01 - Configuration YAML en double

Symptôme :
Elasticsearch retourne une erreur `Duplicate field`.

Cause :
Présence de plusieurs occurrences de `cluster.initial_master_nodes`.

Résolution :
Suppression de la clé en double.

Statut : Résolu.

---

## PB-02 - Cluster Elasticsearch en HTTP 503

Symptôme :
`elasticsearch-reset-password` retourne HTTP 503.

Cause :
Le cluster n'avait pas encore élu de master.

Résolution :
Bootstrap de ES-NODE-01.

Statut : Résolu.

---

## PB-03 - ES-NODE-02 ne rejoint pas le cluster

Symptôme :
ES-NODE-02 démarre mais n'apparaît pas dans `_cat/nodes`.

Cause :
ES-NODE-02 publiait son adresse NAT `10.0.2.15`.

Résolution :
Configuration explicite :

```yaml
transport.publish_host: 192.168.100.11
http.publish_host: 192.168.100.11

```
## PB-04 - Kibana ne démarre plus

Symptôme :
Kibana passe de `active (running)` à `failed` et le port 5601 n'écoute plus.

Cause :
Le filesystem racine de SOC-SERVER était plein :

- volume logique `/` : 10 Go
- utilisation : 100 %

Le disque virtuel faisait déjà 20 Go, mais le volume logique LVM n'utilisait que 10 Go.

Résolution :
Extension du volume logique avec l'espace libre disponible dans `ubuntu-vg`.

Résultat :
Le port 5601 est de nouveau en écoute sur `0.0.0.0:5601`.

Statut : Résolu.