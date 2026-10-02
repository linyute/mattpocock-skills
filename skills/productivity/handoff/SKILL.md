---
name: handoff
description: 'Compact the current conversation into a handoff document for another agent to pick up.'
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

撰寫一份交接文件以摘要目前的對話，讓全新的代理人能夠接續工作。儲存至使用者作業系統的暫存目錄——而非目前的工作區。

在文件中包含「建議的技能」章節，指明下一個代理人應該呼叫 Skill 工具取得哪些技能。

切勿重複其他產物（規格、計畫、ADR、issue、commit、diff）中已記錄的內容。改為透過路徑或 URL 引用它們。

遮蓋任何機密資訊，例如 API 金鑰、密碼或個人識別資訊。

若使用者傳遞了引數，請將其視為下一個工作階段將著重內容的描述，並據此量身定制文件。
