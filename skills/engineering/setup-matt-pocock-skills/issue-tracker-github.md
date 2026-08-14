# 議題追蹤器：GitHub

此儲存庫的議題與規格作為 GitHub 議題存在。所有操作皆使用 `gh` CLI。

## 慣例

- **建立議題**：`gh issue create --title "..." --body "..."`。多行內文請使用 heredoc。
- **讀取議題**：`gh issue view <number> --comments`，透過 `jq` 過濾留言並擷取標籤。
- **列出議題**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`，並搭配適當的 `--label` 與 `--state` 過濾器。
- **在議題上留言**：`gh issue comment <number> --body "..."`
- **套用 / 移除標籤**：`gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **關閉**：`gh issue close <number> --comment "..."`

從 `git remote -v` 推斷儲存庫 — `gh` 在 clone 內部執行時會自動完成此操作。

## 將 Pull Request 作為分揀表面

**將 PR 作為請求表面：no。** _（如果此儲存庫將外部 PR 視為功能請求，請設定為 `yes`；`/triage` 會讀取此旗標。）_

當設定為 `yes` 時，PR 會透過與議題相同的標籤與狀態執行，使用等效的 `gh pr` 命令：

- **讀取 PR**：`gh pr view <number> --comments` 以及用於差異的 `gh pr diff <number>`。
- **列出用於分揀的外部 PR**：`gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`，然後僅保留 `authorAssociation` 為 `CONTRIBUTOR`、`FIRST_TIME_CONTRIBUTOR` 或 `NONE` 的項目（捨棄 `OWNER`/`MEMBER`/`COLLABORATOR`）。
- **留言 / 標籤 / 關閉**：`gh pr comment`、`gh pr edit --add-label`/`--remove-label`、`gh pr close`。

GitHub 在議題與 PR 之間共享一個號碼空間，因此單純的 `#42` 可能是其中任何一個 — 透過 `gh pr view 42` 解析，並備用為 `gh issue view 42`。

## 當技能提到「發布至議題追蹤器」時

建立一個 GitHub 議題。

## 當技能提到「擷取相關票券」時

執行 `gh issue view <number> --comments`。

## 尋路操作

由 `/wayfinder` 使用。**地圖（map）**是包含作為票券的**子**議題的單一議題。

- **地圖**：標有 `wayfinder:map` 的單一議題，持有 Notes / Decisions-so-far / Fog 主體。`gh issue create --label wayfinder:map`。
- **子票券**：作為 GitHub 子議題（sub-issue）連結至地圖的議題（在 sub-issues 端點上使用 `gh api`）。當未啟用子議題時，將子項目新增至地圖主體中的任務清單，並在子項目主體頂部放置 `Part of #<map>`。標籤：`wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）。一旦認領，票券將指派給主導的開發人員。
- **阻塞（Blocking）**：GitHub 的**原生議題依賴項** — 規範且 UI 可見的表示方式。使用 `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>` 新增邊界，其中 `<blocker-db-id>` 是阻塞項的數字**資料庫 id**（`gh api repos/<owner>/<repo>/issues/<n> --jq .id`，_不是_ `#number` 或 `node_id`）。GitHub 會報告 `issue_dependencies_summary.blocked_by`（僅限開啟的阻塞項 — 即時關卡）。當無法使用依賴項時，備用為子主體頂部的 `Blocked by: #<n>, #<n>` 行。當每個阻塞項都關閉時，票券即解除阻塞。
- **邊界查詢**：列出地圖開啟的子項目（`gh issue list --state open`，劃定範疇至地圖的子議題 / 任務清單），丟棄帶有開啟阻塞項（`issue_dependencies_summary.blocked_by > 0`，或 `Blocked by` 行中開啟的議題）或受派者的任何項目；按地圖順序第一個勝出。
- **認領**：`gh issue edit <n> --add-assignee @me` — 會話的第一筆寫入。
- **解決**：`gh issue comment <n> --body "<answer>"`，然後 `gh issue close <n>`，接著在地圖的 Decisions-so-far 附加上下文指標（摘要 + 連結）。
