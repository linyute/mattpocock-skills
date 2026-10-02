# Matt Pocock 技能

由 Claude Code 載入的一系列代理技能（斜線指令與行為）。技能被組織為多個分桶，並由 `/setup-matt-pocock-skills` 所產生的各儲存庫設定使用。

## 語言

**問題追蹤器（Issue tracker）**：
託管儲存庫問題（issues）的工具：GitHub Issues、Linear、本機 `.scratch/` markdown 慣例或類似工具。像 `to-tickets`、`to-spec` 與 `triage` 等技能會對其進行讀取與寫入。
_避免使用_：backlog manager、backlog backend、issue host

**問題（Issue）**：
**問題追蹤器**內單一追蹤的工作單位：由 `to-tickets` 產生的錯誤、任務、規格或切片。
_避免使用_：ticket（僅在引用將其稱為 ticket 的外部系統，或針對**決策工單**時使用，見下文）

**決策工單（Decision ticket）**：
一個 `wayfinder` 單位：`wayfinder:map` 的子**問題**，包含一個*問題*，其解決方案是一項決策，而非要執行的建構切片。**決策**限定詞是使其與實作工單區隔的關鍵；`wayfinder` 引入該術語，隨後使用「ticket」。

**分類角色（Triage role）**：
在分類（triage）期間套用至**問題**的標準狀態機標籤（例如 `needs-triage`、`ready-for-afk`）。每個角色透過 `docs/agents/triage-labels.md` 對應至**問題追蹤器**中的真實標籤字串。

## 關聯

- 一個**問題追蹤器**包含多個**問題**
- 一個**問題**一次帶有一個**分類角色**
- 一個**決策工單**是一個**問題**（`wayfinder:map` 的子項）

## 已標記的模糊之處

- 「backlog」先前曾用於同時指稱託管問題的*工具*與其內部的*工作主體*。已解決：該工具為**問題追蹤器**；「backlog」不再作為領域術語使用。
- 「backlog backend」/「backlog manager」。已解決：合併為**問題追蹤器**。
