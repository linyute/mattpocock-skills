---
"mattpocock-skills": patch
---

在 `code-review`、`diagnosing-bugs`、`grill-with-docs`、`grill-me`、`improve-codebase-architecture`、`tdd`、`to-spec`、`to-tickets`、`triage` 與 `wayfinder` 中，將跨技能呼叫標準化為明確的「呼叫 Skill 工具」指示，而非單純的 `/skill` 風格內文。

- 在內文中指定另一項技能名稱的技能（「執行 `/grilling` 技能」）無法可靠地觸發載入。這是 `grill-with-docs` 最常被回報的問題背後記錄的瑕疵。直接指名工具（`使用 "grilling" 呼叫 Skill 工具`）旨在提高命中率。去掉前導的 `/` 也使指示更具環境中立性：它不再假設使用 Claude Code 的觸發語法。
- 需要超過一項技能的步驟現在明確表示為多次呼叫（「呼叫 Skill 工具兩次，分別針對 `grilling` 與 `domain-modeling`」），而非一次包含兩個名稱的呼叫。
- 在 `.agents/invocation.md` 中記錄了該慣例，供未來的技能遵循。
