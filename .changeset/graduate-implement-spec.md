---
"mattpocock-skills": minor
---

將 **`implement-spec`** 推廣至 **Engineering** 分桶，使其隨附於 Claude Code 外掛程式中，獲得文件頁面，並由 `ask-matt` 引導作為依工單執行的 `implement` 的平行替代方案。

`implement-spec`（使用者呼叫）可在單次執行中實作完整規格。它將工單讀取為**任務圖**，在就緒的**前沿**（frontier）上於各自的 worktree 中執行實作者子代理，並將所有內容合入單一**整合分支**，最後以 `code-review` 收尾。在推廣之前：

- 目前的目標是整合分支，而非 PR。只有當問題追蹤器透過 PR 關閉工作或您主動要求時，且僅在第一次合併之後（沒有領先 main 之提交的分支無法開啟 PR）才會開啟 PR 草稿。在沒有 PR 的情況下，工單會按照追蹤器關閉工作的方式來解決。
- 它與相鄰技能一樣指向問題追蹤器，在未提供任何追蹤器時提示您執行 `/setup-matt-pocock-skills`，而不是預設靜默使用 `gh`。
- 每個實作者確認其 worktree 以整合分支為基礎，使用 `tdd` 建構其工單，並在回報完成之前將整合分支的頂端合併至其自身分支，因此每次合併都是快轉（fast-forward）。
