## 功能說明

`domain-modeling` 在你進行設計時建構並精煉專案的**通用語言（ubiquitous language）** — 質疑與術語表衝突的詞彙、在你使用模糊字眼時強制使用精準的詞彙，並透過具體情境對關係進行壓力測試，直到邊界變得精確為止。

這是**主動的**規範，而不是被動的。讀取 `CONTEXT.md` 以借用其詞彙是任何技能都可以做到的單行習慣；本技能適用於你正在*變更*模型的時候。這正是使其產生中斷的原因。它會在對話中途、術語被確定解決的時刻將該術語寫入 `CONTEXT.md`，而不是在最後產生一份整潔的術語表 — 因為批量版本是對[工作階段](https://www.aihero.dev/ai-coding-dictionary/session)的摘要，而內聯版本才是工作階段的實際輸出。

## 何時使用

輸入 `/domain-modeling`，或者當任務適合時，agent 會自動使用它。在實踐中，自動呼叫是該技能最薄弱的部分：當 `grill-with-docs` 或 `wayfinder` 指示載入它時，[models](https://www.aihero.dev/ai-coding-dictionary/model)（模型）經常會載入 `grilling` 並跳過本技能。如果執行了 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（審問）工作階段且結尾時 `CONTEXT.md` 未被動過，這就是原因所在 — 請按名稱與其他技能一同呼叫它。

當*詞彙*是問題所在時使用它：

| 狀況 | 處置 |
| --- | --- |
| 兩個人對「取消」有不同的理解 | `domain-modeling` — 挑選規範術語，將另一個列於 `_Avoid_` 下 |
| 「帳號（Account）」在三個檔案中承擔了三項工作 | `domain-modeling` — 將其拆分為 Customer 與 User |
| 你剛做出了難以逆轉的架構抉擇 | `domain-modeling` — 如果該抉擇通過標準，它會提供 ADR |
| 模組的*形狀*是問題所在 — 接縫放置何處、介面有多深 | [codebase-design](https://aihero.dev/skills-codebase-design) |
| 你希望在建構前對整個計畫進行審問 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，它在底層驅動本技能 |
| 你希望查閱術語，而不是變更它 | 無需技能。閱讀 `CONTEXT.md` 即可。它只是一個檔案。 |

## 先決條件

事前無需任何先決條件。本技能寫入兩個地方，並以延遲方式建立兩者：

- 位於儲存庫根目錄的 **`CONTEXT.md`**，由第一個確定解決的術語建立。在根目錄帶有 `CONTEXT-MAP.md` 的儲存庫中，術語會改為進入地圖所指向的各 context 專用 `CONTEXT.md`。
- **`docs/adr/`**，由第一個通過標準的 ADR 建立。

在你開始之前不需要存在任何東西，且不會按推測性建立任何東西。

## 兩種產物，兩種標準

術語表與 ADR 遵循不同的標準，而混淆它們正是本技能大部分問題的根源。

| | `CONTEXT.md` | `docs/adr/NNNN-slug.md` |
| --- | --- | --- |
| 內容 | 術語。事物**是什麼**（在一至兩句話中），被拒絕的同義詞列於 `_Avoid_` 下 | 單一決策（在一至三句話中）：context、抉擇、理由 |
| 寫入標準 | 模糊術語變成了規範術語 | **全部三項**：難以逆轉、缺乏 context 時令人驚訝、真實權衡的結果 |
| 寫入時機 | 內聯，術語確定解決的瞬間 | 提供建議，而非假定寫入 |
| 絕不包含 | 實作細節、[spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格）、草稿區、一般程式設計概念 | 本工作階段所做出之每個抉擇的日誌 |

錯過 ADR 三項測試中的任何一項，就不會產生 ADR。容易逆轉的決策只需要直接逆轉；不令人驚訝的決策不是任何人的問題；沒有真正替代方案的決策只記錄了你做了顯而易見的事。

`CONTEXT.md` 規則是真正需要堅守的規則，因為它是實務中容易破壞的規則。**它是一份術語表，僅此而已。**如果不加控制，模型會將「寫入 `CONTEXT.md`」視為持續儲存你給出的每個答案的許可，檔案隨之變成動態規格 — 這是跨多個模型中最常被回報的技能問題。

## 交叉引用及其止步之處

使本技能順暢運作的操作是：當你陳述某事物如何運作時，它會檢查程式碼並顯露矛盾。*「你的程式碼取消了整個訂單，但你剛說可以部分取消 — 哪一個才是對的？」* 在變更語言或程式碼之前，大聲使其達成一致。

這個局限值得了解。它交叉引用**程式碼**與已提交的 `CONTEXT.md`/ADR，僅此而已。它不會搜尋你的議題追蹤器，因此幾個月前在已關閉議題中辯論並刻意決定的命名衝突會像新問題一樣重新浮現。有一個 [開放的要求](https://github.com/mattpocock/skills/issues/717) 來修復此問題；在此之前，替代方案是將指示放在你自己的 `docs/agents/domain.md` 中，技能已經會讀取該檔案。

## 常見問題

**我的 `CONTEXT.md` 有 500 行、1,000 行、3,000 行。我該怎麼辦？**
檔案大小是症狀而非病因 — 該檔案吸收了絕不屬於術語表材料的實作細節與決策。修復方法是直接給出指示：`/grill-with-docs make my CONTEXT.md more concise and remove any implementation details from it`。針對臃腫的檔案執行它，大部分臃腫內容就會消失。僅在檔案真正精簡且仍涵蓋讀者不希望同時掌握的兩個領域時，才使用 `CONTEXT-MAP.md` 進行拆分；拆分臃腫的檔案只會為你帶來多個臃腫的檔案。本技能在此處的指引尚不足以從一開始就阻止膨脹，且追蹤該問題的議題仍處於開放狀態。

**為什麼是 `CONTEXT.md` 而不是 `GLOSSARY.md`？**
這是整個技能集合中最受爭議的命名問題，且沒有確定的答案。反對目前名稱的理由很充分：如果它是「術語表，僅此而已」，`GLOSSARY.md` 就說明了這一點，而且 — 正如一位讀者所言 —「對於 AI agent 來說，一切都是 [context](https://www.aihero.dev/ai-coding-dictionary/context)」。支持它的理由是地圖：`CONTEXT-MAP.md` 指向多個 `CONTEXT.md` 檔案讀起來很自然，而 `GLOSSARY-MAP.md` 則不然，且 `context` 是領域驅動設計（DDD）中代表模型限界區域（bounded area）的標準用語。至少有一個人維持本機 fork 純粹是為了重新命名該檔案。你也可以做同樣的事，但集合中的其他每個技能都會尋找 `CONTEXT.md`，因此重新命名意味著需要修補所有技能。

**`/ubiquitous-language` 去了哪裡？**
它已被移除，且未被廢棄。它的工作轉移到了 `domain-modeling` 中，後者持續維護整個模型，而不是從單一對話中傾印出術語表。詞彙強制的關鍵程度變高了而非變低了 — 它現在在審問（grilling）、triage 與 mapping 底層執行，而不是作為你需要記得執行的獨立檢查。

**如何為沒有術語表的程式碼庫取得術語表？**
明確提出要求，而不是等待它累積。`/grill-with-docs help me scaffold my existing repo with a CONTEXT.md` 是記錄在案的路徑；預期會有長期的審問 — 一位使用者回報在檔案成形之前回答了 50 多個問題。在既存專案（brownfield repo）上，附帶使用建立術語表的速度過慢。

**我可以保留領域模型並使用我自己的 ADR 格式嗎？**
目前無法乾淨地做到。術語表部分與 ADR 部分在一個技能中發布，因此具有既定 ADR 約定（不同範本、不同位置、不同命名）的團隊會收到與其內部風格衝突的指示。目前的選項是在本機複製該技能並進行編輯，或者在儲存庫自身的 agent 文件中覆寫 ADR 約定。將兩者拆開是一個[開放的要求](https://github.com/mattpocock/skills/issues/557)。

**術語表真的物有所值嗎？它是多一個需要審查的產物，且可能會過期。**
有時並非如此，值得坦白說明何時如此。DDD 越接近實作就越沒有效果 — 其回報在於上游的命名與概念對齊，而不是聚合（aggregates）與層級儀式。同義詞控制在命名邊界很重要：模組名稱、表格名稱、狀態列舉（enums）、議題標題、CLI 指令。它在普通散文中的重要性要小得多。還有一個真實的反對意見：領域術語壓縮了已經共享這些術語的*人類之間*的溝通，而 agent 對純英文描述的反應相同 — 按照這種解讀，術語表的價值在於讓你和你的審查者與 agent 所做的事保持一致，而不是讓 agent 變得更好。在單日建構中請跳過它。且未經審查、由 agent 撰寫的術語表比沒有更糟糕：它會變成聽起來自信的傳說，後續的工作階段會將其視為真理。

**它可以幫我將模糊的 prompt 轉換為領域語言嗎？**
不行，且沒有計畫推出能做到這一點的技能。你自己都不理解的領域語言一旦寫下來就會變成毫無意義的廢話。本技能在你擁有理解後強制執行精準度 — 它不會製造你所沒有的詞彙。相關陷阱是在沒有進行建模的情況下使用領域詞彙：錯誤概念結構上的正確名詞會產生讀起來正確但實際並非如此的輸出。

## 運作正常的指標

- 它會在句子中途打斷你，詢問你指的是兩件事中的哪一件，而不是隨便挑選一個並繼續前進。
- `CONTEXT.md` 在對話**期間**變更，而不是在最後爆發式地變更。
- 它拒絕為你明天就可以撤銷的事情撰寫 ADR — 並說明三項測試中哪一項失敗了。
- 新條目在一或兩句話中定義事物*是什麼*，並在 `_Avoid_` 下列出你要放棄的詞彙。
- 當你的程式碼與你的句子不一致時，它會將你的程式碼引用並回應給你。
- `CONTEXT.md` 變短的頻率與變長的頻率一樣高。

## 適用位置

`domain-modeling` 是一個**模型呼叫的參考檔案**，比起單獨執行，它更常在其他技能*底層*執行。[grill-with-docs](https://aihero.dev/skills-grill-with-docs) 透過審問工作階段驅動它，[wayfinder](https://aihero.dev/skills-wayfinder) 在繪製地圖時載入它，[triage](https://aihero.dev/skills-triage) 使用它以專案自己的詞彙維持 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)，而 [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 則在決策明確化時呼叫它。它最接近的兄弟是 [codebase-design](https://aihero.dev/skills-codebase-design)：兩者是一切事物的底層詞彙層，本技能針對*領域*，該技能針對模組的*形狀*。當你想使用該規範又不想承諾執行通常會引入該規範之技能的步驟時，也可以直接存取它。當你不確定適合哪個技能時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你進行路由。
