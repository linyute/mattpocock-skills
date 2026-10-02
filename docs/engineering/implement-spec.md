## 功能說明

`implement-spec` 接收一份 [spec](https://www.aihero.dev/ai-coding-dictionary/spec) 及其相關 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket)，並在單次執行中完成全部內容。負責編排的 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 將每張票券交給在各自獨立 git worktree 中工作的實作者 [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent)，將每個完成的分支合併至單一**整合分支（integration branch）**，對結果執行 [code-review](https://aihero.dev/skills-code-review)，並解決票券。

它將票券視為**任務圖（task graph）**而非清單。阻擋邊（blocking edges）決定了哪些任務可以開始，因此在任何時刻都存在一個所有阻擋項皆已完成的票券**前緣（frontier）**，且該前緣上的每張票券都會同時執行。這正是與逐張處理票券的區別所在：決定節奏的是圖的形態，而非其在 tracker 上的排列順序。

## 何時使用

你可以透過輸入 `/implement-spec` 來呼叫它，且 agent 不會主動使用它。

| 你的情境 | 建議使用的技能 |
| --- | --- |
| 一份拆分為帶有阻擋邊之票券的規格，且你希望在單次執行中全部落地 | `/implement-spec` |
| 一次處理一張票券，在自己的 [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) 中執行，並在票券之間執行 [clear](https://www.aihero.dev/ai-coding-dictionary/clearing) | [implement](https://aihero.dev/skills-implement) |
| 尚未拆分為票券的規格 | 先使用 [to-tickets](https://aihero.dev/skills-to-tickets) |
| 沒有複雜圖結構的小型工作 | 直接使用 [implement](https://aihero.dev/skills-implement) |

## 先決條件

- **Issue tracker。** 該技能從 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 所設定的 tracker 讀取票券並在其上解決票券。若尚未設定，它會停止並通知你先執行該設定，而非自行猜測。
- **帶有阻擋邊的票券**，如同 [to-tickets](https://aihero.dev/skills-to-tickets) 所撰寫的格式。若缺乏阻擋邊，圖將呈現扁平狀，所有票券都會同時啟動。
- **能在背景執行 subagents 並賦予每個 subagent 獨立 git worktree 的 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)。** 並行處理才是核心所在；一次僅能執行一個 subagent 的 harness 只會得到較慢的 `implement`。

## 整合分支

所有內容都落實在單一分支上。每個實作者：

1. 在開始前確認其 worktree 是以整合分支為基底，
2. 使用 [tdd](https://aihero.dev/skills-tdd) 建構其票券，一次處理一個紅燈-綠燈切片，
3. 在回報完成前將整合分支的頂端合併至其自身分支，以便落地時能以快轉（fast-forward）方式合併。

是否產生 pull request 由 tracker 決定。若你的 tracker 透過 PR 關閉工作，或你主動要求建立 PR，則在第一次合併後會開啟草稿 PR，並在最後標記為就緒。否則，執行過程會在整合分支上結束，並依照你的 tracker 關閉工作的方式解決每張票券，這能完全離線針對本機 markdown tracker 運作。

實作者透過 [context 指標](https://www.aihero.dev/ai-coding-dictionary/context-pointer)（規格、票券、共用的探索筆記、先前的 commits）與編排者溝通，而非貼上摘要，這使得每個 subagent 的提示詞維持精簡，並讓編排者的視窗空間保留給任務圖。

## 常見問題

**這與我自己對每張票券執行 `/implement` 有何不同？**

這正是本技能所要回答的問題。在發布之前，人們不斷建立自己的版本，一位使用者準確描述了這項痛點：他們希望「由 subagents 實作票券」，而不是「當一份規格可能包含 5 張以上的票券時，必須個別建立新的 session 並指示它們逐一實作票券」。使用 `implement` 時你就是調度員：每張票券一個 [session](https://www.aihero.dev/ai-coding-dictionary/session)，其間進行 clear，並自行追蹤哪些票券已解除阻擋。`implement-spec` 將這項工作交給單一編排 session。代價是你不再於每張票券落地時閱讀其成果；而是在最後審查整合分支。若要開始執行，請清除 context 並輸入 `/implement-spec` 以及指向規格的指標（issue 編號或檔案路徑）。對於沒有複雜圖結構的小型變更，請略過它並直接使用 `implement`。

**它需要 GitHub 嗎？我希望它停留在分支即可。**

不需要，現在已經不用了。一位喜歡開發中版本的用戶曾有過這樣的抱怨：「它最後會建立 PR，這需要像 GitHub 這樣的線上儲存庫。我希望它能離線完成相同工作，並停留在合併所有工作的分支上。」現在的目標是整合分支。只有在設定的 tracker 透過 PR 關閉工作或你主動要求時才會開啟 PR，因此在本地 markdown tracker 上，執行結束時每張票券都會被解決，且工作皆已合併在分支上。

**它的審查與修復循環執行了數小時，或不斷「修復」尚未建構的票券。**

這兩種情況都源自於 `code-review` 在技能分配的單一槽位之外執行。它是將程式碼與整個規格進行比對，因此唯有在每張票券都落地後才有意義；在執行途中執行它，每張未建構的票券都會被視為失敗，agent 便著手建構它，進而觸發另一輪審查。在最後，該技能會執行一次 `code-review` 並將所有發現傳送給單一修復 subagent，但目前尚未規定在修復後何時停止。一位使用者回報了一個包含 5 張票券的功能，「審查與修復循環大約耗時四個小時」。若你看到第二輪廣泛審查開始，請指示它針對已修復的發現執行針對性檢查並停止。請預期第一次審查會發現真實問題：執行的產出是一份由審查來定稿的草稿，而非能直接交付的成品。

**它是否像 implement 一樣推動 tdd？**

現在確實有，雖然起初並沒有。執行開發中版本的使用者注意到「實作者 subagents 未繼承 /tdd 指示」，因此當他們從單一票券擴展到整個規格時，紅燈-綠燈流程便中斷了。現在每個實作者都使用 `tdd` 建構其票券。不過目前仍不像 `implement` session 那樣設有互動式商定接縫的步驟，因此若你想固定接縫，請在規格或票券中直接指明接縫。

**兩個平行執行的實作者在同一個檔案上產生衝突，或對同一事物選取了不同的名稱。**

Worktrees 並不能消除衝突；它們只是將衝突推遲到合併時。依據票券內文撰寫的阻擋邊，只是對每張票券將觸及哪些檔案的猜測，而位於「程式碼庫不同部分」的兩張票券仍可能共用訊息目錄、設定註冊表或型別。每個實作者僅能看見自己的票券與共用筆記，絕不會看到對方的進行中工作，因此曾有使用者的 web 與 mobile 票券分別將相同的字串新增為 `blockedSince` 與 `blockedOn`。當兩張前緣票券觸及同一個共用接觸面時，可以在兩者之間加入阻擋邊以依序執行，或是在探索筆記中明確規定每張票券所新增的確切名稱。

**受阻擋的票券從未開始，即使其阻擋項已經合併。**

這是 GitHub 上的已知粗糙處。Tracker 的 blocked-by 計數只有在阻擋項*關閉*時才會減少，而票券通常在 PR 合併（即整個執行結束）時才關閉。Tracker 是起始圖的合適來源，但在執行途中卻會過期。請指示編排者自行追蹤哪些票券已合併至整合分支，並依此計算前緣。

**這是否能取代 Sandcastle 或 AFK 指令碼？**

不能。人們之所以詢問，是因為技能現在已深入實作領域：「Sandcastle 還有用嗎？你的技能現在似乎也能處理實作了。」`implement-spec` 讓一個 agent 在單一 harness session 內負責編排，無需基礎設施，且能讓你觀看與引導。對於真正[暫離鍵盤（AFK）](https://www.aihero.dev/ai-coding-dictionary/afk)的工作，具確定性的循環（[Sandcastle](https://github.com/mattpocock/sandcastle)、shell 指令碼、CI 工作）更快、更便宜且更可靠，因為編排的任何部分都不會偏離軌道。

**票券的關鍵測試在它的 worktree 內被略過，卻回報綠燈。**

Worktree 僅包含 git 追蹤的內容。讀取被 gitignore 的 fixture、本機資料庫或憑證的測試可能會在那裡靜默略過自己。對於驗證依賴於未追蹤素材的票券，請指示編排者改在主簽出目錄（main checkout）中執行。

## 運作正常的指標

- 只要圖結構允許，多個實作者會同時執行，而非一個接一個。
- 票券在其最後一個阻擋項落實到整合分支後立即啟動，而非等到整個執行結束。
- 每張票券的追蹤記錄皆顯示正在執行 `tdd`，且在程式碼之前存在失敗的測試。
- 合併至整合分支採用快轉（fast-forward），而非衝突解決。
- 執行結束於單一分支上，每張票券皆已解決，且只有在 tracker 需要時才建立 PR。

## 適用位置

`implement-spec` 是主要鏈條的建構步驟，作為每張票券分別執行一次 [implement](https://aihero.dev/skills-implement) 的平行替代方案：

```txt
grill-with-docs → to-spec → to-tickets → implement-spec → retro
```

其相鄰技能為 [to-tickets](https://aihero.dev/skills-to-tickets)（宣告其讀取為任務圖的阻擋邊），以及 [code-review](https://aihero.dev/skills-code-review)（在收尾前對整合分支執行）。當你不確定自己身處哪個流程時，[ask-matt](https://aihero.dev/skills-ask-matt) 是涵蓋整個集合的路由器。
