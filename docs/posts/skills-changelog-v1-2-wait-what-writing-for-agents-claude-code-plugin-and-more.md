# v1.2: /wait-what, /writing-for-agents, Claude Code 外掛程式，以及更多

<iframe width="560" height="315" src="https://www.youtube.com/embed/gaDdrDdczO4?si=h46qVO7gQRVzF5kv" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

我的 Skill 1.2 版本已經發布。它將 Skill 作為 Claude Code 外掛程式發佈，為每個 Skill 新增了 Codex Metadata，並將整個套件置於 [aihero.dev/skills](https://aihero.dev/skills) 的文件網站下。外掛程式新增了三個 Skill，一個已重新命名，六個已被移除。

完整的變更集位於 [v1.2.0 版本發布](https://github.com/mattpocock/skills/releases/tag/v1.2.0)。
此頁面涵蓋為您帶來的變更。

## 每個 Skill 上的 Codex Metadata

每個 `SKILL.md` 旁邊現在都有一個 `agents/openai.yaml`。該 sidecar 攜帶了 Codex UI Metadata（`interface.display_name`、`interface.short_description`），因此該套件在兩種環境中都能運作，無需產生副本。

該檔案中的重要一行是 `policy.allow_implicit_invocation: false`。它是
`disable-model-invocation: true` 在 Codex 中的對應項目。每個由使用者呼叫的 Skill 現在
都帶有此設定，因此 Codex 會將該 Skill 排除在 Agent 的上下文之外，直到您輸入
`$skill`。在此版本之前，使用者呼叫與模型呼叫的劃分僅在 Claude
Code 中有效，而在 Codex 中無效。

`AGENTS.md` 是指向 `CLAUDE.md` 的符號連結，因此 Codex 會讀取相同的儲存庫指示。

## 位於 aihero.dev/skills 的文件

![位於 aihero.dev/skills 的新文件網站](https://res.cloudinary.com/total-typescript/image/upload/v1785944102/ai-hero-images/dj54xx1bhly29e6vwibz.png)

從 `/skills` 開始並閱讀分組。主要流程為 `/grill-with-docs` →
`/to-spec` → `/to-tickets` → `/implement` → `/code-review`。左側面板是每個
Skill 的完整參考。

每個頁面都包含 **常見問題** 區段（源自人們實際問我的問題 Wiki），以及 **運作正常的徵兆** 區段。術語的首次使用會連結至 AI 編程辭典，例如 ticket 連結會導向我對 ticket 的定義。您可以閱讀文件以學習各項 Skill，或了解 AI 編程如何運作。

## 重大變更：`/writing-great-skills` → `/writing-for-agents`

請使用新名稱重新安裝。沒有別名，舊名稱已被移除。

重新命名遵循了其涵蓋範圍。該參考資料現在涵蓋 Agent 所取用的任何文件，包括 Skill、`AGENTS.md`、`CLAUDE.md` 以及透過指標到達的文件，而不僅僅是 Skill。使用它可將過載的 `AGENTS.md` 拆分為多個 Skill，從而避免前置載入過多內容。

隨之而來的三個結構性變更：

- `GLOSSARY.md` 已合併至 `SKILL.md`。每個術語只有一份權威性說明。
- 僅限 Skill 的機制（frontmatter、模型呼叫 vs 使用者呼叫、路由器 Skill、呼叫分界）移至 `SKILL-MECHANICS.md`。
- 此 Skill 改為由模型呼叫。當您建立或編輯 Skill，或是修改 `AGENTS.md` / `CLAUDE.md` 時會觸發。

修剪區段新增了一個新詞彙：**快取**。環境是唯一的真實來源：`package.json` 指令稿、設定檔、目錄配置、`--help` 輸出。重述它們的文件只是查詢的快取，只有在查詢成本高昂時才值得載入。請快取 Agent 無法直接透過檢視找到的內容、不成文的慣例、選擇背後的原因，以及沒有任何設定透露的邊界案例。將單一檔案、單一指令的查詢留給環境，在那裡它們不會過期。

## 新增：`/wait-what`

用於修正模型過度冗長的單字指令。在訊息無法被清楚理解的瞬間輸入它。
Agent 會重新調整表達方式：提供少許上下文、使用 ASD-STE100 簡化技術英文
以及來自您 `CONTEXT.md` 的通用語言。由使用者呼叫，
僅有三行長度。

其運作機制即在於名稱本身。簡潔度 Skill 常因內容增長而失效——400 行的 Skill 仍會
讓模型冗長發言——因此這個 Skill 僅為單一精確的前導詞，別無其他。
描述*輸出成果*的名稱（`/tldr`、`/no-fluff`）會讓模型刪減字句並使您更加迷失。
命名*聆聽者*的狀態則能同時滿足兩方面的需求：減少字數，**並且**補足您所
遺漏的上下文。

它修復單一訊息，但無法防止下一則訊息再次冗長。術語問題的根治方法是預先
透過 `/grill-with-docs` 建立共享語言。當您尚未建立共享語言時，請使用
`/wait-what`。

## 新增：`/wizard`

![在終端機中執行的互動式 bash 精靈，顯示「準備開始」提示](https://res.cloudinary.com/total-typescript/image/upload/v1785944103/ai-hero-images/tjf1n5eaksf50ujr3smh.png)

`/wizard` 從 `in-progress/` 畢業並歸入 **Engineering** 分類，且由
模型呼叫。

它會產生一個互動式 bash 指令稿，引導人工完成手動程序、第三方設定、一次性遷移、A→B 狀態轉換。該指令稿會開啟每個 URL、說明該點擊什麼、擷取您貼上的數值，並將它們寫入 `.env` 檔案與 GitHub Actions 機密中。這是一個確定性的指令稿，因此您輸入的機密絕不會傳遞給 Agent。

使用者體驗已由隨附的 `template.sh` 預先解決：具有剩餘時間的進度顯示、
確認關卡、跨平台 URL 開啟（包含 WSL）、隱藏的機密輸入、
冪等的 `.env` 更新、具備平緩降級機制的
`gh secret` / `gh variable` 寫入，以及結尾的略過摘要。
位於 `STAGES` 標記之上的所有內容皆為固定函式庫，絕不進行手動編輯。
此 Skill 的工作是定義程序範圍並撰寫其階段。

由模型呼叫意味著 Agent 在遇到只有人類能執行的步驟時，會立即取用 `/wizard`，而不是在對話中傾倒編號指示。輸入 `/wizard` 的運作方式與先前完全相同。說明中指明了四個觸發分支（佈署基礎架構、設定憑證或 CI 機密、瀏覽陌生的第三方儀表板、一次性遷移或切換），以及一個明確的不觸發條件：請勿針對 Agent 自身能執行的步驟呼叫它。Agent 能做的工作，就應由 Agent 來做。`/wizard` 是為了您不願交給 Agent 的點擊、審批與儀表板操作而設計。

## 新增：`/to-questionnaire`

`/to-questionnaire` 從 `in-progress/` 畢業並歸入 **Productivity** 分類。

它將您無法單獨回答的決策轉換為 Markdown 問卷，供唯一能夠回答該問題的
對象填寫。可非同步填寫，或在會議中共同完成。這是我在針對花園辦公室進行
`/wayfinder` 階段時建構的：Agent 正在審問我，但真正該詢問的
對象是我太太。該問卷被放入 Google 文件中，我們共同完成它，
並將答案回傳給 Agent。

其代表性作法在於它審問的是**發送目標**，而非主題本身。一般的審問階段會
詢問該主題的細節，而這正是您在此無法回答的。因此訪談只詢問問卷發送給誰
以及您需要取回什麼，
接著將每個問題聚焦於兩者之間的差距。

`/ask-matt` 將其定義為 `/grill-me` 的反向操作：挖掘他人，而非挖掘自己。

## 變更：`/grilling` 採回合制提問

`/grilling` 從一次一個問題轉變為按回合提問。相同的 13 個問題大約在
3 個回合內完成，而非經歷 13 次對話往返。

該 Skill 將工作繪製為**設計樹**：每個決策都會分支出依附於它的決策。**前沿**是先決條件已解決的所有決策，亦即它現在可以提出而無需猜測尚未聽到的答案的問題。它將整個前沿作為一個帶編號的回合提出，然後根據您的答案重新計算前沿並提出下一回合。答案依賴於另一個仍未解決的問題者屬於後續回合。當前沿為空時，該階段結束。

環境能回答的事實會交給子 Agent，因此研究絕不會阻礙回合進行。
執行中的探索是尚未確定的先決條件：僅有其下游的問題需要等待，
前沿的其餘部分則可立即提問。決策權始終在您手中。

回合中的每個問題都使用固定格式：

```
❓ **Q1** - **<問題標題>**: <問題內文，可能包含多個段落，包括多選題>

➡️ <您的建議答案>
```

一個回合讀起來就像是一份可快速掃描的編號清單，每個建議與其問題分開。您按編號回答（「Q1 同意，Q2 同意，Q3 修改此處」），這非常適合聽寫輸入。

`/grill-me`、`/grill-with-docs` 與 `/triage` 也採用按回合執行前沿的方式。
選擇退回一次一個問題的設定保持不變：在您的全域
`CLAUDE.md` 中新增一行即可。

`/grilling` 也針對通用用途進行了措辭調整。「這份計畫」變為「這項內容」，「執行計畫」
變為「對其採取行動」，而「探索程式碼庫」變為「探索環境」。
技巧保持不變。它現在讀起來就像是對任何計畫、
決策或構想的壓力測試。

## 變更：`/prototype` 產生單一可共享的 HTML 檔案

邏輯分支現在會產生單一獨立檔案（純 HTML、CSS 與 JS，無需建置也無需伺服器），而非終端機應用程式。非開發人員可透過按兩下開啟它，並在他們自己的領域語言中操作：標記清楚的狀態面板、隨時可用的自由操作按鈕，以及分頁式的**引導式逐步解說**（每個都是一個情境，下方有按順序排列的按鈕）。可攜帶的純邏輯模組仍可移植到真實程式碼中。HTML 外殼則是拋棄式的。

拋棄式不再意味著被刪除。`/prototype` 輸出會作為可執行的佐證擷取至從 main 分支出的 `prototype/<name>` 分支上，並在實作 Issue 上提供指向它的上下文指標。Main 只保留經過驗證的決策，而探索過程保持可被搜尋。解答（結論加上問題）仍記錄在 Issue、ADR 或 commit 中。

## 變更：`/wayfinder` Ticket 為決策 Ticket

人們常將 `/wayfinder` Ticket 誤讀為一般的實作 Ticket（要執行的建置切片）。`/wayfinder` 將它們作為**決策 Ticket**：其解決方案為決策的問題。Skill 說明、其開篇第一行、README 簡介以及文件頁面現在都介紹了此術語。一旦確立術語，「Ticket」仍為日常用詞，而 `CONTEXT.md` 將**決策 Ticket** 記錄為領域術語。

研究 Ticket 不再擱置至單獨階段。研究仍為真實的
Ticket 類型，因為它是下游決策所依賴的真正共享阻礙。改變的是其解決方式。
研究屬於離線任務，因此繪製地圖不會停下來閱讀它：建立 Ticket 後，
繪圖階段會為每個研究 Ticket 啟動 `/research` 子 Agent
並平行處理消化它們，在帶有上下文指標的
`research/<name>` 分支上擷取研究發現。
研究 Ticket 是每個階段處理一個 Ticket 規則的唯一例外。

## 變更：`/ask-matt` 路由

路由器增加了**階段邊界**。階段是指單一工作階段內的一大塊工作（審問、實作、品管），而兩個階段之間的邊界是您決定如何處理所建構上下文的地方。舊有的兩個項目符號區段現在是一個包含所有五個選項（按順序排列）的決策樹：**繼續**、`/clear`、`/handoff`、**子 Agent**、`/compact`。其背後的推論在 `PHASE-BOUNDARIES.md` 中揭示。隨之而來的三項修正：

- **`/handoff` 被過度吹捧。** 它的適用範圍很窄。您只有在某些內容必須*轉移*時才需要它（新的環境、新的目錄、同事，或是在階段中途分岔的次要任務）。
- **`/compact` 是預設選項，而非首選。** 它位於決策樹底部。從它開始會讓您的階段對摘要所扁平化的任何內容產生過度自信的錯誤認知。
- **先前缺少了兩個分支。** 請先排除**繼續**選項，這是唯一將對話保留為主要來源而非摘要的作法。**子 Agent** 則處理任何範圍劃分得足夠緊湊以進行離線執行的工作。

上下文衛生的應急方案現在顯示為 `/compact` 而非 `/handoff`，且聰明區間數字
從 ~120k 移動到 ~150k 個 token。

`/wayfinder` 路由修復了人們在處理最繁重流程時最常犯的兩個錯誤。
**過度濫用它**：`/wayfinder` 比單次審問更慢且更密集，因此它是專門為真正
無法容納於單一階段的構想而保留的。範圍明確的功能屬於 `/grill-with-docs`。
**在交接時迷失方向**：當地圖清晰時，`/wayfinder` 進行交接，它並不負責建置。
在 `/to-spec` 處合併至主要流程，這會將地圖上連結的決策摺疊為可建置的計畫。
只有在工作確實非常小時，
才直接進行 `/implement`。

`/grilling` 與 `/resolving-merge-conflicts` 先前未出現在路由器中，現在已加入。
`/grill-me` 依據您是否在工作目錄中而與 `/grill-with-docs`
劃分開來。

## 變更：較小的項目

- **`/improve-codebase-architecture`** 在其 Explore 步驟中增加了 YAGNI 範圍篩選器。它不再均勻掃描儲存庫。指明方向它就會朝該方向進行；否則它會讀取最近約 20 條提交訊息，並偏向探索積極開發中的路徑。在無人觸碰的程式碼中尋找深化機會是一種永遠無法兌現的重構，因此報告不再整理休眠的角落。
- **`/setup-matt-pocock-skills`** 更加親民。只有在安裝了 `/triage` 時才會詢問分級標籤，並且作為一個推薦為「是」的問題。外部 PR 作為請求介面不再是一個問題，該旗標預設為關閉。領域文件預設為單一上下文，除非儲存庫顯示出 monorepo 跡象。本機 Markdown Ticket 在 `.scratch/<feature>/issues/<NN>-<slug>.md` 下為每個 Ticket 一個檔案，規格檔案則為 `spec.md`。
- **`/to-prd` → `/to-spec` 的重新命名已完成。** 「Spec」是發佈文字中的唯一
  術語。`/to-spec` 刪除了「您可能將此稱為 PRD」的開篇引言，
  `/code-review` 改為談論原始 Issue／規格，而 GitHub 與 GitLab
  追蹤工具範本不再將「PRDs」寫入它們接觸的每個儲存庫中。

## 移除：六個 Skill

這六個 Skill 都不在 Claude Code 外掛程式中，但全部都可以透過
[skills.sh](https://skills.sh/mattpocock/skills) 安裝，該網站提供儲存庫中的
每個 Skill。其中四個被更能勝任該工作的 Skill 吸收：

- **`/ubiquitous-language`** → **`/domain-modeling`**，它維護整個領域模型，而不是從單一對話中傾倒詞彙表。
- **`/design-an-interface`** → **`/codebase-design`**。未遺失任何內容：
  設計兩次的技巧在該 Skill 內部作為 `DESIGN-IT-TWICE.md` 發布。
- **`/qa`** → **`/triage`** 與 **`/to-tickets`**。
- **`/request-refactor-plan`** → **`/to-spec`** 與 **`/improve-codebase-architecture`**。

有兩個一直都僅供我個人使用，綁定於我自己的機器。`personal/` 分類也隨之
移除：**`/edit-article`** 與 **`/obsidian-vault`**。

`skills/deprecated/` 保留為空分類。`skills/in-progress/` 保持不變，
現在依其本質進行描述：一個刻意發布的 Beta 頻道，可透過 skills.sh
一次安裝一個 Skill。

---

[翻譯自 AI Hero](https://www.aihero.dev/skills/skills-changelog-v12-wait-what-writing-for-agents-claude-code-plugin-and-more)
