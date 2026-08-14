## 功能說明

`code-review` 沿著兩個軸度審查 `HEAD` 與你指定的固定點（提交、分支、標籤、`main`、`HEAD~5`）之間的差異（diff）。**Standards**（標準）詢問程式碼是否符合此儲存庫撰寫程式碼的方式。**Spec**（規格）詢問程式碼是否實現了原始議題或 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格）所要求的事物。每個軸度都在自己的 [sub-agent](https://www.aihero.dev/ai-coding-dictionary/subagent)（子 agent）中執行，因此兩者都不會看到對方的推理過程。

這兩個軸度絕不會合併，也絕不會重新排名。報告以*每個軸度*最嚴重的問題結尾，並拒絕在它們之間指定單一的勝出者，因為一項變更可以通過一個軸度卻在另一個軸度失敗：在實現錯誤事物的同時遵循每項約定的程式碼通過了 Standards 卻在 Spec 失敗；完全按照 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 要求做卻違反儲存庫約定的程式碼則相反。混合的裁決會讓通過的軸度掩蓋失敗的軸度。

## 何時使用

輸入 `/code-review`，或者當你要求審查分支、PR、進行中的工作或「自 X 以來」的任何內容時，agent 會自動使用它。

| 你的狀況 | 使用技能 |
| --- | --- |
| 存在 diff 且你想知道它是否被正確建構*以及*是否為正確的事物 | `code-review` |
| 你想在 diff 中尋找錯誤 — 空值路徑（null paths）、競態（races）、差一錯誤（off-by-one） | Claude Code 自身的內建審查，而非本技能（參見下方的名稱衝突） |
| 尚未撰寫任何內容，且你想以測試先行（test-first）方式撰寫 | [tdd](https://aihero.dev/skills-tdd) |
| 需要建構整個規格，包含審查在內 | [implement](https://aihero.dev/skills-implement)，它自己會呼叫此技能 |
| 整個程式碼庫發生了偏離，而非單一 diff | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) |
| 某些東西損壞了而你不知道原因 | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |

你必須提供固定點。如果你沒有提供，技能會詢問一個而不是去猜測；然後它會在產生任何內容之前檢查 ref 能否解析以及 diff 是否非空，因此打錯的分支名稱會在你的眼前失敗，而不是在兩個 sub-agent 內部失敗。

## 先決條件

Standards 軸度不需要任何東西。它會讀取儲存庫所記錄的任何內容（`CODING_STANDARDS.md`、`CONTRIBUTING.md` 等），並在儲存庫未記錄任何內容時退回至內建基準線。

Spec 軸度需要規格存在且可被找到。它按以下順序尋找：

1. 提交訊息中的議題參考（`#123`、`Closes #45`、GitLab 的 `!67`），透過 `docs/agents/issue-tracker.md` 擷取。
2. 你作為引數傳入的路徑。
3. 在 `docs/`、`specs/` 或 `.scratch/` 下符合分支或功能名稱的規格檔案。
4. 詢問你。

步驟 1 依賴於 `docs/agents/issue-tracker.md`，該檔案由 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 寫入。如果沒有它，只要你交給它一個路徑，該軸度仍可運作。在完全沒有規格的情況下，Spec sub-agent 會被跳過，且報告會顯示「no spec available」（無可用規格），而不是捏造需求。

## 兩個軸度

| | Standards | Spec |
| --- | --- | --- |
| 問題 | 它是否被正確建構？ | 它是否為正確的事物？ |
| 讀取內容 | 儲存庫記錄的標準，加上 smell 基準線 | 原始議題或規格 |
| 報告內容 | 記錄的違規（可以是硬性的），以及 smell（始終是判斷呼叫） | 缺失或部分需求、範疇蔓延（scope creep）、實作錯誤的需求 |
| 每項發現引述 | 標準檔案與規則，或具名的 smell 加上程式碼區塊（hunk） | 規格的行號 |

一個不知道你標準的通用審查技能正是此設計試圖避免的 — 它會標記你程式碼庫中蓄意為之的內容，並遺漏你的程式碼庫實際上所依賴的不變性（invariants）。因此，儲存庫本身的檔案是 Standards 軸度上的 [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source)（第一手來源），且**儲存庫永遠優先覆寫**。

**smell 基準線**是底層的基石：來自《重構》第 3 章的 12 個 Fowler 程式碼壞氣味（code smells）— 晦澀名稱（Mysterious Name）、重複程式碼（Duplicated Code）、依戀情結（Feature Envy）、資料泥團（Data Clumps）、基本類型偏執（Primitive Obsession）、重複開關（Repeated Switches）、發散式修改（Shotgun Surgery）、發散式變化（Divergent Change）、誇誇其談通用性（Speculative Generality）、訊息鏈（Message Chains）、中間人（Middle Man）、被拒絕的遺贈（Refused Bequest）。每一個都是帶有標籤的啟發式判斷（例如「可能的 Feature Envy」），絕非硬性違規，且每一個都陳述為*是什麼* → *如何修復*，因此發現問題時會附帶解決步驟而非抱怨。你的 linter 已經強制執行的任何內容都會被這兩個軸度跳過。

## 常見問題

**它與 Claude Code 自身的 `/code-review` 發生衝突。我該怎麼辦？**

這是該技能回報最多的問題，且尚未修復。Claude Code 附帶了自己的 `/code-review`，它做的事不同 — 它在 diff 中尋找錯誤，而本技能則檢查規格相容性與儲存庫標準。安裝此函式庫意味著其中一個會勝出，而哪一個勝出取決於你的安裝方式。透過外掛程式市場，所有內容都會在 `mattpocock-skills:` 前綴下建立別名，而內建技能在未限定名稱下變得難以存取；透過純技能安裝，本機檔案勝出且此技能會遮蔽（shadow）內建技能。一個乾淨的解答是完全移除 Claude Code 的內建技能：節省大量 [context](https://www.aihero.dev/ai-coding-dictionary/context)，且衝突不再重要。遮蔽本身可以說是 Claude Code [harness](https://www.aihero.dev/ai-coding-dictionary/harness) 的錯誤 — 技能作者應該可以自由地將技能命名為任何名稱 — 因此另一個解答是重新命名本機複本。編輯 frontmatter 或重新命名目錄會被 `npx skills update` 復原；使用者回報的持久替代方案是將技能 fork 為新名稱並從管理集合中刪除 `code-review`，同時保留你 fork 之提交的記錄，以便你可以手動重新同步。

**它的 sub-agent 不斷再次呼叫 `/code-review` 並產生更多 agent。**

這是已知的開放錯誤，已被多人及多個 harness 重現。Standards 與 Spec prompt 並未禁止委派，因此 sub-agent 可以重新發現該技能並再次展開 — 有一份報告達到了 50 個以上的 agent。人們在 fork 上採用的修復方法是在兩個 sub-agent 簡報中附加一行：「不要呼叫 `/code-review` 或產生額外的 agent — 請直接執行此審查。」有些人偏好在 harness 層級處理，以便每個技能都繼承防護。兩者都尚未包含在發布的技能中。如果你無人值守執行此技能，請留意 agent 數量。

**我應該在撰寫程式碼的同一個 [session](https://www.aihero.dev/ai-coding-dictionary/session)（工作階段）中執行它嗎？**

偏好使用全新工作階段。正如一位讀者所言：「相同的 context 審查自身不是審查，而是帶有斜線指令的確認偏誤。」在創作工作階段中的審查 agent 擁有塑造程式碼的每一個假設，這恰恰是獨立審查者所不會擁有的 context。這也是為什麼人們要求沒有內建審查步驟的 [implement](https://aihero.dev/skills-implement) — 它在剛剛撰寫 diff 的工作階段內部執行審查。由你在乾淨的工作階段中自己呼叫 `/code-review` 才是真誠的版本。

**在每個 ticket 之後，還是在最後執行一次？**

兩者皆可，且技能不會為你做決定。按 ticket 處理可使每個 diff 足夠小，從而讓 Spec 軸度有一個明確的規格可進行比對，這也是 `implement` 所使用的模式。批量處理至分支末端可捕捉各 ticket 之間相互作用，這是單獨按 ticket 檢查時會遺漏的。如果你不確定，請按 ticket 審查並針對分支點執行最後一次審查。

**我可以信任這些發現嗎？**

未經檢查前不行。Sub-agent 的輸出是假設而非證據 — 一個團隊回報了十幾個破壞性變更，而基於散文的審查放過了這些變更。該技能逐字或輕度清理地彙整這兩份報告，而不是針對檔案重新驗證每項主張，因此發現可能會引述錯誤位置或誇大影響。在採取行動前請閱讀每項發現的引述。要求每項發現都必須帶有一個引述 — 標準規則、smell 加上其程式碼區塊，或規格行號 — 這正是使其完全可被檢查的原因。

**為什麼我每次執行它都會發現新問題？**

因為修復會建立新的表面，且因為 Standards 軸度中屬於判斷呼叫的部分在多次執行之間並非確定性的。一位讀者平實地描述了這個迴圈：「/code-review 與 /improve-code-architecture 每次都會發現新東西。我實作修復、重新執行這些技能，一次又一次。」這沒有收斂保證。將一次審查視為線索清單，針對背後有引述規則的線索採取行動，然後停止 — 不要循環執行它直到它返回乾淨結果，因為它不會。

**它會審查我未提交的工作嗎？**

不會。它對 `<fixed-point>...HEAD` 進行三點 diff，這是從 merge-base 測量的，排除了暫存區（staged）與工作區（working-tree）的變更。如果 `implement` 尚未進行臨時提交，則即將提交的工作對審查而言是不可見的。請先提交，然後審查，再進行修訂（amend）或新增修復提交（fixup）。

## 運作正常的指標

- 在產生任何 sub-agent 之前，它會拒絕在無效 ref 或空 diff 上啟動。
- 報告分為 `## Standards` 與 `## Spec` 下的兩個獨立區塊呈現，而非單一合併的清單。
- 每項 Standards 發現要麼指定你儲存庫檔案中的規則，要麼指定 12 個 smell 之一，並引用程式碼區塊；每項 Spec 發現都會引用規格的一行。
- 結尾摘要給出每個軸度中最嚴重的問題，並拒絕挑選整體勝出者。
- 在無可用規格的情況下，Spec 區塊會如此表明，而不是列出它從程式碼推論出的需求。

## 適用位置

`code-review` 是建構鏈結尾端的審查步驟 — `grill-with-docs → to-spec → to-tickets → implement → code-review` — 並且也可以獨立應用於你指向的任何分支或 PR 上。

- [implement](https://aihero.dev/skills-implement) 是最接近的鄰居：它驅動建構並在提交前呼叫本技能作為其本身的結尾審查。
- [to-spec](https://aihero.dev/skills-to-spec) 與 [to-tickets](https://aihero.dev/skills-to-tickets) 產生 Spec 軸度所比對的文件；模糊的規格會使該軸度變得模糊。
- [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 是涵蓋整個程式碼庫的對應技能 — 本技能永遠只檢視單一 diff。

[ask-matt](https://aihero.dev/skills-ask-matt) 當你不確定該狀況需要哪個技能時，會在整個集合中進行路由。
