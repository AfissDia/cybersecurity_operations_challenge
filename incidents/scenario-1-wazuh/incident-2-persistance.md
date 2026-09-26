# Incident n°2 - Persistance sur le système

**Catégorie : moyenne** | **Criticité : élevée** | **Statut : clôturé**

## 1. Identification

| Élément | Valeur |
|---|---|
| Date | 26/09/2026, à partir de 19h17 (UTC+1) |
| Machine | DESKTOP-11QRGKA - agent 001 "Windows-Amal" |
| Compte | desktop-11qrgka\canette (SID ...-1001) |
| Source de détection | Wazuh EDR - canal Security (4688), FIM registre, canal TaskScheduler |

## 2. Techniques de persistance observées

| Technique | Commande | Droits requis | MITRE ATT&CK |
|---|---|---|---|
| Clé de registre Run | `reg add HKCU\...\CurrentVersion\Run` | Aucun (utilisateur standard) | T1547.001 - Registry Run Keys |
| Tâche planifiée à la connexion | `schtasks /create /sc onlogon` | Administrateur | T1053.005 - Scheduled Task |
| Exécution furtive | `powershell.exe -WindowStyle Hidden` | Variable | T1564.003 - Hidden Window |

## 3. Chronologie

| Heure | Action | Détection |
|---|---|---|
| 19:17 | Création clé registre `Run` (valeur UpdateService) | Événement 4688 + FIM registre |
| 19:17 | Tentative création tâche en session standard | Échec "Accès refusé" - droits insuffisants |
| ~19:28 | Création tâche planifiée en session administrateur | Événement 4688, règle 100112 (niveau 13) |

## 4. Indicateurs de compromission (IoC)

- Valeurs de registre : `UpdateService`, `UpdateService2` sous `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`
- Tâches planifiées : `WindowsUpdateCheck`, noms usurpant des processus système légitimes
- Chemin de charge utile : `C:\Users\Public\backdoor.ps1` (répertoire public, accessible sans privilège)
- Motif de ligne de commande : `powershell.exe -WindowStyle Hidden -File`

## 5. Analyse

L'attaquant a cherché à établir une persistance, c'est-à-dire un mécanisme garantissant la ré-exécution de sa charge après un redémarrage ou une reconnexion. Deux techniques distinctes ont été employées.

La clé de registre `Run` sous `HKCU` est la plus discrète : elle ne demande **aucun privilège élevé** et s'exécute à chaque ouverture de session de l'utilisateur. La tâche planifiée `onlogon`, elle, offre plus de fiabilité mais a **exigé une élévation de privilèges** - la tentative en session standard a échoué avec "Accès refusé", puis a réussi en session administrateur.

L'analyse de l'événement 4688 correspondant confirme cette élévation : le champ *Type d'élévation du jeton* indique la valeur 2 (jeton complet avec privilèges administratifs), et le processus parent est `powershell.exe`, révélant la filiation PowerShell → schtasks.

Le choix des noms (`WindowsUpdateCheck`, `UpdateService`) relève d'une technique de masquage : usurper l'identité de composants système légitimes pour échapper à une revue superficielle.

## 6. Étendue de la compromission

Deux mécanismes de persistance actifs simultanément, l'un en contexte utilisateur, l'autre en contexte administrateur. La charge référencée (`backdoor.ps1`) n'était pas présente sur le disque dans le cadre de la simulation, mais les vecteurs de ré-exécution étaient pleinement opérationnels.

## 7. Verdict

Incident avéré de niveau moyen à élevé. Persistance caractérisée par deux techniques indépendantes. Correspond à la tactique *Persistence* de MITRE ATT&CK, phase qui suit typiquement l'accès initial et la reconnaissance (voir incident n°1).

## 8. Mesures de remédiation

| Mesure | Type | Statut |
|---|---|---|
| Règle Wazuh 100112 - détection de `-WindowStyle Hidden` (niveau 13) | Détection | Implémentée |
| Surveillance FIM des clés de registre Run/RunOnce | Détection | Configurée |
| Activation du canal TaskScheduler/Operational | Collecte | Configurée |
| Script de suppression des persistances (reg delete + schtasks /delete) | Réponse | Voir scripts/remediation |
| Restriction des droits de création de tâches planifiées | Durcissement | Recommandée |
| Surveillance du répertoire C:\Users\Public (emplacement de charge courant) | Durcissement | Recommandée |
