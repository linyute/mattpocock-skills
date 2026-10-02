# 議題追蹤器：GitHub

此儲存庫的議題與規格書以 GitHub issue 形式存在。所有操作均使用 `gh` CLI。

## 慣例

- **建立議題**：`gh issue create --title "..." --body "..."`。多行內文請使用 heredoc。
- **讀取議題**：`gh issue view <number> --comments`，以 `jq` 篩選留言並同時擷取標籤。
- **列出議題**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` 搭配適當的 `--label` 與 `--state` 篩選條件。
- **在議題上留言**：`gh issue comment <number> --body "..."`
- **套用／移除標籤**：`gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **關閉**：`gh issue close <number> --comment "..."`

從 `git remote -v` 推斷儲存庫；在複製的儲存庫內執行時 `gh` 會自動執行此操作。

## 將 Pull Request 作為分流介面

**將 PR 作為請求介面：否。** _（若此儲存庫將外部 PR 視為功能請求，請設為 `yes`；`/triage` 會讀取此旗標。）_

當設為 `yes` 時，PR 會透過 `gh pr` 同等指令套用與 issue 相同的標籤與狀態：

- **讀取 PR**：`gh pr view <number> --comments` 以及使用 `gh pr diff <number>` 查看 diff。
- **列出待分流的外部 PR**：`gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`，然後僅保留 `authorAssociation` 為 `CONTRIBUTOR`、`FIRST_TIME_CONTRIBUTOR` 或 `NONE` 的項目（排除 `OWNER`／`MEMBER`／`COLLABORATOR`）。
- **留言／加上標籤／關閉**：`gh pr comment`、`gh pr edit --add-label`/`--remove-label`、`gh pr close`。

GitHub 在 issue 與 PR 之間共用相同的編號空間，因此單純的 `#42` 可能是任一者：請先以 `gh pr view 42` 解析，若失敗再退回使用 `gh issue view 42`。

## 當技能提示「發布至議題追蹤器」時

建立 GitHub issue。

## 當技能提示「擷取相關工單」時

執行 `gh issue view <number> --comments`。

## 路線導引（Wayfinding）操作

由 `/wayfinder` 使用。**地圖（map）**是單一 issue，**子（child）** issue 則作為工單。

- **地圖**：標記為 `wayfinder:map` 的單一 issue，包含 Notes / Decisions-so-far / Fog 內文。`gh issue create --label wayfinder:map`。
- **子工單**：作為 GitHub sub-issue 連結至地圖的 issue（在 sub-issues 端點使用 `gh api`）。在未啟用 sub-issues 的環境中，將子項目新增至地圖內文中的工作清單，並在子項目內文頂部加上 `Part of #<map>`。標籤：`wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）。一旦被認領，該工單將指派給負責推動的開發者。
- **阻擋（Blocking）**：GitHub 的**原生 issue 相依性**，也就是標準且 UI 可見的呈現方式。使用 `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>` 新增關聯邊，其中 `<blocker-db-id>` 是阻擋者的數值**資料庫 ID**（`gh api repos/<owner>/<repo>/issues/<n> --jq .id`，_不是_ `#number` 或 `node_id`）。GitHub 會回報 `issue_dependencies_summary.blocked_by`（僅限未結案的阻擋者，即即時防護門控）。在相依性不可用時，退回在子項目內文頂部加上 `Blocked by: #<n>, #<n>` 行。當所有阻擋者皆關閉時，工單即解除阻擋。
- **邊界查詢（Frontier query）**：列出地圖中未結案的子項目（`gh issue list --state open`，範圍限定於地圖的 sub-issues／工作清單），排除任何具有未結案阻擋者（`issue_dependencies_summary.blocked_by > 0` 或 `Blocked by` 行中有未結案的 issue）或已有指派者的項目；地圖順序在前者優先。
- **認領**：`gh issue edit <n> --add-assignee @me`，此為該工作階段的首次寫入。
- **解決**：`gh issue comment <n> --body "<answer>"`，然後執行 `gh issue close <n>`，接著在地圖的 Decisions-so-far 後面附加上下文指標（要點 + 連結）。
