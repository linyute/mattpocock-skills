## 它的功能

`grilling` 是一個訪談迴圈，旨在任何人採取行動之前壓力測試計畫、決策或想法。它將主題映射為**設計樹** — 每個決策都分支到懸掛在其上的決策 — 並逐個分支對您進行訪談，直到沒有任何內容被默默假設。

它不會一次詢問一個問題，也不會一次詢問所有問題。每一**輪**都會詢問整個**前沿**：即其先決條件已經定稿的每一個決策，無其他內容。如果一個問題取決於另一個問題，這兩個問題絕不會共享一輪 — 取決於尚未開放答案的問題屬於後面的輪數。您的答案會定稿決策，前沿向前推移，而下一輪會詢問解除阻塞後帶來的新問題。13 個問題通常落在大約三輪中，而不是十三輪。

## 何時使用它

輸入 `/grilling`，或者當任務適合時，[Agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會主動使用它。它是盤問家族中唯一由模型呼叫的 [Skill](https://www.aihero.dev/ai-coding-dictionary/skill)，這就是為什麼您很少輸入它的原因：通常您*確實*輸入的 Skill 正在為您執行它。

直接輸入 `/grilling` 會為您提供純粹的訪談，無其他內容。當您想要比這更多的內容時：

| 您擁有的內容 | 使用工具 |
| --- | --- |
| 您不在工作目錄中工作 | [grill-me](https://aihero.dev/skills-grill-me) — 相同的 [階段作業](https://www.aihero.dev/ai-coding-dictionary/session)，在 Agent 絕不會自己啟動的名稱下 |
| 您在工作目錄中 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) — 相同的階段作業，且會在過程中寫入 `CONTEXT.md` 和 ADR |
| 單個階段作業無法容納的大型工作 | [wayfinder](https://aihero.dev/skills-wayfinder) — 它會繪製地圖並在決策工單內部執行盤問 |
| 討論無法解決的問題 — 事物應該看起來或感覺如何 | [prototype](https://aihero.dev/skills-prototype) — 建構一次性拋棄的版本，然後再回來 |
| 您自己需要訪談的 Skill | 從中呼叫 `/grilling`，而不是撰寫另一個訪談 |

## 輪數、前沿與誰做決定

三個概念承載了整個 Skill。

**設計樹**是主題的模型：懸掛著決策的決策。**前沿**是先決條件全都合定的決策集合 — 唯一可以誠實提出的問題。**一輪**是一個完整的門面，完全提問並完全回答。

在一輪內部，每個問題都以固定形狀到達：在 `❓` 後面編號並帶有標題，然後是內文，然後在 `➡️` 行上單獨放置 Agent 的建議答案。這使得一輪問題可以按編號回答 —「1 是，2 第二個選項，3 否，原因如下」— 而不是透過引用問題來回答。該格式有一個已知的粗糙之處：建議有時會針對與字面表述*相反*的問題進行論證，因此同意建議意味著對問題回答「否」。當這種情況發生時，請回答建議並說明。

設計的另一半是事實與決策之間的分離。事實是 Skill 自己的工作：當前沿問題需要 [環境](https://www.aihero.dev/ai-coding-dictionary/environment) 可以定稿的內容時，它會派發一個 [子 Agent](https://www.aihero.dev/ai-coding-dictionary/subagent) 去查明，而不是詢問您。它不會在此阻塞 — 只有正在執行的探索下游的問題會等待。決策是您的，它必須等待它們。執行 `grilling` 的 Agent 如果自己回答了自己的決策，那是破壞了 Skill，而不是自由發揮。當前沿為空時階段作業結束，且在您確認達成共同理解之前，它不會對您同意的內容採取行動。

誠實的局限性：前沿是 Agent 的判斷，而不是計算出來的圖。它可以在一輪中提出兩個問題，並在事後發現一個答案應該已經改變了另一個答案。除了告訴它之外，沒有防止這種情況的防護，這會在下一輪中重新開啟受影響的分支。

## 這裡包含什麼以及封裝中包含什麼

本頁面涵蓋機制。人們最常想要的內容記載在上一層。

| 問題 | 在何處得到回答 |
| --- | --- |
| 樹、前沿、輪數、問題格式、事實與決策 | 本頁面 |
| 階段作業應該執行多久、如何處理無法透過討論回答的問題、如何避免盲目點頭 | [grill-me](https://aihero.dev/skills-grill-me) |
| 什麼寫入 `CONTEXT.md`，什麼成為 ADR | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |

## 常見問題

**我可以回到一次一個問題嗎？**
可以，且很大一部份受眾都這麼做。將此新增至您的全域 `CLAUDE.md`：

```
When grilling, ask one question at a time.
```

基於輪數的預設值確實存在爭議。閱讀緩慢的從業者、使用第二語言工作的從業者，或是使用順序格式作為專注腳手架的從業者都回報一次一個問題的節奏對他們更好，且該選擇是受到支援的而非被忽視的。

**`/batch-grill-me` 去哪裡了？**
合併到了這個 Skill 中。基於輪數的提問曾短暫作為單獨的 Skill 發布，然後移動到了 `grilling` 本身中，因此建構在原語上的所有內容（`grill-me`、`grill-with-docs`、`triage`、`wayfinder`）都一次獲得了該功能。不需要安裝 `batch-grill-me`，也沒有單獨的順序 Skill；上面的 `CLAUDE.md` 行是回到一次一個問題的方法。

**一次詢問一整輪一定會失去我之前的答案所引出的問題。不是嗎？**
這是對輪數設計最常見的反對意見，而前沿就是對它的回答：一輪中僅包含互不依賴的問題，因此一輪中的答案不會使該輪中的另一個問題無效。答案仍然會重塑下游的一切 — 下一輪是重新計算的，而不是預先撰寫的。您失去的比「一次所有問題」所隱含的要小，但大於零：請參閱上面的前沿局限性。

**它用完了問題並開始建構。**
確認閘道的存在正是為了這個原因：當前沿清空時，Skill 並未完成，當您表示理解共享時它才完成。較弱和較快的 [模型](https://www.aihero.dev/ai-coding-dictionary/model) 仍然會破壞它 — 這在較低努力或非頂級模型上回報最多，它們將「訪談直到共享理解」壓縮為幾個問題和一份大綱。如果您的模型這麼做，可靠的修復方法是在您自己的 `AGENTS.md` 或 `CLAUDE.md` 中添加一行，告訴 Agent 未經許可不要進行實作。

**它回答了自己的問題而不是詢問我。**
這是執行中的 Bug，而不是預期行為，也是在 Skill 文字中分離事實和決策的原因。當另一個 Skill 在解決此工單框架中執行 `grilling` 時，最容易出現這種情況，其中周圍的任務讀起來像是繼續推進的許可。同樣的約束也是為什麼沒有非同步模式的原因：人們要求一種讀取 GitHub Issue 並發布一份綜合決策備忘錄的變體，那是另一個 Skill，因為沒有人回答的盤問階段作業產生的是 Agent 的意見，而不是您的意見。

**我可以限制問題的數量嗎？**
不行，且上限是刻意排除在範疇之外的。有些計畫需要三個問題，有些需要五十個；固定上限要麼截斷硬性情況，要麼在簡單情況下顯得任意。用平實的語言進行主導是預期的控制方式 — 告訴它總結，或者停止並接受現有的計畫。如果階段作業執行非常長，原因通常是範疇太大；拆分工作並盤問各個部分。

**我單獨安裝了 `grill-me`，什麼也沒發生。**
`grill-me` 是一個單行 Skill，其整個主體是「執行 `/grilling` 階段作業」，因此它也需要安裝此 Skill。`grill-with-docs` 也是如此，它另外還需要 [domain-modeling](https://aihero.dev/skills-domain-modeling)。安裝整個集合避免了該問題；選擇性安裝意味著也要安裝原語。

**`grill-with-docs` 執行了，但它從未載入 `grilling`。**
一個真實且尚未修復的粗糙之處，跨 [框架](https://www.aihero.dev/ai-coding-dictionary/harness) 和模型回報：命名另一個 Skill 的 Skill 不會可靠地導致該 Skill 載入，而 `grill-with-docs` 命名了兩個。徵兆是階段作業一次性詢問所有內容且沒有附加任何建議 — 那是模型在即興發揮訪談，而不是執行這個訪談。直接詢問 Agent 是否載入了 `grilling` 和 `domain-modeling` 通常可以恢復它。

## 運作良好的指標

- 一輪問題作為編號列表到達，每個問題都有其建議放在單獨的 `➡️` 行上，您可以按編號回答整輪問題。
- 一輪中的任何內容都不需要先回答同一輪中的另一個問題。
- 後續輪數詢問第一輪無法詢問的事情。
- 它會去尋找事實 — 讀取檔案、派發子 Agent — 而不是詢問您本可以查明的事物。
- 背景執行的研究不會拖延該輪；只有取決於它的問題會等待。
- 它在最後停止並要求您確認理解已共享，而不是開始工作。
- 問題數量保持高位，而輪數保持低位。

## 適用位置

`grilling` 是一個**原語**，而不是您排程的步驟：訪談技巧的唯一真實來源，保留在一個地方，以便每個需要訪談的 Skill 都使用它而不是發明一個。[grill-me](https://aihero.dev/skills-grill-me) 和 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 是其兩個使用者呼叫的大門，而 `grill-with-docs` 是主要建構鏈開始的地方（在 [to-spec](https://aihero.dev/skills-to-spec) 之前）。[wayfinder](https://aihero.dev/skills-wayfinder) 執行它來解決決策工單，[triage](https://aihero.dev/skills-triage) 盤問模糊的回報為可工作的回報，而 [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 則在您選擇要深化的候選對象後走過樹結構。當您不確定哪個入口點適合時，[ask-matt](https://aihero.dev/skills-ask-matt) 會為您引導路線。
