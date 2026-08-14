## 功能說明

`codebase-design` 固定了你用來設計模組的詞彙：**模組（module）**、**介面（interface）**、**深度（depth）**、**接縫（seam）**、**轉接器（adapter）**、**槓桿（leverage）**、**區域性（locality）**。它精準地定義了每一個詞彙，禁止使用鬆散的替代詞（「元件」、「服務」、「API」、「邊界」），並陳述了隨之產生的少數原則。

它是一份參考文件，而不是一個流程。沒有要執行的迴圈，沒有產生的產物，也沒有詢問你問題的檢查點。其他每一個涉及設計的技能都借用了它的詞彙；它本身僅為你提供語言然後停止。這是你在呼叫它之前需要知道的事，因為如果沒有流程且沒有停止規則的技能，當你將 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）指向它並說「開始」時，它會即興創作一個流程 — 請參閱下方的問題。

## 何時使用

輸入 `/codebase-design`，或者當設計任務適合時，agent 會自動使用它。

當你已經知道要重新設計哪些程式碼，且你需要思考其形狀時使用它：接縫放在哪裡、介面可以變得多小、提煉（extraction）是否值得。當你要解決關於某個詞彙含義的爭論時，也可以使用它。

有幾個技能與它很接近。你需要哪一個取決於實際的問題是什麼：

