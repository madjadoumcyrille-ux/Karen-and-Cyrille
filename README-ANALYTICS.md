# Activer le suivi privé (Supabase)

Le code du jeu est prêt à être relié à Supabase, mais les données ne seront pas collectées tant que tu n'auras pas créé/configuré ton projet. Ne publie jamais de clé service_role.

## 1. Créer la base
1. Crée un projet sur https://supabase.com/ (le forfait gratuit suffit généralement pour commencer).
2. Dans SQL Editor, exécute tout le fichier `supabase-schema.sql` de ce dépôt.
3. Dans Authentication > Users, crée un utilisateur avec TON email et un mot de passe fort. Désactive l'inscription publique si elle est proposée.
4. Copie l'UUID de cet utilisateur et exécute dans SQL Editor :
   `insert into public.admin_users(user_id) values ('COLLE_UUID_ICI');`
5. Dans Project Settings > API (ou Connect), copie Project URL et la clé publique anon/publishable.
6. Remplace les deux valeurs dans `supabase-config.js`. Utilise uniquement la clé publique anon/publishable; jamais la clé service_role.

## 2. Activer sur GitHub Pages
Enregistre/commit les changements, puis attends la publication GitHub Pages. Ouvre le jeu une fois en ligne et envoie une réaction de test. Les visites et retours ne s'affichent qu'après la configuration correcte.

## 3. Tableau de bord
Ouvre `https://madjadoumcyrille-ux.github.io/Karen-and-Cyrille/dashboard.html` et connecte-toi avec l'utilisateur créé à l'étape 3. Seuls les UUID présents dans `admin_users` peuvent lire les données.

## Données et limites
- Une visite est comptée à chaque chargement du jeu; ce n'est pas un nombre exact de personnes uniques.
- Aucun IP, géolocalisation ou empreinte d'appareil n'est enregistré par le code de suivi.
- Le pseudo est facultatif; les réactions/commentaires sont volontairement envoyés par le joueur.
- Les politiques RLS autorisent l'insertion contrôlée mais bloquent la lecture publique. Limite de conservation recommandée : supprimer régulièrement les vieux événements.
- Le dashboard affiche au plus 1 000 événements récents; pagination à ajouter si le jeu devient populaire.
- Le projet Supabase doit rester en ligne et ses règles de sécurité doivent rester activées.