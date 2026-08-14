# 工程

我每天用於程式碼工作的技能。

## 使用者呼叫

僅在您輸入時可存取（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[ask-matt](./ask-matt/SKILL.md)** — 詢問適合您情況的技能或流程。本儲存庫中使用者呼叫技能的路由器。
- **[grill-with-docs](./grill-with-docs/SKILL.md)** — 審問（Grilling）會話，同時建構專案的領域模型，精煉術語並內聯更新 `CONTEXT.md` 和 ADR。
- **[triage](./triage/SKILL.md)** — 透過分揀角色的狀態機來推動議題（issue）。
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — 掃描程式碼庫以尋求深化機會，將其呈現為視覺化 HTML 報告，然後對您選擇的任何一項進行深入審問。
- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)** — 為工程技能設定此儲存庫（議題追蹤器、分揀標籤、領域文件佈局）。每個儲存庫執行一次。
- **[to-spec](./to-spec/SKILL.md)** — 將目前的對話轉換為規格並發布至議題追蹤器。
- **[to-tickets](./to-tickets/SKILL.md)** — 將任何計劃、規格或對話分解為一組追光彈票券（tracer-bullet tickets），每張票券宣告其阻塞邊界 — 本地檔案中的文字，或真實追蹤器上的原生阻塞連結。
- **[implement](./implement/SKILL.md)** — 建構規格或一組票券所描述的工作，在預先約定的接縫處驅動 `/tdd`，並在提交前以 `/code-review` 結束。
- **[wayfinder](./wayfinder/SKILL.md)** — 規劃大量的工作 — 超出單一 Agent 會話所能容納的範圍 — 作為議題追蹤器上決策票券的共享地圖，一次解決一張，直到通往目的地的道路清晰為止。

## 模型呼叫

模型或使用者皆可存取（豐富的觸發詞短語，以便模型可以調用它們）。

- **[prototype](./prototype/SKILL.md)** — 建構一次性原型以回答設計問題：用於狀態/邏輯的單一可共享 HTML 檔案，或多個可切換的 UI 變體。

- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)** — 針對棘手 Bug 與效能退化的嚴謹診斷迴圈：建立在此 Bug 上變紅的回饋迴圈 → 最小化 → 提出假設 → 植入檢測 → 修復 → 退化測試。
- **[research](./research/SKILL.md)** — 針對高信任度的主要來源調查問題，並將結果記錄為儲存庫中引用來源的 Markdown 檔案，作為背景 Agent 執行。
- **[tdd](./tdd/SKILL.md)** — 具備紅-綠-重構迴圈的測試驅動開發。一次建構一個垂直切片的功能或修復 Bug。
- **[domain-modeling](./domain-modeling/SKILL.md)** — 主動建構與精煉專案的領域模型 — 質疑術語、使用情境進行壓力測試，內聯更新 `CONTEXT.md` 與 ADR。
- **[codebase-design](./codebase-design/SKILL.md)** — 設計深度模組的共享紀律與詞彙：小型介面、乾淨接縫、可透過介面進行測試。
- **[code-review](./code-review/SKILL.md)** — 自固定點以來差異的雙軸審查：**標準**（是否遵循儲存庫的程式碼撰寫標準，外加 Fowler 壞氣味基準線）與**規格**（是否忠實實作源頭議題/規格），作為平行子 Agent 執行。
- **[resolving-merge-conflicts](./resolving-merge-conflicts/SKILL.md)** — 逐塊處理解決進行中的 git merge 或 rebase 衝突，透過追溯至各方主要來源的意圖進行解決，然後完成操作 — 絕不 `--abort`。
- **[wizard](./wizard/SKILL.md)** — 產生互動式 bash 向導，引導人類完成只有他們才能執行的步驟：佈署基礎架構、設定憑證或 CI 密鑰、瀏覽不熟悉的第三方儀表板，或執行一次性遷移或切換。
