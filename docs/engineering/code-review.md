## 功能說明

`code-review` 沿著兩個維度審查 `HEAD` 與你指定的固定點（commit、分支、tag、`main`、`HEAD~5`）之間的 diff。**Standards（規範）** 探討程式碼是否遵循此儲存庫撰寫程式碼的風格。**Spec（規格）** 探討程式碼是否達成了原始 issue 或 [spec](https://www.aihero.dev/ai-coding-dictionary/spec) 所要求的事項。每個維度都在各自獨立的 [sub-agent](https://www.aihero.dev/ai-coding-dictionary/subagent) 中執行，因此彼此不會看到對方的推論過程。

這兩個維度絕不合併，也絕不重新排序。報告結尾會列出*各維度*最嚴重的問題，並拒絕在兩者之間評選出單一總結，因為變更可能通過其中一個維度卻未通過另一個：完全遵循每項慣例卻實作了錯誤內容的程式碼能通過 Standards 但無法通過 Spec；完全符合 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 要求卻違反儲存庫慣例的程式碼則恰好相反。混合的結論會讓通過的維度掩蓋失敗的維度。

## 何時使用

輸入 `/code-review`，或者當你要求審查分支、PR、進行中的工作或「自 X 以來」的任何變更時，agent 會自動取用它。

| 你的情境 | 建議使用的技能 |
| --- | --- |
| 已存在 diff，且你想確認它是否建構得宜*並且*符合正確需求 | `code-review` |
| 你想在 diff 中搜尋錯誤：null 路徑、競爭條件、差一錯誤（off-by-one） | Claude Code 自帶的內建審查，而非本技能（參見下方的名稱衝突） |
| 尚未撰寫任何程式碼，且你希望以測試先行的方式撰寫 | [tdd](https://aihero.dev/skills-tdd) |
| 需要建構整個 spec，且包含審查 | [implement](https://aihero.dev/skills-implement)，它會自行呼叫此技能 |
| 整個程式碼庫出現架構偏離，而非單一 diff | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) |
| 某處發生故障且不知原因 | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |

你必須提供固定點。若未提供，該技能會主動詢問而非自行猜測；接著它會在產生任何 sub-agent 前，檢查參照是否解析成功且 diff 是否非空，因此打錯的分支名稱會在你的眼前報錯，而非在兩個 sub-agent 內部才失敗。

## 先決條件

Standards 維度無需任何先決條件。它會讀取儲存庫中記載的任何文件（`CODING_STANDARDS.md`、`CONTRIBUTING.md` 等），若儲存庫未記載任何內容，則退回使用內建的基準線。

Spec 維度需要 spec 存在且可被找到。它會依以下順序尋找：

1. commit 訊息中的 issue 參照（`#123`、`Closes #45`、GitLab 的 `!67`），透過 `docs/agents/issue-tracker.md` 擷取。
2. 你作為引數傳入的路徑。
3. `docs/`、`specs/` 或 `.scratch/` 下與分支或功能名稱相符的 spec 檔案。
4. 詢問你。

步驟 1 依賴由 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 寫入的 `docs/agents/issue-tracker.md`。若沒有該檔案，只要你傳入路徑，此維度仍可運作。如果完全沒有 spec，則會略過 Spec sub-agent，報告會顯示「無可用規格（no spec available）」，而非捏造需求。

## 兩個維度

| | Standards | Spec |
| --- | --- | --- |
| 核心問題 | 是否建構得宜？ | 是否符合正確需求？ |
| 讀取內容 | 儲存庫記載的規範，加上不良味道基準線 | 原始 issue 或 spec |
| 報告內容 | 記載的違規事項（可能屬強制性），以及不良味道（始終為主觀判斷） | 遺漏或部分未完成的需求、範圍蔓延、實作錯誤的需求 |
| 每個發現引用的依據 | 規範檔案與規則，或是具名味道加上程式碼區塊 | spec 的行號 |

本設計試圖避免的是不懂你規範的通用審查技能：它會挑出你程式碼庫中特意設計的部分，卻遺漏了程式碼庫實際上依賴的不變性。因此儲存庫本身的文件是 Standards 維度的[主要來源](https://www.aihero.dev/ai-coding-dictionary/primary-source)，且**儲存庫永遠具備最高優先權**。

**不良味道基準線（smell baseline）** 是底層的最低標準，源自 Fowler《重構》第 3 章的 12 種程式碼壞味道：神祕名稱（Mysterious Name）、重複程式碼（Duplicated Code）、依戀情結（Feature Envy）、資料泥團（Data Clumps）、基本型別偏執（Primitive Obsession）、重複 switch（Repeated Switches）、散彈式修改（Shotgun Surgery）、發散式變化（Divergent Change）、誇誇其談未來性（Speculative Generality）、訊息鏈（Message Chains）、中間人（Middle Man）、被拒絕的遺贈（Refused Bequest）。每一種都是帶有標籤的啟發式判斷（如「可能存在 Feature Envy」），絕非強制違規，且每項都陳述為*是什麼* → *如何修復*，因此發現問題時會附帶改進措施而非單純抱怨。任何你的 linter 已經強制執行的項目都會被兩個維度略過。

## 常見問題

**它與 Claude Code 內建的 `/code-review` 衝突。我該怎麼辦？**

這是該技能回報最多的問題，且尚未修復。Claude Code 自帶其 `/code-review`，功能截然不同：它是在 diff 中尋找錯誤，而本技能則是檢查 spec 合規性與儲存庫規範。安裝此函式庫表示其中之一會勝出，具體取決於你的安裝方式。透過外掛程式市集，所有內容都會加上 `mattpocock-skills:` 前綴別名，使內建指令難以透過不加前綴的名稱調用；透過一般 skills 安裝，本機檔案勝出，此技能會遮蔽內建指令。一個俐落的解法是完全移除 Claude Code 的內建技能：可大幅節省 [context](https://www.aihero.dev/ai-coding-dictionary/context)，且衝突不再重要。遮蔽現象本身可說是 Claude Code [harness](https://www.aihero.dev/ai-coding-dictionary/harness) 的錯誤（技能作者理應能自由命名任何技能），因此另一個解法是重新命名本機副本。編輯 frontmatter 或重命名目錄會在執行 `npx skills update` 時被還原；使用者回報的長久替代方案是 fork 該技能為新名稱，並從受管集合中移除 `code-review`，同時記下 fork 時的 commit 以便手動重新同步。

**它的 sub-agents 不斷再次呼叫 `/code-review` 並產生更多 agents。**

這是已知且未修復的錯誤，已由多人在不同 harness 中重現。Standards 與 Spec 的提示詞未禁止委派，因此 sub-agent 可能重新發現該技能並再次擴散：曾有回報指出產生了超過 50 個 agents。人們在 fork 版本中應用的修復方法是在兩個 sub-agent 的指示中附加一行：「Do not invoke `/code-review` or spawn additional agents: perform this review directly.（請勿呼叫 `/code-review` 或產生額外 agent：直接執行此次審查。）」有些人偏好在 harness 層級處理，讓每個技能都能繼承此防護。兩者都尚未納入官方釋出的技能中。若你在無人看管時執行，請留意 agent 數量。

**我應該在撰寫程式碼的同一個 [session](https://www.aihero.dev/ai-coding-dictionary/session) 中執行它嗎？**

建議使用全新 session。正如一位讀者所言：「相同的 context 審查自身並非真正的審查，而是帶有斜線指令的確認偏差。」撰寫 session 中的審查 agent 擁有塑造該程式碼時的所有假設，而這恰恰是獨立審查者所不會具備的 context。這也是為何人們希望 [implement](https://aihero.dev/skills-implement) 不要內建審查步驟：因為它是在剛寫出 diff 的 session 內部執行審查。自行從乾淨的 session 呼叫 `/code-review` 才是踏實的做法。

**在每張票券完成後執行，還是最後統一執行一次？**

兩種皆可行，該技能不會替你決定。每張票券分別審查可讓每次的 diff 足夠精巧，使 Spec 維度有清晰單一的規格進行檢查，這也是 `implement` 採用的模式。批次延至分支末端審查則能捕捉到個別票券審查所忽略的互動影響。若你不確定，建議每張票券分別審查，並在分支點進行最後一次總審查。

**我可以信任審查發現的問題嗎？**

未經檢查前不可輕信。Sub-agent 的輸出只是假設，並非證據：有團隊回報散文式審查曾輕易放行了十幾處破壞性變更。該技能是將兩份報告逐字或略微清理後彙整，而非對照檔案重新驗證每項陳述，因此某項發現可能引用錯誤位置或誇大影響。採取行動前請先閱讀每項發現的引用依據。每項發現都必須攜帶依據（規範規則、不良味道及程式碼區塊、或 spec 行號），這正是使其具備可檢查性的關鍵。

**為什麼每次執行它都會發現新問題？**

因為修復會產生新的接觸面，且 Standards 維度中主觀判斷的部分在多次執行間並非確定性的。一位讀者直白地描述了這個循環：「/code-review 與 /improve-code-architecture 每次都能發現新東西。我實作修復、重新執行這些技能，一次又一次。」這並不能保證收斂。請將每次審查看作一份線索清單，針對背後有明確規範依據的項目進行處理即可停止：不要反覆循環執行直到完全沒有問題，因為那不會發生。

**它會審查我尚未 commit 的工作嗎？**

不會。它比對的是 `<fixed-point>...HEAD`（三點標記法），這是從 merge-base 算起，並排除了 staged 與 working-tree 的變更。若 `implement` 尚未建立過渡 commit，即將被 commit 的工作在審查中是隱形的。請先 commit 再進行審查，接著使用 amend 或加入 fixup。

## 運作正常的指標

- 在產生任何 sub-agent 之前，它會拒絕在錯誤的 ref 或空的 diff 上啟動。
- 報告以 `## Standards` 與 `## Spec` 兩個獨立區塊呈現，而非合併的單一清單。
- 每項 Standards 發現皆指出儲存庫檔案中的規則或 12 種不良味道之一，並引述程式碼區塊；每項 Spec 發現皆引述 spec 中的某一行。
- 結尾摘要列出各維度最嚴重的問題，並拒絕評選出總結。
- 在無可用 spec 的情況下，Spec 區塊會明確說明這一點，而非列出從程式碼推斷的需求。

## 適用位置

`code-review` 是建構鏈條尾端的審查步驟：`grill-with-docs → to-spec → to-tickets → implement → code-review → retro`。它也可以獨立針對你指定的任何分支或 PR 執行。

- [implement](https://aihero.dev/skills-implement) 是最接近的相鄰技能：它推動建構，並在 commit 之前呼叫此技能作為自身的收尾審查。[implement-spec](https://aihero.dev/skills-implement-spec) 則在整個整合分支上執行一次相同操作。
- [retro](https://aihero.dev/skills-retro) 接續在其後並進行微調：當某個 session 顯示審查遺漏了某類錯誤時，`retro` 會提出檢查建議或 `CODING_STANDARDS.md` 規則，供 Standards 維度後續讀取。
- [pr](https://aihero.dev/skills-pr) 在審查完成的工作推送後撰寫 pull request 內文。
- [to-spec](https://aihero.dev/skills-to-spec) 與 [to-tickets](https://aihero.dev/skills-to-tickets) 產生供 Spec 維度對照檢查的文件；模糊的 spec 會使該維度變得模糊。
- [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 是涵蓋整個程式碼庫的對應技能：本技能僅檢視單一 diff。

當你不確定當前情境需要哪項技能時，[ask-matt](https://aihero.dev/skills-ask-matt) 可在整個技能集合間進行路由。
