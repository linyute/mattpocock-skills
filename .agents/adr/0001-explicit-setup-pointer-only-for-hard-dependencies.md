# 僅針對硬相依性提供顯式 `/setup-matt-pocock-skills` 指標

工程技能相依於由 `/setup-matt-pocock-skills` 植入的每個儲存庫設定（議題追蹤器、Triage 標籤詞彙、領域文件版面配置）。某些技能若沒有該設定就無法發揮實質作用 — 它們必須發布至特定的議題追蹤器或套用特定的標籤字串。其他技能則僅使用它來精煉輸出（詞彙、ADR 認知），且在沒有它的情況下能優雅降級。

我們將這些劃分為**硬相依性**和**軟相依性**技能：

- **硬相依性**（`to-tickets`、`to-spec`、`triage`）— 包含顯式的一行文字：_"… should have been provided to you — run `/setup-matt-pocock-skills` if not."_ 如果沒有對應關係，輸出會是錯誤的，而不僅僅是模糊的。
- **軟相依性**（`diagnose`、`tdd`、`improve-codebase-architecture`）— 僅在模糊的散文中參考「專案的領域詞彙表」和「您正在觸及領域中的 ADR」。如果文件不存在，技能仍然可以運作；輸出只是沒那麼精銳。

這種劃分保持了軟相依性技能的 Token 輕量化，並避免將設定指標盲目複製套用到不具關鍵作用的地方。
