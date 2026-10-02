## 它的功能

`setup-matt-pocock-skills` 回答關於一個儲存庫的三個問題：issue 存放在哪裡、triage 標籤稱作什麼，以及領域文件位於何處。它將答案記錄為 `docs/agents/` 下的 Markdown 檔案。

這些檔案是不同儲存庫之間唯一變化的內容。Skills 本身在各處都是相同的；它們在執行時讀取 `docs/agents/issue-tracker.md` 並按照其指示操作。這就是為什麼這組技能不綁定於 GitHub，以及為什麼從不需要編輯任何 skill 檔案來將其指向其他地方。以「將 skills 連結至自訂 issue 追蹤器」呼叫它，適用於任何你可以透過程式設計方式連線的工具，且對 skills 零變更。

它是一個 prompt 導向的 skill，而非確定性指令碼。它讀取你的 `git remote`、既有的 `CLAUDE.md`、既有的 `GLOSSARY.md`，提議它所找到的內容，並在寫入任何內容之前等待你的確認。

## 何時使用它

你透過輸入 `/setup-matt-pocock-skills` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會自行使用它。它被特意標記為不可呼叫（non-invokable），因此沒有其他 skill 可以為你觸發它。

每個儲存庫使用一次，在首次使用任何其他工程 skill 之前。如果 [triage](https://aihero.dev/skills-triage)、[to-spec](https://aihero.dev/skills-to-spec)、[to-tickets](https://aihero.dev/skills-to-tickets) 或 [wayfinder](https://aihero.dev/skills-wayfinder) 開始猜測你的 issue 該去哪裡，或者套用你的追蹤器沒有的標籤，代表它們尚未在此設定。已經進行到一半的專案儲存庫也是執行它的好地方；該 skill 會讀取既有的內容，先前的成果不會浪費。

## 先決條件

它會寫入你執行它的儲存庫中：

| 它寫入的內容 | 位置 |
| --- | --- |
| `issue-tracker.md` | `docs/agents/` |
| `domain.md` | `docs/agents/` |
| `triage-labels.md` | `docs/agents/`，僅在安裝了 `triage` skill 時 |
| 一個 `## Agent skills` 區塊 | `CLAUDE.md` / `AGENTS.md` 中已存在者 |

所有這些都是會被 commit 的 Markdown。沒有使用者層級或全域模式：設定存在於儲存庫中，因此每個儲存庫都會獲得自己的複本。

## 三個決定

它在每個小節開頭給出建議的答案，並跳過任何已經確定過的探索。大多數執行只需兩次確認即可完成。

| 決定 | 它提議的內容 | 它何時會真正詢問 |
| --- | --- | --- |
| **Issue 追蹤器** | 與你的 `git remote` 相符的追蹤器 | 總是詢問：這是唯一真正的選擇 |
| **Triage 標籤** | 保留五個標準名稱（`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`） | 僅在安裝了 `triage` skill 時 |
| **領域文件** | 單一上下文：根目錄下的一個 `GLOSSARY.md` 加上 `docs/adr/` | 僅在偵測到 monorepo 跡象時，隨後它會提供多上下文的 `GLOSSARY-MAP.md` |

追蹤器選項：

| 選項 | Issue 存放處 | 需要 |
| --- | --- | --- |
| **GitHub** | 該儲存庫的 GitHub Issues | `gh` CLI |
| **GitLab** | 該儲存庫的 GitLab Issues | `glab` CLI |
| **本地 Markdown** | 本儲存庫中 `.scratch/<feature>/` 下的檔案 | 無：完全不需要遠端 |
| **其他** | 任何你指定的地方 | 來自你描述工作流程的一段文字 |

前三個選項在 skill 中隨附範本，開箱即用。本地 Markdown 是一等公民選項，而非退而求其次的備案：完全支援沒有遠端的個人專案。有一個注意事項值得重申：如果你使用的是 GitHub，請不要使用本地 Markdown。它們是替代方案，而非層級關係。

「其他」也不是虛設。這正是 Jira、Linear、Azure DevOps 和 Beads 都能運作的原因：你描述工作流程，該 skill 將你的文字記錄在 `docs/agents/issue-tracker.md` 中，而下游的 skills 則遵循該文字說明。社群已經實踐了這一點：透過 [MCP](https://www.aihero.dev/ai-coding-dictionary/mcp) 的 Jira 變體、類似 `gh` 形式的 Gitea CLI、手動建構的本地儀表板。

## 常見問題

**我必須使用 GitHub 嗎？**

不需要。GitHub、GitLab 以及 `.scratch/` 下的本地 Markdown 都隨附現成的範本，其他任何工具都可以透過「其他」路徑運作。這是記錄中重複最多次的問題，字句大致如下：*「硬性綁定到 github 嗎」*、*「我可以使用 GitLab / Jira 嗎」*、*「那 Azure DevOps 呢」*。每一次的回答都是追蹤器屬於設定階段的答案，而非 skill 的屬性。

**更新 skills 後我需要重新執行它嗎？**

在 v1.1 之後被直接問到時，Matt 回答說需要。該 skill 本身的結尾訊息則較為緩和：它告訴你只有在切換追蹤器或重新開始時才需要重新執行。兩者都有其道理，差距的原因也很真實：種子範本在版本之間會發生變化，因此由舊版本撰寫的 `docs/agents/issue-tracker.md` 可能會與現在讀取它的 skills 脫節。如果下游 skill 開始做出與文件描述不同的行為，重新執行是代價極低的修復方式。

**它寫入到了 `CLAUDE.md`，但我使用的是 Codex。**

已知缺口，仍未解決。檔案選取規則是「如果 `CLAUDE.md` 存在則編輯它，否則編輯 `AGENTS.md`」：它檢查的是哪個檔案存在，而不是當前正在執行哪個 [harness](https://www.aihero.dev/ai-coding-dictionary/harness)。留有 Claude Code 遺留之 `CLAUDE.md` 的儲存庫，會將其 `## Agent skills` 區塊寫入 Codex 永遠不會讀取的地方。目前有兩種流通的因應措施：手動將該區塊移至 `AGENTS.md`，或者保持 `AGENTS.md` 為標準並讓 `CLAUDE.md` 成為指向它的一行指標。如果兩個檔案都不存在，該 skill 會詢問你要建立哪一個，而不是自行挑選，這讓原本期望它直接決定的使用者感到困惑。

**它沒有建立我的 triage 標籤。**

它本就不會。`docs/agents/triage-labels.md` 是一個*對應表 (mapping)*：它告訴 `/triage` 你的追蹤器中的哪些字串對應至五個標準角色。它不會執行 `gh label create`。在全新的 GitHub 儲存庫上，這些標籤確實還不存在，這已被不只一次回報為 bug。兩個後續重點：

- 如果你的追蹤器已經使用標準名稱，該對應表就是恆等表，沒有任何東西需要設定。這是預期的常見情況，而非遺漏的步驟。
- [wayfinder](https://aihero.dev/skills-wayfinder) 的 `wayfinder:map` 和 `wayfinder:<type>` 標籤也不會在此建立，而且 `gh issue create --label <missing>` 會直接失敗而非建立該標籤。在 GitHub 儲存庫上首次執行 wayfinder 之前，請手動建立它們。

**我可以在這裡設定其他 skill 的行為嗎（[grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) 步調、提問格式、語氣）？**

不行。它只設定三件事：追蹤器、標籤、文件配置。曾有直接請求希望將其作為個別使用者偏好的存放處，而既定的回答是 skills 保持有主見：*「設定即死亡（Config is death）。」*偏好設定屬於你的 `CLAUDE.md` 中的純文字指示，所有 skill 本身都會讀取它。

**我可以將設定保存在 `~/.claude` 中，而不是 commit 到每個儲存庫嗎？**

目前不行。有一位跨多個儲存庫執行 skills 的使用者曾對此提出過明確請求，目前不存在使用者層級的模式。每個儲存庫都承載自己的 `docs/agents/`。

**擁有一個用來設定其他 skill 的 skill 不是很奇怪嗎？**

有一則長期存在的抱怨持肯定態度，字句如下：*「有一個用來設定其他 skill 的 skill 感覺不太對勁：這意味著 LLM 正在設定它自己的 skills。」*這種取捨是真實且被承認的：取代設定步驟的替代方案是將追蹤器指示複製到每個接觸 issue 的 skill 中。其輸出是可檢查、可編輯的 Markdown，這正是緩解措施：你可以閱讀它寫入的每個檔案並手動更改，而日常的微調正是如此，不需要再次執行。

## 若運作正常，會符合以下情況

- `docs/agents/issue-tracker.md` 與 `docs/agents/domain.md` 存在，若安裝了 `triage` 則還包括 `triage-labels.md`。
- 一個 `## Agent skills` 小節出現在你的 harness 實際讀取的指示檔案中，並帶有一行摘要指向每個檔案。
- 它提議的追蹤器與你實際使用的遠端相符，且標籤字串與你的追蹤器中實際存在的標籤相符。
- 隨後，`/to-tickets` 發布時不會詢問你 issue 存放在何處，且 `/triage` 會套用標籤而非憑空捏造標籤。
- Skill 檔案本身沒有任何變更。如果 setup 編輯了 `SKILL.md`，代表某些地方出錯了。

## 它的定位

`setup-matt-pocock-skills` 是工程流程的**單次執行設定 (run-once setup)**，是其他所有工具假設存在的前提條件，而非鏈條中的某一步驟。它的鄰居是它的讀者群：套用此處寫入之標籤詞彙的 [triage](https://aihero.dev/skills-triage)；發布至此處所指定追蹤器的 [to-spec](https://aihero.dev/skills-to-spec) 與 [to-tickets](https://aihero.dev/skills-to-tickets)；以及讀取同一追蹤器檔案中「Wayfinding operations」小節以了解地圖與子 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 如何儲存的 [wayfinder](https://aihero.dev/skills-wayfinder)。它記錄的領域文件配置是 [domain-modeling](https://aihero.dev/skills-domain-modeling) 隨後填入的內容：它會在術語或決策實際被解決時延遲建立 `GLOSSARY.md` 和 ADR，因此設定後儲存庫為空是預期的狀態。至於接下來該使用哪個 skill，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整個集合中進行路由。
