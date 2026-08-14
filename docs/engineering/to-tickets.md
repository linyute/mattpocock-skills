## 它的功能

`to-tickets` 會取得一份計畫、一份 [spec](https://www.aihero.dev/ai-coding-dictionary/spec) 或您當前所在的對話，並將其拆解為問題追蹤器 (issue tracker) 上的一組 **[工單](https://www.aihero.dev/ai-coding-dictionary/ticket)**。每張工單都會宣告其**阻塞邊緣 (blocking edges)** — 即在該工單開始之前必須先完成的其他工單。

每張工單都是一顆**曳光彈 (tracer bullet)**：一條穿過變更每個層級（Schema、API、UI、測試）的狹窄但完整的路徑，在落地的瞬間即可獨立進行展示 (demo)。正是這個約束使其行為不同於顯而易見的工作拆分方式（即一次切分一個層級並在最後進行整合）。它還調整了每張工單的大小，使其適合放置在單個全新的 [內容視窗](https://www.aihero.dev/ai-coding-dictionary/context-window) 中，因為接手該工單的是一個從未看過您的規格的 [階段作業](https://www.aihero.dev/ai-coding-dictionary/session)。

## 何時使用它

您可透過輸入 `/to-tickets` 來呼叫此功能 — [Agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會主動使用它。

| 您當前的情況 | 要執行的內容 |
| --- | --- |
| 您有一個規格 Issue，且建構過程跨越多個階段作業 | `/to-tickets`，或 `/to-tickets #<spec_issue>` |
| 計畫僅存在於對話中，從未寫下 | `/to-tickets` 直接讀取討論串 — 不需要規格 |
| 整个變更適合在單個內容視窗中完成 | [implement](https://aihero.dev/skills-implement) — 跳過工單 |
| 尚未做出任何決定 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，然後執行 [to-spec](https://aihero.dev/skills-to-spec) |
| [wayfinder](https://aihero.dev/skills-wayfinder) 地圖已清除 | 先執行 [to-spec](https://aihero.dev/skills-to-spec) 以收合地圖，然後執行 `/to-tickets` |

`to-tickets` 產生的工單在結構上已具備 Agent 隨時可執行的狀態 (agent-ready)。不要對它們執行 [triage](https://aihero.dev/skills-triage) — triage 是針對來自其他人的工作。

## 先決條件

`to-tickets` 會發布到追蹤器中，因此 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 必須已經為此儲存庫設定好追蹤器以及 triage 標籤詞彙表。兩種方式皆可：像 GitHub 或 Linear 這樣的真實追蹤器，或是 `.scratch/` 下的本機 Markdown 檔案（這是預設支援的）。

## 曳光彈，而非層級

**水平**切片會交付變更的一個層級。在每個層級落地之前，沒有任何東西可以正常運作，且每張工單的驗收條件都必須延伸到另一張工單所擁有的工作中。**垂直**切片 — 即曳光彈 — 會一次交付穿過所有層級的一條薄薄路徑，因此它可以單獨進行驗證，並擁有它所評分的所有內容。

這是人們最常違反的規則，其後果也有詳細記載。有一個團隊使用了按層級切分的 26 張工單堆疊（Corpus、Producer、Aggregator、Selector），每張關閉的工單大約進行了 20 次 Agent 執行，其中約四分之三是重工。他們自己的事後檢討將每一個失敗類別都歸咎於水平切片，而非具體實作。

在發布任何內容之前會發生兩件事。`to-tickets` 會尋找預先重構 (prefactoring) —「讓變更變得容易，然後進行容易的變更」— 並優先排序該工作。然後它會將拆解結果以編號列表呈現並對您進行測驗：粒度是否適當、阻塞邊緣是否真實、是否應該合併或拆分任何內容。在您批准之前，沒有任何內容會到達追蹤器，而該測驗就是表達反對意見的地方。

## 阻塞邊緣

這些邊緣是產物 (artifact) 的核心重點。根據追蹤器的不同，它們有兩種讀取方式：

| 追蹤器 | 邊緣存在的位置 | 您如何處理它們 |
| --- | --- | --- |
| 本機 Markdown | 位於 `.scratch/<feature>/issues/<NN>-<slug>.md` 下每個工單一個檔案中的文字，依阻塞項優先編號 | 由上至下，手動處理 |
| 真實追蹤器 (GitHub, Linear) | 原生阻塞連結，或是追蹤器具備的子 Issue | 任何阻塞項已完成的工單都處於**前沿 (frontier)**，可以被接手 |

無論哪種方式，邊緣都存在於工單中。介質僅決定是否有任何事物可以平行處理它們。`to-tickets` 會產生產物；執行它 — 一次一個階段作業，或是一個機隊 — 是您的工作，而不是 Skill 的工作。

## 廣泛重構的例外

有一種型態會打破曳光彈規則。**廣泛重構 (wide refactor)** 是單一的機械式變更 — 重新命名欄位、重新定義共享符號的型別 — 其**波及範圍 (blast radius)** 會散佈到整個程式碼庫，因此一次修改會破壞數千個呼叫點，沒有任何垂直切片可以保持 Green 狀態落地。

`to-tickets` 會將其改為按**擴充–縮減 (expand–contract)** 的順序排列：

- **擴充 (Expand)** — 在舊形式旁新增新形式，因此不會破壞任何內容。
- **遷移 (Migrate)** — 按照波及範圍大小（每個套件、每個目錄）分批將呼叫點轉移過來，每批一張工單，每一張都被擴充步驟所阻塞。CI 保持 Green 狀態，因為舊形式依然存在。
- **縮減 (Contract)** — 一旦沒有呼叫者留存，即在被所有遷移批次阻塞的工單中刪除舊形式。

在連批次都無法單獨保持 Green 狀態的情況下，它們會共享一個整合分支，並全部阻塞最後的整合與驗證工單。僅在該處承諾 Green 狀態。

## 常見問題

**它為一個三行的變更產生了 12 張工單。**
過度分解是此 Skill 上被回報最多的摩擦，且在從業者中表現一致：[模型](https://www.aihero.dev/ai-coding-dictionary/model) 預設會使用原子單位，並失去了使其有意義的分組。測驗步驟的存在正是為了這個原因 — 要求它合併，它就會合併。更深層的答案是工單有一個底線：如果整個變更適合放在單個內容視窗中，您根本不需要這個 Skill。請直接前往 [implement](https://aihero.dev/skills-implement)。

**產生的工單是每個層級一張 — 所有 Schema 在一張，所有 API 在另一張。**
這正是垂直切片規則旨在防止的失敗，而 Skill 有時仍會產生這種結果。在測驗步驟中透過對每張工單提出一個問題來捕捉它：完成此工單時我可以展示 (demo) 什麼？沒有答案的工單就是水平切片。出於這個原因，有些人會在每張工單中新增一行「展示路徑 (demo path)」，並回報這會引導模型進行垂直分解。

**在 GitHub 上，工單沒有建立為規格 Issue 的子 Issue。**
已知且尚未修復。這在十幾次執行和多個模型中都有被回報，[在 Issue #554 中有最完整的記載](https://github.com/mattpocock/skills/issues/554)，且在 Codex 上比在 Claude 上更嚴重。`gh` 自 v2.94 起已原生支援此功能：`gh issue create --parent <n>`，以及事後的 `gh issue edit <parent> --add-sub-issue <n>`。在追蹤器範本優先使用這些之前，在執行後自己連接父連結是可靠的做法。

**「Blocked by」被寫入 Issue 內文中，而不是真正的阻塞連結。**
同一類型的問題，[在 Issue #513 中回報](https://github.com/mattpocock/skills/issues/513)，其中 Agent 甚至斷言 GitHub 完全沒有原生的阻塞關係。它確實有 — `gh issue create --blocked-by 12,15`。因為阻塞項是先發布的，所以它們的編號在建立時總是可用的。內文文字旨在作為沒有原生邊緣的追蹤器的備用方案，而不是預設方案。

**本機工單去哪裡了？v1.1 的說明提到根目錄的 `tickets.md`。**
確實如此，但那是一個 Bug — 當平行 Agent 寫入單一共享檔案時也會發生競態條件。本機模式現在會依依賴順序，在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md` 下為每張工單寫入一個檔案，符合本機追蹤器範本已經描述的版面配置。`NN` 字首是真正的工單 ID，因此可以使用 `/implement 03` 代替重新輸入長標題。

**當它嘗試讀取我的規格時一直截斷。**
非常龐大的規格可能會超出追蹤器 Issue 乾淨回傳的內容，且沒有本機副本可以退回 — 隨後 Agent 會浪費 [工具呼叫](https://www.aihero.dev/ai-coding-dictionary/tool-call) 重新擷取區塊且永遠無法到達終點。在 `/to-spec` 與 `/to-tickets` 之間不要進行 [clear](https://www.aihero.dev/ai-coding-dictionary/clearing) 或 [compact](https://www.aihero.dev/ai-coding-dictionary/compaction)。在同一個內容視窗中執行它們，規格就完全不需要被重新擷取。

**驗收條件沒有評分任何內容 — 有些在進行任何工作之前就通過了。**
範本要求提供條件，但未說明它們是否會失敗，因此會發生這種情況。經常出現三種型態：在基準 Commit 時已經為真的條件、只能由另一張工單擁有的工作來滿足的條件，以及重述請求而非源自產物的條件。垂直切片可以防止大部分這種情況 — 傳遞先前不存在的行為的切片在結構上於基準 Commit 處即為 Red 狀態 — 但該檢查值得手動進行。對於每個條件，指出顯示其為假的觀察結果，並確認它在實作者開始的 Commit 處失敗。

**工單已發布。我該如何實際執行它們？**
Skill 在產物處停止，且沒有自動派發模式。派發是手動的：查看看板，計算沒有開啟的阻塞項的工單數量，並開啟相同數量的 Agent 階段作業。每個全新內容視窗一張工單，在它們之間進行清除。請注意，[implement](https://aihero.dev/skills-implement) 在完成時不會可靠地關閉或勾選工單（無論在 GitHub 上還是本機 Markdown 中），因此工單的狀態由您來更新。

## 運作良好的指標

- 每張工單對於「完成此工單時我可以展示什麼？」都有答案 — 且答案是行為，而不是層級。
- 在發布任何內容之前，列表會帶有編號並附帶每張工單的「Blocked by」行傳回給您。
- 頂部的工單沒有阻塞項，可以立即開始。
- 工單內文中沒有任何內容是檔案路徑或行號，原型產生的程式碼片段除外。
- 每張工單讀起來都像是全新的階段作業可以在您不在場的情況下完成的內容。
- 預先重構（若有找到）位於順序的前端，而不是混入功能工單中。

## 適用位置

`to-tickets` 是主要建構鏈中的一個步驟：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review
```

上游是 [to-spec](https://aihero.dev/skills-to-spec)，它會移交一份定稿的規格供其進行切片 — 將兩者保持在同一個未中斷的內容視窗中。下游是 [implement](https://aihero.dev/skills-implement)，它會為每個全新的階段作業建構一張工單，為測試驅動 [tdd](https://aihero.dev/skills-tdd) 並以 [code-review](https://aihero.dev/skills-code-review) 結束。當您不確定適合哪個 Skill 或流程時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為您引導路線。
