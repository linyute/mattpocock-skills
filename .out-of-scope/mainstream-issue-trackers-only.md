# Issue tracker 整合僅限於主流工具

`setup-matt-pocock-skills` 僅針對 **主流** issue tracker 提供一等支援。針對小眾、新創或單一廠商實驗性 tracker 新增支援的請求均屬於範圍之外。

## 為何這屬於範圍之外

每個 issue-tracker 後端都會在 skill 中寫死 CLI 的型態（命令、旗標、輸出剖析）。每個新後端都是永久的維護負擔 —— 當工具的 CLI 演進時必須保持運作，且必須持續對 `/to-spec`、`/to-tickets`、`/triage` 及相關功能進行測試。該成本僅值得為有相當比例使用者實際使用的 tracker 付出。

「主流」是主觀判斷，非數字標準：

- GitHub、GitLab 與 Backlog.md 是我們認為屬於主流的工具類型 —— 廣為人知、使用廣泛，遠超越實驗階段。
- 擁有數百個 GitHub star 的全新 agent 導向工具則不屬於主流，無論其設計多麼有趣。

Star 數、推出時間與下載量在做出判斷時是實用的訊號，但皆非硬性規則。規則是：一般工程師是否能認出此工具，並合理地為其團隊選擇了它？

針對非主流 tracker 的彈性機制已經存在：

- 輕量級 repo 內追蹤使用 `local markdown`。
- 想自行串接的使用者使用 `other/custom`。

兩者皆不需要核心 skill 了解該特定工具。

## 先前的請求

- #99 — "Add dex as an issue tracker backend"（提出請求時 dex 約推出 3 個月且約有 300 個 star）
