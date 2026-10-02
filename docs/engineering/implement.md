## 功能說明

`implement` 建構已經敲定的工作。你將它指向一張 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)、一份 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)、或是你剛在對話中商定好的計畫，它就會撰寫程式碼、在接縫處推動 [tdd](https://aihero.dev/skills-tdd)、在執行過程中進行型別檢查、在最後執行 [code-review](https://aihero.dev/skills-code-review)，並 commit 至當前分支。

它絕不會推翻或重新討論計畫。沒有訪談、沒有釐清環節、也不會提議不同的做法。上游敲定的任何內容就是其輸入，而本技能的全部任務就是將其轉化為一個 commit。這正是它與對全新的 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 輸入「建構這個」的區別所在，後者在建構的同時往往會樂於重新設計該工作。

## 何時使用

你必須自行輸入 `/implement` 來呼叫它：agent 不會主動使用它。它隨附了 `disable-model-invocation: true`，因此其他技能也無法呼叫它。無論 [ask-matt](https://aihero.dev/skills-ask-matt) 或 [to-tickets](https://aihero.dev/skills-to-tickets) 在何處提到「然後針對每張票券執行 `/implement`」，那都是給你的指示，而非 agent 會未經提示就主動執行的動作。

目前工作所處的狀態決定了這是否為合適的技能：

| 工作所處狀態… | 建議使用的技能 |
| --- | --- |
| tracker 上的票券 | `/implement #42`，每個 [session](https://www.aihero.dev/ai-coding-dictionary/session) 處理一張票券，並在票券之間 [clear](https://www.aihero.dev/ai-coding-dictionary/clearing) context |
| 規格，尚未拆分，且建構跨越多個 session | 先使用 [to-tickets](https://aihero.dev/skills-to-tickets)，然後針對每張票券執行 `/implement` |
| 規格，且建構規模較小 | 直接針對該規格執行 `/implement` |
| 僅存在於你剛才的對話中，且規模依然很小 | 直接在同一個視窗中就地執行 `/implement` |
| 尚未記錄於任何地方 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，若無程式碼庫則使用 [grill-me](https://aihero.dev/skills-grill-me) |
| 一項你想透過測試先行完成的具體行為，沒有規格 | 直接使用 [tdd](https://aihero.dev/skills-tdd) |
| 已經建構完成，且你希望進行檢查 | 直接使用 [code-review](https://aihero.dev/skills-code-review) |

同一 session 的情境值得特別說明，因為該技能自身的第一行並未涵蓋此情況。`SKILL.md` 提到「規格或票券」，這會促使[模型](https://www.aihero.dev/ai-coding-dictionary/model)去尋找根本不存在的檔案。如果計畫僅存在於討論串中，請在呼叫時明確說明。

## 先決條件

`implement` 會 commit 到你目前所在的分支。它不會建立分支，也不會主動詢問。在開始之前，請確認你處於希望寫入工作成果的分支上。

若票券來自 [to-tickets](https://aihero.dev/skills-to-tickets)，它們所在的 tracker 是由 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 所設定。`code-review` 在結尾時會讀取相同設定以尋找原始規格。

## 單次執行的運作流程

一次執行包含依序進行的五個節奏：

1. 讀取票券或規格並理清接縫。
2. 在預先商定的接縫處推動 [tdd](https://aihero.dev/skills-tdd)，一次處理一個紅燈-綠燈切片。
3. 頻繁進行型別檢查，並在過程中執行單一測試檔案。
4. 在最後執行一次完整測試套件。
5. 執行 [code-review](https://aihero.dev/skills-code-review)，接著 commit 到當前分支。

一次執行涵蓋一張票券。[to-tickets](https://aihero.dev/skills-to-tickets) 產生的票券是曳光彈式的垂直切片，其規模剛好能放入單一全新的 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)，因此預期的節奏為：clear context、實作一張票券、commit、再次 clear。每張票券皆自成一體，這正是上一張票券的 context 可以被丟棄的原因。

## 預先商定的接縫

該技能仰賴的核心概念是**接縫（seam）**：你在其上觀察行為的公開邊界，而無需深入內部。測試存在於接縫處。在撰寫任何程式碼之前，於預先商定的接縫處展開工作是維持測試長久耐用的關鍵，因為底層的實作可以在測試無需變動的情況下重寫。

「預先商定」這個詞承載了實質分量，也是本技能最薄弱的環節。`implement` 內部沒有任何機制來商定接縫。`tdd` 才是會主動提問的技能，且它會拒絕在未確認的接縫處撰寫測試。因此在實務上，商定要麼發生在上游的規格中，要麼發生在執行的第一輪交流中。如果兩處都沒有發生，該先決條件就永遠不會被觸發，執行過程便會悄悄轉變成「單純寫程式碼」。在規格中明確指出接縫正是防止此現象的方法。

## 常見問題

**它完成了，但我的票券依然處於開啟狀態且驗收準則未勾選。**

沒錯，這在預料之中。`implement` 沒有完工步驟。它結束於 commit，且從不碰觸工作項目，這點已在 GitHub Issues 與本機 markdown tracker 上確認，因此這並非 tracker 整合的問題。它也不會針對 `code-review` 產出的發現採取行動，亦不會勾選原始 issue 上的 `- [ ]` 核取方塊。請自行關閉票券並確認驗收準則。這在相依性鏈條上的影響最為嚴重，因為 `to-tickets` 將前緣定義為所有阻擋項皆已關閉的票券。若沒有任何項目被關閉，就永遠不會有項目顯式解除阻擋。

**我可以一次將它指向所有票券，或平行執行多張票券嗎？**

使用 `/implement` 不行：一次呼叫對應一張票券。若要在單次執行中處理整個規格，請使用 [implement-spec](https://aihero.dev/skills-implement-spec)，它會在就緒的前緣上將票券散發給 [subagents](https://www.aihero.dev/ai-coding-dictionary/subagent)（每個都在各自獨立的 worktree 中），並將它們合併到單一整合分支上。在同一個簽出目錄中並排執行多個 `/implement` session 不僅僅是不受支援而已：一份實地報告指出，在同一個下午處理三個 issue 的過程中，某個 session 的 `git commit --amend` 落到了另一個 session 的 commit 上、stash 從 `refs/stash` 中消失、且 commits 落到了錯誤的分支上。這些 session 共用同一個工作目錄、索引（index）與 HEAD。Git worktrees 是社群採用的因應方案，請注意 `refs/stash` 在不同 worktree 之間也是共用的，因此單靠 worktree 無法解決 stash 的問題。

**它可以建立 pull request 而非直接 commit 嗎？**

沒有內建此功能。它會直接 commit 到當前分支，有些人覺得這過於急躁：程式碼在他們有機會驗證其正常運作之前就已經落地。這裡沒有設定旗標，也沒有 PR 模式。大家通常會在呼叫時覆寫它（「commit 到分支並建立 PR」）或透過編輯本機技能副本來調整。當 agent 確實撰寫 PR 時，[pr](https://aihero.dev/skills-pr) 會塑造其內文結構。

**`code-review` 表示它看不到我的變更。**

`code-review` 審查的是 `git diff <fixed-point>...HEAD`，這排除了 staged 與 working-tree 的變更。`implement` 在 commit 前執行它，因此除非已經存在過渡 commit，否則該 diff 中沒有任何內容可供審查。多人回報了此問題，且雙方皆尚未修復。請先 commit，再對照你分支的起始點進行審查。

另外，有些人特意不希望在執行過程中包含審查，因為 agent 審查自己剛寫出的程式碼會對其自身方案產生偏見。在全新的 session 中針對固定點執行 [code-review](https://aihero.dev/skills-code-review) 是一個合理的替代方案，這也是該技能在獨立 sub-agents 中執行其兩個維度的相同原因。

**一張票券消耗了 15 萬 tokens。是我使用方式有誤嗎？**

很可能是票券規模過大，而非誤用技能。單次執行包含程式碼庫探索、每個接縫的紅燈-綠燈循環、完整測試套件以及審查，因此具有一定複雜度的票券超過 10 萬個 [tokens](https://www.aihero.dev/ai-coding-dictionary/token) 實屬正常，而非發生錯誤的徵兆。解決槓桿在於上游：在 [to-tickets](https://aihero.dev/skills-to-tickets) 中合理劃分票券規模，使每張票券都能放入單一全新視窗中。若單張票券持續膨脹，請將其拆分，而不是提高[投入程度（effort）](https://www.aihero.dev/ai-coding-dictionary/effort)層級。

**在全新 session 中執行 `/implement #2` 處理了完全無關的事物。**

`#2` 會對照 agent 所能看見的任何編號清單進行解析，在全新的 session 中，這可能是一個待辦檔案、檢查清單或另一個工作清單，而非設定好的 tracker。此解析具盲目自信而非安全閉合（fail-closed），因此在它開始之前錯誤往往不明顯。請傳遞完整參照、issue URL 或 `owner/repo#2`，並在它開始之前要求它確認回報標題。

## 運作正常的指標

- Session 一開始會讀取票券或規格並重述其即將建構的內容，而非向你詢問要建構什麼。
- 你能在追蹤記錄中看見實際的 `/tdd` 呼叫，而不僅僅是 diff 中出現測試。
- 在執行過程中重複執行型別檢查與單一測試檔案，並在接近尾聲時執行一次完整測試套件。
- 執行過程在無需你提示繼續的情況下，順利於當前分支產生 commit。
- diff 是一張票券的工作量變更：貫穿各層的垂直切片，而非多張票券混雜在一起。

## 適用位置

`implement` 是主要鏈條的建構步驟：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

其相鄰技能為 [to-tickets](https://aihero.dev/skills-to-tickets)（產出其所消耗的票券並宣告決定其順序的阻擋邊）；[tdd](https://aihero.dev/skills-tdd)（在其內部針對每個接縫推動）；以及 [code-review](https://aihero.dev/skills-code-review)（在 commit 之前執行）。它位於規劃技能的下游並信任它們。它不會重新驗證所接收內容的架構形態，因此結構不良的地圖或水平分層的票券都會照章建構。

這份信任正是為何 [wayfinder](https://aihero.dev/skills-wayfinder) 會在 [to-spec](https://aihero.dev/skills-to-spec) 處併入鏈條，而非將其地圖直接連入 `implement`。只有當工作量經證實確實很小時，才從地圖直接跳至 `implement`。

當你不確定自己身處哪個流程時，[ask-matt](https://aihero.dev/skills-ask-matt) 是涵蓋整個集合的路由器。
