---
"mattpocock-skills": patch
---

停止讓技能嘗試透過 Skill 工具取用使用者呼叫的技能：修復在 `to-spec`、`wayfinder`、`to-tickets`、`triage`、`code-review` 與 `diagnosing-bugs` 中違反了 `.agents/invocation.md` 中「其他技能都無法呼叫它」不變性的跨技能引用。

- `to-spec`、`wayfinder`、`to-tickets`、`triage` 與 `code-review` 各自帶有一個先決條件（「…如果沒有，請執行 `/setup-matt-pocock-skills`」），PR #878 將其改寫為字面上的 `使用 "setup-matt-pocock-skills" 呼叫 Skill 工具` 指示。`setup-matt-pocock-skills` 是使用者呼叫的，因此這些技能（無論是使用者呼叫還是模型呼叫）都無法呼叫它。將這五個全部重新改寫為指示代理通知人員去執行。
- `diagnosing-bugs` 的第 6 階段事後檢討同樣以這種方式移交給 `improve-codebase-architecture`（也是使用者呼叫），這是在沒有人員介入以捕捉失敗呼叫的自主、通常無人看管的除錯流程中發生的。直接移除了移交環節而不是淡化它，因為它在實踐中極少觸發。第 6 階段現在僅為「清理」；機械性檢查清單保持不變。
- 在 `.agents/invocation.md` 的「它們之間的依賴關係」章節中新增了一個例外說明段落：`使用 "name" 呼叫 Skill 工具` 的慣例僅在指定的技能為模型呼叫時適用。這是 PR #878 引入的章節，當時未與該章節上方八行所述的使用者呼叫/模型呼叫不變性進行調和；這項缺漏正是該錯誤波及六個呼叫點而非僅僅一個的主要原因。

Fixes #453.
