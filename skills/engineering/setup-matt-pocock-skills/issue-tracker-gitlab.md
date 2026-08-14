# 議題追蹤器：GitLab

此儲存庫的議題與規格作為 GitLab 議題存在。所有操作皆使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## 慣例

- **建立議題**：`glab issue create --title "..." --description "..."`。多行描述請使用 heredoc。傳入 `--description -` 以開啟編輯器。
- **讀取議題**：`glab issue view <number> --comments`。機器可讀的輸出請使用 `-F json`。
- **列出議題**：`glab issue list -F json`，並搭配適當的 `--label` 過濾器。
- **在議題上留言**：`glab issue note <number> --message "..."`。GitLab 將留言稱為「notes」。
- **套用 / 移除標籤**：`glab issue update <number> --label "..."` / `--unlabel "..."`。多個標籤可以用逗點分隔或重複旗標。
- **關閉**：`glab issue close <number>`。`glab issue close` 不接受關閉留言，因此先使用 `glab issue note <number> --message "..."` 發布說明，然後關閉。
- **Merge request**：GitLab 將 PR 稱為「merge request」。使用 `glab mr create`、`glab mr view`、`glab mr note` 等 — 形式與 `gh pr ...` 相同，以 `mr` 替代 `pr`，以 `note`/`--message` 替代 `comment`/`--body`。

從 `git remote -v` 推斷儲存庫 — `glab` 在 clone 內部執行時會自動完成此操作。

## 將 Merge Request 作為分揀表面

**將 MR 作為請求表面：no。** _（如果此儲存庫將外部 merge request 視為功能請求，請設定為 `yes`；`/triage` 會讀取此旗標。）_

當設定為 `yes` 時，MR 會透過與議題相同的標籤與狀態執行，使用等效的 `glab mr` 命令：

- **讀取 MR**：`glab mr view <number> --comments` 以及用於差異的 `glab mr diff <number>`。
- **列出用於分揀的外部 MR**：`glab mr list -F json`，然後僅保留作者非專案成員/擁有者的 MR（貢獻者的 MR，而非維護者進行中的工作）。
- **留言 / 標籤 / 關閉**：`glab mr note`、`glab mr update --label`/`--unlabel`、`glab mr close`。

與 GitHub 不同，GitLab 分別對議題與 MR 進行編號，因此一旦知道維護者是指哪個表面，`#42` 就是明確的。

## 當技能提到「發布至議題追蹤器」時

建立一個 GitLab 議題。

## 當技能提到「擷取相關票券」時

執行 `glab issue view <number> --comments`。

## 尋路操作

由 `/wayfinder` 使用。**地圖（map）**是包含作為票券的**子**議題的單一議題。

- **地圖**：標有 `wayfinder:map` 的單一議題，持有 Notes / Decisions-so-far / Fog 主體。`glab issue create --label wayfinder:map`。（在擁有原生 Epic 的 GitLab 層級中，Epic 可以替代持有地圖；標有標籤的議題在任何地方皆可運作。）
- **子票券**：在描述頂部帶有 `Part of #<map>` 且標有 `wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）標籤的議題。一旦認領，票券將指派給主導的開發人員。
- **阻塞（Blocking）**：GitLab 的**原生阻塞連結** — 規範且 UI 可見的表示方式。使用 `/blocked_by #<n>` 快速動作新增（發布為 note：`glab issue note <child> --message "/blocked_by #<blocker>"`）。原生阻塞連結是 Premium/Ultimate 功能；在免費層級（或無法使用之處）備用為描述頂部的 `Blocked by: #<n>, #<n>` 行。當每個阻塞項都關閉時，票券即解除阻塞。
- **邊界查詢**：`glab issue list -F json` 劃定範疇至地圖的子項目，丟棄帶有開啟阻塞項（連至開啟議題的原生 `blocked_by` 連結 `glab api projects/:id/issues/:iid/links`，或 `Blocked by` 行中開啟的議題）或受派者的任何項目；按地圖順序第一個勝出。
- **認領**：`glab issue update <n> --assignee @me` — 會話的第一筆寫入。
- **解決**：`glab issue note <n> --message "<answer>"`，然後 `glab issue close <n>`，接著在地圖的 Decisions-so-far 附加上下文指標（摘要 + 連結）。
