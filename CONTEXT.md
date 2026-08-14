# Matt Pocock 技能

一套由 Claude Code 載入的代理人技能（斜線命令與行為）集合。技能被組織到分類桶中，並由 `/setup-matt-pocock-skills` 所輸出的每個儲存庫設定來使用。

## 語言

**Issue 追蹤器**：
託管儲存庫 issue 的工具 — GitHub Issues、Linear、本機 `.scratch/` markdown 規範或類似工具。像 `to-tickets`、`to-spec` 及 `triage` 這類技能會讀取與寫入它。
_避免使用_：backlog 管理器、backlog 後端、issue 託管者

**Issue**：
**Issue 追蹤器**內部單一追蹤的工作單位 — 由 `to-tickets` 所產生的 bug、任務、規格或切片。
_避免使用_：ticket（僅在引用稱其為 ticket 的外部系統時使用，或是用於 **決策 ticket** — 參見下方）

**決策 ticket**：
一個 `wayfinder` 單位 — `wayfinder:map` 的子 **Issue**，持有一個*問題*，其解決方案是一個決策，而不是要執行的建構切片。**決策**修飾詞是使其與實作 ticket 區別開來的關鍵；`wayfinder` 引入了此術語，隨後使用 "ticket"。

**Triage 角色**：
在 triage 期間套用到 **Issue** 的規範狀態機標籤（例如 `needs-triage`、`ready-for-afk`）。每個角色透過 `docs/agents/triage-labels.md` 對應到 **Issue 追蹤器** 中的真實標籤字串。

## 關係

- 一個 **Issue 追蹤器** 包含許多 **Issue**
- 一個 **Issue** 一次攜帶一個 **Triage 角色**
- 一個 **決策 ticket** 是一個 **Issue**（`wayfinder:map` 的子項）

## 標記的歧義

- "backlog" 以前被用來同時表示託管 issue 的*工具*以及其中的*工作主體* — 已解決：該工具為 **Issue 追蹤器**；"backlog" 不再用作領域術語。
- "backlog 後端" / "backlog 管理器" — 已解決：合併為 **Issue 追蹤器**。
