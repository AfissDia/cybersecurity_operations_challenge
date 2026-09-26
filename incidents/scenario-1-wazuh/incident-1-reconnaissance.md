# Incident n°1 - Reconnaissance post-compromission

**Catégorie : simple** | **Criticité : faible** | **Statut : clôturé**

## 1. Identification

| Élément | Valeur |
|---|---|
| Date | 24/09/2026, 11h29 - 11h43 (UTC+1) |
| Machine | DESKTOP-11QRGKA - agent 001 "Windows-Amal" |
| Adresse IP | 10.60.5.28 |
| Système | Windows 11 Famille, build 26200 |
| Compte concerné | desktop-11qrgka\canette (SID ...-1001) |
| Niveau d'intégrité | Moyen - aucune élévation de privilèges |
| Source de détection | Wazuh EDR - canaux Security (4688) et PowerShell/Operational (4104) |

## 2. Chronologie des événements

| Heure | Action observée | Technique MITRE ATT&CK |
|---|---|---|
| 11:33 | `whoami /all` | T1033 - System Owner/User Discovery |
| 11:35 | `net user` | T1087.001 - Account Discovery: Local Account |
| 11:37 | `net localgroup administrateurs` | T1069.001 - Permission Groups Discovery |
| 11:39 | `systeminfo` puis `ipconfig /all` | T1082 - System Information Discovery / T1016 - System Network Configuration Discovery |
| 11:41 | `net share` | T1135 - Network Share Discovery |
| 11:43 | `powershell.exe -NoProfile -EncodedCommand VwByAGkA...` | T1059.001 - PowerShell / T1027 - Obfuscated Files or Information |

## 3. Indicateurs de compromission (IoC)

- Chaîne Base64 : `VwByAGkAdABlAC0ASABvAHMAdAAgACIAVABlAHMAdAAgAFMATwBDACIA`
- Motif de ligne de commande : `powershell.exe` invoqué avec `-NoProfile` ET `-EncodedCommand`
- Séquence comportementale : 5 commandes de découverte ou plus en moins de 15 minutes, depuis un compte non privilégié

## 4. Analyse

Prises isolément, ces commandes sont toutes légitimes : un administrateur peut lancer `systeminfo` ou `net user` dans le cadre de son travail. Ce qui caractérise l'incident, c'est la séquence et la densité : six commandes de découverte système, réseau et comptes enchaînées en quinze minutes, suivies d'une exécution PowerShell dissimulée.

Le marqueur le plus significatif est la combinaison `-NoProfile` et `-EncodedCommand`. Le premier évite de charger le profil utilisateur, le second masque le contenu réel de la commande. Aucun usage interactif légitime courant ne réunit ces deux options : c'est une signature classique de charge utile automatisée.

Le décodage du Base64 a confirmé un contenu inoffensif dans le cadre de cette simulation (`Write-Host "Test SOC"`), mais le mécanisme employé est identique à celui d'une charge malveillante réelle.

## 5. Étendue de la compromission

Limitée. Le jeton d'accès était à intégrité moyenne, avec le groupe Administrateurs positionné en "refus uniquement" : aucune action privilégiée n'était possible depuis cette session. Aucune persistance, aucune connexion réseau sortante anormale et aucune modification des clés de registre `Run` n'ont été observées sur la période.

## 6. Verdict

Incident avéré de niveau faible. Reconnaissance caractérisée, sans élévation de privilèges ni impact sur la confidentialité ou l'intégrité des données. Correspond à la tactique *Discovery* du framework MITRE ATT&CK, qui suit typiquement un accès initial et précède une tentative d'escalade.

## 7. Mesures de remédiation

| Mesure | Type | Statut |
|---|---|---|
| Règle Wazuh 100100 - détection de `-EncodedCommand` (niveau 12) | Détection | Implémentée |
| Règle Wazuh 100101 - détection des commandes de découverte (niveau 10) | Détection | Implémentée |
| Règle Wazuh 100102 - corrélation : 4 commandes ou plus en 5 minutes (niveau 13) | Corrélation | Implémentée |
| Journalisation PowerShell (Script Block Logging) généralisée au parc | Durcissement | Implémentée sur l'agent 001 |
| Audit de création de processus avec ligne de commande (4688) | Durcissement | Implémentée sur l'agent 001 |
| Restriction de PowerShell aux comptes administrateurs via AppLocker ou WDAC | Durcissement | Recommandée |
| Isolation réseau automatique du poste via Active Response | Réponse | Voir playbook 01 |
