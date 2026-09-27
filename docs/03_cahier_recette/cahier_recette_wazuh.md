# Cahier de recette - Scénario 1 (Wazuh EDR)

**Projet :** Cybersécurité opérationnelle - TechnoVision
**Périmètre :** SOC Wazuh, agents Windows 11 et Kali Linux
**Date des tests :** 26-27/09/2026

## Cahier de recette

| ID | Exigence testée | Test | Résultat attendu | Résultat | Statut | Preuve |
|---|---|---|---|---|---|---|
| REC-01 | Infrastructure | Service Wazuh Manager | active (running) | Conforme | OK | CAP-01 |
| REC-02 | Infrastructure | Service Wazuh Indexer | active (running) | Conforme | OK | CAP-01 |
| REC-03 | Infrastructure | Service Wazuh Dashboard | active (running) | Conforme | OK | CAP-01 |
| REC-04 | Agents | Enrôlement agent Windows (001) | Agent Active | Conforme | OK | CAP-02 |
| REC-05 | Agents | Enrôlement agent Kali (002) | Agent Active | Conforme | OK | CAP-02 |
| REC-06 | Collecte | Canaux Application/Security/System | Événements remontés | Conforme | OK | CAP-03 |
| REC-07 | Collecte | Configuration des canaux (ossec.conf) | 6 canaux configurés | Conforme | OK | CAP-04 |
| REC-08 | Collecte | Journalisation PowerShell (4104) | Événement 4104 visible | Conforme | OK | CAP-03 |
| REC-09 | Collecte | Création de processus (4688) | Événement 4688 visible | Conforme | OK | CAP-11 |
| REC-10 | Module FIM | File Integrity Monitoring actif | Scan FIM opérationnel | Conforme | OK | CAP-05 |
| REC-11 | Module SCA | Security Configuration Assessment | Évaluation CIS terminée | Conforme | OK | CAP-06 |
| REC-12 | MITRE ATT&CK | Enrichissement des alertes | Techniques mappées | Conforme | OK | CAP-07 |
| REC-13 | Règle 100100 | Détection PowerShell encodé | Alerte niveau 12 | Conforme | OK | CAP-08 |
| REC-14 | Règle 100101 | Détection reconnaissance | Alerte niveau 10 | Conforme | OK | CAP-09 |
| REC-15 | Règle 100102 | Corrélation de séquence | Alerte niveau 13 | Conforme | OK | CAP-10 |
| REC-16 | Incident 1 | Reconnaissance (simple) | Détection + MITRE Discovery | Conforme | OK | CAP-09, CAP-10 |
| REC-17 | Incident 2 | Persistance (moyenne) | Détection registre + tâche | Conforme | OK | CAP-11, CAP-12 |
| REC-18 | Incident 3 | Kill chain (complexe) | 4 phases, niveaux 12 à 14 | Conforme | OK | CAP-13, CAP-14 |
| REC-19 | Règles personnalisées | 6 règles chargées | Règles visibles dans le manager | Conforme | OK | CAP-15 |
| REC-20 | Réponse | Script de remédiation persistance | Persistances supprimées | Conforme | OK | Script |

## Références des preuves

| Code | Fichier |
|---|---|
| CAP-01 | captures/scenario-1-wazuh/installation/Services Wazuh actifs.png |
| CAP-02 | captures/scenario-1-wazuh/installation/Les 2 agents actifs.png |
| CAP-03 | captures/scenario-1-wazuh/installation/05-repartition-canaux.png |
| CAP-04 | captures/scenario-1-wazuh/installation/04-canaux-collecte.png |
| CAP-05 | captures/scenario-1-wazuh/fim-sca/06-fim.png |
| CAP-06 | captures/scenario-1-wazuh/fim-sca/07-sca.png |
| CAP-07 | captures/scenario-1-wazuh/fim-sca/08-mitre.png |
| CAP-08 | captures/scenario-1-wazuh/incident-3/incident-3_01-killchain-timeline.png |
| CAP-09 | captures/scenario-1-wazuh/incident-1/incident_1-01_reconnaissance.png |
| CAP-10 | captures/scenario-1-wazuh/incident-1/incident-1-02-correlation-detail.png |
| CAP-11 | captures/scenario-1-wazuh/incident-2/incident-2_01-detection-persistance.png |
| CAP-12 | captures/scenario-1-wazuh/incident-2/incident-2_02-detail-4688.png |
| CAP-13 | captures/scenario-1-wazuh/incident-3/incident-3_01-killchain-timeline.png |
| CAP-14 | captures/scenario-1-wazuh/incident-3/incident-3_02-exfiltration-detail.png |
| CAP-15 | captures/scenario-1-wazuh/installation/09-regles-personnalisees.png |

## Synthèse

| Catégorie | Tests | OK | KO |
|---|---|---|---|
| Infrastructure et agents | 5 | 5 | 0 |
| Collecte | 4 | 4 | 0 |
| Modules (FIM/SCA/MITRE) | 3 | 3 | 0 |
| Règles de détection | 3 | 3 | 0 |
| Incidents | 3 | 3 | 0 |
| Règles + réponse | 2 | 2 | 0 |
| **Total** | **20** | **20** | **0** |

**Taux de réussite : 100%**

## Réserves et limites

- Déploiement de 2 agents sur 3 prévus (limite d'espace disque sur la machine hôte)
- Canal TaskScheduler activé manuellement (désactivé par défaut sous Windows 11)
- Certificat dashboard auto-signé (à remplacer par un certificat d''autorité reconnue en production)
