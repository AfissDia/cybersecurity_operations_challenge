# Cluster Elasticsearch

## Cluster

Nom :

technovision-soc

Nœuds :

- es-node-01 : 192.168.100.10
- es-node-02 : 192.168.100.11

## Communication

La communication inter-nœuds utilise le port TCP 9300.

Test :

```bash
nc -vz 192.168.100.11 9300  

```
## Incidents techniques rencontrés

Plusieurs problèmes ont été rencontrés pendant la mise en place du cluster :

- doublons dans `elasticsearch.yml`
- cluster sans master élu
- ES-NODE-02 publiant l'adresse NAT au lieu de l'adresse SOC

Les détails, causes et corrections sont documentés dans :

`docs/06_suivi_projet/points_blocants.md`