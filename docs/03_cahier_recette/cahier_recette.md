# Cahier de recette

| ID | Test | Résultat attendu | Statut |
|---|---|---|---|
| REC-01 | Ping ES-NODE-01 vers ES-NODE-02 | Communication réussie | OK |
| REC-02 | Ping ES-NODE-02 vers ES-NODE-01 | Communication réussie | OK |
| REC-03 | Accès HTTPS Elasticsearch | Réponse HTTP 401 sans authentification | OK |
| REC-04 | Authentification utilisateur elastic | Authentification réussie | OK |
| REC-05 | Vérification du cluster | Deux nœuds visibles | OK |
| REC-06 | Vérification du master | ES-NODE-01 élu master | OK |