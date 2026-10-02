## 它的功能

`to-tickets` 接收計畫、[規格 (spec)](https://www.aihero.dev/ai-coding-dictionary/spec) 或你當前所處的對話，並將其拆分為 issue 追蹤器上的一組 **[ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)**。每個 ticket 都會宣告其**阻擋邊 (blocking edges)**：在它開始之前必須先完成的其他 ticket。

每個 ticket 都是一顆**示蹤彈 (tracer bullet)**：貫穿變更的每一層（結構描述、API、UI、測試）之狹窄但完整的路徑，在交付的瞬間即可單獨展示。這項限制使其行為有別於顯而易見的切分工作方式（即一次切一層並在最後整合）。它還調整了每個 ticket 的大小以適應單一且全新的[上下文視窗 (context window)](https://www.aihero.dev/ai-coding-dictionary/context-window)，因為接手 ticket 的將是一個從未看過你的規格的 [session](https://www.aihero.dev/ai-coding-dictionary/session)。

## 何時使用它

你透過輸入 `/to-tickets` 來呼叫它。[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會自行使用它。

| 你的狀態 | 該執行什麼 |
| --- | --- |
| 你有規格 issue 且建構跨越多個 session | `/to-tickets`，或 `/to-tickets #<spec_issue>` |
| 計畫僅存在於對話中，從未成文 | `/to-tickets` 直接讀取討論串，無需規格 |
| 整個變更適合放入單一上下文視窗 | [implement](https://aihero.dev/skills-implement)，跳過 ticket |
| 尚未做出任何決定 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，接著 [to-spec](https://aihero.dev/skills-to-spec) |
| 一個 [wayfinder](https://aihero.dev/skills-wayfinder) 地圖已完成清除 | 先使用 [to-spec](https://aihero.dev/skills-to-spec) 以收斂地圖，接著 `/to-tickets` |

由 `to-tickets` 產生的 ticket 本質上就是 agent 就緒的。不要對它們執行 [triage](https://aihero.dev/skills-triage)。Triage 是用於處理來自其他人的工作。

## 先決條件

`to-tickets` 會發布至追蹤器，因此 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 必須先為此儲存庫設定好追蹤器以及 triage 標籤詞彙。兩種方式皆可運作：像 GitHub 或 Linear 這樣的真實追蹤器，或是 `.scratch/` 下的本地 Markdown 檔案，開箱即支援。

## 示蹤彈，而非層級

**水平 (horizontal)** 切片交付變更的單一層。在每一層都交付之前沒有任何東西可以運作，而且每個 ticket 的驗收條件都必須涉及另一個 ticket 所擁有的工作。**垂直 (vertical)** 切片（示蹤彈）則是一次交付貫穿所有層的一條狹窄路徑，因此它可以單獨被驗證，並擁有它所評估的一切。

這是人們最常違反的規則，其後果有詳盡的記錄。有一個團隊執行了一個按層級切片（語料庫、生產者、聚合器、選擇器）的 26 個 ticket 堆疊，每個關閉的 ticket 大約需要二十次 agent 執行，其中約四分之三是返工。他們自己的檢討報告將每類失敗都追溯至水平切片，而非實作本身。

在發布任何內容之前會發生兩件事。`to-tickets` 會尋找預先重構（prefactoring，即「先讓變更變容易，再進行容易的變更」原則）並優先安排這項工作。接著它以編號清單呈現拆分結果並對你進行提問確認：粒度是否合適、阻擋邊是否真實、是否應該合併或拆分任何項目。在獲得你的核准之前，沒有任何內容會傳遞至追蹤器，而該提問確認正是提出反對意見的地方。

## 阻擋邊

阻擋邊是該產出物的重點。根據追蹤器的不同，它們有兩種呈現方式：

| 追蹤器 | 阻擋邊所在處 | 你如何處理它們 |
| --- | --- | --- |
| 本地 Markdown | `.scratch/<feature>/issues/<NN>-<slug>.md` 下每個 ticket 一個檔案中的文字，依阻擋者優先編號 | 由上至下，手動處理 |
| 真實追蹤器 (GitHub, Linear) | 原生阻擋連結，或在追蹤器具備的地方使用子 issue | 阻擋者已完成的任何 ticket 都位於**前沿 (frontier)**，可以被領取 |

無論何種方式，邊都存在於 ticket 中。媒介僅決定是否有任何東西可以平行對其採取行動。`to-tickets` 負責產生產出物；執行它（一次一個 session，或是一組 fleet）是你的工作，而非該 skill 的工作。

## 廣泛重構的例外

有一種形狀打破了示蹤彈規則。**廣泛重構 (wide refactor)** 是一項單一的機械性變更（重新命名欄位、重新指定共用符號的型別），其**爆炸半徑 (blast radius)** 散布至整個程式碼庫，因此一次編輯就會損壞數千個呼叫點，沒有任何垂直切片能以綠燈狀態交付。

`to-tickets` 將其依序排定為**展開–收縮 (expand–contract)**：

- **展開 (Expand)**：在舊形式旁新增新形式，因此不會破壞任何內容。
- **遷移 (Migrate)**：按爆炸半徑劃分大小的批次（按套件、按目錄）轉移呼叫點，每批次一個 ticket，每個批次都由展開步驟阻擋。由於舊形式依然存在，CI 保持綠燈。
- **收縮 (Contract)**：一旦沒有呼叫端殘留，便在由每個遷移批次阻擋的 ticket 中刪除舊形式。

如果連批次都無法單獨保持綠燈，它們會共享一個整合分支，並全部阻擋最終的整合與驗證 ticket。僅在該處承諾綠燈。

## 常見問題

**它為一個三行的變更產生了十二個 ticket。**
過度拆解是此 skill 回報最多的摩擦點，且在實踐者之間是一致的：[模型](https://www.aihero.dev/ai-coding-dictionary/model)預設傾向原子單元，並遺失了賦予它們意義的分組。提問確認步驟正是為此而存在：要求它合併，它就會合併。更深層的答案是 ticket 有一個底線：如果整個變更放得進一個上下文視窗，你根本不需要這個 skill。直接前往 [implement](https://aihero.dev/skills-implement)。

**ticket 產出為每層一個：所有的結構描述在一個，所有的 API 在另一個。**
這正是垂直切片規則旨在防止的失敗狀況，而該 skill 有時仍會產生這種結果。在提問確認步驟中為每個 ticket 問一個問題來捕捉它：完成這個之後我可以展示什麼？沒有答案的 ticket 就是水平切片。有些人出於這個原因在每個 ticket 中加入一行「展示路徑」，並回報這能促使模型走向垂直拆解。

**在 GitHub 上，ticket 未被建立為規格 issue 的子 issue。**
已知且未修復。在十幾次執行與多個模型中都有回報，[在 issue #554 中記錄最完整](https://github.com/mattpocock/skills/issues/554)，且在 Codex 上比在 Claude 上更嚴重。`gh` 自 v2.94 起已原生支援：`gh issue create --parent <n>`，以及事後的 `gh issue edit <parent> --add-sub-issue <n>`。在追蹤器範本偏好這些選項之前，在執行後自行串接父項連結是可靠的作法。

**「Blocked by」被寫入 issue 內文，而不是真實的阻擋連結。**
同類型的問題，[在 issue #513 中回報](https://github.com/mattpocock/skills/issues/513)，其中 agent 甚至斷言 GitHub 完全沒有原生阻擋關聯。它確實有：`gh issue create --blocked-by 12,15`。因為阻擋者先被發布，所以它們的編號在建立時總是可用的。內文文字旨在作為沒有原生邊之追蹤器的備用手段，而非預設選項。

**本地 ticket 去哪裡了？v1.1 說明提到了根目錄層級的 `tickets.md`。**
確實提過，那是一個 bug：當平行 agent 寫入單一共用檔案時也會產生競爭條件。本地模式現在依相依性順序在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md` 下為每個 ticket 寫入一個檔案，符合本地追蹤器範本已描述的配置。`NN` 前綴是真實的 ticket ID，因此可以使用 `/implement 03` 而無需重新輸入長標題。

**它在嘗試讀取我的規格時不斷被截斷。**
非常龐大的規格可能會超出追蹤器 issue 乾淨提供的範圍，且沒有本地複本可供退回使用，因此 agent 隨後會消耗[工具呼叫 (tool calls)](https://www.aihero.dev/ai-coding-dictionary/tool-call) 重新擷取區塊且永遠無法抵達結尾。不要在 `/to-spec` 與 `/to-tickets` 之間進行[清除 (clear)](https://www.aihero.dev/ai-coding-dictionary/clearing) 或[壓縮 (compact)](https://www.aihero.dev/ai-coding-dictionary/compaction)。在同一個上下文視窗中執行它們，規格就完全不需要重新擷取。

**驗收條件沒有評估任何東西：有些在完成任何工作之前就通過了。**
範本要求提供條件，卻沒有說明條件是否能失敗，因此會發生這種情況。三種常見情況反覆出現：在基礎 commit 上就已經為真的條件、只能由另一個 ticket 擁有的工作所滿足的條件，以及重述請求而非源自產出物的條件。垂直切片能防止大部分情況（交付先前不存在行為的切片在基礎 commit 上本質上是紅燈），但手動進行檢查是值得的。對於每個條件，指出能證明其為偽的觀察，並確認它在實作者開始的 commit 上會失敗。

**ticket 已發布。我該如何實際執行它們？**
該 skill 在產出產物後便告停止，沒有自動調度模式。調度是手動的：檢視看板，計算沒有未完成阻擋者的 ticket 數量，並開啟相應數量的 agent session。每個全新上下文一個 ticket，在它們之間進行清除。請注意，[implement](https://aihero.dev/skills-implement) 在完成時無法可靠地在 GitHub 或本地 Markdown 中關閉或勾選 ticket，因此 ticket 的狀態由你來更新。

## 若運作正常，會符合以下情況

- 每個 ticket 對於「完成這個之後我可以展示什麼？」都有答案，且答案是行為，而非層級。
- 在發布任何內容之前，清單會以帶有編號且每項都附有「Blocked by」行的形式回傳給你。
- 最頂部的 ticket 沒有阻擋者，可以立即開始。
- ticket 內文中沒有檔案路徑或行號，除了原型產出的程式碼片段。
- 每個 ticket 讀起來都像是全新 session 在沒有你在場的情況下也能完成的內容。
- 預先重構（若有找到）排在順序的最前面，而不是混入功能 ticket 中。

## 它的定位

`to-tickets` 是主要建構鏈中的一個步驟：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

上游是 [to-spec](https://aihero.dev/skills-to-spec)，它提供已確定的規格供其進行切片；請將兩者保持在同一個未中斷的上下文視窗中。下游是 [implement](https://aihero.dev/skills-implement)，它在每個全新 session 中建構一個 ticket，驅動 [tdd](https://aihero.dev/skills-tdd) 進行測試，並以 [code-review](https://aihero.dev/skills-code-review) 收尾。[implement-spec](https://aihero.dev/skills-implement-spec) 是另一種下游方式：它將相同的阻擋邊讀取為任務圖，並在一個整合分支上平行建構每個就緒的 ticket。當你不確定哪項 skill 或流程合適時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你引導。
