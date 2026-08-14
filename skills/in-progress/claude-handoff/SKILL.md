---
name: 'claude-handoff'
description: '將當前的對話交接給全新的背景 Agent，該 Agent 會立即接手工作。'
argument-hint: '下一個會話將用於什麼？'
disable-model-invocation: 'true'
---

撰寫當前對話的交接摘要，以便全新的 Agent 可以繼續工作。無需儲存它，而是啟動一個以摘要作為提示詞種入的背景 Agent：`claude --bg --name "<descriptive name>" "<handoff summary>"`。它在當前工作目錄中啟動並立即傳回；使用者透過 `claude agents` 管理它。

始終使用描述性名稱傳入 `-n`/`--name`（例如 `--name "Fix login bug"`）— 它會設定作業清單、會話選擇器與終端機標題中顯示的顯示名稱。

在摘要中包含「建議的技能」章節，用以建議 Agent 應該呼叫的技能。

不要重複其他產物（規格、計劃、ADR、議題、提交、差異）中已經擷取的內容。改為透過路徑或 URL 引用它們。

遮蔽任何敏感資訊，例如 API 密鑰、密碼或個人身份可識別資訊 — 因為摘要會成為 Agent 的提示詞。

如果使用者傳遞了引數，將其視為下一個會話將專注內容的描述，並相應調整摘要。
