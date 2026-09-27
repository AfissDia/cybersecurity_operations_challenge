# Dossier d'Architecture Détaillée (DAT)
## Scénario 1 - Détection et réponse aux menaces avancées (Wazuh EDR)

**Projet :** Cybersécurité opérationnelle - TechnoVision
**Solution :** Wazuh 4.14.7 (EDR / SIEM open source)
**Auteur :** Amal
**Date :** Septembre 2026

---

## 1. Contexte et objectifs

L'entreprise fictive TechnoVision ne disposait d'aucune solution EDR ni de processus
d'analyse et de réponse aux incidents. Des comportements suspects avaient été signalés :
connexions à des domaines inconnus, exécutions PowerShell inhabituelles, modifications
de registre suspectes.

L'objectif de ce scénario est de déployer un centre opérationnel de sécurité (SOC)
capable de détecter, analyser et répondre à ces menaces, en s'appuyant sur Wazuh comme
brique EDR centrale.

## 2. Architecture déployée

### 2.1 Vue d'ensemble

Le SOC repose sur une architecture centralisée : un serveur Wazuh (Manager, Indexer,
Dashboard) collecte et analyse les événements remontés par des agents installés sur les
postes surveillés.

### 2.2 Composants

| Composant | Rôle | Hébergement | Version |
|---|---|---|---|
| Wazuh Manager | Analyse des événements, corrélation, déclenchement des alertes | Debian sur WSL2 | 4.14.7 |
| Wazuh Indexer | Stockage et indexation des alertes (base OpenSearch) | Debian sur WSL2 | 4.14.7 |
| Wazuh Dashboard | Interface web de visualisation et d'investigation | Debian sur WSL2 | 4.14.7 |
| Agent 001 - Windows-Amal | Collecte des événements Windows | Windows 11 (hôte) | 4.14.7 |
| Agent 002 - Kali-Linux-Amal | Collecte des événements Linux | VM VirtualBox (NAT) | 4.14.7 |

### 2.3 Flux réseau

| Source | Destination | Port | Protocole | Usage |
|---|---|---|---|---|
| Agents | Manager | 1514 | TCP | Remontée des événements |
| Agents | Manager | 1515 | TCP | Enrôlement initial |
| Analyste | Dashboard | 443 | HTTPS | Consultation web |
| Manager | Indexer | 9200 | HTTPS | Stockage des alertes |

L'agent Windows (hôte) communique directement avec le Manager. L'agent Kali (VM NAT)
joint le Manager via l'adresse de passerelle 10.0.2.2. Une redirection de ports
(portproxy) a été configurée sur l'hôte Windows pour relayer les ports 1514/1515 vers
l'instance WSL du Manager.

## 3. Modules de détection activés

| Module | Fonction | Statut |
|---|---|---|
| Log collection | Collecte des journaux Windows (Application, Security, System, PowerShell, TaskScheduler) | Actif |
| FIM (File Integrity Monitoring) | Surveillance de l'intégrité des fichiers et clés de registre | Actif |
| SCA (Security Configuration Assessment) | Évaluation de conformité (benchmark CIS Windows 11) | Actif |
| MITRE ATT&CK | Enrichissement des alertes avec les techniques d'attaque | Actif |
| Active Response | Réponse automatisée aux incidents | Configuré (playbooks) |

## 4. Prérequis de journalisation

Certains événements ne sont pas générés par défaut sous Windows et ont nécessité une
activation explicite :

- **Script Block Logging** (événement 4104) : contenu des scripts PowerShell exécutés
- **Audit de création de processus** (événement 4688) avec ligne de commande complète
- **Canal TaskScheduler/Operational** : activé via wevtutil

Sans ces prérequis, les canaux seraient collectés mais vides de contenu exploitable.

## 5. Règles de détection personnalisées

Six règles ont été développées pour élever la criticité et enrichir le contexte MITRE
des comportements suspects, là où les règles natives se contentent de journaliser.

| ID | Description | Niveau | MITRE |
|---|---|---|---|
| 100100 | Exécution PowerShell obfusquée (Base64) | 12 | T1059.001, T1027 |
| 100101 | Commande de reconnaissance système | 10 | T1033, T1087.001, T1082 |
| 100102 | Corrélation : 4+ commandes de reconnaissance en 5 min | 13 | T1087 |
| 100112 | Exécution PowerShell furtive (fenêtre masquée) | 13 | T1564.003 |
| 100120 | Téléchargement de charge distante | 12 | T1105 |
| 100121 | Exfiltration potentielle de données | 14 | T1041 |

## 6. Périmètre et limites

Le cahier des charges prévoyait trois agents (deux Windows, un Linux). Deux agents ont
été déployés, couvrant les deux familles de systèmes d'exploitation demandées. Le
troisième agent (seconde machine Windows virtualisée) n'a pas pu être déployé faute
d'espace disque sur la machine hôte. L'architecture reste extensible : la procédure
d'enrôlement est identique à celle de l'agent 001.

Par ailleurs, le certificat TLS du Dashboard est auto-signé (généré à l'installation).
En production, il serait remplacé par un certificat émis par une autorité reconnue.

## 7. Bilan

Le SOC déployé assure une surveillance continue de deux systèmes d'exploitation,
détecte les comportements suspects via des règles natives et personnalisées, enrichit
les alertes avec le framework MITRE ATT&CK, et dispose de playbooks de réponse. Trois
incidents de catégories distinctes (simple, moyenne, complexe) ont été détectés,
analysés et documentés, validant l'efficacité opérationnelle du dispositif.
