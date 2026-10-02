## 它的功能

`triage` 處理專案追蹤器上的 issue，讓每個 issue 通過一個由 **triage 角色**（一個類別角色與一個狀態角色）組成的小型狀態機，並留下 agent 就緒的簡報、給回報者的具體問題，或是附帶記錄原因的已關閉 issue。

它僅適用於**非你所建立**的 issue。原始 bug 回報、收到的新功能請求、無預警送達的外部 pull request：從外部進入追蹤器的工作，無論回報者留下的形式為何。由 [to-tickets](https://aihero.dev/skills-to-tickets) 產生的 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 本質上就已經是 agent 就緒的，對它們執行 `triage` 充其量只是白費力氣。規則很明確：`/triage` 僅適用於傳入的 issue，而不適用於你自己建立的 issue。

將其與手動標記區分開來的第二點：它提出建議並等待。它會告訴你其類別與狀態判斷及推理依據，加上它在程式碼庫中找到的內容，且在得到你的指示之前不會套用任何變更。

## 何時使用它

你透過輸入 `/triage` 並用日常語言描述你的需求來呼叫它。[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會自行使用它。「顯示需要我注意的任何事項」、「我們來看看 #42」、「將 #42 移至 ready-for-agent」。

| 你擁有的內容 | 該去哪裡 |
| --- | --- |
| 充滿其他人原始回報的追蹤器 | `/triage` |
| 自己未成文的粗略想法 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 要轉化為[規格 (spec)](https://www.aihero.dev/ai-coding-dictionary/spec) 的確定對話 | [to-spec](https://aihero.dev/skills-to-spec) |
| 要拆分為 agent 就緒 ticket 的規格 | [to-tickets](https://aihero.dev/skills-to-tickets) |
| 需要根本原因而非標籤的已確認 bug | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |

## 先決條件

`triage` 會讀取並寫入你的 issue 追蹤器，因此 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 必須先設定好該追蹤器及其標籤詞彙。以下的角色名稱是**標準 (canonical)** 的；你的追蹤器中的標籤字串可能有所不同，而設定提供的正是這項對應關係。如果你的追蹤器已經完全使用標準名稱，則無需對應，也不需要任何設定。

追蹤器設定也決定外部 pull request 是否算作請求介面，以及誰算作外部人員。該旗標預設為關閉且不再是設定階段的問題，因此如果你希望將 PR 納入範圍，請在 `docs/agents/issue-tracker.md` 中將其開啟。

## 狀態機

每個經過分流的項目最終都會帶有剛好一個類別角色與一個狀態角色。兩個類別：`bug`（某些東西損壞）與 `enhancement`（新功能或改進）。五個狀態：

| 狀態 | 代表意義 |
| --- | --- |
| `needs-triage` | 你需要對其進行評估。未標記的 issue 通常首先進入此處。 |
| `needs-info` | 等待回報者回覆。在他們回覆後返回 `needs-triage`。 |
| `ready-for-agent` | 規格完備，附帶 agent 簡報。[AFK](https://www.aihero.dev/ai-coding-dictionary/afk) agent 可以接手。 |
| `ready-for-human` | 相同的簡報，加上無法委派的原因：主觀判斷、外部存取、手動測試。 |
| `wontfix` | 已關閉，並記錄原因。 |

這就是全部的詞彙，而「剛好一個狀態角色」的不變性保持了查詢的簡潔。這也是該 [skill](https://www.aihero.dev/ai-coding-dictionary/skill) 最常收到擴充請求的領域：使用者曾要求增加第六個狀態，用於已明確規範但受阻於另一個 issue 的工作；用於受未來觸發條件管制的 `deferred` 工作；以及用於終端終止的 `implemented` 狀態。這些都尚未發布。請參閱下方的常見問題。

`wontfix` 分為三種情況，其差異很重要，因為只有其中一種會寫入知識庫：

| 為何關閉它 | 會發生什麼事 |
| --- | --- |
| 已經實作 | 指向其既有位置的留言。不會在 `.out-of-scope/` 中寫入任何內容，因為它是已建構的功能而非被拒絕的功能，將其歸檔至該處會毒害去重檢查。 |
| 被拒絕的 bug | 禮貌的解釋，然後關閉。 |
| 被拒絕的 enhancement | 在 `.out-of-scope/` 中寫入一個檔案，從關閉留言中連結它，然後關閉。 |

`.out-of-scope/` 是每個被拒絕的**概念**一個 Markdown 檔案，而非每個 issue 一個檔案，寫成簡短的設計文件而非資料庫資料列：拒絕了什麼、原因，以及每個提出過該請求的 issue。`triage` 在評估任何事情之前會先讀取整個目錄，並按概念而非關鍵字進行比對，因此「night theme」能比對到 `dark-mode.md`。當發生相符時，它會浮現舊有的決定並詢問你是否仍持相同看法，而不是從頭開始重新爭論該請求。

## 簡報前先驗證

在進行任何 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) 之前，`triage` 會檢查陳述是否屬實。對於 bug，它會根據回報者的步驟重現它。對於 PR，它會簽出分支並執行相關測試。接著它會回報發生了三種情況中的哪一種：已確認並附帶程式碼路徑；重現失敗；或細節不足無法嘗試，而這本身就是最強烈的 `needs-info` 訊號。

它在同一輪處理中針對程式碼庫執行另外兩項檢查：**冗餘性 (redundancy)**（這是否已實作，以領域概念而非回報者的措辭進行搜尋？）與**先前拒絕 (prior rejection)**（`.out-of-scope/` 是否已經說了不？）。兩者的成本都極低，且命中時都會產出 `wontfix`。

這一切的存在都是為了讓一個產出物達到良好水準：**agent 簡報**，即當 issue 移至 `ready-for-agent` 時所發布的結構化留言。一旦發布，簡報就是契約，而原始回報僅作為背景資訊。簡報的撰寫原則是**持久**而非精確，因為 issue 可能在程式碼持續演進的情況下在 `ready-for-agent` 中停留數週。因此它們指定型別、簽章與行為契約，絕不指定檔案路徑或行號。確認過的重現所產出的簡報遠比猜測所產出的強大。

## PR 是附帶程式碼的 Issue

當追蹤器將外部 pull request 視為請求介面時，它們會通過相同的狀態機，具有相同的類別、相同的狀態、相同的轉換。這些狀態只是對照 diff 進行解讀：`ready-for-agent` 表示已附帶簡報且 agent 應對該程式碼採取下一步，`ready-for-human` 表示它已就緒可供人工合併。PR 上的簡報描述的是對既有 diff 還需要做什麼，而非如何從零建構該事物。

探索只會浮現*外部* PR，因為協作者進行中的分支不屬於分流工作。該篩選僅用於探索，明確指出某個 PR 會對其進行分流，無論是誰撰寫的。一個粗糙之處：GitHub 範本的外部 PR 列出指令向 `gh pr list` 請求一個 `gh` 未公開的 `authorAssociation` 欄位，因此照原樣撰寫的指令會直接失敗（[#468](https://github.com/mattpocock/skills/issues/468)）。

## 常見問題

**我執行了 `/to-spec` 和 `/to-tickets`，現在那些 ticket 處於未分流狀態。我要對它們執行 `/triage` 嗎？**
不要。它們已經是 agent 就緒的，因為 `to-tickets` 在發布時就會套用 `ready-for-agent` 標籤，正是為了讓 AFK 執行器在不需要額外流程的情況下接手它們。遇到此問題的使用者先前執行了規格流程，在輸出中看到 `needs-triage`，並發現他們的 AFK 執行器忽略了所有內容。`triage` 是外部進來之工作的入口匝道；規格流程是你發起之工作的專用車道。它們在 `ready-for-agent` 匯合，而非在此之前。

**現在有了 `to-spec` → `to-tickets` → `implement` 流程，`triage` 還有用嗎？**
只有在你有傳入工作時才有用。`triage` 早於該主幹存在，並且負責不同的工作：它是其他人提交之回報的專用車道。如果你追蹤器中的所有內容都來自你自己的規劃，你將很少打開它。如果你維護任何公開專案，或者你的團隊向你回報 bug，它就是正門入口。主要用途是接收來自外部貢獻者 issue 的開源儲存庫。

**Agent 嘗試套用 `ready-for-agent`，而 `gh` 表示該標籤不存在。**
已知未修復的 bug（[#616](https://github.com/mattpocock/skills/issues/616)）。`setup-matt-pocock-skills` 將標籤詞彙寫入 `docs/agents/triage-labels.md`，但不會在你的追蹤器中建立標籤。使用 `gh label create` 或追蹤器的 UI 自行建立這五個狀態標籤與兩個類別標籤一次，問題就會停止。該 issue 連結了一個尚未合併的社群修復分支。

**五個狀態不夠用：那 blocked、deferred 或 implemented 呢？**
這是該 skill 回報最多的缺口，分為三種形式。規格完備但等待另一個 issue 關閉的 issue（[#139](https://github.com/mattpocock/skills/issues/139)），回報者的抱怨是在那種情況下 `ready-for-agent`「技術上屬實」但具誤導性，因此 agent 接手後會碰壁。由觸發條件管制的未來工作，有意進行但尚不可行（[#297](https://github.com/mattpocock/skills/issues/297)）。以及用於「已實作，等待驗證」的終端狀態，沒有它 AFK 執行器可能會重新將已完成的 ticket 加入佇列。Matt 已同意 blocked 的情況是真實存在的，但在命名上猶豫不決（`blocked` 對比 `paused`）。這些都尚未發布。人們使用的替代做法是在類別旁使用儲存庫本地額外標籤，這保持了標準狀態位置被真實內容佔用，代價是該 skill 不知道它。有一個社群衍生版本走得更遠，新增了 `needs-slicing`、`tracking` 和工作量標籤。那樣可行，但那是他們自己的，不是該 skill 的。

**這與 `/diagnosing-bugs` 有何不同？**
這裡的驗證步驟特意保持淺層（足以回答「這是真的嗎，大約位在哪裡」），而不是找出根本原因。當 bug 無法在幾分鐘內根據回報者的步驟重現時，誠實的作法是標記為 `needs-info`，或者如果你現在想追查它，則使用 [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs)。這兩個 skill 的文字目前都沒有提到對方；有使用者發現了這個接縫，且目前仍未處理。

**我可以將它指向整個積壓工作並讓它執行嗎？**
你可以提出要求，但要留意它閱讀了什麼。「顯示需要注意的事項」流程是用於*選取*的低成本清單，讓你挑選一個，然後它針對你挑選的項目收集完整的[上下文 (context)](https://www.aihero.dev/ai-coding-dictionary/context)。一次在二十個 issue 上執行它，agent 可能會悄悄退回到以該低成本清單作為其證據基礎，而該清單只回傳 issue 內文而不包含留言。有一位使用者正好遇到了這種情況：三個 issue 已經帶有「已修復，建議關閉」的留言，結果這三個 issue 卻全都獲得了全新的 agent 簡報。如果你想要批次處理，請明確指出每個 issue 都必須閱讀留言。

**它能與 Linear 或除 GitHub Issues 之外的其他工具一起使用嗎？**
可以，追蹤器屬於設定項目，而非硬式編碼的假設，人們在 Linear（透過 `linear` CLI）、GitLab 以及 `.scratch/` 下的純 Markdown 檔案中執行它。常見的分工是使用 Linear 進行 issue 與規劃，使用 GitHub 進行程式碼與 PR：提及「issue tracker」的 skill 對應到 Linear，提及「PR」的 skill 對應到 GitHub。在本地 Markdown 追蹤器上存在一個待解的範本 bug，產生的檔案可能會包含兩次驗收條件，一次在頂層，一次在 agent 簡報內部（[#200](https://github.com/mattpocock/skills/issues/200)）。

## 若運作正常，會符合以下情況

- 它接觸的每個項目最終都剛好帶有一個類別角色與一個狀態角色，絕非零個，也絕不會有兩個衝突的狀態。
- 它為你提供帶有推理依據的建議並停下來，而不是直接重新標記並繼續處理下一個。
- 在任何內容達到 `ready-for-agent` 之前，bug 已經被重現，或者 PR 已經被簽出並執行。
- 它撰寫的簡報指定型別與行為，且不包含檔案路徑也不包含行號。
- 六個月前被拒絕的請求再次出現時，它會指出這一點並引用舊有的原因，而不是重新分流。
- 它發布的每則留言開頭都是 `> *This was generated by AI during triage.*`

## 它的定位

`triage` 是一個**入口匝道 (on-ramp)**，而非主鏈條中的一個步驟。主要流程從你產生的想法出發（grill、spec、tickets、implement、review），而 `triage` 是平行用來處理收到的外來工作的專用車道。它在同一個地方匯合：一個標記為 `ready-for-agent` 且附帶簡報的 issue，[implement](https://aihero.dev/skills-implement) 會像對待來自 [to-tickets](https://aihero.dev/skills-to-tickets) 的 ticket 一樣接手它。當請求在形成簡報前需要進一步明確化時，`triage` 會結合執行 [grilling](https://aihero.dev/skills-grilling) 與 [domain-modeling](https://aihero.dev/skills-domain-modeling)，一次進行一輪提問，以便決策在做出的同時記錄在 `GLOSSARY.md` 與 ADR 中。當你不確定自己在哪條車道時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你引導。
