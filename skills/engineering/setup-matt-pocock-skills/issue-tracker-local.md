# 議題追蹤器：本地 Markdown

此儲存庫的議題與規格作為 Markdown 檔案存在於 `.scratch/` 中。

## 慣例

- 每個功能一個目錄：`.scratch/<feature-slug>/`
- 規格為 `.scratch/<feature-slug>/spec.md`
- 實作議題在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md` 處每張票券一個檔案，從 `01` 開始編號 — 絕非單一合併的票券檔案
- 分揀狀態記錄為每個議題檔案頂部附近的 `Status:` 行（角色字串參見 `triage-labels.md`）
- 留言與對話歷史紀錄附加至檔案底部 `## Comments` 標題之下

## 當技能提到「發布至議題追蹤器」時

在 `.scratch/<feature-slug>/` 下建立一個新檔案（如果需要則建立目錄）。

## 當技能提到「擷取相關票券」時

讀取被引用路徑處的檔案。使用者通常會直接傳遞路徑或議題號碼。

## 尋路操作

由 `/wayfinder` 使用。**地圖（map）**是每張票券包含一個**子**檔案的檔案。

- **地圖**：`.scratch/<effort>/map.md` — Notes / Decisions-so-far / Fog 主體。
- **子票券**：`.scratch/<effort>/issues/NN-<slug>.md`，從 `01` 開始編號，問題位於主體中。`Type:` 行記錄票券型態（`research`/`prototype`/`grilling`/`task`）；`Status:` 行記錄 `claimed`/`resolved`。
- **阻塞（Blocking）**：頂部附近的 `Blocked by: NN, NN` 行。當其列出的每個檔案皆為 `resolved` 時，票券即解除阻塞。
- **邊界（Frontier）**：掃描 `.scratch/<effort>/issues/` 尋找開啟、未阻塞且未認領的檔案；按編號第一個勝出。
- **認領**：在進行任何工作前設定 `Status: claimed` 並儲存。
- **解決**：在 `## Answer` 標題下附加答案，設定 `Status: resolved`，然後在 `map.md` 的地圖 Decisions-so-far 附加上下文指標（摘要 + 連結）。
