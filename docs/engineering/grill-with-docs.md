## 功能說明

`grill-with-docs` 針對計畫或設計對你進行訪談盤問，直到你與 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 達成共同理解，並在此過程中將詞彙與關鍵決策寫入你的儲存庫。它與 [grill-me](https://aihero.dev/skills-grill-me) 執行的訪談相同（一輪提問，隨後等待，接著下一輪），只不過是針對程式碼庫進行。

它是**[具狀態性（stateful）](https://www.aihero.dev/ai-coding-dictionary/stateful)**的。所有其他盤問技能都會將 [session](https://www.aihero.dev/ai-coding-dictionary/session) 留在你的腦海中；而本技能則會在磁碟上留下檔案。一個術語敲定後，在敲定的當下就會寫入 `GLOSSARY.md`，而不是在最後一口氣批次處理。一個決策通過了三道關卡，就會作為 ADR 落地。這就是兩者的全部差別，也是多數人使用本技能遇到問題的根源：產物是真實儲存庫中的真實檔案，因此在你預期它們存在時可能會缺席，且當有多人同時寫入時可能會產生偏差。

## 何時使用

你可以透過輸入 `/grill-with-docs` 來呼叫它；agent 不會主動使用它。

在儲存庫中準備開始變更、計畫仍不明確且事物的用詞尚未敲定時使用它。它是單一 session 的工具。你該選用哪種盤問技能取決於眼前的情況：

| 眼前的情況 | 建議使用的技能 |
| --- | --- |
| 你根本沒有在任何工作目錄中進行作業 | [grill-me](https://aihero.dev/skills-grill-me) |
| 有儲存庫，且可以在單一 session 內敲定的變更 | `grill-with-docs` |
| 工作量龐大到單一 session 無法涵蓋（全新專案建構、大型功能） | [wayfinder](https://aihero.dev/skills-wayfinder) |
| 完全沒有領域文件的儲存庫，且心目中沒有特定功能 | `grill-with-docs`，針對儲存庫本身而非特定變更 |
| 決策因卡在別人的知識盲區中而受阻 | [to-questionnaire](https://aihero.dev/skills-to-questionnaire) |

與 wayfinder 的分界在於 session 數量：`/grill-with-docs` 用於單一 session 的規劃，`/wayfinder` 用於多 session 的規劃。

## 先決條件

該技能會寫入你的儲存庫，因此你需要處於允許安全寫入的環境。敲定的術語會寫入根目錄的 `GLOSSARY.md` 詞彙表，若根目錄有 `GLOSSARY-MAP.md` 標記為多 context 儲存庫，則寫入相關 context 的 `GLOSSARY.md`。決策會寫入 `docs/adr/`。兩者皆以延遲載入方式建立；在第一個術語或決策明確成形之前不會有任何檔案存在，因此事前無需搭建任何鷹架。

它還需要另外兩項技能存在，因為它自有的 `SKILL.md` 僅有委派給它們的一行指令：[grilling](https://aihero.dev/skills-grilling) 提供訪談機制，[domain-modeling](https://aihero.dev/skills-domain-modeling) 提供寫入機制。單獨安裝 `grill-with-docs` 會得到一個無法運作的技能。

## 書面記錄追蹤

一次 session 會產出三樣事物，且它們的地位並不均等。

| 敲定的內容 | 存放位置 |
| --- | --- |
| 術語：專案為某事物制定的專屬字詞 | `GLOSSARY.md`，行內即時寫入，在敲定的那一刻 |
| 難以逆轉、缺乏背景時令人意外、且具實質權衡取捨的決策 | 位於 `docs/adr/` 下的 ADR |
| 你決定的其餘一切事項 | 對話中，除此無他 |

第三行正是常讓人意想不到的地方。`GLOSSARY.md` 是一份詞彙表，且刻意維持其純粹性：沒有實作細節、沒有 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)、沒有草稿筆記。ADRs 同時受限於全部三項條件，因此多數決策都不符合資格，大多數 session 也不會產生任何 ADR。一個產出更銳利詞彙表且零 ADR 的 session 是符合設計預期的，但這代表你們達成一致的大部分內容僅存在於達成一致時的 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) 中。請將該對話交由 [to-spec](https://aihero.dev/skills-to-spec) 處理，而不要直接執行 [clear](https://www.aihero.dev/ai-coding-dictionary/clearing)。

詞彙表才是重點所在。領域語言是此技能真正建構的核心：專案自有的字詞，經一次敲定後，你、agent 與你的同事就不必再付出成本反覆推導。值得一提的是，並非所有人都認同這能換來 agent 效能的提升：最強烈的公開質疑認為，某個術語與其純英文展開說明在[模型](https://www.aihero.dev/ai-coding-dictionary/model)中獲得的結果完全相同，該詞彙真正壓縮的是具備共識的人類之間的溝通。這種觀點依然肯定詞彙表的價值，只是將價值的重心轉移了。

## 常見問題

**我應該使用本技能還是 `/wayfinder`？**
範圍決定一切。任何可在單一 session 內敲定的事項皆可使用本技能；當工作量過大而無法在單一 session 內涵蓋時，請使用 [wayfinder](https://aihero.dev/skills-wayfinder)，它會先將工作繪製為決策 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) 地圖。Wayfinder 速度較慢且更緊密，在範圍明確的功能上調用它是常見的錯誤。它不會取代本技能：它可以針對地圖中合適的部分切換進入盤問 session。

**它執行了，但沒有出現 `GLOSSARY.md` 也沒有 ADRs。**
有兩個已知原因。平凡的原因：沒有內容符合資格。ADR 需要滿足全部三道門檻，而針對沒有新詞彙的變更所進行的 session 確實沒有內容可寫。真正的錯誤：當該技能在另一個編排層（規格驅動開發包裝器、多 agent 架構、將其作為他人管線步驟呼叫的規則）內部執行時，回報指出寫入檔案的部分會靜默失效，而訪談卻仍繼續進行。此問題已被登記且尚未修復。若你處於此類設定中，在信任 session 的產出之前，請先檢查工作目錄。

**它一口氣問了所有問題，沒有給出建議，也從未提及 `GLOSSARY.md`。**
這是該技能未能成功載入其兩個相依技能所致。因為 `SKILL.md` 是單行的委派指示，未能取得 [grilling](https://aihero.dev/skills-grilling) 與 [domain-modeling](https://aihero.dev/skills-domain-modeling) 的 agent 會猜測盤問的含義，導致你收到未經區分的整批問題傾倒。部分載入則是更令人困惑的情況：`grilling` 載入了，`domain-modeling` 卻沒有，你獲得了一場良好的訪談卻完全沒有書面記錄追蹤。這與模型及[投入程度（effort）](https://www.aihero.dev/ai-coding-dictionary/effort)層級有關，且是此技能回報最多的問題。若你有所懷疑，請直接詢問 agent 載入了哪些技能。

**我其他的決策都去哪了？**
僅留在對話中。這是該技能最實質的未解決抱怨：詞彙表不是 spec，多數回答都爭取不到 ADR，且沒有任何總帳能將每個敲定的答案一路串聯至規格、票券與測試。精確的回答（順序保證、負向需求、數值預設值）在下游被弱化為鬆散的文字，結果看似完整卻遺漏了你實際敲定的內容。目前可用的緩解措施是保留該 session 並直接將其提供給 [to-spec](https://aihero.dev/skills-to-spec)，並且對照你自己的回答重新閱讀 spec，而非直接假定它已捕獲了這些內容。

**我可以將它指向完全沒有文件的既有儲存庫嗎？**
可以。對於完全沒有 ADR、沒有領域語言且沒有設計原則的程式碼庫來說，這是合適的技能：呼叫它並說「help me document my repo（協助我記錄我的儲存庫）」。社群模式是將其與 [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 搭配使用，以建立或修復 `GLOSSARY.md`。請做好引導它的準備：它會閱讀程式碼並針對所發現的內容向你提問，而你才是決定程式碼庫中既有用詞何者正確的人。

**當 session 結束時我該做什麼？**
該技能的結尾訊息往往是開放式的，這是已知的未打磨處。在主要流程中，解答是在同一個對話中接續使用 [to-spec](https://aihero.dev/skills-to-spec)。若變更規模小到足以立即建構，則可直接轉向 [implement](https://aihero.dev/skills-implement)。

**為什麼要取這個名字？**
沒有人對這個名稱感到滿意。目前有一項開放的提議建議將其重新命名為 `grill-domain-model`，這能更忠實地描述其行為。目前尚無進展。若未來確定重新命名，文件頁面將隨之移動且 URL 也會變更。

## 運作正常的指標

- `GLOSSARY.md` 在 session *進行中*逐詞變更，而非在最後一口氣成批出現。
- 詞彙表讀起來純粹是詞彙（具備嚴謹定義的專案專屬字詞），且不包含實作細節或類似規格的散文。
- 程式碼庫能回答的問題會透過閱讀程式碼解答，而非向你提問。
- 你收到的 ADR 很少或甚至沒有，且收到的都是若必須重新爭辯會讓你感到困擾的決策。
- 它質疑你使用的某個字詞，因為既有的詞彙表對其定義有所不同。

## 適用位置

`grill-with-docs` 是主要建構鏈條的開端：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

它位於任何規格書面化之前：它產生共同理解與敲定的詞彙，供 [to-spec](https://aihero.dev/skills-to-spec) 後續彙整而無需再次對你進行訪談。其相近的鄰居包括 [grill-me](https://aihero.dev/skills-grill-me)（沒有儲存庫且沒有檔案的相同訪談），以及 [domain-modeling](https://aihero.dev/skills-domain-modeling)（由其驅動的詞彙表與 ADR 規範）；兩者皆立足於 [grilling](https://aihero.dev/skills-grilling) 原語。在其上游，[wayfinder](https://aihero.dev/skills-wayfinder) 負責繪製單一 session 無法消化的龐大工作，並能將地圖的部分內容交回給它。當你不確定哪項技能或流程合適時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你進行路由。
