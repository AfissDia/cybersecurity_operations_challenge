# Points bloquants et solutions apportées

## 1. ES-NODE-02 ne rejoignait pas le cluster Elasticsearch

### Problème

Le deuxième nœud Elasticsearch était démarré mais n'apparaissait pas dans le cluster.

Les logs montraient que le nœud publiait son adresse NAT :

`10.0.2.15:9300`

au lieu de son adresse sur le réseau SOC.

### Cause

Elasticsearch utilisait la mauvaise interface réseau pour publier son adresse de transport.

### Solution

Configuration explicite de :

- `transport.publish_host: 192.168.100.11`
- `http.publish_host: 192.168.100.11`

Après correction, ES-NODE-02 a rejoint le cluster.

---

## 2. Erreur de configuration Elasticsearch

### Problème

Elasticsearch ne démarrait plus avec une erreur liée à une clé dupliquée dans le fichier de configuration.

### Cause

Présence de plusieurs déclarations de paramètres, notamment autour de la configuration du bootstrap du cluster.

### Solution

Nettoyage du fichier `elasticsearch.yml` et suppression des paramètres en double.

Le service a ensuite redémarré correctement.

---

## 3. Problèmes d'authentification Elasticsearch

### Problème

Certaines requêtes vers l'API Elasticsearch retournaient une erreur `401 Unauthorized`.

### Solution

Réinitialisation du mot de passe du compte Elasticsearch et utilisation de l'authentification correcte pour les tests API et Logstash.

---

## 4. Saturation du disque SOC-SERVER

### Problème

La partition racine de SOC-SERVER est arrivée à saturation.

Conséquences observées :

- erreurs de services ;
- Kibana ne fonctionnait plus correctement ;
- espace disque disponible presque nul.

### Cause

Le volume logique Linux n'utilisait pas tout l'espace disponible sur le disque virtuel.

### Solution

Extension du volume LVM avec l'espace libre disponible.

Le système de fichiers a ensuite été agrandi automatiquement.

---

## 5. Boucle de logs Filebeat / Logstash

### Problème

Le fichier `/var/log/syslog` a grandi très rapidement jusqu'à occuper plusieurs gigaoctets.

### Cause

Une sortie de debug Logstash :

`stdout { codec => rubydebug }`

écrivait les événements dans la sortie du service.

Ces messages étaient ensuite récupérés dans syslog.

Filebeat relisait ces événements et les renvoyait vers Logstash.

Une boucle était alors créée :

Filebeat
→ Logstash
→ stdout / syslog
→ Filebeat

### Solution

Suppression de la sortie `stdout` de la pipeline de production.

Le fichier syslog a également été nettoyé.

Après redémarrage des services, la croissance des logs est redevenue normale.

---

## 6. Kibana Detection Engine indisponible

### Problème

La création ou l'exécution des règles Elastic Security échouait.

Message observé :

`Encrypted Saved Objects plugin is missing encryption key`

### Cause

Aucune clé de chiffrement n'était configurée pour les Saved Objects Kibana.

### Solution

Génération puis configuration de :

`xpack.encryptedSavedObjects.encryptionKey`

dans `kibana.yml`.

Après redémarrage de Kibana, le moteur de détection a fonctionné normalement.

---

## 7. SOC-SERVER ne démarrait plus correctement dans VirtualBox

### Problème

La VM affichait un écran noir et semblait ne plus démarrer.

### Cause

Le type/version de la machine virtuelle avait été modifié dans VirtualBox.

### Solution

Restauration du type :

- Linux
- Ubuntu 64-bit

La machine a ensuite démarré normalement.

---

## 8. Winlogbeat ne se connectait pas à Logstash

### Problème

Le test de sortie Winlogbeat échouait.

### Cause

Une erreur de saisie était présente dans l'adresse Logstash :

`127.0.0.1.:5044`

### Solution

Correction en :

`127.0.0.1:5044`

Le test de connexion Winlogbeat est ensuite passé avec succès.

---

## 9. Les logs Windows étaient envoyés vers le mauvais index

### Problème

Les événements Winlogbeat étaient initialement envoyés vers l'index Linux.

### Cause

La pipeline Logstash ne distinguait pas correctement Filebeat et Winlogbeat.

### Solution

Ajout de conditions selon :

`[agent][type]`

afin de router :

- Filebeat vers `linux-logs-*`
- Winlogbeat vers `windows-logs-*`

---

## 10. pfSense non accessible directement depuis Windows

### Problème

Le réseau interne `SOC-NET` n'était pas directement accessible depuis le poste Windows.

### Solution

Utilisation d'un tunnel SSH :

`ssh -L 8443:192.168.100.1:443 es-node-01@127.0.0.1 -p 2223`

Le WebGUI pfSense est ensuite accessible via :

`https://127.0.0.1:8443`

---

## 11. Parsing initial des logs pfSense limité

### Problème

Les logs pfSense arrivaient dans Elasticsearch mais restaient principalement sous forme de messages bruts.

### Solution

Ajout dans Logstash :

- d'un filtre Grok pour l'en-tête Syslog ;
- d'un filtre CSV pour les événements `filterlog` ;
- de champs structurés comme :
  - `event.action`
  - `source.ip`
  - `destination.ip`
  - `source.port`
  - `destination.port`
  - `network.transport`
  - `network.direction`

Cela a permis d'utiliser les événements pfSense dans les règles Elastic Security.

---

## 12. Certaines alertes Elastic ne se déclenchaient pas immédiatement

### Problème

Les événements étaient visibles dans Discover mais certaines règles ne généraient pas d'alerte.

### Cause

La fenêtre temporelle des règles était parfois trop courte par rapport au délai d'ingestion.

### Solution

Utilisation d'un `Additional look-back` de plusieurs minutes.

Cela a permis aux règles de prendre en compte les événements légèrement retardés.

---

## 13. Politique de rétention absente

### Problème

Les index ne disposaient pas initialement d'une politique de suppression automatique.

### Solution

Création d'une politique ILM :

`soc-retention-7d`

avec suppression après 7 jours.

La politique a été appliquée aux index Linux, Windows et réseau.