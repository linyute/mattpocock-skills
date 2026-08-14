# 生產力（Productivity）

一般性工作流程工具，非特定於程式碼。

## 由使用者呼叫

僅在您輸入它們時可存取（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[grill-me](./grill-me/SKILL.md)** — 就計劃或設計接受不懈的訪談，直到設計樹的每個分支都被解決。
- **[handoff](./handoff/SKILL.md)** — 將當前對話精簡為交接文件，使另一個 Agent 能繼續工作。
- **[teach](./teach/SKILL.md)** — 在多個會話中教授使用者一項新技能或概念，使用當前目錄作為有狀態的教學工作區。
- **[to-questionnaire](./to-questionnaire/SKILL.md)** — 將您無法獨自回答的決策轉換為針對唯一能回答者編寫的 Markdown 問卷 — 非同步填寫，或在開會時一同完成。
- **[wait-what](./wait-what/SKILL.md)** — 在訊息無法理解的瞬間觸發此功能。Agent 會使用您缺乏的上下文，以平實的英語，並使用您的 `CONTEXT.md` 詞彙重新進行推介。

## 由模型呼叫

模型或使用者皆可存取（豐富的觸發措辭，使模型能主動調用它們）。

- **[grilling](./grilling/SKILL.md)** — 就計劃、決策或想法對使用者進行不懈的訪談，直到設計樹的每個分支都被解決。
- **[writing-for-agents](./writing-for-agents/SKILL.md)** — 為 Agent 撰寫文件：技能、AGENTS.md/CLAUDE.md，以及 Agent 透過指標存取的任何文件。
