---
name: 'setup-matt-pocock-skills'
description: '為工程技能設定此儲存庫：設定其議題追蹤器、分流標籤詞彙以及領域文件配置。在首次使用其他工程技能之前執行一次。'
disable-model-invocation: 'true'
---

# 設定 Matt Pocock 的技能

搭建工程技能所預期的每個儲存庫配置鷹架：

- **議題追蹤器（Issue tracker）**：議題存放之處（預設為 GitHub；開箱即可支援本機 markdown）
- **分流標籤（Triage labels）**：用於五個標準分流角色的字串
- **領域文件（Domain docs）**：`GLOSSARY.md` 與 ADR 的存放處，以及閱讀它們的使用者規則

這是一個提示導向的技能，而非確定性的指令稿。進行探索、展示您的發現、與使用者確認，然後寫入。

## 流程

### 1. 探索

檢視目前的儲存庫以了解其初始狀態。閱讀既有的任何內容；不要預設立場：

- `git remote -v` 與 `.git/config`：這是 GitHub 儲存庫嗎？是哪一個？
- 儲存庫根目錄下的 `AGENTS.md` 與 `CLAUDE.md`：兩者是否存在？其中是否已有 `## Agent skills` 區段？
- 儲存庫根目錄下的 `GLOSSARY.md` 與 `GLOSSARY-MAP.md`
- `docs/adr/` 與任何 `src/*/docs/adr/` 目錄
- `docs/agents/`：此技能先前的輸出是否已存在？
- `.scratch/`：表示已經在使用本機 markdown 議題追蹤器慣例的跡象
- 是否安裝了 `triage` 技能？（此資料夾旁的 `triage` 技能資料夾，或您可用技能中的 `triage`。）這決定了區段 B 是否執行。
- Monorepo 訊號：`pnpm-workspace.yaml`、`package.json` 中的 `workspaces` 欄位，或帶有自身 `src/` 的內容充實 `packages/*`。這些僅在真正龐大的多套件儲存庫中才會出現；缺少它們表示為單一上下文，這幾乎適用於所有儲存庫。

### 2. 展示發現並詢問

摘要說明存在與遺漏的內容。然後依序處理各區段。一個區段、一個答案，然後進行下一個。

每個區段均以建議答案開頭，讓使用者能以單字接受。僅在選項確實產生分歧時給予單行解釋；當探索階段已經決定時則完全略過該區段（未安裝 `triage` 時略過區段 B，非 monorepo 時略過區段 C）。

**區段 A：議題追蹤器。**

> 解釋：所謂「議題追蹤器」就是此儲存庫議題存放的地方。像 `to-tickets`、`triage` 和 `to-spec` 等技能會對其進行讀取與寫入。它們需要知道是呼叫 `gh issue create`、在 `.scratch/` 下寫入 markdown 檔案，還是遵循您描述的某個其他工作流程。請挑選您實際為此儲存庫追蹤工作的地方。

預設立場：這些技能是為 GitHub 設計的。若 `git remote` 指向 GitHub，請建議 GitHub。若 `git remote` 指向 GitLab（`gitlab.com` 或自我託管的主機），請建議 GitLab。否則（或若使用者偏好），提供：

- **GitHub**：議題存放在儲存庫的 GitHub Issues 中（使用 `gh` CLI）
- **GitLab**：議題存放在儲存庫的 GitLab Issues 中（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **本機 markdown**：議題作為檔案存放在此儲存庫的 `.scratch/<feature>/` 下（適合個人專案或沒有 remote 的儲存庫）
- **其他**（Jira、Linear 等）：請使用者用一個段落描述工作流程；該技能會將其記錄為自由格式文字

將選擇記錄在 `docs/agents/issue-tracker.md` 中。GitHub 與 GitLab 範本帶有「將 PR 作為請求介面」旗標，預設為**關閉**。保持關閉且不要主動提出：想要將外部 PR 納入分流佇列的使用者稍後可以在檔案中切換該旗標。

**區段 B：分流標籤詞彙。** 若未安裝 `triage` 技能，請完全略過此區段（探索已告訴您），因為未安裝的技能不需要標籤。

若已安裝，僅問一個問題：

> 您是否要保留預設的分流標籤？（建議：**是**）

預設為五個標準角色，每個標籤字串等於其名稱：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。選**是**時，按原樣寫入。唯有使用者回答否時（通常是因為其追蹤器已使用其他名稱，例如以 `bug:triage` 代替 `needs-triage`），才收集覆寫名稱，以便 `triage` 套用既有標籤而非建立重複項目。

**區段 C：領域文件。** 預設為**單一上下文**（儲存庫根目錄下單一 `GLOSSARY.md` + `docs/adr/`）。這適用於幾乎所有儲存庫；無需詢問即可寫入。

僅在探索時發現 monorepo 訊號時，才提供**多上下文**（指向各上下文 `GLOSSARY.md` 檔案的根目錄 `GLOSSARY-MAP.md`）。然後確認他們想要哪種配置。

### 3. 確認並編輯

向使用者展示以下內容的草案：

- 要新增至正在編輯的 `CLAUDE.md` / `AGENTS.md` 中的 `## Agent skills` 區塊（選取規則見步驟 4）
- `docs/agents/issue-tracker.md`、`docs/agents/domain.md` 與 `docs/agents/triage-labels.md` 的內容（後者僅在安裝 `triage` 時提供）

在寫入之前讓他們進行編輯。

### 4. 寫入

**選擇要編輯的檔案：**

- 若 `CLAUDE.md` 存在，編輯它。
- 否則若 `AGENTS.md` 存在，編輯它。
- 若兩者皆不存在，詢問使用者要建立哪一個；不要代為挑選。

當 `CLAUDE.md` 已存在時絕不要建立 `AGENTS.md`（反之亦然）；一律編輯既有的那個。

若所選檔案中已存在 `## Agent skills` 區塊，請就地更新其內容，而非附加重複項目。不要覆寫使用者對周圍區段的編輯。

該區塊：

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout: "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

僅在安裝了 `triage` 且執行了區段 B 時，才包含 `### Triage labels` 子區塊並寫入 `docs/agents/triage-labels.md`。未安裝時，兩者皆省略。

然後以本技能資料夾中的種子範本為起點寫入文件檔案：

- [issue-tracker-github.md](./issue-tracker-github.md)：GitHub 議題追蹤器
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md)：GitLab 議題追蹤器
- [issue-tracker-local.md](./issue-tracker-local.md)：本機 markdown 議題追蹤器
- [triage-labels.md](./triage-labels.md)：標籤對應（僅在安裝 `triage` 時）
- [domain.md](./domain.md)：領域文件使用者規則 + 配置

針對「其他」議題追蹤器，根據使用者的描述從頭撰寫 `docs/agents/issue-tracker.md`。

### 5. 完成

告知使用者設定已完成，以及哪些工程技能現在會從這些檔案中讀取。提醒他們稍後可以直接編輯 `docs/agents/*.md`；僅在他們想要切換議題追蹤器或從頭重新開始時才需要重新執行此技能。
