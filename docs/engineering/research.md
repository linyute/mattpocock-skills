## 功能說明

`research` 透過閱讀擁有解答的來源來回答問題，然後在儲存庫中留下一個帶有引述的 Markdown 檔案。它僅從**[第一手來源（primary sources）](https://www.aihero.dev/ai-coding-dictionary/primary-source)** — 官方文件、原始程式碼、規格、第一方 API — 運作，並將每項主張追溯回擁有它的來源，因此當 API 自己的文件可存取時，它不會重複部落格文章對 API 的描述。

它不會在對話中回答你。輸出是一個檔案，寫在儲存庫已經保留此類筆記的地方，且每項主張上都帶有連結。這正是重點所在：一份你可以對其做出反應、交給另一個 agent，或丟棄的文件，而不是當[工作階段](https://www.aihero.dev/ai-coding-dictionary/session)結束時就消失的答案。

## 何時使用

輸入 `/research`，或者當任務變成閱讀腿力工作（繁重搜尋）時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會自動使用它。

當下一步是從工作目錄外部*找出某事物*（第三方 API 如何運作、規格實際上說了什麼、版本主張是否成立），且你不想停頓自己的討論串來進行閱讀時使用它。你的需求決定了使用哪個技能：

| 你的需求 | 使用技能 |
| --- | --- |
| 決策等待中的外部事實 | `research` |
| 透過訪談*與你共同*做出的決策 | [grilling](https://aihero.dev/skills-grilling) |
| 寫入 `CONTEXT.md` 與 ADR 中的持久架構決策 | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 了解某種方法在你的程式碼庫中是否可行 | [prototype](https://aihero.dev/skills-prototype) |
| 太大而無法在單一工作階段中容納的計畫 | [wayfinder](https://aihero.dev/skills-wayfinder) |

`research` 與 `grill-with-docs` 之間的分水嶺在於**回傳內容的保存期限**。Research 產生短暫的資產 — 本週此函式庫的驗證機制如何運作。ADR 記錄你保留的決策。如果你產生的內容是決策而非事實，你是在進行 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)（審問），而不是研究。

## 委派的腿力工作

關鍵的操作在於閱讀作為**背景 agent** 執行。你繼續工作；它離開並追蹤每項主張至其第一手來源、撰寫一個 Markdown 檔案並回報。Research 是你委派的腿力工作，而不是你外包的思考 — 你獲得一份文件來進行審問、規劃或設計，且你仍然做出決策。

委派是未受防禦的，且背景 agent 可以進一步產生它自己的背景 agent。這是本技能上記錄最充分的粗糙邊角。

檔案落腳處由儲存庫決定，而不是由本技能決定：它符合筆記現有的任何約定，如果沒有，它會選擇合理的位置並告訴你路徑。每次執行寫入一個檔案。

## 常見問題

**它產生了第二個研究 agent — 這是預期的嗎？**

不是。這是一個開放錯誤，[issue #530](https://github.com/mattpocock/skills/issues/530)。本技能告知其呼叫者啟動背景 agent，但沒有限制 agent 型別，因此它產生的 agent 是通用型（`general-purpose`）agent，持有 `Agent` 工具與相同的指示 — 並再次觸發它們。一位回報者測量了單一研究任務在三個重疊的執行中消耗了約 45 萬個 [tokens](https://www.aihero.dev/ai-coding-dictionary/token)，且重複的執行在半小時後於完全不可見的情況下完成。這在 Claude Code 之外也會重現；在帶有 GPT-5.6-sol 的 Codex 中確認了相同的嵌套。目前沒有發布修復。使用者透過新增一行指示修補了他們自己安裝的複本，告知已經是 [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent)（子 agent）的 agent 自己完成工作，這有所幫助但屬於指示層級而非結構層級。在呼叫後請留意你的背景任務清單，並停止重複的任務。

相反的失敗情況也存在：如果你自己的全域指示禁止 agent 重新委派工作，背景 agent 會禮貌地拒絕該任務，且該技能會在靜默中不採取任何行動。

**檔案應該存放在哪裡 — 我應該提交它嗎？**

本技能將檔案存放在儲存庫已經保留筆記的地方，此外沒有其他意見。社群共識相當明確：ADR 予以保留，研究檔案不予保留。來自討論該問題之 Discord 討論串的最犀利版本：「ADR 要保留。其他所有內容在完成後存檔或刪除。否則它會變成工作的渣滓，且如果你已經偏離規格/研究，可能會毒害未來的儲存庫讀取。」研究檔案記錄了撰寫當天真實的內容，因此過期的檔案比沒有更糟糕。總體而言，這些產物並不真正屬於 git，且沒有規範的存放處 — 人們改為使用 Obsidian、獨立的知識儲存庫或議題追蹤器。

**什麼算作「高信任度」的第一手來源，由誰決定？**

由 [model](https://www.aihero.dev/ai-coding-dictionary/model)（模型）決定。本技能指定了符合條件的來源*種類* — 官方文件、原始程式碼、規格、第一方 API — 且沒有允許清單、沒有領域閘門，也沒有驗證審查。這是本技能最初被提出時最大的反對意見，且從未被公開回答過：「五個指向垃圾的研究子 agent 只會更快為你提供五個自信的錯誤答案。你該如何把關什麼才是高信任度來源？」你實際擁有的緩解措施是每項主張上的引述。追縱其中的兩三個。如果它們落腳於事物的摘要而不是事物本身，說明執行在其單一工作上失敗了。

**後續的工作階段會重新使用早期執行發現的內容嗎？**

不會。沒有任何內容會自動載入過去的研究檔案；它只是一個存放在儲存庫中的文件，直到人類或技能指向它。這在早期被提出作為對設計的最強挑戰 —「價值在於 markdown 成為 agent 稍後重新閱讀的 context，而不是抓取本身。寫入一次的死檔案只是花哨的搜尋」— 且發布的技能並未解決此問題。在實踐中，該檔案透過被刻意提供給下一步來發揮作用：將其附加至規格、引述至審問工作階段中、將 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 指向它。

**為什麼不直接要求 agent 去閱讀文件？**

你可以這麼做，且完全這樣說的兩行 prompt 正是本技能所替換的做法。與 prompt 相比，本技能帶來了兩點好處：它在背景執行，因此你的工作階段可以保持其 [context](https://www.aihero.dev/ai-coding-dictionary/context) 乾淨，且第一手來源約束與帶有引述的檔案輸出每次都以相同的形式呈現，而不是取決於你碰巧如何措辭。與 [harness](https://www.aihero.dev/ai-coding-dictionary/harness) 自身的深度研究（deep-research）模式相比，差異在於產物與來源規範，而不是搜尋。如果兩行 prompt 能在微小問題上為你提供所需內容，請使用兩行 prompt。

**它何時停止閱讀？**

技能中沒有停止標準，這表現為看起來相反但本質相同的兩個抱怨：深入過頭的 agent，以及廣泛涵蓋主題卻遺漏了關鍵之單一特定細節的 agent。一位實踐者將其陳述為「深度研究技能有時有點過深了。且告訴 agent 去研究通常會導致遺漏關鍵細節。」劃定範圍在於你。狹窄、可回答的問題 — 一個 API、一種行為、一個版本主張 — 產生的結果遠好於「研究 X」。

**`/wayfinder` 建立了研究 tickets — 我要自己解決那些嗎？**

不需要，它現在會為你觸發它們。在 v1.1 以來未發布的變更中，繪圖工作階段會為每個研究 ticket 啟動一個 `/research` subagent 並平行銷毀它們，將發現結果擷取在獨立的一次性 `research/<name>` 分支上，並從 ticket 留下 [context pointer](https://www.aihero.dev/ai-coding-dictionary/context-pointer)。研究 tickets 是 wayfinder 每個工作階段一個 ticket 規則的唯一例外，因為它們是 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk)（離開鍵盤）的 — 沒有內容在等待你。這些分支有兩個已知問題：曾觀察到 subagent 從絕不打算合併的分支開啟草稿 PR（[issue #576](https://github.com/mattpocock/skills/issues/576)），且稍後刪除分支會破壞 tickets 所持有的 context 指針。

## 運作正常的指標

- 你自己的工作階段繼續進行。如果你坐著看它閱讀，說明委派並未發生。
- 恰好出現一個新的背景任務。名稱幾乎相同的第二個任務是嵌套錯誤。
- 出現一個新的 Markdown 檔案，位於儲存庫已用於筆記的資料夾中，且 agent 會告知你路徑。
- 其中的每項主張都帶有連結，且隨機追蹤兩個連結會讓你落腳於官方文件、規格或實際的來源檔案 — 而不是某些人的報導。
- 你僅憑該檔案就能做出原本卡住的決策，而無需自己重新查看來源。

## 適用位置

一個隨時可用的獨立技能，用以向思考技能提供養分，而不是部位於建構鏈結中。它的檔案可以用於帶入*流程*：當事實已經擺在桌面上時，[grilling](https://aihero.dev/skills-grilling) 與 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 能提出更犀利的問題，而 [to-spec](https://aihero.dev/skills-to-spec) 可以對其進行綜合。 [wayfinder](https://aihero.dev/skills-wayfinder) 是直接呼叫它的唯一技能，透過 `/research` subagent 確定解決其地圖上的每個研究 ticket。對於整個地圖，請參閱 [ask-matt](https://aihero.dev/skills-ask-matt)。
