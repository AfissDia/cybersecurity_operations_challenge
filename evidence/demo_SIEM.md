# Démo soutenance – SIEM Elastic Stack

## Objectif de la démonstration

Montrer rapidement la chaîne complète du SIEM :

**Événement → collecte → Logstash → Elasticsearch → Discover → règle → alerte → investigation**


---

## 1. Démo Windows – PowerShell suspect

### Génération de l'événement

Windows --- PowerShell( asensible):

```powershell
Invoke-WebRequest http://example.com
```


### Vérification dans Kibana


```text
Discover → Windows-logs
```


```text
winlog.event_id : 4104
```

### result

- Winlogbeat a bien collecté l'événement Windodans Elasticsearch.

### Vérification de l'alerte


```text
Security → Alerts
```

Chercher la règle :

```text
Windows - Suspicious PowerShell Activity
```

### conclusion 

> La règle Elastic Security a détecté automatiquement l'événement et généré une alerte de niveau High.

---

## 2. Démo Nginx – Reconnaissance Web

### Génération des événements

Sur `SOC-SERVER` :

```bash
for i in {1..6}; do
  curl -s -o /dev/null http://127.0.0.1/admin$i
done
```

Puis :

```bash
curl -s -o /dev/null http://127.0.0.1/phpmyadmin
curl -s -o /dev/null http://127.0.0.1/wp-admin
```

### --------------------

> simulation de plusieurs requêtes vers des chemins sensibles du serveur Web.

### Vérification dans Discover

Dans Kibana :

```text
Discover → Linux-logs
```



```text
event.module : "nginx" and message : *admin*
```

### Ce que je montre

- les requêtes vers `/admin` ;
- les erreurs HTTP ;
- la source Nginx.

### Vérification de l'alerte


```text
Security → Alerts
```

Montrer l'une des règles suivantes :

```text
Nginx - Sensitive Path Access
```

ou :

```text
Nginx - Multiple HTTP 404 Responses
```

### Ce que je dis

> On retrouve la même chaîne : collecte, indexation puis détection automatique par Elastic Security.

---

## 3. Démo pfSense – Logs réseau normalisés

Cette partie peut être montrée directement avec les événements déjà présents.

Dans Discover, utiliser :

```text
event.module : "pfsense"
```

Afficher si possible les champs :

```text
event.action
source.ip
destination.ip
source.port
destination.port
network.transport
network.direction
```

### ------

> Les logs pfSense arrivent initialement en Syslog. Logstash les normalise pour extraire les IP, les ports, le protocole, la direction et l'action du firewall.

> Ces champs structurés peuvent ensuite être utilisés dans les recherches, les dashboards et les règles de détection.

---

## 4. Dashboard SOC


```text
Dashboard → SOC - Supervision générale
```

### Ce que je montre

- événements Linux ;
- événements Windows ;
- activité pfSense ;
- activité Nginx.

### Ce que je dis

> Ce dashboard donne une vue globale de l'activité du SOC et permet de vérifier rapidement les différentes sources collectées.

---

## 5. Timeline multi-source

```text
Security → Timelines
```

open : Timeline add l'incident multi-source.

### ---------------

> La Timeline permet de rapprocher plusieurs sources de logs et de reconstruire la chronologie d'un incident.

> Ici, je peux par exemple combiner des événements Nginx et pfSense, ou Linux et pfSense, afin d'obtenir plus de contexte pendant l'investigation.

---





















































### ---note 

# Ordre conseillé pendant la démo


---

# Phrase de transition vers la démo

> Maintenant, je vais vous montrer rapidement la plateforme avec quelques logs dans Discover, les alertes Elastic Security, la Timeline et le dashboard SOC.

---

# Phrase de conclusion de la démo

> Cette démonstration montre la chaîne complète du SIEM : génération d'un événement, collecte, centralisation, détection, visualisation et investigation.

---

# Conseils pour la soutenance

- Ouvrir toutes les pages Kibana avant de commencer.
- Garder la démo sous 5 minutes.
- Ne pas lancer de scénario complexe ou risqué en direct.
- Si une alerte met du temps à apparaître, utiliser les captures CAP déjà préparées.
- Ne pas perdre du temps à réparer un problème devant le jury.
- Toujours expliquer ce que l'on montre et pourquoi c'est utile dans un SOC.
