## 它的功能

`triage` 會處理專案追蹤器上的 Issue，將每個 Issue 移過由 **triage 角色**（一個類別角色和一個狀態角色）組成的微型狀態機，並留下 Agent 隨時可執行的簡報 (agent-ready brief)、給回報者的具體提問，或是附有記錄原因已關閉的 Issue。

它僅適用於**非您建立**的 Issue。原始的 Bug 回報、傳入的功能請求、未經事先通知抵達的外部 Pull Request — 即從外部進入追蹤器的工作，無論回報者留下的形式為何。[to-tickets](https://aihero.dev/skills-to-tickets) 產生的 [工單](https://www.aihero.dev/ai-coding-dictionary/ticket) 在結構上已具備 Agent 隨時可執行的狀態，對它們執行 `triage` 充其量是浪費工作。這是一條明確的規則：`/triage` 僅適用於傳入的 Issue，而不適用於您自己建立的 Issue。

將其與手動標籤區分開來的第二件事：它會進行推薦並等待。它會告訴您其類別與狀態的判定及推論，加上它在程式碼庫中找到的內容，並在您給出指示之前不套用任何變更。

## 何時使用它

您可透過輸入 `/triage` 並用平實的語言描述您想要的內容來呼叫此功能 — [Agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會主動使用它。「顯示任何需要我注意的內容」、「我們來看看 #42」、「將 #42 移動至 ready-for-agent」。

| 您擁有的內容 | 去向 |
| --- | --- |
| 填滿其他人原始回報的追蹤器 | `/triage` |
| 您自己的粗略想法，尚未寫下任何內容 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 定稿的對話，欲轉化為 [spec](https://www.aihero.dev/ai-coding-dictionary/spec) | [to-spec](https://aihero.dev/skills-to-spec) |
| 欲拆解為 Agent 隨時可執行工單的規格 | [to-tickets](https://aihero.dev/skills-to-tickets) |
| 需要根本原因而非標籤的已知 Bug | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |

## 先決條件

`triage` 會讀取並寫入您的 Issue 追蹤器，因此 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 必須先為該追蹤器設定好其標籤詞彙表。下面的角色名稱是**規範性的 (canonical)**；您的追蹤器中的標籤字串可能有所不同，而設定所提供的正是這種映射。如果您的追蹤器已經精確使用了規範名稱，則無需進行任何映射或設定。

追蹤器設定還決定了外部 Pull Request 是否算作請求表面，以及誰算作外部人員。該標記預設為關閉，且不再是設定問題 — 如果您希望將 PR 納入範圍，請在 `docs/agents/issue-tracker.md` 中將其開啟。

## 狀態機

每個經過 triage 的項目最終都會恰好攜帶一個類別角色和一個狀態角色。兩個類別：`bug`（某些內容損壞）和 `enhancement`（新功能或改進）。五個狀態：

| 狀態 | 代表意義 |
| --- | --- |
| `needs-triage` | 您需要對其進行評估。未標籤的 Issue 通常首先落在這裡。 |
| `needs-info` | 等待回報者。當他們回覆時回到 `needs-triage`。 |
| `ready-for-agent` | 已完全指定，並附有 Agent 簡報。[AFK](https://www.aihero.dev/ai-coding-dictionary/afk) Agent 可以接手它。 |
| `ready-for-human` | 相同的簡報，加上為何無法委派的原因 — 判斷力、外部存取、手動測試。 |
| `wontfix` | 已關閉，並記錄原因。 |

這就是全部的詞彙表，而「恰好一個狀態角色」的不變性維護了簡單的查詢。這也是 [Skill](https://www.aihero.dev/ai-coding-dictionary/skill) 中最常被要求的領域：使用者要求為已指定但被另一個 Issue 阻塞的工作提供第六個狀態、為受未來觸發條件管制的工作提供 `deferred` 狀態，以及終端 `implemented` 狀態。這些都沒有發布。請參閱下面的問題。

`wontfix` 分為三種情況，其差異很重要，因為只有其中一種會寫入知識庫：

| 為何關閉它 | 會發生什麼事 |
| --- | --- |
| 已實作 | 指向其現有位置的留言。沒有任何內容會寫入 `.out-of-scope/` — 這是一個已建構的功能，而不是被拒絕的功能，將其存檔在那裡會毒害去重檢查。 |
| 拒絕的 Bug | 禮貌的解釋，然後關閉。 |
| 拒絕的 Enhancement | `.out-of-scope/` 中的一個檔案，從關閉留言進行連結，然後關閉。 |

`.out-of-scope/` 是每個被拒絕的**概念**一個 Markdown 檔案，而不是每個 Issue 一個檔案，寫成簡短的設計文件而非資料庫資料列：拒絕了什麼、原因以及要求過它的每個 Issue。`triage` 在評估任何內容之前會讀取整個目錄，並按概念而非關鍵字進行比對 — "night theme" 會比對 `dark-mode.md`。當遇到比對結果時，它會呈現舊的決定並詢問您是否仍然有同感，而不是從頭重新討論該請求。

## 簡報前進行驗證

在進行任何 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) 之前，`triage` 會檢查該主張是否真實成立。對於 Bug，它會從回報者的步驟進行重現。對於 PR，它會檢出分支並執行相關測試。然後它會回報三種情況中的哪一種發生了：已確認（附帶程式碼路徑）；無法重現；或是細節不足無法嘗試（這本身就是最強烈的 `needs-info` 信號）。

它在同一次傳遞中對程式碼庫執行另外兩項檢查 — **冗餘**（是否已經實作，按領域概念而非回報者的字眼搜尋？）以及 **先前拒絕**（`.out-of-scope/` 是否已經拒絕？）。兩者都很廉價，且在命中時都會產生 `wontfix`。

所有這一切的存在都是為了讓一個產物變好：**Agent 簡報**，即當 Issue 移動到 `ready-for-agent` 時發布的結構化留言。一旦發布，簡報就是契約，而原始回報僅作為背景資訊。簡報寫成**持久的**而非精確的，因為 Issue 可能在 `ready-for-agent` 中停留數週，而底下的程式碼在此期間會發生移動。因此它們命名型別、簽章和行為契約，而絕不命名檔案路徑或行號。確認的重現比推測能產生強大得多的簡報。

## PR 是附帶程式碼的 Issue

當追蹤器將外部 Pull Request 視為請求表面時，它們會通過相同的狀態機 — 相同的類別、相同的狀態、相同的過渡。狀態只是針對 Diff 進行解讀：`ready-for-agent` 意味著已附加簡報且 Agent 應該對程式碼採取下一步，`ready-for-human` 意味著已準備好讓人工進行合併。PR 上的簡報描述了對現有 Diff 還需要做什麼，而不是如何從零建構該事物。

探索僅呈現*外部* PR，因為協作者進行中的分支不是 triage 工作。該篩選僅限於探索 — 明確指定 PR，無論是誰寫的都會被 triage。一個粗糙的地方：GitHub 範本的外部 PR 列表命令向 `gh pr list` 要求一個 `gh` 未公開的 `authorAssociation` 欄位，因此書寫的命令直接失敗 ([#468](https://github.com/mattpocock/skills/issues/468))。

## 常見問題

**我執行了 `/to-spec` 與 `/to-tickets`，現在這些工單擺在那裡未經 triage。我需要對它們執行 `/triage` 嗎？**
不需要。它們在結構上已經具備 Agent 隨時可執行的狀態 — `to-tickets` 在發布時會套用 `ready-for-agent` 標籤，正是為了讓 AFK 執行器在不需要另一次傳遞的情況下拾取它們。遇到這種情況的使用者執行了規格流程，在輸出中看到 `needs-triage`，並發現他們的 AFK 執行器忽略了一切。`triage` 是針對來自外部工作的匝道；規格流程是針對您發起工作的車道。它們在 `ready-for-agent` 會合，而不是之前。

**現在有了 `to-spec` → `to-tickets` → `implement` 流程，`triage` 是否仍然相關？**
只有在您有傳入的工作時才有相關。`triage` 早於該主幹，且做著不同的工作：它是針對其他人提交的回報的車道。如果您的追蹤器中的所有內容都來自您自己的規劃，您將很少打開它。如果您維護任何公開項目，或者您的團隊向您提交 Bug，它就是大門。主要用途是收受來自外部貢獻者 Issue 的開源儲存庫。

**Agent 嘗試套用 `ready-for-agent` 且 `gh` 表示標籤不存在。**
已知開放的 Bug ([#616](https://github.com/mattpocock/skills/issues/616))。`setup-matt-pocock-skills` 將標籤詞彙表寫入 `docs/agents/triage-labels.md`，但不會在您的追蹤器中建立標籤。自己使用 `gh label create` 或追蹤器的 UI 建立這五個狀態標籤和兩個類別標籤一次，問題就會停止。Issue 中連結了一個尚未合併的社群修復分支。

**五個狀態不夠 — 那麼 blocked、deferred 或 implemented 呢？**
這是該 Skill 上最常被提交的缺口，呈三種型態。已完全指定但正在等待另一個 Issue 關閉的 Issue ([#139](https://github.com/mattpocock/skills/issues/139)) — 回報者的抱怨是 `ready-for-agent` 在那裡「技術上為真」但具誤導性，因此 Agent 拾取它並碰壁。有意圖但尚未可採取行動的觸發條件管制未來工作 ([#297](https://github.com/mattpocock/skills/issues/297))。以及「已實作，等待驗證」的終端狀態，沒有它 AFK 執行器可能會重新排隊已完成的工單。Matt 已同意被阻塞的情況是真實存在的，且尚未決定名稱（`blocked` 對比 `paused`）。這些都沒有發布。人們使用的變通方案是在類別旁使用儲存庫本機的額外標籤，這使得規範狀態插槽由誠實的內容佔用，代價是 Skill 不知道它。一個社群衍生版本走得更遠，新增了 `needs-slicing`、`tracking` 和工作量標籤 — 這可行，但那是他們的，而不是 Skill 的。

**這與 `/diagnosing-bugs` 有何不同？**
這裡的驗證步驟刻意保持淺層 — 足以回答「這是真的嗎，以及它大致部位在哪裡」，而不是尋找根本原因。當 Bug 無法在幾分鐘內從回報者的步驟中重現時，誠實的做法是 `needs-info`，或者如果您現在想追查它，則使用 [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs)。目前這兩個 Skill 的文字都沒有提及對方；一名使用者發現了該縫隙，且它仍然開放。

**我可以將它指向我的整個 Backlog 並讓它執行嗎？**
您可以詢問，但請注意它讀取的內容。「顯示需要注意的內容」傳遞是一個旨在用於*選擇*的廉價列表 — 您挑選一個，然後它為您挑選的那個收集完整的 [內容](https://www.aihero.dev/ai-coding-dictionary/context)。一次對 20 個 Issue 執行它，Agent 可能會悄悄退回到該廉價列表作為其證據基礎，這會回傳 Issue 內文但不會回傳留言。一名使用者正好遇到這種情況：三個 Issue 已經帶有寫著「已修復，建議關閉」的留言，且這三個都收到了全新的 Agent 簡報。如果您想要進行批次處理，請明確說明每個 Issue 都必須讀取留言。

**它是否適用於 Linear，或是 GitHub Issues 以外的任何內容？**
是的 — 追蹤器是設定，而不是硬編碼的假設，人們對 Linear（透過 `linear` CLI）、GitLab 以及 `.scratch/` 下的純 Markdown 檔案執行它。常見的分工是 Linear 用於 Issue 和規劃，GitHub 用於程式碼和 PR：寫著「Issue 追蹤器」的 Skill 映射至 Linear，寫著「PR」的 Skill 映射至 GitHub。在本機 Markdown 追蹤器上有一個開放的範本 Bug，產生的檔案可能會攜帶驗收條件兩次，一次在頂層，一次在 Agent 簡報內部 ([#200](https://github.com/mattpocock/skills/issues/200))。

## 運作良好的指標

- 它觸及的每個項目最終都恰好帶有一個類別角色和一個狀態角色 — 絕不少於一個，也絕不有兩個衝突的狀態。
- 它向您提供帶有推理的建議並停止，而不是重新打上標籤並繼續。
- 在任何內容到達 `ready-for-agent` 之前，Bug 已重現，或者 PR 已檢出並執行。
- 它撰寫的簡報命名型別和行為，且不包含檔案路徑和行號。
- 六個月前被拒絕的請求再次出現，它指出這一點並引用舊的原因，而不是重新進行 triage。
- 它發布的每條留言都以 `> *This was generated by AI during triage.*` 開頭。

## 適用位置

`triage` 是一個**匝道**，而不是主鏈中的步驟。主要流程從您擁有的想法開始 — 盤問 (grill)、規格 (spec)、工單 (tickets)、實作 (implement)、審查 (review) — 而 `triage` 是針對抵達工作的平行車道。它在同一個地方匯合：一個標有 `ready-for-agent` 且附有簡報的 Issue，[implement](https://aihero.dev/skills-implement) 會像拾取來自 [to-tickets](https://aihero.dev/skills-to-tickets) 的工單一樣精確地拾取它。當請求在生成簡報前需要打磨時，`triage` 會同時執行 [grilling](https://aihero.dev/skills-grilling) 和 [domain-modeling](https://aihero.dev/skills-domain-modeling)，一次進行一輪提問，以便決策在做出時落入 `CONTEXT.md` 和 ADR 中。當您不確定自己處於哪個車道時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為您引導路線。
