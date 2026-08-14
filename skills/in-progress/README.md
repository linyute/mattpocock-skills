# 進行中（In Progress）

Beta 測試中。這些技能刻意公開 — 試用它們並告訴我什麼損壞了。在它們晉升至穩定貯列前，它們被排除在外掛程式與頂層 README 之外，它們沒有文件頁面，且可能會在沒有警告的情況下變更或消失。

外掛程式不會為您提供這些。直接安裝一個：

```bash
npx skills@latest add mattpocock/skills --skill=<name>
```

- **[loop-me](./loop-me/SKILL.md)** — 在多個會話中自我盤問成可實作的工作流程規格，使用當前目錄作為有狀態的工作區。由使用者呼叫。
- **[writing-beats](./writing-beats/SKILL.md)** — 將文章塑造為節奏之旅，採用「選擇你自己的冒險」風格。挑選一個起始節奏，僅撰寫該節奏，然後轉向下一個，直到文章達到自然終點。
- **[writing-fragments](./writing-fragments/SKILL.md)** — 挖掘您的片段 — 寫作的異質金塊 — 並將其附加至單一文件作為未來文章原料的盤問會話。
- **[writing-shape](./writing-shape/SKILL.md)** — 取得原料 Markdown 檔案並將其逐段塑造為文章，在每個步驟中爭論格式選擇。
- **[claude-handoff](./claude-handoff/SKILL.md)** — 將當前對話交接給全新的背景 Agent，該 Agent 會立即可接手工作，透過 `claude --bg` 種入交接摘要。由使用者呼叫。
- **[setup-ts-deep-modules](./setup-ts-deep-modules/SKILL.md)** — 將 dependency-cruiser 連線至 TypeScript 儲存庫，使每個套件成為深層模組 — 實作隱藏在子資料夾中，僅能透過其進入點檔案存取，測試透過這些檔案進行練習。由使用者呼叫。
