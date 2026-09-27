# Scénario 1 - Détection et réponse aux menaces avancées (Wazuh EDR)

## Architecture déployée

| Composant | Hébergement | Version |
|---|---|---|
| Wazuh Manager | Debian sur WSL2 | 4.14.7 |
| Wazuh Indexer | Debian sur WSL2 | 4.14.7 |
| Wazuh Dashboard | Debian sur WSL2 | 4.14.7 |
| Agent 001 - Windows-Amal | Windows 11 (hôte) | 4.14.7 |
| Agent 002 - Kali-Linux-Amal | VM VirtualBox, réseau NAT | 4.14.7 |

## Contenu de ce dossier

- `configs/scenario-1-wazuh/` - fichiers de configuration des agents
- `rules/scenario-1-wazuh/` - règles de détection personnalisées
- `incidents/scenario-1-wazuh/` - fiches d'investigation
- `playbooks/scenario-1-wazuh/` - playbooks de réponse automatisée
- `captures/scenario-1-wazuh/` - captures d'écran justificatives
- `docs/scenario-1-wazuh/` - DAT et rapport détaillé

## Limites assumées

Le cahier des charges prévoyait trois agents (deux Windows, un Linux). Deux agents ont été déployés, couvrant les deux familles de systèmes d'exploitation demandées. Le troisième agent (seconde machine Windows virtualisée) n'a pas pu être déployé faute d'espace disque sur la machine hôte. La procédure d'enrôlement étant identique à celle de l'agent 001, l'architecture reste extensible sans modification.
