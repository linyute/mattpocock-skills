## 它的功能

`research` 透過閱讀掌握答案的來源來回答問題，接著在儲存庫中留下一個附帶引用的 Markdown 檔案。它僅依據**[主要來源 (primary sources)](https://www.aihero.dev/ai-coding-dictionary/primary-source)**工作：官方文件、原始程式碼、規格、第一方 API。它會將每項陳述追溯至掌握該陳述的來源，因此當 API 本身的文件可以存取時，它不會重複引用部落格文章對該 API 的說明。

它不會在對話中回答你。其輸出是一個檔案，寫入儲存庫既有用於保留此類筆記的位置，並在每項陳述附上連結。這就是重點所在：一份你可以回應、交給另一個 agent 或丟棄的文件，而不是隨著 [session](https://www.aihero.dev/ai-coding-dictionary/session) 結束而消失的回答。

## 何時使用它

輸入 `/research`，或者當任務轉變為閱讀繁瑣工作時，[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會自動使用它。

當下一步是從工作目錄外部*查明某些事情*（第三方 API 如何運作、規格實際上寫了什麼、版本聲明是否屬實），而且你不想停下自己的執行緒親自閱讀時，請使用它。你的需求決定該使用哪項 skill：

| 你的需求 | 使用技能 |
| --- | --- |
| 決定正等待取得的外部事實 | `research` |
| 透過訪談*與*你共同做出的決定 | [grilling](https://aihero.dev/skills-grilling) |
| 持久的架構決策，寫入 `GLOSSARY.md` 與 ADR | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 查明某種方法是否適用於你的程式碼庫 | [prototype](https://aihero.dev/skills-prototype) |
| 一個 session 放不下的龐大計畫 | [wayfinder](https://aihero.dev/skills-wayfinder) |

`research` 與 `grill-with-docs` 之間的界線在於**回傳內容的保存期限**。Research 產生短期資產：例如本週該函式庫的驗證機制如何運作。ADR 則記錄你保留下來的決策。如果你正在產出的是一項決策而非事實，你是在進行 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling)，而不是 research。

## 委派繁瑣工作

其最具代表性的做法是將閱讀工作當作**背景 agent** 執行。你繼續工作；它自行出發、將每項陳述追溯至其主要來源、撰寫一份 Markdown 檔案並回報結果。Research 是你委派的繁瑣工作，而不是外包思考：你獲得一份文件來進行 grilling、規劃或針對其設計，而最終裁決仍在於你。

這種委派是不受防護的，背景 agent 可以自行繁衍出進一步的背景 agent。這是該 skill 紀錄最詳盡的粗糙之處。

檔案存放的位置由儲存庫決定，而非由 skill 決定：它遵循既有筆記的任何慣例，如果沒有慣例，它會挑選合理的位置並告訴你在哪裡。每次執行都會寫入一個檔案。

## 常見問題

**它繁衍出第二個 research agent。這是預期的行為嗎？**

不是。這是一個尚未解決的 bug，[issue #530](https://github.com/mattpocock/skills/issues/530)。該 skill 指示其呼叫端啟動一個背景 agent，但沒有限制 agent 類型，因此它繁衍出的 agent 是一個持有 `Agent` 工具與相同指示的 `general-purpose` agent，並再次觸發它們。有一位回報者測量到單一 research 任務在三個重疊執行中花費了大約 45 萬個 [token](https://www.aihero.dev/ai-coding-dictionary/token)，且重複的執行在半小時後完全在視野之外結束。這在 Claude Code 之外也重現了；在 Codex 與 GPT-5.6-sol 中也確認了相同的巢狀情況。目前尚未發布修復。使用者透過加入一行指示來修補自己安裝的複本，告訴已經是 [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) 的 agent 自己完成工作，這有所幫助但屬於指示層級，而非結構性層級。呼叫後請留意你的背景任務清單，並停止重複的任務。

相反的失敗情況也存在：如果你自己的全域指示禁止 agent 重新委派工作，背景 agent 將禮貌地拒絕該任務，而 skill 則悄悄地什麼都不做。

**檔案應該放在哪裡，我應該 commit 它嗎？**

該 skill 會將檔案放在儲存庫既有存放筆記的位置，除此之外沒有任何定見。社群的共識相當明確：ADR 會保留，research 檔案則不保留。針對這個問題，Discord 討論串中最一針見血的說法是：「ADR 要留。其他所有東西在完成後封存或刪除。否則它會變成工作的殘留物，如果你偏離了規格/研究，還可能毒害未來的儲存庫讀取。」Research 檔案記錄的是撰寫當天屬實的內容，因此過期的檔案比沒有更糟。權衡之下，這些產出物並不真正屬於 git，而且它們也沒有標準歸宿：人們改用 Obsidian、獨立的知識儲存庫或 issue 追蹤器。

**什麼算作「高信任度」的主要來源，由誰決定？**

由[模型](https://www.aihero.dev/ai-coding-dictionary/model)決定。該 skill 列出了符合資格的來源*種類*（官方文件、原始程式碼、規格、第一方 API），並且沒有允許清單、沒有網域閘門、也沒有驗證階段。這是該 skill 最初被提出時最強烈的反對意見，且從未被公開解答：「將五個 research subagent 指向垃圾，只會讓你更快得到五個自信的錯誤答案。你們要如何把關什麼算作高信任度來源？」你實際擁有的緩解措施是每項陳述上的引用。隨機追蹤其中的兩到三個。如果它們連到的是該事物的摘要而非事物本身，那麼該次執行就未能達成其唯一的任務。

**後續的 session 會重用先前執行找到的內容嗎？**

不會。沒有任何機制會自動載入過去的 research 檔案；它是一份留在儲存庫中的文件，直到有人類或 skill 指向它。這在早期就被提出作為對此設計最有力的質疑：「價值在於 Markdown 變成 agent 後續重新閱讀的上下文，而不是擷取本身。一次性寫入的死檔案只不過是花俏的搜尋。」已發布的 skill 並未解決這個問題。在實務上，該檔案是透過特意提供給下一步驟來證明其價值：將其附加至規格、在 grilling session 中引用它、將 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 指向它。

**為什麼不直接要求 agent 去閱讀文件？**

你可以這麼做，而一行正是這麼寫的兩行 prompt 就是這項 skill 取代的操作方式。該 skill 相比 prompt 帶來的兩個優勢：它在背景執行因此能讓你的 session 保持乾淨的[上下文 (context)](https://www.aihero.dev/ai-coding-dictionary/context)，而且主要來源限制與附帶引用的檔案輸出每次都以相同方式產出，而不是取決於你碰巧如何措辭。相較於 [harness](https://www.aihero.dev/ai-coding-dictionary/harness) 本身的 deep-research 模式，差異在於產出物與來源紀律，而非搜尋本身。如果兩行 prompt 就能解決你在小型問題上的需求，就使用兩行 prompt。

**它什麼時候會停止閱讀？**

該 skill 中沒有停止標準，這表現為兩種看似相反卻是同一缺口的抱怨：深入過頭的 agent，以及廣泛涵蓋主題卻遺漏唯一重要細節的 agent。一位實踐者將其描述為「deep-research skill 有時過於深入。而指示 agent 去研究通常會導致遺漏關鍵細節。」劃定範圍是你的責任。一個狹窄、可回答的問題（單一 API、單一行為、單一版本聲明）產生的回傳結果遠優於「研究 X」。

**`/wayfinder` 建立了 research ticket。我要自己解決那些嗎？**

不需要，它現在會替你觸發。在 v1.1 以來未發布的變更中，charting session 會為每個 research ticket 繁衍一個 `/research` subagent 並平行銷毀處理它們，將發現記錄在拋棄式的 `research/<name>` 分支上，並附帶來自 ticket 的[上下文指標 (context pointer)](https://www.aihero.dev/ai-coding-dictionary/context-pointer)。Research ticket 是 wayfinder 單一 session 一個 ticket 規則的唯一例外，因為它們是 [AFK](https://www.aihero.dev/ai-coding-dictionary/afk)：沒有任何事情等待你。這些分支有兩個已知的障礙：曾看過 subagent 從絕無意圖合併的分支開啟草稿 PR（[issue #576](https://github.com/mattpocock/skills/issues/576)），且日後刪除該分支會破壞 ticket 所持有的上下文指標。

## 若運作正常，會符合以下情況

- 你自己的 session 繼續進行。如果你坐在那裡看著它閱讀，表示委派並未發生。
- 正好出現一個新的背景任務。出現名稱近乎相同的第二個任務則是巢狀 bug。
- 出現一份新的 Markdown 檔案，位於儲存庫既有用於筆記的資料夾中，且 agent 會告訴你路徑。
- 其中的每項陳述都附帶連結，且隨機追蹤兩個連結會讓你連到官方文件、規格或實際的原始檔案，而非某人的介紹文章。
- 你僅憑該檔案就能做出之前卡住的決定，而無需自己回頭去查閱來源。

## 它的定位

一個隨時可用、為思考型 skill 提供素材而非位於建構鏈中的獨立工具。它的檔案是要帶*入*工作流程的產物：當事實已經擺在眼前時，[grilling](https://aihero.dev/skills-grilling) 與 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) 能提出更銳利的問題，而 [to-spec](https://aihero.dev/skills-to-spec) 則可以對照它進行綜合彙整。[wayfinder](https://aihero.dev/skills-wayfinder) 是唯一直接呼叫它的 skill，利用 `/research` subagent 解決其地圖上的每個 research ticket。關於整體架構圖，請參閱 [ask-matt](https://aihero.dev/skills-ask-matt)。
