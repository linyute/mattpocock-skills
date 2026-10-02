# Issue tracker: GitLab

本儲存庫的 Issue 與規格均作為 GitLab issue 存在。所有操作請使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## 慣例

- **建立 issue**：`glab issue create --title "..." --description "..."`。多行說明請使用 heredoc。傳入 `--description -` 可開啟編輯器。
- **讀取 issue**：`glab issue view <number> --comments`。使用 `-F json` 取得機器可讀的輸出。
- **列出 issue**：`glab issue list -F json` 搭配適當的 `--label` 篩選條件。
- **在 issue 發表留言**：`glab issue note <number> --message "..."`。GitLab 將留言稱為「notes」。
- **套用 / 移除標籤**：`glab issue update <number> --label "..."` / `--unlabel "..."`。多個標籤可以用逗號分隔，或是重複使用該旗標。
- **關閉**：`glab issue close <number>`。`glab issue close` 不接受關閉留言，因此請先以 `glab issue note <number> --message "..."` 發布說明，然後再關閉。
- **Merge request**：GitLab 將 PR 稱為「merge request」。使用 `glab mr create`、`glab mr view`、`glab mr note` 等，其形式與 `gh pr ...` 相同，只需將 `pr` 換成 `mr`，並將 `comment`/`--body` 換成 `note`/`--message`。

從 `git remote -v` 推斷儲存庫；在複製的儲存庫內執行時，`glab` 會自動完成此操作。

## 將 Merge request 作為分流介面

**將 MR 作為請求介面：否。** _（如果此儲存庫將外部 merge request 視為功能請求，請設為 `yes`；`/triage` 會讀取此旗標。）_

當設為 `yes` 時，MR 會透過 `glab mr` 等效指令經歷與 issue 相同的標籤與狀態：

- **讀取 MR**：`glab mr view <number> --comments` 以及使用 `glab mr diff <number>` 檢視差異。
- **列出待分流的外部 MR**：`glab mr list -F json`，然後僅保留作者非專案成員/擁有者的 MR（貢獻者的 MR，而非維護者進行中的工作）。
- **留言 / 標籤 / 關閉**：`glab mr note`、`glab mr update --label`/`--unlabel`、`glab mr close`。

與 GitHub 不同，GitLab 分開為 issue 與 MR 編號，因此一旦知道維護者所指的介面，`#42` 就不會有歧義。

## 當技能指出「發布至 issue tracker」時

建立 GitLab issue。

## 當技能指出「擷取相關 ticket」時

執行 `glab issue view <number> --comments`。

## 尋路操作

供 `/wayfinder` 使用。**地圖**是單一 issue，並以**子** issue 作為 ticket。

- **地圖**：標記為 `wayfinder:map` 的單一 issue，包含 Notes / Decisions-so-far / Fog 內文。`glab issue create --label wayfinder:map`。（在具備原生 epic 的 GitLab 方案中，地圖亦可存放於 epic 中；標記標籤的 issue 則適用於所有方案。）
- **子 ticket**：說明頂端帶有 `Part of #<map>` 且標籤為 `wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）的 issue。一旦認領，ticket 就會指派給主導的開發者。
- **阻礙（Blocking）**：GitLab 的**原生阻礙連結**，標準且在 UI 上可見的呈現方式。透過以 note 發布 `/blocked_by #<n>` 快速動作來新增（`glab issue note <child> --message "/blocked_by #<blocker>"`）。原生阻礙連結為 Premium/Ultimate 功能；在免費方案（或無法使用時），請退回在說明頂端使用 `Blocked by: #<n>, #<n>` 行。當每個阻礙者都已關閉時，ticket 即解除阻礙。
- **前沿查詢**：限定為地圖子項目的 `glab issue list -F json`，排除任何帶有未結阻礙者的項目：指向未結 issue 的原生 `blocked_by` 連結（`glab api projects/:id/issues/:iid/links`）、`Blocked by` 行中的未結 issue，或已有指派者；地圖順序在前者優先。
- **認領**：`glab issue update <n> --assignee @me`，這是該工作階段的首次寫入。
- **解決**：`glab issue note <n> --message "<answer>"`，然後 `glab issue close <n>`，接著在地圖的 Decisions-so-far 附加情境指標（摘要 + 連結）。
