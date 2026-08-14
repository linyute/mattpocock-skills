---
name: 'setup-matt-pocock-skills'
description: '為工程技能設定此儲存庫 — 設定其議題追蹤器、分揀標籤詞彙以及領域文件佈局。在第一次使用其他工程技能之前執行一次。'
disable-model-invocation: 'true'
---

# 設定 Matt Pocock 的技能

腳手架工程技能所假設的每個儲存庫設定：

- **議題追蹤器（Issue tracker）** — 議題存在之處（預設為 GitHub；開箱即用支援本地 Markdown）
- **分揀標籤（Triage labels）** — 用於五個規範分揀角色的字串
- **領域文件（Domain docs）** — `CONTEXT.md` 與 ADR 存在之處，以及閱讀它們的使用者規則

這是一個提示詞驅動的技能，而不是確定性腳本。探索、展示您發現的內容、與使用者確認，然後寫入。

## 流程

### 1. 探索

查看當前儲存庫以理解其起始狀態。閱讀現有的任何內容；不要假設：

- `git remote -v` 與 `.git/config` — 這是 GitHub 儲存庫嗎？哪一個？
- 儲存庫根目錄下的 `AGENTS.md` 與 `CLAUDE.md` — 兩者是否存在？兩者中是否已經存在 `## Agent skills` 章節？
- 儲存庫根目錄下的 `CONTEXT.md` 與 `CONTEXT-MAP.md`
- `docs/adr/` 與任何 `src/*/docs/adr/` 目錄
- `docs/agents/` — 此技能之前的輸出是否已經存在？
- `.scratch/` — 代表本地 Markdown 議題追蹤器慣例已經在使用的跡象
- 是否已安裝 `triage` 技能？（與此技能並列的 `triage` 技能資料夾，或可用技能中的 `triage`。）這決定了 B 章節是否執行。
- Monorepo 跡象 — `pnpm-workspace.yaml`、`package.json` 中的 `workspaces` 欄位，或者擁有自身 `src/` 的填充 `packages/*`。僅存在於真正龐大的多套件儲存庫中；缺乏這些跡象代表單一上下文，幾乎所有儲存庫都是如此。

### 2. 呈現發現並詢問

摘要存在與缺失的內容。然後按順序處理各個章節 — 一個章節、一個回答，然後進行下一個。

在每個章節前給出建議的回答，以便使用者可以用一個詞接受它。僅在選擇確實分岔時才給出單行解釋；當探索已確定答案時則完全跳過該章節（當未安裝 `triage` 時跳過 B 章節，當沒有 monorepo 時跳過 C 章節）。

**A 章節 — 議題追蹤器。**

> 解釋：[議題追蹤器] 是此儲存庫議題存在的地方。像 `to-tickets`、`triage` 和 `to-spec` 這類技能會從中讀取並寫入 — 它們需要知道是呼叫 `gh issue create`、在 `.scratch/` 下撰寫 Markdown 檔案，還是遵循您描述的其他工作流程。選擇您為此儲存庫實際追蹤工作的地方。

預設姿態：這些技能是專為 GitHub 設計的。如果 `git remote` 指向 GitHub，請建議使用它。如果 `git remote` 指向 GitLab（`gitlab.com` 或自建主機），請建議 GitLab。否則（或如果使用者偏好），請提供：

- **GitHub** — 議題存在於儲存庫的 GitHub Issues 中（使用 `gh` CLI）
- **GitLab** — 議題存在於儲存庫的 GitLab Issues 中（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **本地 Markdown** — 議題作為檔案存在於此儲存庫的 `.scratch/<feature>/` 底下（適合個人專案或沒有遠端庫的儲存庫）
- **其他**（Jira、Linear 等）— 請使用者用一個段落描述工作流程；該技能將其記錄為自由形式的散文

將選擇記錄在 `docs/agents/issue-tracker.md` 中。GitHub 與 GitLab 範本帶有「將 PR 作為請求表面」的旗標，預設為**關閉** — 保持關閉且不要提出；希望在分揀佇列中加入外部 PR 的使用者稍後可以在檔案中翻轉該旗標。

**B 章節 — 分揀標籤詞彙。** 如果未安裝 `triage` 技能（探索已告知您），請完全跳過此章節 — 未安裝的技能不需要標籤。

如果已安裝，請恰好提出一個問題：

> 您想保留預設的分揀標籤嗎？（建議：**是**）

預設為五個規範角色，每個標籤字串等於其名稱：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。選 **是** 時按原樣寫入。僅當使用者回答「否」時 — 通常是因為他們的追蹤器已經使用其他名稱（例如以 `bug:triage` 替代 `needs-triage`）— 收集覆寫，以便 `triage` 套用現有標籤而不是建立重複項目。

**C 章節 — 領域文件。** 預設為**單一上下文** — 在儲存庫根目錄放一個 `CONTEXT.md` + `docs/adr/`。這適合幾乎每個儲存庫；不經詢問直接寫入。

僅當探索發現 Monorepo 跡象時才提供**多個上下文** — 指向各個上下文 `CONTEXT.md` 檔案的根目錄 `CONTEXT-MAP.md`。然後確認他們想要哪種佈局。

### 3. 確認與編輯

向使用者展示草稿：

- 要新增至正在編輯的 `CLAUDE.md` / `AGENTS.md` 的 `## Agent skills` 區塊（選擇規則參見步驟 4）
- `docs/agents/issue-tracker.md`、`docs/agents/domain.md` 與 `docs/agents/triage-labels.md` 的內容（僅當安裝了 `triage` 時才包含最後一個）

在寫入前讓他們編輯。

### 4. 寫入

**選擇要編輯的檔案：**

- 如果 `CLAUDE.md` 存在，編輯它。
- 否則如果 `AGENTS.md` 存在，編輯它。
- 如果兩者皆不存在，詢問使用者建立哪一個 — 不要幫他們選擇。

當 `CLAUDE.md` 已經存在時，絕不要建立 `AGENTS.md`（反之亦然）— 始終編輯已經存在的那個。

如果選定的檔案中已經存在 `## Agent skills` 區塊，請就地更新其內容，而不是附加重複項目。不要覆寫使用者對周圍章節進行的編輯。

該區塊：

```markdown
## Agent skills

### Issue tracker

[追蹤議題位置的單行摘要]。參見 `docs/agents/issue-tracker.md`。

### Triage labels

[標籤詞彙的單行摘要]。參見 `docs/agents/triage-labels.md`。

### Domain docs

[佈局的單行摘要 — 「單一上下文」或「多個上下文」]。參見 `docs/agents/domain.md`。
```

僅當安裝了 `triage` 且執行了 B 章節時，才包含 `### Triage labels` 子區塊並寫入 `docs/agents/triage-labels.md`。當未安裝時，兩者皆省略。

然後使用此技能資料夾中的種子範本作為起始點寫入文件檔案：

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub 議題追蹤器
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — GitLab 議題追蹤器
- [issue-tracker-local.md](./issue-tracker-local.md) — 本地 Markdown 議題追蹤器
- [triage-labels.md](./triage-labels.md) — 標籤對映（僅當安裝了 `triage` 時）
- [domain.md](./domain.md) — 領域文件使用者規則 + 佈局

對於「其他」議題追蹤器，使用使用者的描述從頭撰寫 `docs/agents/issue-tracker.md`。

### 5. 完成

告知使用者設定已完成，以及哪些工程技能現在將從這些檔案讀取。提及他們稍後可以直接編輯 `docs/agents/*.md` — 僅當他們想切換議題追蹤器或從頭重新開始時才需要重新執行此技能。
