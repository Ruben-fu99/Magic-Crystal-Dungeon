// ===== 帳號服務設定 =====
// 1) 到 https://supabase.com 建立免費專案
// 2) 在 SQL Editor 執行 supabase.sql 的內容
// 3) Project Settings → API，把 Project URL 與 anon public key 貼到下面（anon key 本來就是公開用的）
window.MOJING_CONFIG = window.MOJING_CONFIG || {
  supabaseUrl: "https://YOUR_PROJECT.supabase.co",
  supabaseKey: "YOUR_ANON_PUBLIC_KEY"
};
