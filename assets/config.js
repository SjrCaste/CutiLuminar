// Configuración pública de Supabase.
// La "publishable key" está diseñada para exponerse en el navegador: solo
// permite lo que las políticas de seguridad (RLS) definidas en
// supabase/schema.sql autorizan (lectura pública de productos activos).
// NUNCA pongas acá la "secret key" (sb_secret_...): esa solo se usa desde
// scripts de servidor/migración, nunca en archivos que viajan al navegador.
window.SUPABASE_CONFIG = {
  url: 'https://afeowwgrdxiiihiatbvw.supabase.co',
  publishableKey: 'sb_publishable_ip-jywvhHlXspHkf3FcBkw_VtEiqtJH',
};
