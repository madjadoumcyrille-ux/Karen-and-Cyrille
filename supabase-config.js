// Configuration publique du projet Supabase. Remplacez ces deux valeurs par celles de votre projet.
// N'ajoutez JAMAIS une clé service_role ici : ce fichier est visible publiquement.
export const SUPABASE_URL = "https://VOTRE-PROJET.supabase.co";
export const SUPABASE_ANON_KEY = "VOTRE_CLE_ANON_PUBLIQUE";
export const isSupabaseConfigured = !SUPABASE_URL.includes("VOTRE-PROJET") && !SUPABASE_ANON_KEY.includes("VOTRE_CLE");