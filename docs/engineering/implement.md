## 功能說明

`implement` 建構已經決定的工作。你將其指向 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)、[spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格）或你在對話中剛達成一致的計畫，它就會撰寫程式碼、在接縫處驅動 [tdd](https://aihero.dev/skills-tdd)、在執行過程中進行型別檢查、在最後執行 [code-review](https://aihero.dev/skills-code-review)，並提交（commit）至目前分支。

它絕不會重新討論計畫。沒有訪談、沒有澄清輪次、沒有提出不同方法的建議。上游確定下來的內容就是輸入，且本技能的全部工作就是將其轉換為一次提交。這就是它與在新的 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 中輸入「建構這個」的區別，後者會在建構的同時樂於重新設計工作。

## 何時使用

你透過輸入 `/implement` 來呼叫此技能 — agent 不會自行主動使用它。它在發布時帶有 `disable-model-invocation: true`，因此其他技能也無法呼叫它。無論 [ask-matt](https://aihero.dev/skills-ask-matt) 或 [to-tickets](https://aihero.dev/skills-to-tickets) 在何處提及「然後按 ticket 執行 `/implement`」，那是給你的指示，而不是 agent 會主動做的事情。

工作目前所在的位置決定了這是否為正確的技能：

| 工作位於… | 使用技能 |
| --- | --- |
| 追蹤器上的 ticket | `/implement #42`，每個[工作階段](https://www.aihero.dev/ai-coding-dictionary/session)一個 ticket，在 ticket 之間 [clearing](https://www.aihero.dev/ai-coding-dictionary/clearing)（清除）context |
| 規格尚未拆分，且建構跨越工作階段 | 先使用 [to-tickets](https://aihero.dev/skills-to-tickets)，然後按 ticket 執行 `/implement` |
| 規格已備妥且建構規模較小 | 直接針對規格執行 `/implement` |
| 僅在你剛進行的對話中，且規模仍較小 | 直接在該處的同一個視窗中執行 `/implement` |
| 尚未在任何地方寫下 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，如果沒有程式碼庫則使用 [grill-me](https://aihero.dev/skills-grill-me) |
| 無規格且你想以測試先行方式建構單一具體行為 | 直接使用 [tdd](https://aihero.dev/skills-tdd) |
| 已經建構完成且你想進行檢查 | 直接使用 [code-review](https://aihero.dev/skills-code-review) |

相同工作階段的情況值得一提，因為該技能本身的第一行並未涵蓋此情況。`SKILL.md` 指出「規格或 tickets」，這會推動 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）去尋找不存在的檔案。如果計畫僅存在於對話討論串中，請在呼叫它時說明。

## 先決條件

`implement` 會提交（commit）至你目前所在的分支。它不會建立分支，也不會詢問。在開始之前，請檢查你是否位於想要放置該工作的分支上。

如果 tickets 來自 [to-tickets](https://aihero.dev/skills-to-tickets)，它們所在的追蹤器是由 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 設定的。`code-review` 在收尾時會讀取相同的設定以尋找原始規格。

## 一次執行的操作內容

一次執行按順序分為五個拍子（步驟）：

1. 閱讀 ticket 或規格並釐清接縫。
2. 在預先同意的接縫處驅動 [tdd](https://aihero.dev/skills-tdd)，一次完成一個紅燈-綠燈切片。
3. 頻繁進行型別檢查，在執行過程中執行單一測試檔案。
4. 在最後執行一次完整的測試套件。
5. 執行 [code-review](https://aihero.dev/skills-code-review)，然後提交至目前分支。

一次執行涵蓋一個 ticket。[to-tickets](https://aihero.dev/skills-to-tickets) 產生的 tickets 是曳光彈（tracer-bullet）風格的垂直切片，大小適合單一全新的 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window)（context 視窗），因此預期的節奏是：clear context、實作一個 ticket、commit、再次 clear。每個 ticket 都是自包含的，這正是使前一個 ticket 的 context 可丟棄的原因。

## 預先同意的接縫

本技能運行的概念是**接縫**：你在不接觸內部的情況下觀察行為的公開邊界。測試存在於接縫處。在撰寫任何程式碼之前先在同意的接縫處工作，才能保持測試的耐久性，因為內部的實作可以重新撰寫而測試無需移動。

「預先同意」這個詞起到了實質作用，且它也是本技能最薄弱的關節。`implement` 內部沒有任何內容會去同意接縫。`tdd` 才是進行詢問的技能，且它拒絕在未確認的接縫處撰寫測試。因此在實踐中，協議要麼在上游的規格中達成，要麼在執行的第一次對話中達成。如果任何地方都沒有達成協議，先決條件就永遠不會觸發，而執行會在靜默中變成「直接寫程式碼」。在規格中指定接縫名稱正是阻止這種情況發生的關鍵。

## 常見問題

**它結束了，但我的 ticket 仍然開啟且驗收標準仍未勾選。**

正確，且這是預期的。`implement` 沒有完成步驟。它在提交處結束，且從不碰觸工作項目（這在 GitHub Issues 與本機 markdown 追蹤器上已獲得證實），因此這不是追蹤器整合問題。它也不會針對 `code-review` 產生的發現採取行動，且不會勾選原始議題上的 `- [ ]` 核取方塊。請自行關閉 ticket 並核對標準。這在依賴鏈結上影響最大，因為 `to-tickets` 將前沿定義為其阻礙因素（blockers）均已關閉的 tickets。如果沒有內容被關閉，就沒有任何內容會顯現為已被解除阻礙。

**我可以一次將其指向我的所有 tickets，或平行執行多個嗎？**

不行。一次呼叫處理一個 ticket。跨 ticket 佇列（queue）的批量分發與 [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) 展開（fan-out）都被反覆要求，但兩者都不存在。在單一檢出（checkout）中並排執行多個 `/implement` 工作階段比不支援更糟糕：一份現場報告描述了一個工作階段中的 `git commit --amend` 落在另一個工作階段的提交上、stash 從 `refs/stash` 中消失，以及提交落在錯誤的分支上，這一切發生在一個下午跨三個議題的過程中。這些工作階段共享一個工作目錄、一個索引與一個 HEAD。Git worktree 是社群的替代方案，並請注意 `refs/stash` 在 worktree 之間也是共享的，因此單靠 worktree 並不能解決 stash 的情況。如果你今天需要平行處理，請自行組合。

**它可以開啟發佈 PR（pull request）而不是直接提交嗎？**

非內建功能。它會直接提交至目前分支，好幾個人覺得這太過急切：程式碼在他們有機會驗證其正常運作之前就已著陸。沒有設定標記，也沒有 PR 模式。人們會在呼叫時覆寫它（「提交至分支並開啟 PR」），或透過編輯本機技能複本來實現。

**`code-review` 表示它看不到我的變更。**

`code-review` 審查 `git diff <fixed-point>...HEAD`，排除了暫存區（staged）與工作區（working-tree）變更。`implement` 在提交前執行它，因此除非已經存在臨時提交，否則該 diff 中沒有任何內容可供審查。多個人回報了此問題，且雙方均未修復。請先提交，然後針對你建立分支的點進行審查。

另外，有些人刻意完全不希望在執行內部包含審查，因為審查剛撰寫之程式碼的 agent 會偏向它自己的解決方案。在全新的工作階段中針對固定點執行 [code-review](https://aihero.dev/skills-code-review) 是一個合法的替代方案，且這也是該技能在獨立 sub-agent 中執行其兩個軸度的相同原因。

**單一 ticket 消耗了 15 萬個 token。是我使用錯誤嗎？**

很可能是 ticket 規模過大，而不是技能被誤用。一次執行包含程式碼庫探索、每個接縫的紅燈-綠燈迴圈、完整的測試套件以及審查，因此一個非簡單的 ticket 超過 10 萬個 [tokens](https://www.aihero.dev/ai-coding-dictionary/token) 是正常的，而不是某些東西損壞的徵兆。槓桿在於上游：在 [to-tickets](https://aihero.dev/skills-to-tickets) 中調整 ticket 至適當大小，使每個 ticket 適合單一全新的視窗。如果單一 ticket 持續超標，請將其拆分，而不是提高 [effort](https://www.aihero.dev/ai-coding-dictionary/effort)（努力程度）層級。

**在全新工作階段中執行 `/implement #2` 處理了完全不相關的事物。**

`#2` 是根據 agent 所能看到的任何帶編號清單進行解析的，在全新的工作階段中，這可能是 todo 檔案、檢核表或其他工作清單，而不是已設定的追蹤器。解析是自信的而不是失敗封閉（fail-closed）的，因此在開始之前錯誤並不明顯。請傳遞完整的參考、議題 URL 或 `owner/repo#2`，並要求它在開始前向你確認標題。

## 運作正常的指標

- 工作階段以閱讀 ticket 或規格並重新陳述其將要建構的內容開始，而不是詢問你要建構什麼。
- 你可以在追蹤紀錄中看到實際的 `/tdd` 呼叫，而不僅僅是 diff 中出現測試。
- 型別檢查與單一測試檔案在執行過程中重複執行，而完整的測試套件在接近尾聲時執行一次。
- 執行到達你目前分支上的提交，無需你提示它繼續執行。
- diff 是一個 ticket 價值的變更：貫穿每個層級的垂直切片，而不是將多個 tickets 掃在一起。

## 適用位置

`implement` 是主要鏈結的建構步驟，倒數第二個：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review
```

它的鄰居是 [to-tickets](https://aihero.dev/skills-to-tickets)（產生其所消耗的 tickets 並宣告決定其順序的阻塞邊緣）、[tdd](https://aihero.dev/skills-tdd)（它在每個接縫處內部驅動該技能），以及 [code-review](https://aihero.dev/skills-code-review)（它在提交前執行該技能）。它位於規劃技能的下游並信任它們。它不會重新驗證交給它的內容形狀，因此結構不良的地圖或水平分層的 ticket 會照單全收進行建構。

這種信任正是 [wayfinder](https://aihero.dev/skills-wayfinder) 在 [to-spec](https://aihero.dev/skills-to-spec) 處合併至鏈結，而不是直接將其地圖循環至 `implement` 的原因。只有當工作量證實確實很小時，才從地圖直接前往 `implement`。

當你不確定自己處於哪個流程時，[ask-matt](https://aihero.dev/skills-ask-matt) 是涵蓋整個集合的路由器。
