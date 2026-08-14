## 功能說明

`tdd` 以測試先行（test-first）方式建構功能或修復錯誤：一個失敗的測試，隨後僅寫入足以通過它的程式碼，接著是下一個行為。它帶有使該迴圈產生值得保留之測試的標準 — 什麼是良好的測試、測試去往何處、Mock 的作用是什麼，以及悄悄毀掉測試套件的三種反模式（anti-patterns）。

在未經你事先同意的接縫處，它不會撰寫任何測試。在任何測試存在之前，它會指定其意圖進行測試的公開邊界並停下來等待你的確認，因為測試工作量是有限的，這正是你將其花費在關鍵路徑上而不是每個邊界條件上的地方。另一件需要知道的事情是 `tdd` 是一份**參考文件**，而不是驅動者。它持有所為迴圈的規則，由其他事物（你或 [implement](https://aihero.dev/skills-implement)）執行套用這些規則的[工作階段](https://www.aihero.dev/ai-coding-dictionary/session)。

## 何時使用

輸入 `/tdd`，或者當任務適合時 — 以測試先行方式建構功能或修復錯誤，或當你說出「紅燈-綠燈-重構（red-green-refactor）」時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會自動使用它。

當有具體的行為需要建構、帶有輸入與可觀察的輸出，且你需要能在重構後保留的測試時使用它。

| 你的狀況 | 前往之處 |
| --- | --- |
| 具有已定義輸入與輸出的行為 — 商業邏輯、請求/回應合約、轉換、驗證 | `tdd` |
| 行為尚未鎖定 | [to-spec](https://aihero.dev/skills-to-spec)，它也在撰寫任何程式碼前同意測試接縫 |
| 問題實際上是介面的形狀而非測試 | [codebase-design](https://aihero.dev/skills-codebase-design) |
| 你擁有 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)（規格）或 [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) 且希望為你執行整個建構 | [implement](https://aihero.dev/skills-implement)，它按 ticket 驅動 `tdd` |
| 設定、連線、膠水程式碼、型別註解、直接 CRUD 委派 | 此處無一完全適合 — 參見下方的開放缺口 |

最後一列是一個真實的漏洞，而不是風格上的偏好。本技能決定接縫放置於*何處*；其中沒有任何內容決定一項變更是否*值得*執行該迴圈。在沒有獨立真實來源（source of truth）可進行斷言的變更上執行它，你會得到一個重新陳述實作的測試 — 技能本身所警告的自體重複（tautological）反模式，從另一個方向到達。這是 [issue #746](https://github.com/mattpocock/skills/issues/746) 且處於開放狀態。在它關閉之前，該判斷由你或你的 `CLAUDE.md` 負責。

## 先決條件

需要安裝 [codebase-design](https://aihero.dev/skills-codebase-design)。`tdd` 過去帶有自己的深模組與介面設計筆記；在 v1.0 中，這些筆記被刪除，取而代之的是共享技能，且 `tdd` 現在依賴它來提供介面設計詞彙。此外無需其他內容 — 本技能是[無狀態的（stateless）](https://www.aihero.dev/ai-coding-dictionary/stateless)，且不寫入其本身的檔案。

## 迴圈及其執行的接縫

三個詞彙承載了本技能。

**紅燈-綠燈（Red-green）。** 撰寫失敗的測試，然後僅撰寫足以通過它的程式碼。不要預期下下一個測試。沒有重構階段：它在 2026 年 6 月被廢棄，因為 agent 本質上從未執行過它，且因為審查與實作作為獨立的工作階段運作得更好。重構屬於 [code-review](https://aihero.dev/skills-code-review)。

**垂直切片（Vertical slice）。** 一個接縫、一個測試、一個最小實作，然後重複 — 第一個循環是證明單一路徑端到端的**曳光彈（tracer bullet）**。相反的情況是水平切片：首先撰寫所有測試，然後撰寫所有程式碼。批量測試驗證*想像中*的行為，它們檢查事物的形狀而不是使用者的操作，並在你理解實作之前就讓你承諾某種測試結構。

**預先同意的接縫。** 接縫是你在不接觸內部的情況下觀察行為的公開邊界。規則是絕對的：不得在未確認的接縫處撰寫測試。在完整的鏈結中，接縫在 [to-spec](https://aihero.dev/skills-to-spec) 期間更早被同意 —「告知 `/tdd` 僅在預先同意的測試接縫處工作，`/code-review` 檢查是否僅使用了同意的測試接縫。」獨立呼叫時，`tdd` 會直接詢問你。

其被寫入以防止的三種反模式：

| 反模式 | 徵兆 |
| --- | --- |
| 實作耦合（Implementation-coupled） | 當你重新命名內部函式時測試破壞，儘管行為並未改變。內部協作者被 Mock、斷言呼叫次數、使用資料庫查詢進行驗證而不是透過介面。 |
| 自體重複（Tautological） | 預期值按照程式碼計算的方式進行計算，因此測試因建構而通過。預期值必須來自其他地方 — 已知良好的字面值、實例、規格。 |
| 水平切片（Horizontal slicing） | 一批測試在任何實作之前著陸。 |

Mock 僅用於系統邊界 — 外部 API、時間、隨機性，有時是檔案系統或資料庫。不是你自己的模組。

## 常見問題

**為什麼它不進行重構？描述中寫著「紅燈-綠燈-重構」。**

因為重構步驟被刪除了，而描述沒有更新。刪除是刻意的：agent 本質上從未執行過它，且將實作與審查保持在獨立的工作階段中運作得更好。結果是否仍符合教科書上的 TDD，遠不如迴圈是否能產生更好的程式碼重要。觸發短語與本文之間的不符已被記錄為 [issue #589](https://github.com/mattpocock/skills/issues/589) 且仍處於開放狀態，因此「紅燈-綠燈-重構」繼續作為觸發該技能的短語運作。你獲得的是紅燈 → 綠燈，以及在 [code-review](https://aihero.dev/skills-code-review) 中進行重構。

**它要求我選擇測試接縫，而我完全不知道該選哪一個。**

這是該技能回報最多的摩擦點（[issue #607](https://github.com/mattpocock/skills/issues/607)）。Prompt 僅按名稱列出候選接縫，完全沒有提及每一個接縫會捕捉或遺漏什麼，因此你是在標籤之間進行選擇。目前尚未發布修復。實際的替代方案是在回答前向 agent 詢問權衡考量 — 元件層級接縫遺漏了整合接縫捕捉到的什麼內容，以及它慢了多少。這也是為什麼鏈結在 `to-spec` 中預先同意接縫的原因，在那裡你可以掌握整個功能，而不是單一 prompt。

**儘管技能說明紅燈優先，它還是在測試之前撰寫了實作。**

這種情況時有發生。一位使用者在此事上追問 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型），並獲得了異常坦白的回答：「我知道技能說明了『一次一個測試，觀察它因正確的原因失敗』— 我讀過。我只是預設使用了平時的習慣。」本技能撰寫時就接受了這一點。沒有任何指示能使 agent 100% 遵從，且過度強求會限制 agent 的創造力而收益甚微 — 即使未被嚴格遵循，該迴圈仍值得執行，因為總體而言結果仍然更好。如果嚴格遵從對特定切片很重要，請留意執行過程，而不是信任技能會強制執行。

**它應該先撰寫瀏覽器測試或端對端測試嗎？**

通常不需要，且本技能不會阻止它。一位使用者回報 agent 先撰寫了 Playwright 測試，然後在重新執行它的漫長迴圈中消耗資源，並得出對於尚不存在的功能而言*測試*損壞了的結論。請在你的 `CLAUDE.md` 中設定這一點。瀏覽器測試足夠慢，以至於紅燈-綠燈回饋迴圈不再划算；請在儲存庫的 `CLAUDE.md` 中宣告它們是在行為運作正常之後撰寫的。

**`/tdd` 是否替換了 `/implement` 或課程的 `/do-work`？**

沒有。`/tdd` 記錄了方法論；`/implement` 是一個非常簡單的工作→回饋→提交迴圈，並且是 `/do-work` 的直接替代品。課程的單一 `/do-work` 步驟現在拆分至 `/implement`、`/tdd` 與 `/code-review`。如果你詢問要針對 ticket 執行哪一個，答案幾乎總是 `/implement`。

**深模組與介面設計指引去了哪裡？**

在 v1.0 中移入了 [codebase-design](https://aihero.dev/skills-codebase-design)，進行了通用化，使多個技能共享一個詞彙表。`refactoring.md` 同時離開；重構現在是 [code-review](https://aihero.dev/skills-code-review) 的工作，且該技能帶有 Fowler 的 smell 基準線。

**它知道我的其他 tickets 嗎？**

不知道。針對單一 ticket 執行，它會樂於提出屬於兄弟 ticket 的工作，因為它無法檢視其餘的議題圖表（[issue #129](https://github.com/mattpocock/skills/issues/129)）。Matt 的立場是這不是 `tdd` 的工作。在傳遞 ticket 的同時傳遞規格有所幫助；從一開始就調整好 tickets 的大小幫助更大。

## 運作正常的指標

- 在任何測試檔案存在之前，它會停止並指定其意圖進行測試的接縫，然後等待。
- 出現一個測試，顯示紅燈，獲得僅足以通過的程式碼，隨後才出現下一個測試 — 而不是一批測試接著一批程式碼。
- 測試名稱讀起來是功能（「使用者可以用有效的購物車結帳」），而不是內部細節（「結帳呼叫 paymentService.process」）。
- 斷言中的預期值是可以追溯至規格的字面值，而不是按照程式碼計算方式重新計算出的值。
- 重新命名內部函式不會破壞測試套件中的任何內容。
- Mock 僅出現在外部邊界 — 支付 API、時鐘 — 絕不出現在你自己的模組周圍。

## 適用位置

`tdd` 是主要鏈結之建構步驟內部的引擎，而不是其自身的步驟：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review
```

[to-spec](https://aihero.dev/skills-to-spec) 預先同意測試接縫，[implement](https://aihero.dev/skills-implement) 按 ticket 驅動 `tdd`，隨後 [code-review](https://aihero.dev/skills-code-review) 檢查是否僅使用了同意的接縫 — 並擁有 `tdd` 不再執行的重構。它的另一個鄰居是 [codebase-design](https://aihero.dev/skills-codebase-design)，這是 `tdd` 所使用之接縫與深模組詞彙的共享來源。當有具體行為要建構且沒有完整規格發揮作用時，你也可以獨立使用它。當你不確定哪個技能適合你的狀況時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你進行路由。
