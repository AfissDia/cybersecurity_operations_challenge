# Rapport de synthèse - Scénario 1
## Détection et réponse aux menaces avancées (Wazuh EDR)

**Projet :** Cybersécurité opérationnelle - TechnoVision
**Auteur :** Amal
**Date :** Septembre 2026

---

## 1. Résumé exécutif

Ce rapport présente le déploiement et l'exploitation d'un SOC basé sur Wazuh pour
l'entreprise fictive TechnoVision. Le dispositif surveille deux systèmes (Windows 11
et Kali Linux), détecte les comportements suspects via des règles natives et
personnalisées, et classe les menaces selon le framework MITRE ATT&CK. Trois incidents
de complexité croissante ont été simulés, détectés et analysés : reconnaissance,
persistance, et une kill chain complète du téléchargement à l'exfiltration.

## 2. Méthodologie

La démarche a suivi quatre phases :
1. **Préparation** : déploiement de Wazuh (Manager, Indexer, Dashboard) et enrôlement des agents
2. **Configuration de la détection** : collecte des logs, activation FIM/SCA, développement de règles personnalisées
3. **Détection et analyse** : simulation d'attaques, investigation dans Threat Hunting, classification MITRE
4. **Réponse** : rédaction de playbooks et de scripts de remédiation

## 3. Infrastructure

Voir le Dossier d'Architecture Détaillée (DAT-scenario-1.md) pour le détail des
composants, flux réseau et modules.

Synthèse : serveur Wazuh 4.14.7 hébergé sur Debian/WSL2, deux agents (Windows 11 et
Kali Linux), modules FIM, SCA et MITRE ATT&CK actifs.

## 4. Règles de détection développées

Six règles personnalisées ont été implémentées dans local_rules.xml. Leur valeur
ajoutée par rapport aux règles natives : élévation de la criticité (niveaux 10 à 14
contre 3 en natif), enrichissement MITRE, et surtout capacité de corrélation
(règle 100102) permettant de détecter une séquence d'attaque et non une action isolée.

## 5. Incidents investigués

### Incident 1 - Reconnaissance (simple)
Séquence de commandes de découverte système et réseau, suivie d'une exécution PowerShell
encodée. Détecté par les règles 100100, 100101 et corrélé par 100102. Voir
incident-1-reconnaissance.md.

### Incident 2 - Persistance (moyenne)
Installation de deux mécanismes de persistance : clé de registre Run et tâche planifiée.
Analyse de l'élévation de privilèges via l'événement 4688. Détecté par la règle 100112.
Voir incident-2-persistance.md.

### Incident 3 - Kill chain (complexe)
Attaque multi-étapes complète : téléchargement, exécution, persistance, exfiltration.
Les quatre phases détectées en moins de 2 secondes, avec des niveaux croissants
(12 à 14). Voir incident-3-killchain.md.

## 6. Réponse aux incidents

Deux playbooks au format YAML ont été développés :
- **PB-001** : isolation réseau d'un poste compromis (déclenché sur alerte niveau >= 12)
- **PB-002** : suppression automatique d'une persistance registre

Un script de remédiation PowerShell (remediation-persistance.ps1) automatise le
nettoyage des persistances identifiées.

## 7. Résultats et métriques

- 2 systèmes d'exploitation supervisés en continu
- 6 règles de détection personnalisées opérationnelles
- 3 incidents détectés et analysés (100% de détection sur les scénarios simulés)
- Délai de détection observé : moins d'une minute entre l'action et l'alerte
- 12 techniques MITRE ATT&CK couvertes

## 8. Recommandations

- Généraliser la journalisation PowerShell et l'audit 4688 à l'ensemble du parc
- Restreindre PowerShell (Constrained Language Mode, AppLocker/WDAC)
- Remplacer le certificat auto-signé du Dashboard par un certificat d'autorité reconnue
- Déployer le troisième agent Windows prévu, une fois les ressources disponibles
- Configurer l'Active Response pour automatiser réellement l'isolation

## 9. Conclusion

Le SOC déployé répond aux objectifs du scénario : détection, analyse et réponse aux
menaces sur un environnement multi-OS. La combinaison de règles personnalisées, de
corrélation et du mapping MITRE ATT&CK permet de passer d'une simple journalisation à
une véritable capacité de détection comportementale, validée par trois incidents de
complexité croissante.
