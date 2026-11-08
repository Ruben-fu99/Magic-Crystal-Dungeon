# 魔晶地牢（GitHub Pages 版）

單檔網頁遊戲 `index.html`，含**註冊／登入、雲端存檔、排行榜**，並能把「尚未登入的本機紀錄」繼承到帳號。

## 部署（GitHub Pages）
1. 把 `index.html`、`config.js`、`README.md`、`supabase.sql` 放到倉庫根目錄。
2. 倉庫 **Settings → Pages**：Source 選 `Deploy from a branch`，Branch 選 `main` / `(root)`。
3. 網址會是 `https://<帳號>.github.io/<倉庫名>/`。

## 開啟帳號功能（一次性，免費）
GitHub Pages 只能放靜態檔案，登入需要後端，這裡用免費的 Supabase：
1. 到 supabase.com 建立專案。
2. **SQL Editor** 貼上 `supabase.sql` 全部內容並執行（建立存檔表與排行榜表，並開啟「只能讀寫自己資料」的權限規則）。
3. **Authentication → URL Configuration**：把 *Site URL* 設成你的 GitHub Pages 網址（驗證信、重設密碼信的連結會回到這裡）。
4. （選用）**Authentication → Providers → GitHub**：照畫面步驟建立 GitHub OAuth App，即可使用「用 GitHub 登入」。
5. **Project Settings → API**：複製 *Project URL* 與 *anon public key*，貼進 `config.js`。anon key 設計上就是公開的，安全由第 2 步的權限規則保證；**不要**把 service_role key 放進來。
6. 若想註冊後免收驗證信，可在 Authentication → Providers → Email 關閉 *Confirm email*（較不安全，自行評估）。

沒完成設定時，遊戲仍可用訪客模式，紀錄存在瀏覽器。

## 如何繼承尚未登錄的紀錄
訪客紀錄存放在瀏覽器（localStorage）。第一次登入或註冊成功後：
- **帳號雲端沒有紀錄**：自動把目前的本機紀錄綁定到帳號並上傳。
- **雲端已有紀錄、本機也有進度**：跳出選單，可選
  - **合併（推薦）**：以進度較高者為主，補上另一邊獨有的角色、寵物、裝備、外觀、稱號等；數值取較大者。
  - 只用本機（覆蓋雲端）／只用雲端。
  未被選中的那份會先備份在瀏覽器中（最近 4 份）。
- 之後同一帳號在不同裝置登入，會依存檔時間載入較新的一份；每次存檔約 2 秒後自動同步。
- 註冊若需要驗證信：驗證前本機紀錄不會動，驗證並登入後才會進入上面的流程。

## 網頁版支援的線上功能
與 Claude 作品頁版本相同：雲端存檔、總榜／無盡塔／每日／每週／PvP／世界王排行榜、世界王全服傷害累計、PvP 對戰、好友在線與即時聊天／私訊、合作模式（含實驗性怪物同步）、離線信箱與拜訪家園、公會。
- 資料型功能（排行榜、世界王、信箱…）存在 Supabase 的 `docs` 表，由 `supabase.sql` 的權限規則保護：只能寫自己的文件。
- 即時功能（聊天、在線、合作、PvP）走 Supabase Realtime Broadcast，不需建表；免費方案有同時連線與每秒訊息數上限，人多時可能被限流。
- 需要登入才能使用線上功能；訪客模式為單機。
