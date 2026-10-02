> **已封存。**此 skill 已在 v1.3.0 中從外掛程式中移除，且不再維護。沒有任何東西取代它：agent 可以在沒有專用 skill 的情況下處理 merge 或 rebase 衝突。本頁面保留供參考。

## 它的功能

`resolving-merge-conflicts` 會逐個 hunk 處理進行中的 git merge 或 rebase，然後執行專案本身的檢查，並以 commit 完成操作。

它拒絕將衝突視為純文字問題。在處理 hunk 之前，它會將每一方追溯至其**[主要來源 (primary sources)](https://www.aihero.dev/ai-coding-dictionary/primary-source)**（commit 訊息、PR、原始 issue），因此它是在兩個意圖之間做選擇，而不是在兩個文字區塊之間做選擇，並且在兩者相容之處同時保留兩者。在兩者確實無法相容的地方，它會挑選符合該 merge 所聲明目標的一方，並指出取捨。它不會捏造任何新行為來掩飾衝突，而且 `--abort` 不是它的選項：merge 總是會進行到完成 commit 為止。

## 何時使用它

輸入 `/resolving-merge-conflicts`，或者當任務適合時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會自動使用它。

當 git 已經因為無法自行解決的衝突而停止時，請使用它。它的範圍僅限於眼前的衝突，而非衝突兩側的任何其他事物：

| 你的情況 | 技能 |
| --- | --- |
| 處於 merge 或 rebase 中途，工作樹中存在衝突標記 | 本項技能 |
| Merge 完成，現在某些東西因你看不到的原因而異常運作 | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |
| 規劃如何切分工作以減少分支衝突 | 兩者皆非：請參閱下方的平行工作問題 |

## 主要來源優先於 `ours` 和 `theirs`

此技能存在的目的在於消除透過旗標解決衝突的失敗模式：`--ours`、`--theirs`，或者手動刪除看似較不重要的區塊，以便消除標記並讓建置編譯通過。這種解決方式在語法上可能是完美的，但仍會默默遺漏某人刻意進行的變更。

你無法保留你未曾閱讀過的意圖。因此工作從歷史記錄（commit、PR、[ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)）開始，之後才轉向 diff。循環中的另一個步驟也是基於同樣的原因而存在：該 skill 會找到儲存庫本身的[自動化檢查 (automated checks)](https://www.aihero.dev/ai-coding-dictionary/automated-check)，並在 commit 前執行它們，因為 merge 是 git 中最容易產出同時滿足兩個分支卻無法通過任一分支測試的程式碼的地方。

## 常見問題

**Claude Code 本身解決衝突就已經相當出色了。為什麼這需要一個 skill？**

附加價值在於「尋找主要來源」和「執行回饋循環」步驟，否則每次都必須手動 prompt。未經 prompt 的 agent 通常只會從 diff 產出貌似合理的解決方案並停在那裡。該 skill 的價值在於它不允許 agent 跳過的兩個步驟：閱讀每一方存在的原因，以及隨後執行檢查。相較於優秀的[模型](https://www.aihero.dev/ai-coding-dictionary/model)，這是一個微小的優勢，而且它本應如此：至少有一位讀者預測，隨著模型進步，整項 skill 都將變得不再必要。

**我應該讓平行 agent 避開相同的檔案以從根本上避免衝突嗎？**

大多不需要。在平行任務之間劃分檔案區域所花費的成本高於它所節省的，因為 agent 在處理 merge 衝突方面已經足夠優秀，取捨並不如表面看起來那麼嚴苛。唯一值得維持的紀律是先進行大型重構。在分支出十個分支之後才合入大型重新命名，這種情況的成本依然很高。

來自使用者針對平行 worktree 的回報提出了一個告誡：當同層級的 [session](https://www.aihero.dev/ai-coding-dictionary/session) 各自在各自的工作樹中建置 ticket 時，合併回去的動作最好由撰寫該變更的 session 來執行，因為它才是已經知道意圖的一方。最後把所有人的衝突打包給單一 agent 處理，恰恰丟棄了本 skill 第 2 步必須回頭重新建構的[上下文 (context)](https://www.aihero.dev/ai-coding-dictionary/context)。

**為什麼絕不 `--abort`？**

中止操作會丟棄已完成的解決工作，並在你下次嘗試時讓你回到完全相同的衝突。該 skill 是專為即將進行 merge 的情況所編寫的。如果你已決定不應該進行，那是呼叫前該做的決定，而非循環內部的分支。

## 若運作正常，會符合以下情況

- Agent 在解決過程中向你引用 commit 訊息、PR 或 issue，而不僅僅是 diff hunk。
- 每個 hunk 最終都具有雙方的行為，或者帶有明確的註記說明捨棄了什麼以及原因。
- 結果中沒有出現任何兩個分支上原本都不存在的內容。
- 型別檢查、測試和格式化在 commit *之前*就被找到並執行通過（綠燈），而非在你發現損毀之後。
- 你的工作樹乾淨且操作已完成，包括多 commit rebase 中剩餘的每個 commit。

## 它的定位

一個隨時可用的獨立工具，不依賴任何其他 skill：它在 git 停滯時啟動，在工作樹乾淨且已 commit 時結束。它唯一的真實鄰近 skill 是 [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs)，該 skill 在 merge 順利解決但合併後的程式碼表現異常時接手：這屬於診斷問題，而非衝突問題。它完全獨立於主要的從概念到交付流程，因此 [ask-matt](https://aihero.dev/skills-ask-matt) 是了解在其之前與之後執行什麼的地圖。
