# Documentation des pipelines Logstash

## 1. Objectif

Logstash est utilisé comme couche centrale de traitement entre les collecteurs
et Elasticsearch.

Il assure :

- la réception des événements ;
- leur normalisation ;
- leur routage vers les bons index Elasticsearch.

## 2. Pipeline Beats

Fichier :

`/etc/logstash/conf.d/02-filebeat-linux.conf`

Entrée :

- Beats
- Port TCP 5044

Cette entrée reçoit :

- Filebeat depuis Linux ;
- Winlogbeat depuis Windows.

Le routage est effectué selon le champ :

`[agent][type]`

### Filebeat

Les événements Filebeat sont envoyés vers :

`linux-logs-%{+YYYY.MM.dd}`

### Winlogbeat

Les événements Winlogbeat sont envoyés vers :

`windows-logs-%{+YYYY.MM.dd}`

Les communications entre Logstash et Elasticsearch utilisent HTTPS avec
validation de l'autorité de certification Elasticsearch.

Les secrets d'authentification ne sont pas stockés dans le dépôt GitHub.

## 3. Pipeline pfSense

Fichier :

`/etc/logstash/conf.d/03-pfsense.conf`

Entrée :

- UDP
- Port 5514

Les événements sont identifiés avec :

`type = pfsense`

### Normalisation Syslog

Un filtre Grok permet d'extraire notamment :

- priorité Syslog ;
- timestamp ;
- nom du processus ;
- PID ;
- message.

Les champs suivants sont ajoutés :

- `event.module = pfsense`
- `observer.product = pfSense`
- `observer.type = firewall`

### Parsing filterlog

Lorsque le processus est `filterlog`, le contenu CSV du message pfSense est
découpé afin d'extraire notamment :

- action ;
- direction ;
- interface ;
- protocole ;
- IP source ;
- IP destination ;
- port source ;
- port destination.

Ces informations sont ensuite copiées vers des champs structurés :

- `event.action`
- `network.transport`
- `network.direction`
- `source.ip`
- `source.port`
- `destination.ip`
- `destination.port`
- `observer.ingress.interface.name`

Les logs pfSense sont stockés dans :

`network-logs-%{+YYYY.MM.dd}`

## 4. Vérification des pipelines

La syntaxe Logstash est contrôlée avec :

```bash
sudo -u logstash /usr/share/logstash/bin/logstash \
  --path.settings /etc/logstash -t