## 功能說明

`grill-with-docs` 就計畫或設計對你進行訪談，直到你與 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 對其達成共同理解為止，並在此過程中將詞彙與艱難決策寫入你的儲存庫。它與 [grill-me](https://aihero.dev/skills-grill-me) 執行的訪談相同 — 一輪問題，然後等待，接著下一輪 — 針對程式碼庫進行。

它是**[有狀態的（stateful）](https://www.aihero.dev/ai-coding-dictionary/stateful)**。其他每一個審問技能都將[工作階段](https://www.aihero.dev/ai-coding-dictionary/session)留在你的腦海中；本技能則將檔案留在磁碟上。術語確定解決的瞬間就會落入 `CONTEXT.md` 中，而不是在最後批量處理。決策通過三道閘門後會作為 ADR 留下。這就是全部的差別，且這也是人們使用該技能遇到大多數問題的根源：產物是真實儲存庫中的真實檔案，因此當你預期它們存在時它們可能會缺失，當有多個人撰寫它們時它們可能會發生偏離。

## 何時使用

你透過輸入 `/grill-with-docs` 來呼叫此技能 — agent 不會自行主動使用它。

在儲存庫進行變更的初期使用它，此時計畫仍模糊且該事物的詞彙尚未確定。它是單一工作階段工具。你需要哪一個審問技能取決於你面前的情況：

| 你擁有的狀況 | 使用技能 |
| --- | --- |
| 你完全沒有在工作目錄中工作 | [grill-me](https://aihero.dev/skills-grill-me) |
| 一個儲存庫，以及你可以在單一工作階段中決定的變更 | `grill-with-docs` |
| 規模太大而無法在單一工作階段中容納的工作 — 全新專案（greenfield）建構、大型功能 | [wayfinder](https://aihero.dev/skills-wayfinder) |
| 完全沒有領域文件的儲存庫，且心中沒有特定功能 | `grill-with-docs`，針對儲存庫而非單一變更 |
| 決策受阻於其他人腦海中的知識 | [to-questionnaire](https://aihero.dev/skills-to-questionnaire) |

與 wayfinder 的分水嶺在於工作階段數量：`/grill-with-docs` 用於單一工作階段規劃，`/wayfinder` 用於多工作階段規劃。

## 先決條件

本技能會寫入你的儲存庫，因此你需要位於可以安全寫入的位置。確定解決的術語會進入根目錄的 `CONTEXT.md` 術語表中 — 或者如果根目錄的 `CONTEXT-MAP.md` 將儲存庫標記為多 context，則進入相關 context 的 `CONTEXT.md`。決策會進入 `docs/adr/`。兩者都是延遲建立的；在第一個術語或決策明確化之前不會存在任何東西，因此不需要預先建置結構。

它還需要存在另外兩個技能，因為它自己的 `SKILL.md` 只有一行委派給它們的內容：[grilling](https://aihero.dev/skills-grilling) 提供訪談，[domain-modeling](https://aihero.dev/skills-domain-modeling) 提供寫入。單獨安裝 `grill-with-docs` 會得到一個無法運作的技能。

## 書面紀錄（Paper trail）

一個工作階段會產生三樣東西，且它們並不平等。

| 產生的內容 | 落腳處 |
| --- | --- |
| 術語 — 專案對某事物的專用詞彙 | `CONTEXT.md`，內聯，確定解決的瞬間 |
| 難以逆轉、缺乏 context 時令人驚訝且屬於真實權衡的決策 | `docs/adr/` 下的 ADR |
| 你做出的其他所有決策 | 對話紀錄中，沒有其他地方 |

第三列是讓人出乎意料的一列。`CONTEXT.md` 是一份術語表，且刻意保持為術語表 — 沒有實作細節、沒有 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格）、沒有草稿筆記。ADR 同時受制於所有三個條件，因此大多數決策都不符合資格，且大多數工作階段都不會產生 ADR。產生更精準術語表且零 ADR 的工作階段是按照設計運作的，但這意味著你所同意的大部分內容僅存在於你達成一致的 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（context 視窗）中。將同一個對話交給 [to-spec](https://aihero.dev/skills-to-spec) 而不是 [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing)（清除）它。

術語表才是重點。領域語言是本技能實際上在建構的東西 — 專案本身的詞彙，一次性達成一致，這樣你、agent 與你的同事就不用再花代價重新推導它們。值得說明的是，並非每個人都認同這能提升 agent 效能：最犀利的公開質疑是，術語及其純英文擴展從 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）獲得了相同的結果，而該詞彙實際上壓縮了共享它的人類之間的溝通。這種解讀仍然讓術語表保持價值；它只是轉移了價值的所在。

## 假設只有單一撰寫者

有狀態的輸出假設由單人進行策劃。一個雙人開發團隊在單一儲存庫中執行四個月，回報抽樣合併的 PR 中約有 20% 出現狀態偏離，其中 ADR 引述與 README 主張是偏離程度最高的表面 — 刻意的人類策劃文件比 agent 記憶發生的偏離更嚴重。修剪過期的文件無法持久；幾天內同一批清理的檔案再次變得過期。有效的方法是徹底刪除影子狀態（shadow state），並在 CI 中新增確定性的引述與連結 linter。

相關情況：在單一儲存庫中跨不相關的變更重複執行該技能往往會累積混合主題的文件，因為沒有任何東西可以將一個工作階段的輸出與另一個工作階段的輸出區分開來。這兩者目前都沒有在技能中得到修復。

## 常見問題

**我應該使用本技能還是 `/wayfinder`？**
由範疇決定。對於可以在單一工作階段中決定的任何事項，使用本技能；當工作量太大而無法在單一工作階段中容納時，使用 [wayfinder](https://aihero.dev/skills-wayfinder)，它會先將工作繪製為決策 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) 地圖。Wayfinder 更慢且更密集，在範疇明確的功能上使用它是常見的錯誤。它不會取代本技能 — 對於適合單一工作階段的地圖部分，它可以切換進入審問工作階段。

**它執行了，但沒有出現 `CONTEXT.md` 與 ADR。**
有兩個已知原因。平凡的原因：沒有內容符合資格。ADR 需要滿足所有三個閘門，而關於沒有新詞彙之變更的工作階段確實沒有內容可寫。真實的錯誤：當該技能在另一個協同運作層（編排層）內部執行時 — 規格驅動開發的封裝、多 agent 架構、將其作為其他人管道中一個步驟進行呼叫的規則 — 據回報，檔案寫入的後半部分在靜默中未發生，而訪談仍在執行。此問題已記錄但未修復。如果你處於該設定中，在信任工作階段的輸出之前，請先檢查工作目錄。

**它一次性詢問了所有問題，沒有任何建議，且從未提及 `CONTEXT.md`。**
那是技能未能載入其兩個依賴項。因為 `SKILL.md` 是單行委派，沒有獲取 [grilling](https://aihero.dev/skills-grilling) 與 [domain-modeling](https://aihero.dev/skills-domain-modeling) 的 agent 會去猜測審問意味著什麼，從而導致你收到無區別的問題傾印。部分載入是更令人困惑的情況 — `grilling` 載入而 `domain-modeling` 未載入，你獲得了良好的訪談卻沒有書面紀錄。這與模型與 [effort](https://www.aihero.dev/ai-coding-dictionary/effort)（努力程度）層級相關，且這是該技能被回報最多的問題。如果你懷疑發生了這種情況，請直接詢問 agent 它載入了哪些技能。

**我的其他所有決策都去了哪裡？**
僅在對話紀錄中。這是對該技能最實質的開放抱怨：術語表不是規格，大多數答案都不值得產生 ADR，且沒有分類帳將每個確定解決的答案連接至規格、ticket 與測試。精準的答案（順序保證、否定需求、數字預設值）在下游被軟化為較弱的散文，其結果看起來完整，卻遺漏了你實際決定的事項。目前可用的緩解措施是保留工作階段並將其直接提供給 [to-spec](https://aihero.dev/skills-to-spec)，並針對你自己的答案重新閱讀規格，而不是假設規格已捕捉到它們。

**我可以將它指向完全沒有檔案的既存儲存庫嗎？**
可以。對於沒有 ADR、沒有領域語言且沒有設計原則的程式碼庫，這是正確的技能 — 呼叫它並說明「協助我記錄我的儲存庫（help me document my repo）」。社群模式將其與 [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 搭配使用，以建立或修復 `CONTEXT.md`。預期需要進行引導：它會閱讀程式碼並向你詢問其發現的內容，而你才是說明程式碼庫中現有詞彙哪些才是正確的那個人。

**當工作階段結束時我該做什麼？**
該技能的結尾訊息往往是開放式的，這是一個已知的粗糙邊角。在主要流程中，解答是在同一個對話中使用 [to-spec](https://aihero.dev/skills-to-spec)。如果變更小到可以立即建構，請改為直接前往 [implement](https://aihero.dev/skills-implement)。

**為什麼它叫這個名字？**
沒有人對這個名稱感到滿意。有一個開放的建議將其重新命名為 `grill-domain-model`，這能更真誠地描述其行為。目前該建議尚無進展。如果重新命名最終落地，文件頁面將隨之移動，且 URL 也會變更。

## 運作正常的指標

- `CONTEXT.md` 在工作階段**期間**逐個術語發生變更，而不是在最後一次性大量出現。
- 術語表讀起來是純粹的詞彙 — 具有嚴格定義的專案詞彙 — 且不包含實作細節或類似規格的散文。
- 程式碼庫可以回答的問題會透過閱讀程式碼庫來回答，而不是向你詢問。
- 你獲得很少或完全沒有 ADR，且你獲得的 ADR 是如果你不得不重新爭論會感到惱火的決策。
- 它會質疑你使用的詞彙，因為你現有的術語表對其進行了不同的定義。

## 適用位置

`grill-with-docs` 是主要建構鏈結的起點：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review
```

它位於任何內容被寫下作為規格之前 — 它產生了共同理解與確定的詞彙，隨後 [to-spec](https://aihero.dev/skills-to-spec) 會對其進行綜合而無需再次對你進行訪談。它最接近的鄰居是 [grill-me](https://aihero.dev/skills-grill-me)（沒有儲存庫與檔案的相同訪談），以及 [domain-modeling](https://aihero.dev/skills-domain-modeling)（它所驅動的術語表與 ADR 規範）；兩者都立足於 [grilling](https://aihero.dev/skills-grilling) 原生概念。在它的上游，[wayfinder](https://aihero.dev/skills-wayfinder) 會繪製對於單一工作階段而言過大的工作，並可將地圖的一部分交還給它。當你不確定適合哪個技能或流程時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你進行路由。
