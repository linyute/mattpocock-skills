## 它的功能

`to-spec` 將你剛才進行的對話轉化為一份**[規格 (spec)](https://www.aihero.dev/ai-coding-dictionary/spec)**，並將其作為單一 issue 發布到你的 issue 追蹤器。

它不會對你進行訪談。當你使用它時，決策已經完成，因此它會綜合彙整已知內容（來自討論串、程式碼庫、你的 `GLOSSARY.md` 和 ADR），而不是開啟新一輪的提問。規格是已做決策的記錄，而不是做出新決策的地方。

## 何時使用它

你透過輸入 `/to-spec` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會自行使用它。

當建構規模過大而無法在單一 agent [session](https://www.aihero.dev/ai-coding-dictionary/session) 中完成，且必須承受被拆分到多個 session 時，請使用它。這就是唯一的觸發條件：

| 你的狀態 | 該執行什麼 |
| --- | --- |
| 你尚未做出任何決定 | 先使用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 已做決定，且工作適合單一[上下文視窗 (context window)](https://www.aihero.dev/ai-coding-dictionary/context-window) | [implement](https://aihero.dev/skills-implement)：跳過規格 |
| 已做決定，且工作跨越多個 session | `/to-spec`，接著使用 [to-tickets](https://aihero.dev/skills-to-tickets) |
| 一個 [wayfinder](https://aihero.dev/skills-wayfinder) 地圖已完成清除 | `/to-spec #<map_issue>` |

## 先決條件

`to-spec` 會將規格作為 issue 發布，因此 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 必須先為此儲存庫設定追蹤器與 triage 標籤詞彙。兩種方式皆可運作：像 GitHub 這樣的真實追蹤器，或是 `.scratch/` 下的本地 Markdown 檔案，開箱即支援。

## 規格是一份決策記錄

規格的存在是因為上下文視窗會結束。你在 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) 期間所確定的一切（解決方案的形狀、你爭論過的選擇、你特意拒絕的事物）都在一個即將被清除的對話中。規格就是存留下來的內容。

因此它不驗證任何事物，也不做任何決定。它以你專案本身的詞彙記錄已決定的事項，以便全新的 session 可以在無需你重新解釋的情況下接手工作。規格中所斷言但你從未真正說過的任何內容都是缺陷。

## 接縫優先於內文

在寫下任何文字之前，`to-spec` 會先勾勒出該功能將被測試的**接縫 (seams)**，並與你進行核對。相比新接縫，它更偏好既有的接縫，並儘可能採用最高層級的接縫：跨越一項變更的理想接縫數量為一個。

這些約定的接縫隨後會傳遞下去。[tdd](https://aihero.dev/skills-tdd) 僅在預先約定的接縫處工作，而 [code-review](https://aihero.dev/skills-code-review) 則會對照規格審核 diff，因此沒有人同意的接縫將會作為審核發現顯示出來。這種繫結是間接的：它透過本份文件運作，這正是為什麼接縫對話在此處值得認真對待，而不是推遲到實作階段的原因。

## 常見問題

**`/to-prd` 去哪裡了？**
就是這個 skill，在 v1.1 中重新命名。「Spec」現在是貫穿始終的單一術語，舊的 `to-prd` slug 已廢棄；請在新的名稱下重新安裝。取代舊詞彙的配對是 *spec* 和 *tickets*：spec 是目的地和鎖定它的決策，[ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 則是到達該目的地的執行步驟。如果你轉向，刪除未完成的 ticket 並保留 spec。

**為什麼規格會獲得 `ready-for-agent` 標籤？我不希望 agent 直接照著它實作。**
該標籤表示「無需進一步分流」：該文件足夠完整，可供 agent 依據其工作。它是一種輸入標記，而非工作工單。但如果你執行輪詢 `ready-for-agent` 的 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk) agent，這種區別對它們是不可見的，它們會很樂意嘗試在一次執行中建構整份規格，而不是接手切片後的 ticket。這是該 skill 回報最多的粗糙之處。在變更之前，請在你的 AFK agent 的 prompt 中明確排除父規格，或者在 `/to-tickets` 執行後移除該標籤。

**為什麼不直接從 grilling 進入 `/to-tickets` 並跳過規格？**
通常你應該這樣做；規格只有在跨多個 session 的工作上才有其存在的價值。它的價值在於 ticket 是拋棄式的而規格不是：每個 ticket 的大小適合一個全新的上下文視窗，並且會被刪除或關閉，而規格則作為其背後推理留存的唯一場所。在單一 session 的變更中，這不會帶來任何好處，而且你還為此付出了額外的綜合彙整步驟代價，在此步驟中[模型](https://www.aihero.dev/ai-coding-dictionary/model)可能會產生偏差。請走 grilling → `/implement`。

**我剛完成了一個 wayfinder 地圖。我該為它提供什麼？**
主地圖 issue：`/to-spec #<map_issue>`，而不是個別的決策 ticket。[wayfinder](https://aihero.dev/skills-wayfinder) 產出的是分散在地圖上的決策而非交付成果；`to-spec` 是將它們收斂成單一可建構文件的步驟。將地圖直接循環套入 `/implement` 會拋棄這種收斂效益。

**規格是讓我審核的，還是只給 agent 看的？**
主要是給 agent 看的，讀起來也是如此：完整、密集、偏重參考。值得你過目的部分是接縫與超出範圍小節，因為在這兩個地方錯誤決策的捕捉成本最低，而在後續發現的代價最高。完整閱讀整篇內容是人們常有的抱怨，而且沒有摘要模式：誠實的答案是，如果規格讓你感到驚訝，代表 grilling 太淺，而不是規格太長。

**一旦 ticket 開始，我該保持規格凍結，還是讓 agent 改寫它？**
沒有任何機制保持同步，因此在實務上它是你當時所知內容的快照，並在實作第一次為你帶來新認知時失效。一旦工作交付，請將其視為拋棄式產物。旨在超越其壽命的產物是你的 `GLOSSARY.md` 與 ADR；如果在實作期間學到的東西值得延續，它屬於那裡，而不是編輯後的規格。

**我的工作是重構或模組邊界，而不是新功能。這個範本合適嗎？**
不太合適，這是已知的限制。範本重度依賴使用者故事，這對架構工作而言是不合適的形狀：你最終會圍繞著本質上是介面與不變項的決策撰寫無人要求的故事。改為倚賴實作決策與測試決策小節，並讓持久的架構決策透過 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 作為 ADR 留存，而不是嘗試讓規格承載它們。

**它會檢查追蹤器尋找相關工作，或是引用它所遵循的 ADR 嗎？**
兩者都不會。它會閱讀並遵循涵蓋其接觸領域的 ADR，但不會連結它們，且在起草前不會搜尋追蹤器以尋找重疊的 issue，因此規格可能會悄悄重複某人已經提交的工作。如果該領域很活躍，請先自行搜尋追蹤器。

**`/to-tickets` 無法讀取我的規格：它不斷被截斷。**
非常龐大的規格可能會超出追蹤器 issue 能完整提供的範圍，且沒有本地複本可供退回使用。修復方式是做好上下文整潔：不要在 `/to-spec` 與 `/to-tickets` 之間進行[清除 (clear)](https://www.aihero.dev/ai-coding-dictionary/clearing) 或[壓縮 (compact)](https://www.aihero.dev/ai-coding-dictionary/compaction)。在同一個視窗中執行它們，規格就完全不需要重新擷取。

## 若運作正常，會符合以下情況

- 它開始撰寫，而非向你提出新一輪問題。
- 它在撰寫前向你提出接縫，並提議儘可能少且夠用的數量。
- 它回傳的內容使用你專案的名詞，而非泛用的產品管理樣板文字。
- 其中的每項決策都是你記得做過的。沒有為了填滿小節而捏造任何內容。
- 超出範圍小節有實質內容：你拒絕的事物通常是頁面上最有用的行句。

## 它的定位

`to-spec` 是主要建構鏈中的一個步驟，且僅位於其多 session 分支上：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

其上游鄰居是 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)（負責完成本 skill 僅負責記錄的決策工作），以及 [wayfinder](https://aihero.dev/skills-wayfinder)（其完成的地圖正好在此處併入鏈條）。在下游，[to-tickets](https://aihero.dev/skills-to-tickets) 將規格切分為示蹤彈 ticket 以供 [implement](https://aihero.dev/skills-implement) 進行建構。當你不確定哪項 skill 或流程合適時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你引導。