| 問題 | 技能 |
|---|---|
| 單一模組的形狀 — 其介面、其接縫、其深度 | `codebase-design` |
| *領域的詞彙* —「帳號」意味著三件事，兩個人對「取消」有不同的理解 | [domain-modeling](https://aihero.dev/skills-domain-modeling) |
| 你還不知道要重新設計*哪一個*模組 | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) — 尋找候選者的調查 |
| 你希望對設計進行辯論，而不僅僅是命名 | [grilling](https://aihero.dev/skills-grilling) |
| 有具體的行為需要建構，且你需要能在重構後保留的測試 | [tdd](https://aihero.dev/skills-tdd) |

## 詞彙表

術語表即是該技能的精髓。每個術語都相對於其他術語進行定義，且每個術語都附帶了它所替換的詞彙。

| 術語 | 含義 | 請勿使用 |
|---|---|---|
| **Module**（模組） | 任何具有介面與實作的事物。刻意不限規模 — 函式、類別、套件、跨層切片。 | unit、component、service |
| **Interface**（介面） | 呼叫者要正確使用它所必須知道的一切：型別簽名，加上不變性、順序約束、錯誤模式、所需設定、效能特性。 | API、signature |
| **Depth**（深度） | 介面處的槓桿 — 呼叫者或測試在其必須學習的每單位介面中可以執行的行為量。**深（Deep）**：小介面背後有大量行為。**淺（Shallow）**：介面幾乎與實作一樣複雜。 | — |
| **Seam**（接縫） | Michael Feathers 的術語：你可以在無需在該處進行編輯的情況下修改行為的位置。它是介面的*位置*，且將其放置何處是獨立於介面背後內容之外的決策。 | boundary |
| **Adapter**（轉接器） | 在接縫處滿足介面的具體事物。指定角色而非實體 — 記憶體內的 fake 與 Postgres repo 都是 adapter。 | — |
| **Leverage**（槓桿） | 呼叫者從深度中獲得的好處：每學習一個單位的介面就能獲得更多功能。 | — |
| **Locality**（區域性） | 維護者從深度中獲得的好處：變更、錯誤與驗證集中在一個地方。修復一次，到處修復。 | — |

刻意*不*將深度定義為實作程式碼行數與介面程式碼行數的比率（這是 Ousterhout 本人的定義）。該指標會獎勵填充實作內容。取而代之的是使用「作為槓桿的深度」（Depth-as-leverage）。

## 四項原則

- **深度是介面的屬性，而不是實作的屬性。** 深模組可以在內部由可互換的小部件建構。它們只是不呈現給呼叫者。模組可以擁有自己測試所使用的內部接縫，以及在其介面處的一個外部接縫。
- **刪除測試（The deletion test）。** 想像刪除該模組。如果複雜性消失了，它就是一個透傳（pass-through）。如果它在 N 個呼叫者中重新出現，說明它發揮了作用。
- **介面即是測試表面（The interface is the test surface）。** 呼叫者與測試穿過相同的接縫。如果你想*越過*介面進行測試，說明該模組的形狀不正確。
- **一個轉接器意味著假設的接縫。兩個轉接器意味著真實的接縫。** 在某事物跨越接縫發生實際變化之前，不要切出接縫。單一轉接器的接縫只是間接引用（indirection）。

兩個支援檔案進行了更深入的說明，且技能會按需讀取它們而非預先讀取。[DEEPENING.md](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DEEPENING.md) 對候選模組的依賴進行分類 — 進程內、本機可替代、遠端但自主擁有、真正外部 — 因為分類決定了深化後的模組如何跨越其接縫進行測試。[DESIGN-IT-TWICE.md](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DESIGN-IT-TWICE.md) 啟動平行 [sub-agents](https://www.aihero.dev/ai-coding-dictionary/subagent) 為同一個模組產生三個或更多截然不同的介面，然後在深度、區域性與接縫位置上對它們進行比較。

## 常見問題

**我該如何在 TypeScript 中實際建構深模組？**

這是關於該技能被詢問最多的問題，而該技能並未回答。它定義了深模組*是什麼*；它完全沒有提及如何阻止偏離的 import 越過介面。[Issue #458](https://github.com/mattpocock/skills/issues/458) 平實地指出：「假設我們對介面滿意，它隱藏了細節等。但我們該如何強制執行它？我認為如果沒有 linting 或清晰的防禦欄杆，人類與 LLM 都會隨著時間推移開始使其變得混亂。」Matt 在該討論串中的回答是三個選項：將其封裝在 class 或 IIFE 中並接受 class 變得龐大；將其設為 monorepo 中的 package 並接受 monorepo 工具；或使用像 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 這樣的 linter 來禁止繞過介面的 import。他另外稱 Effect 為最佳機制，dependency-cruiser 為第二好。儲存庫的 `in-progress/` 儲存區中有一個 `setup-ts-deep-modules` 技能，制定了 `src/packages/<name>/index.ts` 約定，但它是一個沒有文件頁面的 beta 渠道技能，且未附帶 lint 規則。

**我將工作階段指向它，結果它合成了 10 萬個 [tokens](https://www.aihero.dev/ai-coding-dictionary/token) 重新設計了我從未要求過的事物。**

這是已知問題，並已被記錄為 [issue #449](https://github.com/mattpocock/skills/issues/449)。該技能是由模型呼叫的，且將自身描述為詞彙表，但其中沒有任何內容能硬性阻止 agent 將其視為可執行的流程。當被告知「在 /codebase-design 中恢復並驅動開放的決策」時，agent 拿取了它能找到的最具行動導向的內容 — `DESIGN-IT-TWICE.md` 中的平行 sub-agent — 重新探索了前一個工作階段已經對映過的程式碼，並在詢問任何內容之前執行了很長時間。驅動技能所具備的防禦欄杆（檢查點、一次一個問題、不自動推進）在這裡都不存在，因為參考文件沒有這些欄杆。替代方案是指定一個驅動技能並讓此技能置於其下：以 `/grill-with-docs`、`/improve-codebase-architecture` 或 `/tdd` 作為驅動，並將 `codebase-design` 作為詞彙表。該議題目前處於開放狀態。

**`design-an-interface` 去了哪裡？是否有 `/interface-design` 技能？**

`design-an-interface` 已被移除並吸收至本技能中。沒有丟失任何內容：其「設計兩次（design it twice）」技巧 — 來自 Ousterhout 的平行 sub-agent 產生截然不同的設計 — 在此處作為 `DESIGN-IT-TWICE.md` 發布。另外，有好幾個人要求針對深模組/薄介面理念提供專用的 `/interface-design` 技能；該理念已經存在於此，且未計畫開發獨立的技能。如果你是前來尋找這兩個名稱中的任何一個，這就是對應的頁面。

**這難道不是一種檔案結構約定 — 資料夾、barrel files、功能切片（feature slices）？**

不是，且該技能在反複的質疑聲中堅守了這一立場。[Issue #95](https://github.com/mattpocock/skills/issues/95) 提出了形式化的碎形樹（fractal-tree）檔案結構作為深模組的具體實作；回覆是兩者是正交的 —「深模組關乎介面的設計以及透過嚴格介面進行存取，無論檔案系統看起來如何。在這種方法下完全有可能擁有淺模組。」#458 中也出現了相同的觀點：「我認為你可能將模組的概念與檔案系統綁定得太緊密了。檔案系統當然可以作為模組形狀的有用提示，但在建構深模組時不需要使用檔案系統。」術語表刻意將**模組（module）**定義為與規模無關。

**`tdd` 實際上會使用這個詞彙表嗎？**

現在會了。在很長一段時間裡它並沒有。過去存在於 `tdd` 內部的內聯深模組筆記在 v1.0 中被移除，取而代之的是這個共享技能，但替換它們的指標從未被新增 — 因此 `tdd` 為自己定義了「接縫」，且沒有引用任何內容。這個缺口現已封閉：指標現在位於技能中，當介面的形狀而非測試是開放性問題時就會觸及該指標。`tdd` 仍然將「接縫」擁有所為你進行*測試*的邊界；而本技能則擁有其背後的模組形狀。

**設計兩次（design-it-twice）模式在 Claude Code 之外能運作嗎？**

無法乾淨地運作。`DESIGN-IT-TWICE.md` 指出「使用 Agent 工具平行產生 3 個以上的 sub-agent」，這是以 Claude Code 的 [tool](https://www.aihero.dev/ai-coding-dictionary/tool) 命名。儲存庫發布了其他 [harnesses](https://www.aihero.dev/ai-coding-dictionary/harness)（包括 Codex）的 metadata，而這些可能在該名稱下沒有暴露任何內容 — 因此平行設計階段的可攜性低於技能 metadata 所暗示的程度。在 [issue #564](https://github.com/mattpocock/skills/issues/564) 中追蹤，目前處於開放狀態。

**我可以將自己的概念新增至術語表中嗎 — 正向共生性（connascence）、模組秘密（module secrets）、[漸進式揭露](https://www.aihero.dev/ai-coding-dictionary/progressive-disclosure)？**

人們確實提出了這些建議。[Issue #180](https://github.com/mattpocock/skills/issues/180) 新增了 Parnas 的模組秘密以及 Page-Jones 的共生性，作為跨越接縫洩漏的*內容*的命名層，並附帶了可運作的 diff；[issue #303](https://github.com/mattpocock/skills/issues/303) 提議在實作內部進行漸進式揭露，這樣一個在公開介面處很深的模組在底下就不會是一整塊無區別的板塊。兩者目前都處於開放且未合併狀態。發布的術語表刻意保持精簡，而保持精簡的原因在技能本身中已指出：一致的語言才是重點，而無人一致使用的術語比沒有術語更糟糕。

## 運作正常的指標

- 設計對話不再產生「component」、「service」與「boundary」等字眼，並開始產生「module」、「interface」與「seam」。
- 有人能指向提議的提煉（extraction）並毫不含糊地說明它是否通過了刪除測試。
- 提議的接縫附帶了第二個指定的 adapter，而不僅僅是第一個。
- 對介面的討論涵蓋了不變性、順序與錯誤模式 — 而不僅僅是型別簽名。
- 呼叫它不會開始一個工作階段。如果 agent 單憑 `/codebase-design` 就開始讀取檔案並提出重構建議，說明它誤將參考檔案當成了驅動者。

## 適用位置

`codebase-design` 是一個**隨時可用的獨立技能**，且是工程技能底層的詞彙層，而不是任何鏈結中的步驟。它最接近的鄰居是 [domain-modeling](https://aihero.dev/skills-domain-modeling)，這是針對*問題領域*詞彙而非模組形狀的平行參考文件 — 兩者通常需要一起使用，因為良好地命名深模組需要這兩者。[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 是另一個：它調查程式碼庫以尋找深化候選者，並將每一個候選者寫入此術語表中，因此它找到模組，而本技能則是你設計它的工作台。當你不確定適合哪個技能或流程時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你進行路由。
