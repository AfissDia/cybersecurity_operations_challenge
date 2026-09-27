# Cahier de recette - Scénario 1 (Wazuh EDR)

**Projet :** Cybersécurité opérationnelle - TechnoVision
**Périmètre :** SOC Wazuh, agents Windows 11 et Kali Linux
**Date des tests :** 26-27/09/2026

---

## 1. Tests d'infrastructure

| ID | Test | Résultat attendu | Résultat obtenu | Statut |
|---|---|---|---|---|
| INFRA-01 | Démarrage du Wazuh Manager | Service active (running) | active (running) | OK |
| INFRA-02 | Démarrage du Wazuh Indexer | Service active (running) | active (running) | OK |
| INFRA-03 | Démarrage du Wazuh Dashboard | Service active (running) | active (running) | OK |
| INFRA-04 | Accès au dashboard via HTTPS | Page de login accessible | Accessible (certificat auto-signé) | OK |
| INFRA-05 | Enrôlement agent Windows (001) | Agent visible et Active | Active | OK |
| INFRA-06 | Enrôlement agent Kali (002) | Agent visible et Active | Active | OK |

## 2. Tests de collecte

| ID | Test | Résultat attendu | Résultat obtenu | Statut |
|---|---|---|---|---|
| COL-01 | Collecte canal Application | Événements remontés | Remontés | OK |
| COL-02 | Collecte canal Security | Événements remontés | Remontés | OK |
| COL-03 | Collecte canal System | Événements remontés | Remontés | OK |
| COL-04 | Collecte PowerShell/Operational | Événement 4104 visible | 4104 visible | OK |
| COL-05 | Collecte création de processus | Événement 4688 visible | 4688 visible | OK |
| COL-06 | Module FIM actif | Scan FIM démarré | Real-time FIM started | OK |
| COL-07 | Module SCA actif | Évaluation CIS terminée | cis_win11_enterprise.yml évalué | OK |

## 3. Tests des règles de détection

| ID | Test | Résultat attendu | Résultat obtenu | Statut |
|---|---|---|---|---|
| RULE-01 | Détection PowerShell encodé (100100) | Alerte niveau 12 | Niveau 12 | OK |
| RULE-02 | Détection reconnaissance (100101) | Alerte niveau 10 | Niveau 10 | OK |
| RULE-03 | Corrélation séquence (100102) | Alerte niveau 13 après 4 commandes | Niveau 13 | OK |
| RULE-04 | Détection exécution furtive (100112) | Alerte niveau 13 | Niveau 13 | OK |
| RULE-05 | Détection téléchargement (100120) | Alerte niveau 12 | Niveau 12 | OK |
| RULE-06 | Détection exfiltration (100121) | Alerte niveau 14 | Niveau 14 | OK |

## 4. Tests des scénarios d'incidents

| ID | Test | Résultat attendu | Résultat obtenu | Statut |
|---|---|---|---|---|
| INC-01 | Incident 1 - Reconnaissance | Détection et classification MITRE | Détecté, tactique Discovery | OK |
| INC-02 | Incident 2 - Persistance | Détection registre + tâche | Détecté, tactique Persistence | OK |
| INC-03 | Incident 3 - Kill chain | 4 phases détectées, niveaux croissants | 4 phases, niveaux 12 à 14 | OK |

## 5. Tests de réponse

| ID | Test | Résultat attendu | Résultat obtenu | Statut |
|---|---|---|---|---|
| REP-01 | Script de remédiation persistance | Suppression des clés et tâches | Persistances supprimées | OK |
| REP-02 | Enrichissement MITRE des alertes | Techniques mappées automatiquement | Mapping actif | OK |

## 6. Synthèse

| Catégorie | Tests | OK | KO |
|---|---|---|---|
| Infrastructure | 6 | 6 | 0 |
| Collecte | 7 | 7 | 0 |
| Règles | 6 | 6 | 0 |
| Incidents | 3 | 3 | 0 |
| Réponse | 2 | 2 | 0 |
| **Total** | **24** | **24** | **0** |

**Taux de réussite : 100%**

## 7. Réserves et limites

- Déploiement de 2 agents sur 3 prévus (limite d'espace disque hôte)
- Canal TaskScheduler activé manuellement (désactivé par défaut sous Windows)
- Certificat dashboard auto-signé (à remplacer en production)
