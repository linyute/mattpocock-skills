---
"mattpocock-skills": minor
---

將 **`retro`** 推廣至 **Engineering** 分桶，使其隨附於 Claude Code 外掛程式中，獲得文件頁面，並由 `ask-matt` 引導作為主要流程在 `code-review` 之後的最後一步。

`retro`（使用者呼叫）回顧寫程式會話，並針對代理的環境而非程式碼提出變更建議：導航指引、自動化檢查、程式碼規範、引導檔案、工具節約性、資訊存取。它首先對每個程式碼規範發現進行分類：機械性違規獲得確定性檢查（linter 規則、pre-commit hook 或 CI 工作），而 `CODING_STANDARDS.md` 則保留給真正的判斷性考量。完全沒有任何防護機制的儲存庫本身就是一項發現。
