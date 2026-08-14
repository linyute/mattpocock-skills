## 功能說明

`to-spec` 將你剛進行的對話轉換為 **[spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格）**，並將其作為單一議題（issue）發布至你的議題追蹤器。

它不會對你進行訪談。當你使用它時，決策已經完成，因此它會綜合已知內容 — 來自討論串、來自程式碼庫、來自你的 `CONTEXT.md` 與 ADR — 而不是開啟新一輪提問。規格是已做出之決策的記錄，而不是做出新決策的地方。

## 何時使用

你透過輸入 `/to-spec` 來呼叫此技能 — [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會自行主動使用它。

當建構規模過大而無法在單一 agent [工作階段](https://www.aihero.dev/ai-coding-dictionary/session)中完成、且必須在跨多個工作階段拆分的情況下存活時使用它。這就是全部的觸發條件：

| 你所處的階段 | 執行的技能 |
| --- | --- |
| 你尚未做出任何決定 | 先使用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 已決定，且工作量適合單一 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（context 視窗） | [implement](https://aihero.dev/skills-implement) — 跳過規格 |
| 已決定，且工作量跨越多個工作階段 | `/to-spec`，隨後 [to-tickets](https://aihero.dev/skills-to-tickets) |
| [wayfinder](https://aihero.dev/skills-wayfinder) 地圖已清除完成 | `/to-spec #<map_issue>` |

## 先決條件

`to-spec` 將規格作為議題發布，因此 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 必須先為此儲存庫設定追蹤器與 triage 標籤詞彙。兩種型態皆可：像 GitHub 這樣的真實追蹤器，或 `.scratch/` 下的本機 markdown 檔案（開箱即用支援）。

## 規格是決策紀錄

規格的存在是因為 context 視窗會結束。你在 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（審問）時確定的內容 — 解決方案的形狀、你辯論過的抉擇、你刻意拒絕的內容 — 都存在於即將被清除的單一對話中。

因此它不驗證任何內容，也不決定任何內容。它以你專案自己的詞彙擷取已決定的內容，以便全新的工作階段可以接管工作而無需你重新解釋。規格所主張的任何你實際上從未說過的內容都是缺陷。

## 文章之前的接縫

在撰寫任何字詞之前，`to-spec` 會勾勒出該功能將進行測試的**接縫**，並與你進行核對。它偏好已經存在的接縫而非新的接縫，並盡可能採用最高層級的接縫 — 一項變更的理想接縫數量為一個。

這些同意的接縫隨後會傳遞。[tdd](https://aihero.dev/skills-tdd) 僅在預先同意的接縫處運作，且 [code-review](https://aihero.dev/skills-code-review) 會針對規格審查 diff，因此未經同意的接縫會顯示為審查發現。綁定是間接的 — 它貫穿本文件 — 這正是為什麼接縫對話在此處值得認真看待而不是延後至實作階段的原因。

## 常見問題

**`/to-prd` 去了哪裡？**
這就是本技能，在 v1.1 中重新命名。「Spec」現在是單一的主線術語，且舊的 `to-prd` 代稱已廢棄 — 請在新名稱下重新安裝。替代舊詞彙的組合是 *spec* 與 *tickets*：spec 是目的地與固定它的決策，[tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) 是到達目的地的執行步驟。如果你轉向，請刪除未完成的 tickets 並保留 spec。

**為什麼規格會獲得 `ready-for-agent` 標籤？我不想讓 agent 根據它進行實作。**
該標籤意味著「不需要進一步的 triage」— 文件足夠完整，可供 agent 進行工作。這是一個輸入指定，而不是工作單。但是如果你執行輪詢 `ready-for-agent` 的 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk)（離開鍵盤）agent，該區別對它們不可見，且它們會樂於嘗試在一輪執行中建構整個規格，而不是接管 ticket 切片。這是該技能上回報最多的粗糙邊角。在變更之前，請在你的 AFK agent 的 prompt 中明確排除父規格，或者在 `/to-tickets` 執行後移除該標籤。

**為什麼不直接從審問前往 `/to-tickets` 並跳過規格？**
通常你應該這麼做 — 規格僅在跨多工作階段的工作上才值得其步驟。其回報之處在於 tickets 是可丟棄的而規格不是：每個 ticket 大小適合單一全新的 context 視窗並被刪除或關閉，而規格保留為其背後推理留存的唯一地方。在單一工作階段變更上，這不會為你帶來任何好處，且你付出了額外綜合步驟的代價，其中 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）可能會偏離。請直接執行 審問 → `/implement`。

**我剛完成了一張 wayfinder 地圖。我該交給它什麼？**
主要地圖議題 — `/to-spec #<map_issue>`，而不是單個決策 ticket。[wayfinder](https://aihero.dev/skills-wayfinder) 產生散落在地圖各處的決策而非交付物；`to-spec` 是將它們摺疊為單一可建構文件的步驟。將地圖直接循環至 `/implement` 會丟失該摺疊效果。

**規格是用於供我審查，還是一旦供 agent 使用？**
主要是供 agent 使用，且讀起來也是如此 — 完整、密集、充滿參考。值得你關注的部分是接縫與超出範疇（out-of-scope）章節，因為這兩個地方是錯誤決策最容易捕捉、且在稍後發現時最代價高昂的地方。從頭到尾閱讀整份文件是人們真正的抱怨，且沒有摘要模式：坦白的解答是，如果規格讓你感到驚訝，說明審問過淺，而不是規格過長。

**一旦 tickets 開始，我是要凍結規格，還是讓 agent 重新撰寫它？**
沒有任何機制保持其同步，因此在實踐中它是你在該時刻所知內容的快照，且在實作第一次教會你某些內容時就會過期。一旦工作交付，請將其視為可丟棄。旨在存活得比它更久的產物是你的 `CONTEXT.md` 與 ADR — 如果在實作期間學到的某些內容值得留存，它屬於那裡，而不是編輯後的規格中。

**我的工作是重構或模組邊界，而不是功能。範本適合嗎？**
適合度較差，且這是一個已知局限。範本過度依賴使用者故事（user stories），這對於架構工作來說是錯誤的形狀 — 你最終會在圍繞實質上關乎介面與不變性的決策撰寫無人要求的故事。請改為依賴實作決策（implementation-decisions）與測試決策（testing-decisions）章節，並透過 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 將持久的架構決策落腳為 ADR，而不是嘗試讓規格去承載它們。

**它會檢查追蹤器以尋找相關工作，或引述其所遵循的 ADR 嗎？**
兩者都不會。它會讀取並遵循涵蓋其觸及領域的 ADR，但不會連結它們，且在起草前不會搜尋追蹤器以尋找重疊的議題 — 因此規格可能會靜默地重複某人已經提交的工作。如果該領域很忙碌，請先自己搜尋追蹤器。

**`/to-tickets` 無法讀取我的規格 — 它一直截斷。**
非常大的規格可能會超出議題追蹤器能乾淨回傳的範圍，且沒有本機複本可供退回。修復方法是 context 衛生：不要在 `/to-spec` 與 `/to-tickets` 之間進行 [clear](https://www.aihero.dev/ai-coding-dictionary/clearing) 或 [compact](https://www.aihero.dev/ai-coding-dictionary/compaction)。在同一個視窗中執行它們，這樣規格就完全不需要重新擷取。

## 運作正常的指標

- 它開始撰寫而不是向你提出新一輪問題。
- 它在撰寫前向你提出接縫，並盡可能少地提議接縫。
- 它以你專案的名詞返回，而不是通用的產品管理模板套話。
- 其中的每個決策都是你能記得做出的決策。沒有任何內容是為了填補章節而捏造的。
- 超出範疇（out-of-scope）章節包含真實的內容 — 你拒絕的事物通常是頁面上最有用的行。

## 適用位置

`to-spec` 是主要建構鏈結中的一個步驟，且僅位於其多工作階段分支上：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review
```

其上游鄰居是 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)（執行本技能僅進行記錄的決策）以及 [wayfinder](https://aihero.dev/skills-wayfinder)（其完成的地圖正好在此處合併至鏈結）。在下游，[to-tickets](https://aihero.dev/skills-to-tickets) 將規格切分為供 [implement](https://aihero.dev/skills-implement) 建構的曳光彈 tickets。當你不確定哪個技能或流程適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你進行路由。
