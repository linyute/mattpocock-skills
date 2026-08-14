## 功能說明

`ask-matt` 是此儲存庫中技能的路由器。你描述自己所處的狀況 — 無法開始的想法、一堆傳入的錯誤報告、執行過長的工作階段（[session](https://www.aihero.dev/ai-coding-dictionary/session)） — 它會指定適合的技能或技能序列，以及該序列中人類決策所在之處。

它給出建議後即停止。它不會審問、撰寫規格（[spec](https://www.aihero.dev/ai-coding-dictionary/spec)）、開啟檔案或觸發它剛指定的技能；你獲得的回應是下一個要輸入的內容，然後由你輸入它。它也是此儲存庫中技能的手寫地圖，而不是掃描你已安裝的內容，因此它不會為你路由你自己的技能或其他作者的技能。

## 何時使用

你透過輸入 `/ask-matt` 來呼叫此技能 — agent 不會自行主動使用它。

| 你的狀況 | 路由器回傳的內容 |
| --- | --- |
| 有一個想法，但不知道從何開始 | 主要流程的起點，以及建構規模是否小到可以跳過規格 |
| 來自其他人的錯誤與需求 | [triage](https://aihero.dev/skills-triage) 入口，以及為什麼你自己產生的 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) 不屬於該流程 |
| 兩個看起來可互換的技能 | 它們之間的界線，這通常是一個具體的測試而非品味問題。[grill-me](https://aihero.dev/skills-grill-me) 或 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 取決於你是否在工作目錄中；[grill-with-docs](https://aihero.dev/skills-grill-with-docs) 或 [wayfinder](https://aihero.dev/skills-wayfinder) 取決於工作量是否適合單一工作階段 |
| 漫長的工作階段以及關於 [context](https://www.aihero.dev/ai-coding-dictionary/context) 的決策 | 階段邊界處五個選項的有序樹 |
| 你已經選定的技能 | 沒有有用的內容。請直接呼叫該技能。 |

## 先決條件

路由器負責指定技能；它不會安裝技能。它所指向的一切都必須先安裝，該建議才能付諸實行，且它只知道此儲存庫中已推廣的技能。

依賴追蹤器的路由 — triage、`to-spec``to-tickets``implement` — 假設 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 已在儲存庫中設定了議題追蹤器。在此之前，路由器仍會樂於推薦它們。

## 是流程，而不是單一技能

此技能引導你思考的核心字眼是**流程**（flow）：一條*穿過*多個技能的路徑，而不是單一技能。描述你的狀況會將你置於某個流程的特定步驟上，這與「這是符合你關鍵字的技能」是不同的答案。存在四種路由，且技能本身完整包含它們：

- **主要流程**，從想法到交付。審問、規格、ticket、實作、審查，其中包含兩個分支：當問題需要可執行的程式碼來釐清時的原型繞道，以及規格與 ticket 分離的分支，這僅在建構跨越一個以上的工作階段時才值得其成本。
- **入口流程**，用於產生工作然後合併至主要流程的狀況：傳入的錯誤報告、損壞的事物，或者過於模糊且規模過大而無法在單一工作階段中容納的工作。
- **獨立技能**，不在任何流程中，按其自身需求使用 — 原型、問卷、你已經陷入的合併衝突。
- **底層的詞彙層**，當問題在於字詞而非流程時，其他技能所引用的兩個參考。

## 階段邊界

它交給你的另一個概念是**階段邊界**。階段是工作階段中的一大塊工作 — [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（審問）、實作、QA — 而兩者之間的邊界是唯一適合提出「我該如何處理這個 context？」問題的地方。在階段中途沒有什麼好決定的：繼續執行，或者將剩餘部分拆分為 [subagents](https://www.aihero.dev/ai-coding-dictionary/subagent)（子 agent）。

| 選項 | 使用時機 |
| --- | --- |
| **Continue** | 下一個階段需要逐字保留此階段內容，或者你還有 [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone) 剩餘。這是唯一能將工作階段保留為 [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source)（第一手來源）的操作，因此請先排除其他可能 |
| **`/clear`** | 你背後的一切都是可丟棄的。這是面板上成本最低的操作，而且如果你弄錯了則是單向不可逆的 |
| **[handoff](https://aihero.dev/skills-handoff)** | 有事物需要轉移：新的 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)、新的目錄、同事、階段中途分出的旁支任務 |
| **Subagent** | 任務範圍足夠緊湊，可以在你[離開鍵盤](https://www.aihero.dev/ai-coding-dictionary/afk)時執行 |
| **`/compact`** | 以上皆非。這是預設選項，且經常落在這裡 |

其中有兩個選項經常被搞錯，這就是為什麼路由器提供順序而非僅僅是清單。`/handoff` 看起來像視窗之間的一般橋樑，但事實並非如此：可攜性是它所帶來的全部好處。`/compact` 是樹的底部而非首選，因為它上面的四個問題各自都更便宜或更精準。

## 常見問題

**難道就沒有一個按正確順序排列的技能清單嗎？**

人們不斷在 README 中要求提供這類清單。本技能就是那個清單 — 這就是它存在的目的。靜態表格會顯示 `wayfinder → to-spec → to-tickets → implement → code-review`，但這在大多數情況下都是錯誤的，因為有趣的部分在於分支 — 是否存在程式碼庫、建構是否跨越工作階段、這個問題是否可以透過對話解決。坦白的代價是路由器是人工維護的，且落後於儲存庫。`/grilling` 與 `/resolving-merge-conflicts` 都在路由器列出它們之前很久就發布了。

**它告訴我有一半的技能未安裝。**

這是一個已知且未修復的錯誤。路由器為你指引的大多數技能都設定了 `disable-model-invocation: true`，這意味著 harness 在注入 agent context 的技能清單中排除了它們。Agent 將該清單視為完整的並回報它們缺失。在一個回報的工作階段中，它宣告整個 spec-and-tickets 流程不存在，並重新路由至單純的 `/grilling` 與 `/tdd`。外掛程式 22 個技能中有 13 個帶有此標記，因此這是常見情況而非邊緣情況。它們其實已安裝。直接輸入斜線指令，或檢查 `.claude-plugin/plugin.json`，那是確認存在哪些內容的權威來源。

**它描述了某個技能的行為，但該技能並沒有那樣做。**

這也是真實存在且未修復的問題。路由器根據自己對每個技能的一行摘要進行回答，而非根據技能本身。一份詳細報告追蹤了單一工作階段中的三個實例，包括基於「將對話紀錄轉換為規格」的註解而建議跳過 [to-spec](https://aihero.dev/skills-to-spec) — `to-spec/SKILL.md` 從未被開啟。在每種情況下，它只有在使用者提出質疑後才進行驗證，從未主動驗證。在該處跳過 `to-spec` 付出了失去真實接縫檢查（seam check）的代價，產生的 ticket 少算了工作量。當路由器對另一個技能斷言某些關鍵行為時，請先要求它開啟該 `SKILL.md`。這同樣適用於地圖完全未涵蓋的問題，例如是否使用 [plan mode](https://www.aihero.dev/ai-coding-dictionary/agent-mode)：該答案是 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）的推論，而不是寫在這裡的內容。

**為什麼它是散文體而不是有編號的檢核表？**

這是一個合理的抱怨，已記錄為開放議題，主張大多數路由是確定的，而敘述性文字使其難以快速瀏覽。沒有什麼能阻止你要求精簡形式 —「直接給我順序」就能為你提供順序。散文體所承載的是條件式的後半部分：分支、預期需要人類決策的地方，以及步驟之間何時 clear 或 compact。平鋪直敘的檢核表恰恰丟失了這些內容。

**它可以為我自己的技能或其他作者的技能進行路由嗎？**

不行。有三個獨立提案要求建立一個能讀取你本機 `skills/` 目錄並從已安裝內容中提供建議的路由器。`ask-matt` 不是那種路由器。它是一套手動維護的特定地圖，對你撰寫或從其他地方安裝的技能一無所知。

**它告訴我編輯 SKILL.md。**

該建議通常是正確的，但很少持久。有人詢問如何讓 [implement](https://aihero.dev/skills-implement) 關閉 ticket，被告知在技能中新增一行，並立即發現了問題：`npx skills update` 會覆寫該檔案，而且外掛程式安裝是唯讀的。請將常駐行為放在你自己的 `CLAUDE.md` 或 `AGENTS.md` 中，或在呼叫時說明。Prompt 層級的調整可以在更新後保留 — 將流程指向 Linear 而非 GitHub，或詢問哪些開放的 ticket 可以平行執行，都是人們以此方式處理的事物。

**它指定了一個我沒有的技能，或者漏掉了一個我擁有的技能。**

在假設它已消失之前，請先檢查變更日誌是否有重新命名。`writing-great-skills` 變成了 [writing-for-agents](https://aihero.dev/skills-writing-for-agents)（沒有別名），`to-prd` 變成了 [to-spec](https://aihero.dev/skills-to-spec)，而 `pathfinder` 變成了 [wayfinder](https://aihero.dev/skills-wayfinder)。有四個技能被直接廢除並整合進吸收它們的技能中：`ubiquitous-language`、`design-an-interface`、`qa` 以及 `request-refactor-plan`。相反的情況則是上面提到的路由器自身的滯後。

## 運作正常的指標

- 它以指定要輸入的內容結尾並停在那裡，而不是自己開始工作。
- 它回傳的路由提到了何時 clear 或 compact context 以及預期你在何處進行審查，而不僅僅是技能名稱清單。
- 在兩個技能相似的地方，它會說明選哪一個以及為什麼另一個不適合你。
- 它對另一個技能行為所作的任何主張，都會在追蹤紀錄中顯示為它讀取了該技能的 `SKILL.md`。
- 你能在它回傳的內容中認出你自己的狀況，而不是最接近的通用情境。

## 適用位置

`ask-matt` 是一個涵蓋整個集合的**獨立路由器**。它絕不是鏈結中的一個步驟；它指向每個鏈結，並且是其他文件頁面連結回的節點，因此它們都不必重新繪製圖表。從這裡你最常落腳於主要流程的起點 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，或傳入工作（而非你開始的工作）的入口 [triage](https://aihero.dev/skills-triage)。

它是其所描述技能的 [secondary source](https://www.aihero.dev/ai-coding-dictionary/secondary-source)（第二手來源）。當路由器與 `SKILL.md` 不一致時，以 `SKILL.md` 為準。
