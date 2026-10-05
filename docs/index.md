# 真實工程師的 AI 技能

一個實用的 Skill 系統，專為想要使用 AI 卻不願放棄標準的工程師打造。安裝你想要的項目，然後輸入斜線指令。

![GitHub Repo stars](https://img.shields.io/github/stars/mattpocock/skills)

[![Live Skills.sh install count](https://www.skills.sh/b/mattpocock/skills)](https://www.skills.sh/mattpocock/skills)

---

## 安裝

### 安裝 Skill

挑選你使用的 Skill 與 Agent。安裝程式會將可編輯的檔案寫入你的專案中。

```bash
npx skills@latest add mattpocock/skills
```

使用 `npx skills update` 進行更新

[Skills.sh](https://www.skills.sh/mattpocock/skills)

### Claude Code

從官方市集安裝完整套件作為託管的唯讀外掛程式。

```bash
claude plugins install mattpocock-skills
```

自動更新

[外掛程式文件](https://code.claude.com/docs/en/plugins)

### 相容於任何 Agent

- Claude Code
- Cursor
- Codex
- Copilot
- 25 個 Skill

---

## Skill 清單

依據你何時需要使用它們進行分組。大多數人從主要流程開始。

### 01 開始使用

設定一次，隨後即可快速上手。

從 [/setup-matt-pocock-skills](./engineering/setup-matt-pocock-skills.md) 開始

- [/setup-matt-pocock-skills](./engineering/setup-matt-pocock-skills.md) `/setup-matt-pocock-skills` Skill 設定單一儲存庫，讓其他 Skill 了解其運作方式。
- [/ask-matt](./engineering/ask-matt.md) `/ask-matt` Skill 找出針對你目前情境應使用的 Skill。

### 02 主要流程

依序進行的「構想→交付」核心主幹。

從 [/grill-with-docs](./engineering/grill-with-docs.md) 開始

- [/grill-with-docs](./engineering/grill-with-docs.md) `/grill-with-docs` Skill 針對計畫接受深入審問訪談，並記錄決策。
- [/to-spec](./engineering/to-spec.md) `/to-spec` Skill 將達成共識的對話轉化為書面規格。
- [/to-tickets](./engineering/to-tickets.md) `/to-tickets` Skill 將規格拆解為 Agent 可以建構的小型 Ticket。
- [/implement](./engineering/implement.md) `/implement` Skill 採用測試驅動方式將完成的規格建構成程式碼。
- [/code-review](./engineering/code-review.md) `/code-review` Skill 根據你的標準與規格審查 diff。
- [/retro](./engineering/retro.md) `/retro` Skill 回顧工作階段，並建議程式碼庫的改進方向。

### 03 塑形

探索開放性問題並產生推動流程的決策／解答。

從 [/wayfinder](./engineering/wayfinder.md) 開始

- [/wayfinder](./engineering/wayfinder.md) `/wayfinder` Skill 將龐大的工作規劃為決策地圖，並逐一解決。
- [/prototype](./engineering/prototype.md) `/prototype` Skill 用隨後即可刪除的程式碼回答設計問題。
- [/research](./engineering/research.md) `/research` Skill 從原始來源閱讀並取得附有引用的解答。

### 04 工程

保持程式碼庫與 Issue 清單健康；為流程產生工作任務。

從 [/improve-codebase-architecture](./engineering/improve-codebase-architecture.md) 開始

- [/improve-codebase-architecture](./engineering/improve-codebase-architecture.md) `/improve-codebase-architecture` Skill 以視覺化報告找出值得重構的模組。
- [/diagnosing-bugs](./engineering/diagnosing-bugs.md) `/diagnosing-bugs` Skill 從失敗的重現步驟開始診斷棘手的 Bug。
- [/triage](./engineering/triage.md) `/triage` Skill 將原始 Issue 分類為可供認領的工作。
- [/wizard](./engineering/wizard.md) `/wizard` Skill 產生引導人工進行設定的指令稿。
- [/implement-spec](./engineering/implement-spec.md) `/implement-spec` Skill 一次建置完整規格，並透過平行子代理協作。

### 05 生產力技能

由你執行的非程式碼相關、面向人類的工作流程。

從 [/grill-me](./productivity/grill-me.md) 開始

- [/grill-me](./productivity/grill-me.md) `/grill-me` Skill 在承諾投入前先對構想取得共識。
- [/handoff](./productivity/handoff.md) `/handoff` Skill 記錄漫長的工作階段，讓另一個 Agent 可以繼續執行。
- [/to-questionnaire](./productivity/to-questionnaire.md) `/to-questionnaire` Skill 將開放性問題轉為供他人填寫的文件。
- [/teach](./productivity/teach.md) `/teach` Skill 透過多次層層遞進的階段學習某個主題。
- [/wait-what](./productivity/wait-what.md) `/wait-what` Skill 要求 Agent 用通俗簡明的語言再說一次。
- [/writing-for-agents](./productivity/writing-for-agents.md) `/writing-for-agents` Skill 如何撰寫供 Agent 閱讀的 Skill 與其他文件。

### 06 參考 Skill

供其他 Skill 呼叫或引用的可重複使用層。

從 [/codebase-design](./engineering/codebase-design.md) 開始

- [/pr](engineering/pr.md) `/pr` Skill Pull Request 內文應採用的格式。
- [/codebase-design](./engineering/codebase-design.md) `/codebase-design` Skill 設計深度模組的詞彙庫。
- [/domain-modeling](./engineering/domain-modeling.md) `/domain-modeling` Skill 淬鍊專案使用的詞彙並將其記錄下來。
- [/grilling](./productivity/grilling.md) `/grilling` Skill 其他 Skill 用來對計畫進行壓力測試的審問訪談。
- [/tdd](./engineering/tdd.md) `/tdd` Skill 紅燈-綠燈-重構循環的規則。

---

## 什麼是 Skill？

Skill 是交給程式碼編寫 Agent 的精簡明確指令，使其能像資深工程師一樣運作。安裝你想要的項目，輸入斜線指令，Agent 便會遵循你真正信任的流程。

### 問題所在

Agent 的表現取決於你給它的流程。若讓它自行猜測，它會寫出看似合理卻悄悄腐蝕程式碼庫的程式碼。

### 解決之道

一個 Skill 編碼了一項良好習慣（審問計畫、撰寫規格、審查 diff），因此 Agent 每次都會以相同方式執行它。

### 為何具有複利效應

Skill 會形成一條鏈。每個 Skill 的輸出都是下一個 Skill 的輸入，因此只要微調單一步驟，整個工作流程就會變得更好。

### 適用於你已在使用的任何 Agent

Skill 是純文字檔案，而非綁定特定平台的系統。

- Claude Code
- Cursor
- Codex
- Amp
- Copilot

---

[翻譯自 AI Hero](https://www.aihero.dev/skills)
