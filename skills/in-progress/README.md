# 進行中

Beta。這些技能是故意公開的：試用它們並告訴我哪裡出問題。在它們晉升至穩定分類之前，不會被包含在外掛程式和頂層 README 中，也沒有說明文件頁面，且可能在沒有警告的情況下變更或消失。

外掛程式不會提供這些技能。直接安裝其中一個：

```bash
npx skills@latest add mattpocock/skills --skill=<name>
```

- **[loop-me](./loop-me/SKILL.md)**：透過多個階段對自己進行深度詢問，整理出可實作的工作流程規格，並使用目前目錄作為具狀態的工作區。由使用者呼叫。
- **[writing-beats](./writing-beats/SKILL.md)**：將文章形塑為節奏之旅，如同冒險解謎遊戲風格。挑選一個起始節奏，只撰寫該節奏，接著轉向下一節奏，直到文章自然結尾。
- **[writing-fragments](./writing-fragments/SKILL.md)**：深入提問的階段，從你身上挖掘片段（寫作的各類素材雛形）並附加至單一文件中，作為未來文章的原始素材。
- **[writing-shape](./writing-shape/SKILL.md)**：取得原始素材的 Markdown 檔案，並逐段將其形塑為一篇文章，在每一步討論格式選擇。
- **[claude-handoff](./claude-handoff/SKILL.md)**：將目前對話交接給全新的背景代理人以立即接手工作，並透過 `claude --bg` 提供交接摘要作為種子提示。由使用者呼叫。
- **[setup-ts-deep-modules](./setup-ts-deep-modules/SKILL.md)**：在 TypeScript 儲存庫中配置 dependency-cruiser，使每個套件都成為深層模組：實作隱藏於子資料夾中，僅能透過進入點檔案存取，並透過這些檔案進行測試。由使用者呼叫。
