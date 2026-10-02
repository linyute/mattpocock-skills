## 功能說明

`domain-modeling` 在你進行設計時建構並打磨專案的**通用語言（ubiquitous language）**：質疑與詞彙表衝突的術語、在你使用含糊詞彙時強制要求精確用詞，並透過具體情境對關聯性進行壓力測試，直到邊界完全精確為止。

它是**主動式**的紀律規範，而非被動式的。讀取 `GLOSSARY.md` 以借用其詞彙是任何技能都能做到的單行習慣；本技能則是用於你正在*改變*模型的時候。這也是它會介入中斷對話的原因。它在術語敲定的那一刻——在對話進行中——便將敲定的術語寫入 `GLOSSARY.md`，而不是在最後產出一份整潔的詞彙表，因為批次版本只是 [session](https://www.aihero.dev/ai-coding-dictionary/session) 的摘要，而行內寫入版本才是該 session 的真實產出。

## 何時使用

輸入 `/domain-modeling`，或者當任務適合時 agent 會自動取用它。在實踐中，自動呼叫是該技能最脆弱的部分：當 `grill-with-docs` 或 `wayfinder` 指示載入它時，[模型](https://www.aihero.dev/ai-coding-dictionary/model)往往會載入 `grilling` 而略過本技能。若 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) session 執行完畢且最後 `GLOSSARY.md` 完全未被更動，那就是發生了這種情況；請與其他技能並列，以具名方式直接呼叫它。

當問題出在*字詞*本身時使用它：

| 所處情境 | 應對方式 |
| --- | --- |
| 兩個人對「cancellation」的定義不同 | `domain-modeling`：選定標準術語，將另一個列於 `_Avoid_` 之下 |
| 「Account」在三個檔案中承擔了三種職責 | `domain-modeling`：將其拆分為 Customer 與 User |
| 你剛做出難以逆轉的架構抉擇 | `domain-modeling`：若該抉擇跨過門檻，它會提議撰寫 ADR |
| 問題在於模組的*形態*：接縫設在哪裡、介面有多深 | [codebase-design](https://aihero.dev/skills-codebase-design) |
| 在建構之前希望對整個計畫進行盤問 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，它在底層推動本技能 |
| 你只想查詢某個術語而非修改它 | 什麼都不用做。閱讀 `GLOSSARY.md` 即可，它是一個檔案。 |

## 先決條件

事前無需任何先決條件。該技能寫入兩個位置，且皆以延遲載入方式建立：

- 位於儲存庫根目錄的 **`GLOSSARY.md`**，由第一個敲定的術語建立。在根目錄包含 `GLOSSARY-MAP.md` 的儲存庫中，術語會改為寫入該地圖所指向的各 context 專屬 `GLOSSARY.md`。
- **`docs/adr/`**，由第一個跨過門檻的 ADR 建立。

在你開始之前無需存在任何檔案，且不會憑空推測建立任何內容。

## 兩項產物，兩種門檻

詞彙表與 ADR 適用不同的標準，將兩者混為一談正是本技能多數問題的根源。

| | `GLOSSARY.md` | `docs/adr/NNNN-slug.md` |
| --- | --- | --- |
| 存放內容 | 術語。以一到兩句話說明事物**是什麼**，並在 `_Avoid_` 下列出被否決的同義詞 | 單一決策，以一到三句話說明：背景、抉擇、原因 |
| 寫入門檻 | 含糊的術語已轉化為標準術語 | **三者兼備**：難以逆轉、缺乏背景時令人意外、具實質權衡取捨的結果 |
| 寫入時機 | 行內即時寫入，在術語敲定的那一刻 | 主動提議，而非擅自假定 |
| 絕不包含 | 實作細節、[spec](https://www.aihero.dev/ai-coding-dictionary/spec)、草稿區、一般程式設計概念 | 該 session 中所做每項選擇的流水帳日記 |

只要未通過 ADR 三項檢驗中的任何一項，就不應產生 ADR。容易逆轉的決策直接逆轉即可；毫不令人意外的決策不會有人產生疑問；沒有其他可行替代方案的決策只不過記錄了你做了顯而易見的選擇。

`GLOSSARY.md` 的規則才是實務上真正必須堅守的，因為它最常在實作中被打破。**它是一份詞彙表，除此無他。** 若放任不管，模型會將「寫入 `GLOSSARY.md`」視為將你給出的每個答案永久保留的許可，該檔案隨之退化為執行中的 spec。跨多個模型來看，這是該技能回報最多的問題。

## 交叉參照及其極限

讓該技能發揮關鍵作用的舉措是：當你陳述某個功能如何運作時，它會檢查程式碼並揭示其中的矛盾。*「你的程式碼會取消整筆訂單，但你剛才說可以部分取消，哪一個才是對的？」* 在任何一方被修改之前，語言與程式碼必須公開達成一致。

其極限值得銘記。它交叉參照的是**程式碼**以及已 commit 的 `GLOSSARY.md`／ADRs，除此無他。它不會搜尋你的 issue tracker，因此數個月前在已關閉的 issue 中經過激烈爭論並特意敲定的命名衝突，會被當成新問題重新提出。目前有[一項開放的請求](https://github.com/mattpocock/skills/issues/717)旨在修復此問題；在那之前，替代做法是在技能本來就會讀取的 `docs/agents/domain.md` 中寫入該指示。

## 常見問題

**我的 `GLOSSARY.md` 達到了 500 行、1,000 行、3,000 行。我該怎麼辦？**
檔案龐大只是徵狀而非病因：該檔案吸收了實作細節以及根本不屬於詞彙表範疇的決策。解法是給予直接指示：`/grill-with-docs make my GLOSSARY.md more concise and remove any implementation details from it`。針對臃腫的檔案執行此操作，大部分贅肉都會被移除。只有當該檔案真正精簡、且仍涵蓋讀者不想同時關注的兩個領域時，才考慮使用 `GLOSSARY-MAP.md` 進行拆分；拆分一個臃腫的檔案只會讓你得到多個臃腫的檔案。該技能在此處的指引尚不足以從根本防止檔案膨脹，追蹤該問題的 issue 仍處於開啟狀態。

**為什麼是 `GLOSSARY.md` 而不是 `GLOSSARY.md`？**
這是整個技能集合中爭議最多的命名問題，且至今尚無定論。反對現有名稱的理由很充分：如果它是「一份詞彙表，除此無他」，`GLOSSARY.md` 就能表明這一點，且正如一位讀者所言：「對於 AI agents 來說，一切都是 [context](https://www.aihero.dev/ai-coding-dictionary/context)」。支持現有名稱的理由在於地圖：`GLOSSARY-MAP.md` 指向多個 `GLOSSARY.md` 檔案讀起來很自然，而 `GLOSSARY-MAP.md` 則不然，且 `context` 是領域驅動設計（DDD）中代表模型限定範圍（bounded area）的標準用語。至少有一人純粹為了重新命名該檔案而維護本機 fork。你也可以這麼做，但該集合中的所有其他技能都會尋找 `GLOSSARY.md`，因此重新命名意味著必須修改所有技能。

**`/ubiquitous-language` 去哪了？**
它已被移除，且未經歷棄用階段。其職責移交給了 `domain-modeling`，後者持續維護整個模型，而非僅從單次對話中匯出詞彙表。詞彙強制執行的分量變得更重而非更輕：它現在在 grilling、triage 與 mapping 的底層執行，而非作為你需要費心記住的獨立步驟。

**如何為完全沒有詞彙表的程式碼庫建立詞彙表？**
明確提出要求，而非等待其慢慢累積。`/grill-with-docs help me scaffold my existing repo with a GLOSSARY.md` 是記載的途徑；請做好面對漫長質詢的心理準備：有使用者回報在該檔案成形前經歷了 50 個以上的提問。在既有程式碼庫（brownfield repo）上附帶使用建立詞彙表的速度實在太慢了。

**我可以保留領域模型並使用自己的 ADR 格式嗎？**
目前無法俐落達成。詞彙表與 ADR 這兩部分封裝在同一個技能中，因此擁有既定 ADR 慣例（不同範本、不同位置、不同命名）的團隊會收到與其內部風格衝突的指示。目前的選項是在本機複製該技能並進行編輯，或者在儲存庫自有的 agent 文件中覆寫 ADR 慣例。將兩者拆分是一項[開啟中的請求](https://github.com/mattpocock/skills/issues/557)。

**詞彙表真的值得其維護成本嗎？它多了一項需要審查的產物，而且可能會過期。**
有時候確實不值得，坦白面對其適用邊界是值得的。越接近實作層面，DDD 的用處就越小：其回報在於上游的命名與概念對齊，而非聚合（aggregates）與分層繁文縟節。同義詞控制在命名邊界至關重要：模組名稱、資料表名稱、狀態列舉、issue 標題、CLI 指令。在一般散文中其重要性大減。此外也有一個具說服力的異議：領域術語壓縮的是已經具備共同理解的*人類之間*的溝通，而 agent 對於純英文描述的反應並無二致。從這種角度來看，詞彙表的價值在於讓你與你的審查者能與 agent 的作為保持一致，而非讓 agent 變得更優秀。在為期一天的建構中，略過它吧。而且未經審查、由 agent 撰寫的詞彙表比沒有詞彙表更糟：它會演變成聽起來言之鑿鑿的民間傳說，讓後續的 session 將其奉為真理。

**它可以替我將模糊的提示詞轉化為領域語言嗎？**
不能，且目前沒有開發此類技能的計畫。你自己都不理解的領域語言一旦寫下來就成了毫無意義的胡言亂語。本技能是在你具備理解後強制落實精確性；它不會憑空製造你尚未擁有的詞彙。相關的陷阱是在沒有進行建模的情況下使用領域詞彙：在錯誤的概念結構上套用正確的名詞，只會產出讀起來正確實則不然的內容。

## 運作正常的指標

- 它在你話說到一半時叫停，詢問兩者之中你究竟是指哪一個，而非隨便選一個就繼續下去。
- `GLOSSARY.md` 在對話**進行中**變更，而非在最後一口氣輸出。
- 它會拒絕為明天就能撤銷的事物撰寫 ADR，並說明未通過三項檢驗中的哪一項。
- 新項目以一到兩句話定義事物*是什麼*，並在 `_Avoid_` 下指明你所放棄的字詞。
- 當你的程式碼與你陳述的句子不符時，它會引用你的程式碼反問你。
- `GLOSSARY.md` 變短的頻率與變長的頻率相當。

## 適用位置

`domain-modeling` 是一個**由模型呼叫的參考指南**，它在其他技能*底層*執行的頻率遠高於獨立執行。[grill-with-docs](https://aihero.dev/skills-grill-with-docs) 在 grilling session 中推動它，[wayfinder](https://aihero.dev/skills-wayfinder) 在繪製地圖時載入它，[triage](https://aihero.dev/skills-triage) 用它讓 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) 維持專案專屬的用詞，而 [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 在決策明朗時呼叫它。它最親近的兄弟是 [codebase-design](https://aihero.dev/skills-codebase-design)：兩者是其他一切底層的詞彙層，本技能負責*領域*，後者負責模組的*形態*。當你想要遵循該紀律卻不想承諾執行平時引入該技能所需的繁複步驟時，也可以直接調用它。當你不確定哪項技能合適時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你進行路由。
