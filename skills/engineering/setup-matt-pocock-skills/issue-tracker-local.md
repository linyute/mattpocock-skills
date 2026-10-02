# Issue tracker: 本地 Markdown

本儲存庫的 Issue 與規格均作為 Markdown 檔案存放在 `.scratch/` 中。

## 慣例

- 每個功能一個目錄：`.scratch/<feature-slug>/`
- 規格為 `.scratch/<feature-slug>/spec.md`
- 實作 issue 為每個 ticket 一個檔案，位於 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，從 `01` 開始編號，絕不合併為單一 tickets 檔案
- 分流狀態記錄在每個 issue 檔案頂端附近的 `Status:` 行（有關角色字串請參閱 `triage-labels.md`）
- 留言與對話歷史會附加在檔案底部的 `## Comments` 標題下

## 當技能指出「發布至 issue tracker」時

在 `.scratch/<feature-slug>/` 下建立新檔案（需要時建立該目錄）。

## 當技能指出「擷取相關 ticket」時

讀取所參照路徑上的檔案。使用者通常會直接傳入路徑或 issue 編號。

## 尋路操作

供 `/wayfinder` 使用。**地圖**是一個檔案，每個 ticket 有一個**子**檔案。

- **地圖**：`.scratch/<effort>/map.md`（Notes / Decisions-so-far / Fog 內文）。
- **子 ticket**：`.scratch/<effort>/issues/NN-<slug>.md`，從 `01` 開始編號，問題寫在內文中。`Type:` 行記錄 ticket 類型（`research`/`prototype`/`grilling`/`task`）；`Status:` 行記錄 `claimed`/`resolved`。
- **阻礙（Blocking）**：頂端附近的 `Blocked by: NN, NN` 行。當 ticket 列出的每個檔案都處於 `resolved` 狀態時，該 ticket 即解除阻礙。
- **前沿**：掃描 `.scratch/<effort>/issues/` 尋找處於未結、未受阻礙且未認領的檔案；編號最小者優先。
- **認領**：在進行任何工作之前設定 `Status: claimed` 並儲存。
- **解決**：在 `## Answer` 標題下附加答案，設定 `Status: resolved`，然後在 `map.md` 的地圖 Decisions-so-far 附加情境指標（摘要 + 連結）。
