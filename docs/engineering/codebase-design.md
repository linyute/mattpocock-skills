## 功能說明

`codebase-design` 確立了你在設計模組時所使用的字詞：**模組（module）**、**介面（interface）**、**深度（depth）**、**接縫（seam）**、**配接器（adapter）**、**槓桿效應（leverage）**、**局部性（locality）**。它精確定義了每個詞彙，禁止使用含糊的替代詞（「元件」、「服務」、「API」、「邊界」），並闡明源自這些詞彙的少數幾項原則。

它是一份參考指南，而非一套流程。沒有需要執行的循環、不產生任何產物、也沒有向你提問的檢查點。其他涉及設計的技能皆借用其詞彙；就其本身而言，它為你提供語言規範後便停止。這是在呼叫它之前必須了解的事，因為一個沒有流程且沒有停止規則的技能，如果你對一個 [session](https://www.aihero.dev/ai-coding-dictionary/session) 指定它並說「開始」，它就會自行拼湊出流程。請參閱下方問題以了解這在實踐中會是什麼情況。

## 何時使用

輸入 `/codebase-design`，或者當設計任務適合時，agent 會自動取用它。

當你已經知道要重新設計哪段程式碼，且需要思考其架構形態時使用它：接縫設在哪裡、介面能精簡到何種程度、某個提取是否值得其維護成本。當你想平息關於某個詞彙含義的爭論時，它也是你的依據。

有幾項技能與其相近。你該選用哪一項取決於實際問題是什麼：

| 面臨的問題 | 建議的技能 |
|---|---|
| 單一模組的形態：其介面、接縫、深度 | `codebase-design` |
| *領域詞彙*：「account」具有三種含義，兩個人對「cancellation」的理解截然不同 | [domain-modeling](https://aihero.dev/skills-domain-modeling) |
| 你尚不知道要重新設計*哪一個*模組 | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture)（用以尋找候選對象的審查） |
| 你希望對設計進行辯證檢視，而不僅僅是命名 | [grilling](https://aihero.dev/skills-grilling) |
| 有具體行為需要建構，且你希望測試能在重構後依然有效 | [tdd](https://aihero.dev/skills-tdd) |

## 核心詞彙

詞彙表即為本技能的本質。每個術語都相互對照定義，且每個詞彙都指明了它所取代的字詞。

| Term | What it means | Don't say |
|---|---|---|
| **Module** | 任何具有介面與實作的事物。刻意不限制規模：可以是一個函式、一個類別、一個套件、或跨越多層的垂直切片。 | 單元（unit）、元件（component）、服務（service） |
| **Interface** | 呼叫端為了正確使用它所必須知曉的一切：型別簽名，加上不變性、順序限制、錯誤模式、必要設定、效能特性。 | API、簽名（signature） |
| **Depth** | 介面處的槓桿效應：呼叫端或測試每學習一個單位的介面所能執行的行為量。**深（Deep）**：小介面背後封裝了大量行為。**淺（Shallow）**：介面幾乎與實作一樣複雜。 | 無 |
| **Seam** | Michael Feathers 提出的術語：一個無需在該處進行編輯即可改變行為的地方。它是介面的*所在位置*，而將其置於何處是獨立於其背後內容的決策。 | 邊界（boundary） |
| **Adapter** | 在接縫處滿足某個介面的具體事物。指涉的是角色而非實質本體：記憶體中的 fake 和 Postgres repo 都是配接器。 | 無 |
| **Leverage** | 呼叫端從深度中獲得的效益：每學習一個單位的介面即可獲得更多能力。 | 無 |
| **Locality** | 維護者從深度中獲得的效益：變更、錯誤與驗證皆集中於一處。一次修復，處處修復。 | 無 |

深度刻意*未*被定義為實作行數與介面行數的比例（那是 Ousterhout 本人的定義）。該指標會變相鼓勵填充實作程式碼。此處改用「深度即槓桿效應」來定義。

## 四項原則

- **深度是介面的屬性，而非實作的屬性。** 深模組內部可以由小型且可替換的組件建構而成，只是它們不會暴露給呼叫端。模組可以擁有供其自身測試使用的內部接縫，並在其介面處擁有一條外部接縫。
- **刪除測試。** 想像刪除該模組。若複雜度隨之消失，它就只是透傳（pass-through）。若複雜度重新散落在 N 個呼叫端中，那它就證明了自己的價值。
- **介面即測試接觸面。** 呼叫端與測試跨越的是同一條接縫。如果你想*越過*介面進行測試，該模組的形態就是錯誤的。
- **單一配接器意味著假設性的接縫。兩個配接器才意味著真實的接縫。** 在真正有事物跨接縫產生變化前，不要切出接縫。只有單一配接器的接縫純粹只是間接層（indirection）。

兩份附屬檔案進行了更深入的探討，技能會依需求讀取它們而非預先載入。[DEEPENING.md](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DEEPENING.md) 將候選對象的相依性分為四類（程序內、本機可替代、遠端但自有、真實外部），因為該類別決定了加深後的模組如何跨其接縫進行測試。[DESIGN-IT-TWICE.md](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DESIGN-IT-TWICE.md) 啟動平行的 [sub-agents](https://www.aihero.dev/ai-coding-dictionary/subagent)，為同一模組產出三種或更多截然不同的介面，接著在深度、局部性與接縫放置上對它們進行比較。

## 常見問題

**我究竟該如何在 TypeScript 中建構深模組？**

這是本技能被問到最多次的問題，但本技能並未給出解答。它定義了什麼*是*深模組；卻完全沒有提及如何阻止零散的 import 越過介面存取內部細節。[Issue #458](https://github.com/mattpocock/skills/issues/458) 直白地指出：「假設我們對介面很滿意，它隱藏了細節等等。但我們要如何強制落實？我認為如果沒有 linting 或明確的防護欄，人類和 LLMs 都會隨著時間推移讓程式碼變混亂。」Matt 在該討論串中給出了三個選項：將其封裝在類別或 IIFE 中，並接受類別變得極其龐大；將其作為 monorepo 中的套件，並接受 monorepo 的工具鏈；或使用像 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 這樣的 linter 來禁止繞過介面的 import。他另外指出 Effect 是最佳機制，dependency-cruiser 次之。儲存庫的 `in-progress/` 分類中有一個 `setup-ts-deep-modules` 技能，制定了 `src/packages/<name>/index.ts` 慣例，但它是測試頻道的技能，沒有文件頁面，且未隨附任何 lint 規則。

**我對它指定了一個 session，它消耗了 10 萬個 [tokens](https://www.aihero.dev/ai-coding-dictionary/token) 重新設計我從未要求的事物。**

這是已知問題，並已登記為 [issue #449](https://github.com/mattpocock/skills/issues/449)。該技能由模型呼叫且自述為詞彙表，但其內部沒有任何機制強制阻止 agent 將其視為可執行的流程。當被告知「在 /codebase-design 中繼續並推進待決定的事項」時，agent 抓取了它能找到最具行動特徵的內容：`DESIGN-IT-TWICE.md` 中的平行 sub-agents。它重新探索了先前 session 已經對應過的程式碼，並在提出任何問題前執行了很長一段時間。引導型技能所具備的防護欄（檢查點、一次一個問題、不自動前進）在此處完全不存在，因為參考指南本來就沒有這些。因應方式是指定一項引導型技能，並讓本技能位於其底層支援：使用 `/grill-with-docs`、`/improve-codebase-architecture` 或 `/tdd`，並以 `codebase-design` 作為詞彙表。此 issue 仍處於開啟狀態。

**`design-an-interface` 去哪了？是否有 `/interface-design` 技能？**

`design-an-interface` 已被移除並併入本技能。沒有任何內容遺失：其「設計兩次」技巧（源自 Ousterhout，由平行的 sub-agents 產生截然不同的設計）在本文中以 `DESIGN-IT-TWICE.md` 提供。另外，有幾個人曾要求提供專門針對深模組／薄介面（deep-module/thin-interface）哲學的 `/interface-design` 技能；該哲學早已存在於此，目前沒有規劃獨立的技能。如果你是為了尋找這兩個名稱而來，本頁面正是目的地。

**這難道不是一種檔案結構慣例嗎，例如資料夾、barrel 檔案、功能切片（feature slices）？**

不是，本技能在屢遭質疑的情況下依然堅持此界線。[Issue #95](https://github.com/mattpocock/skills/issues/95) 提議將形式化的碎形樹狀檔案結構作為深模組的具體實作；回覆則是兩者相互正交：「深模組關乎介面的設計以及透過嚴格介面進行存取，無論檔案系統長什麼樣子。採用這種做法完全有可能產生淺模組。」#458 中也出現了相同的討論：「我認為你可能把模組的概念與檔案系統綁得太緊了。檔案系統固然能為模組形態提供有用的提示，但建構深模組時完全不需要仰賴檔案系統。」詞彙表中刻意將**模組**定義為規模無關。

**`tdd` 實際上是否使用這套詞彙？**

現在確實有使用。有很長一段時間並未使用。過去存在於 `tdd` 內部的深模組行內註記在 v1.0 中被移除，改用本共用技能，但取代它們的指標卻從未被加入，導致 `tdd` 自行定義了「接縫」且未參照任何內容。此落差現已彌合：指標現已存在於該技能中，當未決問題在於介面形態而非測試時便會觸及。`tdd` 仍保留「接縫」作為你進行*測試*時的邊界；本技能則負責其背後的模組形態。

**設計兩次（design-it-twice）模式能在 Claude Code 之外運作嗎？**

無法完美運作。`DESIGN-IT-TWICE.md` 提到「使用 Agent 工具平行產生 3 個以上的 sub-agents」，這是 Claude Code 特有名稱的[工具](https://www.aihero.dev/ai-coding-dictionary/tool)。該儲存庫提供了適用於其他 [harnesses](https://www.aihero.dev/ai-coding-dictionary/harness)（包括 Codex）的 metadata，而那些環境可能完全未以此名稱公開任何功能，因此平行設計階段的可攜性不如該技能的 metadata 所暗示的那樣高。此問題記錄於開啟中的 [issue #564](https://github.com/mattpocock/skills/issues/564)。

**我可以將自己的概念加入詞彙表中嗎，例如共生性（connascence）、模組機密、[漸進式揭露](https://www.aihero.dev/ai-coding-dictionary/progressive-disclosure)？**

確實有人提議過這些。[Issue #180](https://github.com/mattpocock/skills/issues/180) 加入了 Parnas 的模組機密與 Page-Jones 的共生性，作為命名*何種事物*跨越接縫洩漏的層次，並附上了可用的 diff；[issue #303](https://github.com/mattpocock/skills/issues/303) 提議在實作內部採用漸進式揭露，使公開介面很深的模組在其底層不會成為一塊未分化的厚板。這兩個 issue 皆處於開啟且未合併狀態。發布的詞彙表刻意保持精簡，而維持精簡的原因在技能本身已說明：維持一致的語言才是核心目的，而一個沒人能一致使用的術語比沒有術語更糟糕。

## 運作正常的指標

- 設計對話不再出現「元件」、「服務」與「邊界」等字眼，而是開始產出「模組」、「介面」與「接縫」。
- 有人能指著一項提議的提取，毫不含糊地指出它是否通過了刪除測試。
- 提議的接縫指出了第二個配接器名稱，而非僅有第一個。
- 針對介面的討論涵蓋了不變性、順序與錯誤模式，而不僅僅是型別簽名。
- 呼叫它不會啟動 session。如果 agent 僅憑 `/codebase-design` 就開始讀取檔案並提議重構，那它是將參考指南誤當成了引導型流程。

## 適用位置

`codebase-design` 是一個**隨時可調用的獨立技能**，且是工程技能底層的詞彙層，而非任何鏈條中的某一步。它最接近的鄰居是 [domain-modeling](https://aihero.dev/skills-domain-modeling)，後者是針對*問題領域*詞彙而非模組形態的平行參考指南。這兩者通常需要搭配使用，因為要為深模組妥善命名兩者缺一不可。[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 則是另一個鄰居：它審查程式碼庫以尋找加深候選對象，並使用本詞彙表描述每一個對象，因此它負責尋找模組，而本技能則是你設計模組的工作台。當你不確定哪項技能或流程合適時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你進行路由。
