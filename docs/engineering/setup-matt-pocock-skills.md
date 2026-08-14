## 功能說明

`setup-matt-pocock-skills` 回答關於單一儲存庫的三個問題 — 議題（issues）位於何處、triage 標籤稱作什麼，以及領域文件放置何處 — 並將答案記錄為 `docs/agents/` 下的 markdown 檔案。

這些檔案是儲存庫之間唯一不同的內容。技能本身在各處都是完全相同的；它們在執行階段讀取 `docs/agents/issue-tracker.md` 並按照其指示運作。這就是為什麼該集合不與 GitHub 綁定，以及為什麼任何技能檔案都無需編輯即可指向其他地方。使用「將技能連結至自訂議題追蹤器」呼叫它，適用於你可以透過程式碼連接的任何內容，且對技能零變更。

它是一個 Prompt 驅動的技能，而不是確定性的指令碼。它會讀取你的 `git remote`、現有的 `CLAUDE.md`、現有的 `CONTEXT.md`，提議其發現的內容，並等待你確認後才寫入任何內容。

## 何時使用

你透過輸入 `/setup-matt-pocock-skills` 來呼叫此技能 — [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會自行主動使用它。它被刻意標記為不可被呼叫，因此沒有其他技能可以為你觸發它。

每個儲存庫在第一次使用任何其他工程技能之前執行它一次。如果 [triage](https://aihero.dev/skills-triage)、[to-spec](https://aihero.dev/skills-to-spec)、[to-tickets](https://aihero.dev/skills-to-tickets) 或 [wayfinder](https://aihero.dev/skills-wayfinder) 開始猜測你的議題去了哪裡，或套用你的追蹤器所沒有的標籤，說明它們在此處尚未設定完成。專案已進行到一半的儲存庫也是執行它的好地方；本技能會讀取現有的內容，且先前的工作不會被浪費。

## 先決條件

它會寫入你執行它的儲存庫中：

| 寫入內容 | 位置 |
| --- | --- |
| `issue-tracker.md` | `docs/agents/` |
| `domain.md` | `docs/agents/` |
| `triage-labels.md` | `docs/agents/`（僅在安裝了 `triage` 技能時） |
| `## Agent skills` 區塊 | `CLAUDE.md` / `AGENTS.md` 中已存在的任何一個 |

所有內容都是已提交的 markdown。沒有使用者層級或全域模式：設定存在於儲存庫中，因此每個儲存庫都有自己的複本。

## 三個決策

它在每個章節開頭給出建議的解答，並跳過已經確定的探索。大多數執行只需兩次確認即可完成。

| 決策 | 提議內容 | 實際詢問時機 |
| --- | --- | --- |
| **議題追蹤器** | 符合你的 `git remote` 的追蹤器 | 始終 — 這是唯一真實的抉擇 |
| **Triage 標籤** | 保留五個規範名稱（`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`） | 僅在安裝了 `triage` 技能時 |
| **領域文件** | 單一 context：根目錄的一份 `CONTEXT.md` 加上 `docs/adr/` | 僅在發現 monorepo 訊號時，隨後會提供多 context 的 `CONTEXT-MAP.md` |

追蹤器選項：

| 選項 | 議題位置 | 需要 |
| --- | --- | --- |
| **GitHub** | 儲存庫的 GitHub Issues | `gh` CLI |
| **GitLab** | 儲存庫的 GitLab Issues | `glab` CLI |
| **本機 Markdown** | 此儲存庫中 `.scratch/<feature>/` 下的檔案 | 無需任何內容 — 完全不需要遠端 |
| **其他** | 無論你在何處指定 | 你描述工作流程的一段話 |

前三個選項作為技能中的範本發布，且開箱即用。本機 markdown 是第一類選項，而不是後備方案：完全支援沒有遠端的個人專案。有一個警示值得重複：如果你使用的是 GitHub，請勿使用本機 markdown。它們是替代方案，而不是分層。

「其他」也不是虛設。這正是 Jira、Linear、Azure DevOps 與 Beads 都能運作的原因：你描述工作流程，本技能將你的散文記錄在 `docs/agents/issue-tracker.md` 中，而下游技能會遵循該散文。社群已經實現了這一點 — 基於 [MCP](https://www.aihero.dev/ai-coding-dictionary/mcp) 的 Jira 變體、類似 `gh` 的 Gitea CLI、手建的本機儀表板。

## 常見問題

**我必須使用 GitHub 嗎？**

不需要。GitHub、GitLab 與 `.scratch/` 下的本機 markdown 均作為現成範本發布，而其他任何內容均可透過「其他」路徑運作。這是記錄中重複最多的問題，大約是這些字眼：*「硬性鎖定在 GitHub」*、*「我可以使用 GitLab / Jira 嗎」*、*「Azure DevOps 怎麼樣」*。每次的解答都是追蹤器是一個設定解答，而不是技能屬性。

**更新技能後我需要重新執行它嗎？**

在 v1.1 後被直接詢問時，Matt 說需要。技能自身的結尾訊息則較為緩和 — 它告訴你只有在切換追蹤器或重新開始時才需要重新執行。兩者都有其道理，且差距的原因是真實的：種子範本在版本之間會發生變更，因此由較舊版本寫入的 `docs/agents/issue-tracker.md` 相對於現在讀取它的技能而言可能會過期。如果下游技能開始做一些文件描述不同的事情，重新執行是代價低廉的修復方法。

**它寫入了 `CLAUDE.md`，但我使用的是 Codex。**

已知缺口，仍處於開放狀態。檔案選擇規則是「如果 `CLAUDE.md` 存在則編輯它，否則編輯 `AGENTS.md`」— 它檢查存在哪個檔案，而不是正在執行哪個 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)。帶有從 Claude Code 留下的 `CLAUDE.md` 的儲存庫會在 Codex 從未讀取的地方獲得其 `## Agent skills` 區塊。目前流傳著兩種替代方案：手動將該區塊移動至 `AGENTS.md`，或保持 `AGENTS.md` 為規範並使 `CLAUDE.md` 作為指向它的一行指標。如果這兩個檔案都不存在，該技能會詢問你要建立哪一個而不是直接挑選，這使那些期望它直接做決定的人感到困惑。

**它沒有建立我的 triage 標籤。**

它確實不會。`docs/agents/triage-labels.md` 是一份*對映（mapping）* — 它告訴 `/triage` 你追蹤器中的哪些字串對應於五個規範角色。它不會執行 `gh label create`。在全新的 GitHub 儲存庫上，標籤確實尚不存在，且這已被多次記錄為錯誤。兩個後續情況：

- 如果你的追蹤器已經使用規範名稱，對映是一個恆等表且無須設定任何內容。這是預期的常見情況，而不是缺失的步驟。
- [wayfinder](https://aihero.dev/skills-wayfinder) 的 `wayfinder:map` 與 `wayfinder:<type>` 標籤也不在這裡建立，且 `gh issue create --label <missing>` 會直接失敗而不是建立該標籤。在 GitHub 儲存庫上第一次執行 wayfinder 之前請手動建立它們。

**我可以在這裡設定其他技能的行為嗎 — [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（審問）節奏、問題格式、語氣？**

不行。它設定三件事：追蹤器、標籤、文件版面配置。已有直接要求將其作為每位使用者偏好設定的主頁，而標準答案是技能保持獨斷立論：*「設定即死亡（Config is death）。」* 偏好設定作為純文字指示屬於你的 `CLAUDE.md`，每個技能已經會讀取該檔案。

**我可以將設定存放在 `~/.claude` 中，而不是提交給每個儲存庫嗎？**

目前不行。來自在許多儲存庫中執行技能的人明確提出了對此的要求，但不存在使用者層級的模式。每個儲存庫都攜帶自己的 `docs/agents/`。

**擁有一個用來設定其他技能的技能難道不是很奇怪嗎？**

一個存在已久的抱怨用這些字眼說「是的」：*「擁有一個設定其他技能的技能對我來說感覺不對 — 那意味著 LLM 在設定它自己的技能。」* 權衡是真實存在的且獲得了承認：替代設定步驟的方案是將追蹤器指示複製到每個碰觸議題的技能中。輸出是可檢查、可編輯的 markdown，這是緩解措施 — 你可以閱讀它撰寫的每個檔案並手動進行變更，而日常的微調正是如此，而不是另一次執行。

## 運作正常的指標

- `docs/agents/issue-tracker.md` 與 `docs/agents/domain.md` 存在，如果安裝了 `triage` 則再加上 `triage-labels.md`。
- 在你的 harness 實際讀取的方向檔案中出現 `## Agent skills` 章節，帶有一行指向每個檔案的摘要。
- 它提議的追蹤器符合你真實使用的遠端，且標籤字串符合你追蹤器中真實存在的標籤。
- 隨後，`/to-tickets` 發布時不會詢問你議題位於何處，且 `/triage` 會套用標籤而不是捏造它們。
- 技能檔案本身的任何內容都沒有變更。如果 setup 編輯了 `SKILL.md`，說明出現了問題。

## 適用位置

`setup-matt-pocock-skills` 是工程流程的**單次執行設定**，是一切其他內容所假設的先決條件，而不是鏈結中的一個步驟。它的鄰居是它的讀者：[triage](https://aihero.dev/skills-triage)（套用此處寫入的標籤詞彙）、[to-spec](https://aihero.dev/skills-to-spec) 與 [to-tickets](https://aihero.dev/skills-to-tickets)（發布至此處命名的追蹤器），以及 [wayfinder](https://aihero.dev/skills-wayfinder)（讀取同一個追蹤器檔案的「Wayfinding operations」章節以了解地圖與子 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) 如何儲存）。它記錄的領域文件版面配置是 [domain-modeling](https://aihero.dev/skills-domain-modeling) 稍後填入的版面配置 — 它在術語或決策實際確定解決時以延遲方式建立 `CONTEXT.md` 與 ADR，因此設定後空無一物的儲存庫是預期狀態。對於接下來使用哪個技能，[ask-matt](https://aihero.dev/skills-ask-matt) 會為整個集合進行路由。
