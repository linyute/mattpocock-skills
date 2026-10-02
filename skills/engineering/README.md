# 工程 (Engineering)

我日常用於程式碼工作的技能。

## 使用者呼叫 (User-invoked)

僅在您輸入它們時可存取（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[ask-matt](./ask-matt/SKILL.md)**：詢問哪種技能或流程適合您的情況。此儲存庫中使用者呼叫技能的路由器。
- **[grill-with-docs](./grill-with-docs/SKILL.md)**：同時建構專案領域模型的盤問環節，精煉術語並內嵌更新 `GLOSSARY.md` 與 ADR。
- **[triage](./triage/SKILL.md)**：透過分流角色的狀態機推進 issue。
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)**：掃描程式碼庫以尋找深化機會，將其呈現為視覺化 HTML 報告，然後盤問您所挑選的任何一個項目。
- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)**：為工程技能設定此儲存庫（issue 追蹤器、分流標籤、領域文件配置）。每個儲存庫執行一次。
- **[to-spec](./to-spec/SKILL.md)**：將目前的對話轉換為規格並發布至 issue 追蹤器。
- **[to-tickets](./to-tickets/SKILL.md)**：將任何計劃、規格或對話拆解為一組曳光彈工單，各自宣告其阻礙邊緣，無論是作為本地檔案中的文字或真實追蹤器上的原生阻礙連結。
- **[implement](./implement/SKILL.md)**：建構規格或工單組所描述的工作，在預先協商好的接縫處推動 `/tdd`，並在提交前以 `/code-review` 收尾。
- **[implement-spec](./implement-spec/SKILL.md)**：在單一整合分支上實作完整規格。將工單作為任務圖處理，在就緒前沿執行實作者子代理以獲得最大並行度，然後以 `/code-review` 收尾。
- **[wayfinder](./wayfinder/SKILL.md)**：將大量工作（超過單一代理工作階段所能容納）規劃為 issue 追蹤器上的決策工單共享地圖，一次解決一個，直到通往目的地的道路清晰。
- **[retro](./retro/SKILL.md)**：在工作階段結束後建議對編碼代理環境（導覽、自動化檢查、編碼標準、引導檔案、工具鏈）的改進，依嚴重性由高至低排列。

## 模型呼叫 (Model-invoked)

模型或使用者可存取（豐富的觸發措辭以供模型存取）。

- **[prototype](./prototype/SKILL.md)**：建構一次性原型以回答設計問題：用於狀態／邏輯的單一可分享 HTML 檔案，或數個可切換的 UI 變體。

- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**：針對棘手錯誤與效能退化的紀律性診斷迴圈：建立在此錯誤上變紅的意見回饋迴圈 → 最小化 → 假設 → 檢測 → 修復 → 迴歸測試。
- **[research](./research/SKILL.md)**：對高信任度的原始來源調查問題，並將結果記錄為儲存庫中引用來源的 Markdown 檔案，作為背景代理執行。
- **[tdd](./tdd/SKILL.md)**：具備紅－綠－重構迴圈的測試驅動開發。一次建構一個垂直切片的功能或修復錯誤。
- **[domain-modeling](./domain-modeling/SKILL.md)**：透過質疑術語、使用情境進行壓力測試，並內嵌更新 `GLOSSARY.md` 與 ADR，積極建構並精煉專案的領域模型。
- **[codebase-design](./codebase-design/SKILL.md)**：設計深層模組的共享紀律與詞彙：小介面、乾淨接縫、可透過介面測試。
- **[code-review](./code-review/SKILL.md)**：針對固定時間點以來的 diff 進行雙軸檢視：**標準**（是否遵循儲存庫的編碼標準，加上 Fowler 異味基準線？）與**規格**（是否忠實實作原始 issue／規格？），作為平行子代理執行。
- **[pr](./pr/SKILL.md)**：Pull Request 內文應呈現的形式：以使變更清晰的最小視覺呈現為摘要、運作正常的變更前／變更後佐證，以及合併危險性判定（單向門或雙向門，加上影響範圍）。
- **[wizard](./wizard/SKILL.md)**：產生互動式 bash 精靈，引導人工完成僅能由人工執行的步驟：佈建基礎架構、設定憑證或 CI 密鑰、瀏覽陌生的第三方儀表板，或執行一次性遷移或移轉。
