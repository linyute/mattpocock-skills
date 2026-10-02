## 功能說明

`ask-matt` 是此儲存庫中各項技能的路由器。你描述自己所處的情境（無法著手的點子、一堆剛收到的錯誤報告、或是執行時間過長的 [session](https://www.aihero.dev/ai-coding-dictionary/session)），它就會指出適合的技能或技能序列，並說明人工決策在該序列中應置於何處。

它只負責推薦並隨即停止。它不會進行盤問、撰寫 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)、開啟檔案或觸發剛指定的技能；你得到的是下一步要輸入的指令，然後由你自行輸入。它也是此儲存庫中技能的手寫對應圖，而非掃描你已安裝的項目，因此它不會為你自己的技能或其他作者的技能進行路由。

## 何時使用

你可以透過輸入 `/ask-matt` 來呼叫它；agent 不會主動使用它。

| 你的情境 | 路由器回傳的內容 |
| --- | --- |
| 有個點子，但不知從何著手 | 主要流程的起點，以及建構規模是否小到可以略過 spec |
| 收到其他人提出的錯誤與需求 | [triage](https://aihero.dev/skills-triage) 銜接匝道，以及為何你自己產生的 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) 不屬於此處 |
| 兩項看似可互換的技能 | 兩者之間的界線，且通常是一項具體測試而非喜好問題。[grill-me](https://aihero.dev/skills-grill-me) 還是 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 取決於你是否處於工作目錄中；[grill-with-docs](https://aihero.dev/skills-grill-with-docs) 還是 [wayfinder](https://aihero.dev/skills-wayfinder) 則取決於工作量是否能在單一 session 內完成 |
| 漫長的 session 以及關於 [context](https://www.aihero.dev/ai-coding-dictionary/context) 的決策 | 階段邊界處五個選項的排序決策樹 |
| 你已經選定的技能 | 沒有實質幫助。請直接呼叫該技能。 |

## 先決條件

路由器僅指出技能名稱，並不會安裝它們。它指向的所有內容都必須預先安裝，建議才能化為實際行動，而且它只認識此儲存庫中推廣的技能。

依賴 issue tracker 的路由（triage、`to-spec`、`to-tickets`、`implement`）假設 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 已在儲存庫中設定好 issue tracker。但即使尚未設定，路由器仍會照樣推薦它們。

## 流程，而非單一技能

這項技能讓你思考的核心詞彙是**流程（flow）**：一條*穿梭於*各技能間的路徑，而非單一技能。指出你的情境會將你帶入某個流程的特定步驟中，這與「這是符合你關鍵字的技能」是截然不同的答案。共有五種路由類型，該技能本身完整包含了這些路由：

- **主要流程**，從點子到交付。盤問、規格、票券、實作（一次處理一張票券，或使用 [implement-spec](https://aihero.dev/skills-implement-spec) 平行處理整個任務圖）、審查，接著是 [retro](https://aihero.dev/skills-retro)，將建構過程所學回饋到 agent 的環境中。其中包含兩個分支：當問題需要可執行的程式碼來確認時的原型（prototype）繞道，以及 spec 與 tickets 的拆分——只有當建構跨越多個 session 時，這項拆分才值得付出相應成本。
- **銜接匝道（On-ramps）**，適用於產生工作隨後併入主要流程的情境：收到的錯誤報告、損壞的功能，或是過於模糊且龐大以致單一 session 無法涵蓋的工作。
- **程式碼庫健全度**，著重維護而非功能開發：[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 檢視程式碼以尋找深入改善的機會，發現的每個項目都會作為點子重新進入主要流程。
- **獨立技能（Standalones）**，獨立於所有流程之外，依其自身需求調用：原型、問卷、研究執行。
- **底層的詞彙層**，當問題在於字詞而非流程時，其他技能所引用的兩份參考資料。

## 階段邊界

它賦予你的另一個概念是**階段邊界（phase boundary）**。階段是 session 內的一塊工作（[grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)、實作、QA），而兩者之間的邊界是唯一適合提出「我該如何處理這個 context？」問題的地方。在階段中途無需抉擇：繼續進行，或將剩餘工作分拆至 [subagents](https://www.aihero.dev/ai-coding-dictionary/subagent)。

| 選項 | 使用時機 |
| --- | --- |
| **Continue** | 下一個階段需要完整沿用當前內容，或者你仍有剩餘的 [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)。這是唯一能讓 session 保持為 [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source) 的做法，因此應優先考慮或予以排除 |
| **`/clear`** | 先前所有的內容皆可拋棄。這是成本最低的操作，但若判斷錯誤則無法復原 |
| **[handoff](https://aihero.dev/skills-handoff)** | 有內容需要轉移：新的 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)、新目錄、同事、或階段中途分支出來的次要任務 |
| **Subagent** | 任務範圍界定得足夠明確，讓你可以[暫離鍵盤](https://www.aihero.dev/ai-coding-dictionary/afk)由它執行 |
| **`/compact`** | 以上皆非。這是預設做法，且經常落入此選項 |

其中有兩項經常被誤用，這也是為何路由器提供的是決策順序而非單純清單。`/handoff` 看似視窗間的一般橋樑，但實則不然：可攜性是它帶來的全部價值。`/compact` 是決策樹的最底層而非首選，因為排在它前面的四個問題各自具有更低成本或更高精確度。

## 常見問題

**難道沒有一份按正確順序排列的技能清單嗎？**

人們不斷在 README 中尋求此清單。本技能正是這份清單：這就是它存在的目的。靜態表格會寫成 `wayfinder → to-spec → to-tickets → implement → code-review → retro`，但在多數情境下都是錯誤的，因為真正關鍵的是分支：是否存在程式碼庫、建構是否跨越 session、這個問題是否能透過討論來解決。坦白說，代價在於路由器是人工維護的，且進度落後於儲存庫。`/grilling` 在路由器提及它之前很早就已經釋出了。

**它告訴我有一半的技能未安裝。**

這是一個尚未修復的已知錯誤。路由器引導的大多數技能都設定了 `disable-model-invocation: true`，這表示 harness 會將它們排除在注入 agent context 的技能清單之外。agent 將該清單視為完整清單並回報它們缺失。某個回報的 session 中，agent 宣稱整個 spec-and-tickets 流程都不存在，並重新路由至單純的 `/grilling` 與 `/tdd`。外掛程式的 27 個技能中有 16 個帶有此旗標，因此這是常見情況而非特例。它們確實已安裝。直接輸入斜線指令即可，或者檢查 `.claude-plugin/plugin.json`，那是確認存在項目的權威依據。

**它描述了某項技能的行為，但該技能並沒有該行為。**

這同樣是真實存在且尚未修復的問題。路由器是根據其自身對每項技能的單行摘要回答，而非依據技能本身。一份詳細報告追蹤了單一 session 中的三個案例，包括僅憑「將討論串轉為 spec」的簡述就建議略過 [to-spec](https://aihero.dev/skills-to-spec) 的說法：`to-spec/SKILL.md` 根本從未被開啟過。在每個案例中，它都是在使用者提出質疑後才進行驗證，從未主動確認。在該處略過 `to-spec` 導致錯失了真正的交界處檢查，產出的票券也低估了工作量。當路由器對另一項技能提出關鍵斷言時，請先要求它開啟該 `SKILL.md`。這同樣適用於該地圖完全未涵蓋的問題，例如是否使用 [plan mode](https://www.aihero.dev/ai-coding-dictionary/agent-mode)：該答案是[模型](https://www.aihero.dev/ai-coding-dictionary/model)的推論，而非此處所記載的內容。

**為什麼是用散文撰寫而不是編號檢查清單？**

這項合理的抱怨已作為開放 issue 提出，認為多數路由都是確定性的，而敘述性文字難以快速瀏覽。沒有什麼能阻止你要求精簡格式：「直接給我順序」就能取得序列。散文所承載的是條件式的部分：分支、何處需要人工決策、以及在步驟之間何處應執行 clear 或 compact。扁平的檢查清單恰恰會遺漏這些。

**它可以為我自己的技能或其他作者的技能進行路由嗎？**

不行。曾有三個獨立提案要求建立能讀取本機 `skills/` 目錄並從已安裝項目中進行推薦的路由器。`ask-matt` 並不是那樣的工具。它是一組人工維護的地圖，對你撰寫或從其他地方安裝的技能一無所知。

**它叫我編輯 SKILL.md。**

該建議通常正確但往往無法持久。有人問它如何讓 [implement](https://aihero.dev/skills-implement) 關閉票券，被告知要在該技能中加入一行，隨後立刻發現問題：`npx skills update` 會覆寫該檔案，而且外掛程式安裝為唯讀。請將常態行為寫入你自己的 `CLAUDE.md` 或 `AGENTS.md`，或在呼叫時說明。提示詞層級的調整能在更新後保留：將流程指向 Linear 而非 GitHub，或詢問哪些開放的票券可以平行執行，都是人們透過此方式達成的。

**它指出了我沒有的技能，或是遺漏了我擁有的技能。**

在認定其消失之前，請先檢查變更日誌確認是否重新命名。`writing-great-skills` 變更為 [writing-for-agents](https://aihero.dev/skills-writing-for-agents) 且無別名，`to-prd` 變更為 [to-spec](https://aihero.dev/skills-to-spec)，而 `pathfinder` 變更為 [wayfinder](https://aihero.dev/skills-wayfinder)。有四項技能完全退役並併入吸收它們的技能中：`ubiquitous-language`、`design-an-interface`、`qa` 以及 `request-refactor-plan`。相反的情況則是前述路由器本身的滯後。

## 運作正常的指標

- 它以指出要輸入的指令結尾並在此停止，而非自行開始執行工作。
- 它回傳的路由會提及何處應 clear 或 compact context，以及何處預期由你審查，而不僅僅是一份技能名稱清單。
- 當兩項技能很接近時，它會說明該選哪一個，以及為何另一個不適合你。
- 它對另一項技能行為所做的任何斷言，都會在追蹤記錄中顯示它正在讀取該技能的 `SKILL.md`。
- 你能在它回傳的內容中認出你自己的情境，而非最接近的通用情境。

## 適用位置

`ask-matt` 是一個置於整體架構之上的**獨立路由器**。它從不是鏈條中的某一步；它指向每一條鏈條，且是其他文件頁面反向連結的節點，因此任何頁面都無需重繪關聯圖。從這裡你最常進入主要流程的起點 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，或是針對接收到的工作（而非由你發起的工作）的銜接匝道 [triage](https://aihero.dev/skills-triage)。

它是針對其所描述技能的[次要來源](https://www.aihero.dev/ai-coding-dictionary/secondary-source)。當路由器與 `SKILL.md` 出現分歧時，以 `SKILL.md` 為準。
