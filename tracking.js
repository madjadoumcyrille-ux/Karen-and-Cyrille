import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm";
import { SUPABASE_URL, SUPABASE_ANON_KEY, isSupabaseConfigured } from "./supabase-config.js";
if (!isSupabaseConfigured) {
  const status = document.getElementById("feedback-status");
  if (status) status.textContent = "Les réactions seront activées après la configuration de la base de données.";
} else {
  const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
  // Comptage simple des ouvertures, sans IP, géolocalisation ni empreinte d'appareil.
  try { await supabase.from("game_events").insert({event_type:"visit"}); } catch (_) {}
  const form = document.getElementById("feedback-form");
  if (form) form.addEventListener("submit", async event => {
    event.preventDefault();
    const status = document.getElementById("feedback-status");
    const nickname = document.getElementById("nickname").value.trim().slice(0,40) || null;
    const reaction = document.getElementById("reaction").value;
    const comment = document.getElementById("comment").value.trim().slice(0,500);
    if (!reaction && !comment) { status.textContent = "Choisis une réaction ou écris un commentaire."; return; }
    status.textContent = "Envoi…";
    const rows = [];
    if (reaction) rows.push({event_type:"reaction",nickname,reaction});
    if (comment) rows.push({event_type:"comment",nickname,comment});
    const { error } = await supabase.from("game_events").insert(rows);
    status.textContent = error ? "Envoi impossible pour le moment. Réessaie plus tard." : "Merci ! Ta réaction a bien été envoyée 💗";
    if (!error) { document.getElementById("comment").value = ""; document.getElementById("reaction").value = ""; }
  });
}