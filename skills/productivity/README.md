# 生產力

一般工作流程工具，非特定於程式碼。

## 使用者呼叫

僅在您鍵入它們時方可呼叫（Claude Code: `disable-model-invocation: true`；Codex: `agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[grill-me](./grill-me/SKILL.md)**: 針對計畫或設計接受無情的深度訪談，直到設計樹的每個分支都獲得解決。
- **[handoff](./handoff/SKILL.md)**: 將目前的對話精簡為交接文件，以便另一個代理人能接續工作。
- **[teach](./teach/SKILL.md)**: 在多個工作階段中向使用者傳授新技能或概念，將目前目錄作為具備狀態的教學工作區。
- **[to-questionnaire](./to-questionnaire/SKILL.md)**: 將您無法獨自回答的決策轉化為 Markdown 問卷，供唯一能夠回答的人填寫（非同步填寫，或在會議中共同填寫）。
- **[wait-what](./wait-what/SKILL.md)**: 在訊息未能被理解的當下立即觸發。代理人會使用您的 `GLOSSARY.md` 詞彙，以淺顯易懂的文字重新闡述您所遺漏的背景資訊。

## 模型呼叫

模型或使用者皆可呼叫（具備豐富的觸發詞表述，以便模型主動使用它們）。

- **[grilling](./grilling/SKILL.md)**: 針對計畫、決策或想法無情地對使用者進行深度訪談，直到設計樹的每個分支都獲得解決。
- **[writing-for-agents](./writing-for-agents/SKILL.md)**: 為代理人撰寫文件：技能、AGENTS.md/CLAUDE.md，以及任何代理人透過指標讀取的文件。
