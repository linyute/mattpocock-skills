## 它的功能

`tdd` 以測試先行的方式建構功能或修復 bug：一個失敗的測試，接著剛好足夠通過它的程式碼，然後進行下一個行為。它承載了使該循環產出值得保留的測試之標準：什麼是好測試、測試放在哪裡、mock 的用途，以及會悄悄毀掉測試套件的三種反模式。

它不會在未經你事先同意的接縫處撰寫任何測試。在任何測試存在之前，它會列出打算進行測試的公開邊界並停下來等待你的確認，因為測試精力是有限的，這正是你將精力花在關鍵路徑而非每個極端情況的地方。另一件需要了解的事是 `tdd` 是一個**參考規範 (reference)**，而非驅動程式。它掌握循環的規則，而其他東西（你，或 [implement](https://aihero.dev/skills-implement)）執行套用這些規則的 [session](https://www.aihero.dev/ai-coding-dictionary/session)。

## 何時使用它

輸入 `/tdd`，或者當任務適合時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會自動使用它：測試先行建構功能或修復 bug，或當你說「紅燈-綠燈-重構 (red-green-refactor)」時。

當有具體行為需要建構、具有輸入與可觀察的輸出，且你希望測試在重構後仍能存活時，請使用它。

| 你的情況 | 該去哪裡 |
| --- | --- |
| 具有明確輸入和輸出的行為（商業邏輯、請求/回應契約、轉換、驗證） | `tdd` |
| 行為尚未確定 | [to-spec](https://aihero.dev/skills-to-spec)，它也會在編寫任何程式碼之前約定測試接縫 |
| 問題本質在於介面的形狀，而非測試 | [codebase-design](https://aihero.dev/skills-codebase-design) |
| 你有 [規格 (spec)](https://www.aihero.dev/ai-coding-dictionary/spec) 或 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket)，並希望為你執行整個建構 | [implement](https://aihero.dev/skills-implement)，它針對每個 ticket 驅動 `tdd` |
| 設定、線路串接、黏合、型別註解、直接的 CRUD 委派 | 這裡沒有完全適合的；請參閱下方的待解缺口 |

最後一行是一個真正的缺口，而非風格偏好。該 skill 決定接縫*在哪裡*；裡面沒有任何東西決定一項變更*是否*值得進入這個循環。在沒有獨立真實來源可供斷言的變更上執行它，你會得到重述實作的測試：即該 skill 本身警告的套套邏輯反模式，只是從另一個方向得來。這是 [issue #746](https://github.com/mattpocock/skills/issues/746) 且仍未結案。在關閉之前，該判斷取決於你或你的 `CLAUDE.md`。

## 先決條件

需要安裝 [codebase-design](https://aihero.dev/skills-codebase-design)。`tdd` 過去曾承載自己的深模組（deep-module）與介面設計筆記；在 v1.0 中這些內容已被刪除，改由共享 skill 取代，而 `tdd` 現在倚賴它來獲取介面設計詞彙。不需要其他東西；該 skill 是[無狀態 (stateless)](https://www.aihero.dev/ai-coding-dictionary/stateless) 且不寫入自己的檔案。

## 循環及其執行的接縫

三個概念支撐著這項 skill。

**紅燈-綠燈 (Red-green)。** 撰寫失敗的測試，接著只寫足夠通過它的程式碼。不要預先設想下下個測試。沒有重構階段：它在 2026 年 6 月被移除，因為 agent 基本上從不執行它，而且將審核與實作拆分為不同的 session 效果更好。重構屬於 [code-review](https://aihero.dev/skills-code-review)。

**垂直切片 (Vertical slice)。** 一個接縫、一個測試、一個最小實作，然後重複，第一個週期是端到端驗證單一路徑的**示蹤彈 (tracer bullet)**。相反的是水平切片：先寫完所有測試，然後寫完所有程式碼。批次測試驗證的是*想像中的*行為，它們檢查事物的形狀而非使用者的操作，並在了解實作之前就讓你受限於某種測試結構。

**預先約定的接縫 (Pre-agreed seam)。** 接縫是你無需深入內部即可觀察行為的公開邊界。規則是絕對的：不得在未確認的接縫處進行測試。在完整鏈條中，接縫在更早的階段即約定好，即在 [to-spec](https://aihero.dev/skills-to-spec) 期間：「`/tdd` 被告知僅在預先約定的測試接縫處工作，`/code-review` 檢查是否僅使用了約定的測試接縫。」獨立呼叫時，`tdd` 會直接詢問你。

它旨在防止的三種反模式：

| 反模式 | 特徵 |
| --- | --- |
| 與實作耦合 | 當你重新命名內部函式時測試損壞，儘管行為並未改變。Mock 內部協作者、斷言呼叫次數、使用資料庫查詢而非介面來進行驗證。 |
| 套套邏輯 (Tautological) | 預期值是用程式碼計算它的方式計算出來的，因此測試因建構本質而通過。預期值必須來自其他地方：已知的良好常值、推導範例、規格。 |
| 水平切片 | 在任何實作之前就出現了一批測試。 |

Mock 僅用於系統邊界：外部 API、時間、隨機性，有時包含檔案系統或資料庫。不用於你自己的模組。

## 常見問題

**為什麼它不進行重構？描述中寫著「紅燈-綠燈-重構」。**

因為重構步驟被移除了，而描述沒有更新。這項移除是深思熟慮的：agent 基本上從不執行它，且將實作和審核分在不同的 session 中效果更好。結果是否仍符合教科書上的 TDD，不如該循環是否產出更好的程式碼重要。觸發語句與正文之間的不一致已被記錄為 [issue #589](https://github.com/mattpocock/skills/issues/589) 且仍未結案，因此「red-green-refactor」繼續作為觸發該 skill 的語句有效。你得到的是紅燈 → 綠燈，重構則在 [code-review](https://aihero.dev/skills-code-review) 中進行。

**它要求我選擇測試接縫，而我不知道該選哪一個。**

這是該 skill 回報最多的摩擦點（[issue #607](https://github.com/mattpocock/skills/issues/607)）。Prompt 僅按名稱列出候選接縫，完全沒有說明每個接縫能捕捉或遺漏什麼，因此你是在標籤之間做選擇。目前尚未發布修復。實務上的替代做法是在回答之前詢問 agent 其取捨：元件層級的接縫相比整合接縫遺漏了什麼，以及它慢了多少。這也是為什麼該鏈條在 `to-spec` 中預先約定接縫，在那裡你能縱觀整個功能，而非只面對一個 prompt。

**它在測試之前編寫了實作，即使 skill 說明先紅燈。**

這種情況時有發生。一位使用者就此向[模型](https://www.aihero.dev/ai-coding-dictionary/model)追問，得到了異常誠實的回答：「我知道 skill 說了『一次一個測試，觀察它因正確的原因失敗』。我讀過了。但我只是順著我的常規習慣行事。」該 skill 接受這種現實。沒有任何指示能讓 agent 達成 100% 的遵循，強行強求這一點會限制 agent 的創造力而收效甚微；即使沒有嚴格遵守，這個循環仍然值得執行，因為整體結果仍然更好。如果嚴格遵守對某個特定切片至關重要，請觀察執行過程，而非信任 skill 來強制執行。

**它應該先撰寫瀏覽器測試或端到端測試嗎？**

通常不要，且該 skill 不會阻止它。有使用者回報 agent 先寫了一個 Playwright 測試，然後消耗冗長的循環重新執行它，並得出測試對於尚不存在的功能而言是損壞的結論。在你的 `CLAUDE.md` 中設定這一點。瀏覽器測試的速度慢到讓紅燈-綠燈回饋循環不再合算；請在你的儲存庫 `CLAUDE.md` 中宣告它們在行為運作正常後才編寫。

**`/tdd` 是否取代了 `/implement` 或課程中的 `/do-work`？**

沒有。`/tdd` 記錄了方法論；`/implement` 是一個非常簡單的工作→回饋→commit 循環，是 `/do-work` 的直接替代品。課程中單一的 `/do-work` 步驟現在拆分到了 `/implement`、`/tdd` 和 `/code-review`。如果你在問針對 ticket 該執行哪一個，答案幾乎總是 `/implement`。

**深模組與介面設計指引去哪裡了？**

在 v1.0 中移入了 [codebase-design](https://aihero.dev/skills-codebase-design)，進行了泛化，以便多個 skill 共享同一個詞彙。`refactoring.md` 同時被移除；重構現在是 [code-review](https://aihero.dev/skills-code-review) 的工作，該 skill 承載了 Fowler 壞味道基準線。

**它知道我的其他 ticket 嗎？**

不知道。針對單一 ticket 執行時，它會很樂意提議屬於同層級 ticket 的工作，因為它無法綜觀其餘 issue 圖（[issue #129](https://github.com/mattpocock/skills/issues/129)）。Matt 的立場是這不是 `tdd` 的工作。隨 ticket 一併提供規格有所幫助；從一開始適當調整 ticket 大小更有幫助。

## 若運作正常，會符合以下情況

- 在任何測試檔案存在之前，它會停下來並列出打算進行測試的接縫，然後等待。
- 一個測試出現、變紅、獲得剛好足夠通過的程式碼，然後才出現下一個測試，而不是一批測試接著一批程式碼。
- 測試名稱讀起來像能力（「使用者可以使用有效的購物車結帳」），而非內部實作細節（「checkout 呼叫 paymentService.process」）。
- 斷言中的預期值是你可以追溯到規格的常值，而非用程式碼計算的方式重新計算出來的值。
- 重新命名內部函式不會破壞測試套件中的任何內容。
- Mock 僅出現在外部邊界（付款 API、時鐘），絕不出現在你自己的模組周圍。

## 它的定位

`tdd` 是主鏈條中建構步驟內部的引擎，而非其本身的一個步驟：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

[to-spec](https://aihero.dev/skills-to-spec) 預先約定測試接縫，[implement](https://aihero.dev/skills-implement) 針對每個 ticket 驅動 `tdd`，而 [code-review](https://aihero.dev/skills-code-review) 隨後檢查是否僅使用了約定的接縫，並接管了 `tdd` 不再負責的重構。它的另一個鄰居是 [codebase-design](https://aihero.dev/skills-codebase-design)，即 `tdd` 所使用的接縫與深模組詞彙的共享來源。只要有具體行為要建構且沒有完整的規格在運作，你也可以隨時單獨使用它。當你不確定哪項 skill 適合你的情境時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為你引導。
