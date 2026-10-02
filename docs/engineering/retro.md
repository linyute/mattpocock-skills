## 它的功能

`retro` 回顧一次編碼 [session](https://www.aihero.dev/ai-coding-dictionary/session) 並針對 agent 的**[環境 (environment)](https://www.aihero.dev/ai-coding-dictionary/environment)**提出改進建議，以便下一次執行更順利。它讀取 session 本身的記錄（預設為當前 session，或是你在 session 記錄中指向的某個記錄），找出 agent 遭遇困難的時刻，並為你提供一份候選修復清單，最嚴重的排在最前面。

它改變的是環境，而不是程式碼。Agent 發布的 bug、花了二十次[工具呼叫 (tool calls)](https://www.aihero.dev/ai-coding-dictionary/tool-call) 才找到的檔案、審核者遺漏的規則：`retro` 不會在原地修復它們。它會探討儲存庫的哪些方面導致了這些問題，並提出能防止它們再次發生的檢查、指標或標準。它也僅僅是提出建議；在你選取候選方案之前，什麼都不會改變。

## 何時使用它

你透過輸入 `/retro` 來呼叫它，agent 不會自行使用它。

在經歷一次感覺比預期更吃力的 session 結束時使用它：agent 花了太長時間尋找某樣東西、犯了機器本可捕捉到的錯誤，或是需要它無法獲取的資訊。順利的 session 能帶來的學習很少；痛苦的 session 才是發現所在。如果你想要的是對該 session 所產出程式碼的裁決，請改用 [code-review](https://aihero.dev/skills-code-review)。

## 發現結果的歸宿

每個候選方案都屬於一個類別，而該類別決定了修復措施的歸宿：

| Session 中出現了什麼問題 | 修復方式 |
| --- | --- |
| Agent 花了很長時間尋找檔案或事實 | 從其已閱讀的檔案中提供**導覽指標** |
| 它犯了工具本可捕捉到的錯誤 | **[自動化檢查 (automated check)](https://www.aihero.dev/ai-coding-dictionary/automated-check)**：lint 規則、型別、測試、pre-commit hook、CI 作業 |
| 審核者遺漏了主觀判斷上的錯誤 | 在 `CODING_STANDARDS.md` 中為審核者 agent 建立規則 |
| `AGENTS.md` 或 `CLAUDE.md` 龐大 | 將其引導內容移出，放入標準或檢查中 |
| 工具呼叫的代價相對於其回傳內容過高 | 精簡該工具，或取代它 |
| 引導檔案充斥著沒有改變任何事情的語句 | 刪除**無作用項目 (no-ops)** |
| Agent 需要它無法接觸到的資訊 | 擴大其存取權限：將開發伺服器記錄輸出至檔案、提供服務的唯讀存取權限 |

核心想法是標準屬於**審核者**，而非實作者。實作 agent 承受最大的上下文壓力：它進行探索、撰寫程式碼並除錯失敗狀況。審核 agent 則只接收 diff 而無其他內容。因此新規則應該放在有空間套用它的地方，即審核中，絕不要放在 [AGENTS.md](https://www.aihero.dev/ai-coding-dictionary/agents-md)，因為無論是否相關，它都會被載入到每個 session 的[上下文視窗 (context window)](https://www.aihero.dev/ai-coding-dictionary/context-window) 中。

在寫入任何規則之前，違規情況都會先經過分類。**機械式**違規（禁用的 API、匯入形式、檔案位置規則）會獲得確定性檢查，因為檢查可能會失敗，而標準檔案中的一句話則不會。只有真正的主觀判斷——即任何 linter 都無法強制執行的那種——才會寫成文字。一個完全沒有防護欄（沒有 pre-commit hook，沒有執行 lint、型別檢查與測試的 CI 作業）的儲存庫，會作為其本身的發現被回報。

## 常見問題

**它會自己撰寫 lint 規則，還是等待確認？我可以將它串接到每次 session 後執行嗎？**

它會等待。`retro` 僅提出建議；在你挑選候選方案之前什麼都不會改變，因此沒有手動編輯，也沒有自動套用的 hook。這是深思熟慮的設計：一位使用者在「被阻礙良好變更的自動 hook 坑害過」之後，特別提出了這樣的要求。決定什麼值得建立永久性檢查需要判斷力，因此該 skill 保持[以人為本的參與 (human-in-the-loop)](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop) 且由使用者呼叫。有些使用者確實會在每次實作執行後串接它，但順暢的 session 能帶來的學習很少，而且在每次 session 上執行大多只會產出沒有人需要的規則。它沒有預演模式：提議的檢查就像其他程式碼一樣建構，因此在讓它阻擋 merge 之前，請在儲存庫中進行測試。

**這難道不會讓 lint 規則永遠堆積下去嗎？它曾建議刪除規則嗎？**

部分會，而這是它最脆弱的地方。它具備的移除面向涵蓋了文字層面：引導檔案中的無作用項目，以及 `AGENTS.md` 或 `CLAUDE.md` 中應歸屬於標準或檢查的引導。當檔案過大時，它會對照正在閱讀的 session 將這些項目標記為刪除，因此請將每一項視為刪除測試的候選者，而非最終裁決。它不會去稽核上個月提議的 lint 規則、hook 或 CI 作業。它只看到單一 session，因此無法告訴你某項規則已經變得吵雜或壽命已超越促成它的 bug。精簡檢查仍是你的工作；不斷對良好程式碼發出警報的規則就是提示。

**它難道不會捏造泛用建議來填滿其類別嗎？**

這是它受到的最尖銳批評。一位使用者發現「一旦工作完成，AI 往往會忘記 session 中間的掙扎，並捏造泛用建議以滿足 retro 的類別。」其防禦機制在於每個候選方案都必須來自 session 自己的記錄，因此建議是針對該 session 的。這具有雙面性：它很少產生不相關的幻覺，但可能會過度聚焦於這單一 session 碰巧涉及的內容。捨棄任何你無法追溯到具體時刻的候選方案。也請將嚴重程度順序視為初稿：一個隱密、昂貴的錯誤排名可能低於一個喧鬧、廉價的錯誤。

**我的 session 很長。現在執行，還是重新開始？**

預設情況下它會審核當前的 session，這是最佳情況：那些掙扎仍在上下文視窗中。如果 session 已經偏離了[聰明區間 (smart zone)](https://www.aihero.dev/ai-coding-dictionary/smart-zone)，請改為[清除 (clear)](https://www.aihero.dev/ai-coding-dictionary/clearing) 並在 session 記錄中將全新的 `/retro` 指向先前的 session。

**Agent 一直犯同樣的錯誤。我應該在 `CLAUDE.md` 中新增一行嗎？**

通常不要，而那是 `retro` 最常提出異議的地方。`CLAUDE.md` 中的一行會載入到每個 session 中，稀釋檔案中的其他所有內容，並隨著程式碼變更而脫節。如果錯誤是機械式的，修復方式是讓其失敗的檢查。如果是主觀判斷，則放入審核者閱讀的編碼標準中。`AGENTS.md` 和 `CLAUDE.md` 是用於導覽指標，別無其他。出於同樣的原因，`retro` 不是一個[記憶系統 (memory system)](https://www.aihero.dev/ai-coding-dictionary/memory-system)：它不儲存發生了什麼，而是改變環境以使其無法再次發生。

**我的設定提到了 `CODING_STANDARDS.md` 但我沒有。它從何而來？**

沒有任何內建物件會提供該檔案。當 session 第一次為審核者產出主觀判斷規則時，`retro` 會提議建立它，一旦你接受，[code-review](https://aihero.dev/skills-code-review) 從此就會閱讀它。你已經保留的任何其他標準文件（例如 `CONTRIBUTING.md`）運作方式完全相同。

**它與 `improve-codebase-architecture` 有何不同？**

輸入不同。[improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) 只需要程式碼，並為其尋找結構性改進。`retro` 需要 session 歷史記錄，並且改進的是 agent 工作的環境，而非程式碼本身。它們並肩而立；兩者互不取代。

## 若運作正常，會符合以下情況

- 每個候選方案都指向 session 中的具體時刻，而非泛用的最佳實踐。
- 重複的錯誤轉化為會失敗的檢查，且你的 `AGENTS.md` 隨時間推移變得更短而非更長。
- 已經存在但未接上的遺漏檢查會作為發現顯示出來，而非提議建構一個新檢查。
- 在相同類型任務上的下一個 session 能夠更快找到方向。

## 它的定位

`retro` 是主要鏈條的最後一步，流程在此回顧自身：

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review → retro
```

在值得學習的建構之後執行它，可以在同一個 session 中，也可以指向該 session 的記錄。平順的建構可以跳過它。

- [code-review](https://aihero.dev/skills-code-review) 是 `retro` 最常調整的審核者 agent：新的編碼標準會存放在其 Standards 維度讀取的地方。
- [writing-for-agents](https://aihero.dev/skills-writing-for-agents) 設定了 `retro` 提議的每個引導檔案與 skill 的寫作風格，而 `retro` 在啟動前會先載入它。

當你不確定情境需要哪項 skill 時，[ask-matt](https://aihero.dev/skills-ask-matt) 負責整個技能組的路由引導。
