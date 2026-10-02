## 它的功能

`wayfinder` 處理一項單一 agent [session](https://www.aihero.dev/ai-coding-dictionary/session) 無法容納的龐大工作：一個你可以指出**目的地**但尚無法看清路線的想法，並在你的 issue 追蹤器上將其規劃為一份由**決策 ticket** 組成的共享**地圖 (map)**，接著一次解決一個 ticket，直到道路清晰。

它負責規劃，而非執行。每個 ticket 都包含一個問題，其解決結果是一項決策，而非要執行的建構切片；當在有人動手建構該事物之前不再剩下任何需要決定的事項時，地圖即告完成。這條單一規則將 wayfinder ticket 與一般的實作 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 區分開來，也是 agent 最常違反的規則。當地圖清除完畢時，wayfinder 進行交接；它不會繼續深入程式碼。

## 何時使用它

你透過輸入 `/wayfinder` 來呼叫它；[agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會自行使用它。

它是該集合中最沉重、最密集的流程，因此觸發條件很嚴格：工作必須確實大於單一 agent session 所能容納的範圍，且通往目的地的路線必須充滿迷霧。拆分非常明確：單一 session 規劃使用 `/grill-with-docs`，多 session 規劃使用 `/wayfinder`。

| 你眼前所擁有的 | 該執行什麼 |
| --- | --- |
| 一次討論即可確定的範圍良好之功能 | [grill-me](https://aihero.dev/skills-grill-me)，或者當有程式碼庫時使用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 全新專案，或跨越多個 session 且路線仍不明確的建構 | `/wayfinder` |
| 決策已經完成的討論串 | [to-spec](https://aihero.dev/skills-to-spec)：直接跳過地圖 |
| 已清除的 wayfinder 地圖 | [to-spec](https://aihero.dev/skills-to-spec)，接著 [to-tickets](https://aihero.dev/skills-to-tickets) 與 [implement](https://aihero.dev/skills-implement) |
| 已經變得過於龐大的既有 session | 說「交接給 `/wayfinder`」（[handoff](https://aihero.dev/skills-handoff) 既能橋接到地圖，也能從地圖橋接出來） |

全新開闢並非必要條件。Wayfinder 經常在既有或建構了一半的程式碼庫上使用，而且在那些場合它甚至更銳利，因為許多迷霧在於「此處既有的真實情況為何」，而非「我們應該做什麼」。

## 先決條件

地圖及其 ticket 存放在儲存庫的 issue 追蹤器上，因此 wayfinder 需要 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 所奠定的追蹤器串接設定。該步驟會寫入一個「Wayfinding operations」小節，說明如何為 GitHub、GitLab 或本地 Markdown 表達地圖、其子 ticket、阻擋邊以及前沿查詢。Wayfinder 透過你的 `CLAUDE.md` / `AGENTS.md` 中的指標解析該文件，而非固定路徑；在完全沒有設定追蹤器的情況下，它會退回到本地 Markdown 檔案。

追蹤器不是裝飾品。阻擋關聯正是追蹤器自身 UI 能以視覺化方式呈現前沿的關鍵，而沒有原生相依性連結的追蹤器（例如自架的 Gitea）會使 wayfinder 降級為從地圖文字推斷阻擋者，這樣雖能運作但需要更緊密的監督。

## 地圖、迷霧與前沿

**地圖 (map)** 是一個標記為 `wayfinder:map` 的單一 issue；其 ticket 是其子 issue。它是一個**索引，而非儲存庫**：一項決策只存在於剛好一個地方，即其 ticket 中，而地圖只對其進行概述與連結。Session 以低解析度載入地圖，並按需求深入個別 ticket，這正是讓地圖能持續成長而無需讓每個 session 都為其全部歷史付出代價的原因。

地圖上存在四件事物：

- **目的地 (Destination)**：抵達此地圖終點時的樣貌。在任何 ticket 存在之前指出目的地是規劃的第一步，因為目的地鎖定了衡量每個 ticket 的範圍。
- **迄今決策 (Decisions so far)**：每個已關閉 ticket 一行，各自連結到細節實際存放之處。
- **尚未規範 (Not yet specified)**：**戰爭迷霧 (fog of war)**。你預知即將到來但尚無法精確表述的決策。迷霧對比 ticket 的檢驗標準在於你*現在*能否精確陳述問題，而非能否回答問題。解決一個 ticket 可以清除其前方的迷霧，並將現在可規範的內容晉升為全新 ticket。
- **超出範圍 (Out of scope)**：被判定超出目的地的工作。迷霧只會*朝向*目的地聚集，因此超出範圍的工作會被關閉且永不晉升。

**前沿 (frontier)** 是開放、未被阻擋、未被領取的 ticket（已知邊緣）。Session 在進行任何工作之前透過將 ticket 指派給自己來領取它，因此受指派者*即代表*領取狀態，平行 session 會跳過它。全文一律以名稱指稱 ticket，絕非僅使用單純的 `#42`；在敘述中滿螢幕的 issue 編號是無法辨讀的。

## 四種決策 ticket 類型

每個 ticket 都帶有 `wayfinder:<type>` 標籤，且要麼是 **[HITL](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop)**（與代表自己的人類共同處理），要麼是 **[AFK](https://www.aihero.dev/ai-coding-dictionary/afk)**（單獨由 agent 驅動）。HITL ticket 只能透過即時交流來解決；自行回答自己 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) 問題的 agent 就破壞了規則。

| 類型 | 模式 | 何時使用它 | 解決方式 |
| --- | --- | --- | --- |
| `grilling` | HITL | 預設選項。問題可以透過充分討論來解決。 | 在全新的 session 中結合 [grilling](https://aihero.dev/skills-grilling) 與 [domain-modeling](https://aihero.dev/skills-domain-modeling) |
| `prototype` | HITL | 「這應該看起來像什麼」或「這應該如何運作」：討論無法解決的問題。 | [prototype](https://aihero.dev/skills-prototype)，建構好的產物從 ticket 作為資產連結 |
| `research` | AFK | 工作目錄外部的事實正在阻礙決策。 | 一個 [research](https://aihero.dev/skills-research) [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent)，在規劃時觸發並在 `research/<name>` 分支上平行處理銷毀 |
| `task` | 兩者皆可 | 沒有需要決定的事情，但手動工作阻礙了決策，例如開通存取權限、註冊服務或轉移資料以便查看其形狀。 | 在可行的情況下由 agent 單獨處理，否則為人類提供精確的檢核清單 |

`task` 是唯一負責*執行*而非決策的類型，它透過解除對決策的阻擋來證明自身存在的價值，絕不能用於交付目的地的一部分。這是在實務中最常出錯的類型：agent 將其解讀為實作步驟，並開始在地圖內部編寫產品程式碼。

Research 是*每個 session 一個 ticket* 的唯一例外。

## 常見問題

**這與 `/grill-with-docs` 有何不同？我該從哪一個開始？**
在於 Session 數量，而非專案大小。`/grill-with-docs` 是單一 session 規劃；wayfinder 是多 session 規劃。如果你能在單一對話中掌握全局，grilling 是更廉價且更好的工具，而 wayfinder 在那種情況下確實較慢且較沉重。社群定下來的簡要規則：只有在工作放不進單一 session 時，wayfinder 才有意義。這是目前為止最常被問到的 wayfinder 問題，且不斷有人提問是因為描述沒有告訴你自己的任務在該界線上位於何處。你必須自行判斷 session 數量。

**當它詢問「目的地」時，是指本次 session 的結束還是全部的結束？**
整份地圖。這意味著整份地圖的目的地，而不僅僅是初始 session。這個問題讀起來有些模稜兩可，因為 wayfinder 本質上就是一個多 session 工具，因此 session 範圍的答案永遠不合適。典型的目的地包含可交接的[規格 (spec)](https://www.aihero.dev/ai-coding-dictionary/spec)、規劃開始前鎖定的決策、概念驗證，或是像資料遷移這樣的就地變更。

**地圖已經清除。wayfinder 難道沒有已經寫好規格並建立 ticket 嗎？為什麼我還需要 `/to-spec` 和 `/to-tickets`？**
沒有。Wayfinder 的 ticket 是決策 ticket，當地圖關閉時它們也都全部關閉了。剩下的內容是一份充滿連結決策的地圖，這並不是建構計畫。[to-spec](https://aihero.dev/skills-to-spec) 將這些連結的決策收斂為一份規格（`/to-spec #<map_issue>`），而 [to-tickets](https://aihero.dev/skills-to-tickets) 則將其切分為示蹤彈實作 ticket。將地圖直接循環套入 [implement](https://aihero.dev/skills-implement) 會跳過收斂步驟並拋棄連結的細節。只有在工作規模確實很小時才直接進入實作。人們確實執行過縮短的管道並回報有效；這兩個額外的步驟為你帶來審核者或同事可以閱讀的明確規格產出物，你越不是單打獨鬥，這一點就越重要。

**我的 agent 在 wayfinder session 進行到一半時開始撰寫正式環境程式碼。**
此 skill 回報最多的失敗狀況，其背後有一個真實的漏洞。Wayfinder 的「規劃，不執行」預設可以在地圖的**備註 (Notes)** 中被覆寫，但備註是由 agent 撰寫的，因此限制條件及其豁免權存在於受限制方所擁有的同一檔案中。一位使用者看著 agent 在自己的備註中寫下「此地圖承載執行」，隨後在後續 session 中將其作為自己的許可讀回，並在正式伺服器上建構。目前 skill 內沒有針對「我堅持預設」的硬性停止機制。在有解決方案之前：閱讀非你親自繪製的地圖上的備註、將實作保留在獨立的 session 中，並將任何看似建構切片的 `wayfinder:task` 視為類型標記錯誤。

**我規劃了 27 個 ticket，當我進行到第十三個時，其餘的已經不再合理。**
這是一個真實且反覆被回報的結果，逐字摘自實際現場回報。Wayfinder 的預設直覺是進行全面規劃，而後續 ticket 建立在先前 ticket 所推翻的假設之上的地圖，正是此 skill 被指責的瀑布式陷阱。有兩件事可以抵禦它。將地圖的範圍限制在有界的目的地，而非整個產品。實踐者一致回報，範圍限定在一個明確 epic 的地圖表現優於龐大雜亂的「實作 V1」，而且規劃非常龐大的東西本來就不是目標：交付小型增量才是。並且積極進行[原型製作 (prototype)](https://www.aihero.dev/ai-coding-dictionary/prototyping)：路線能保持最新的全部原因在於，在實作依賴不確定性之前，透過廉價且具體的產物將其排除。Wayfinder 是「極致原型化」，而非「極致計畫化」。

**我可以平行處理多個 ticket 嗎？**
前沿旨在向你展示哪些 ticket 是可領取的，而阻擋邊的存在使得平行工作在理論上是安全的。在實務上，一次處理一個是更安全的預設值。同時處理兩個 grilling ticket 的使用者在一個 session 中會被問及剛剛在另一個 session 中回答過的問題，因為 session 之間不共享[上下文 (context)](https://www.aihero.dev/ai-coding-dictionary/context)。在原型 ticket 上也存在一個已知的缺口：據回報曾有 agent 建構了三個 UI 變體，自己挑選了一個，然後關閉了 ticket。選擇權在於你，而該 skill 目前沒有足夠大聲地說明這一點。如果你確實平行執行，請先自行審核相依性圖。

**我必須使用 GitHub Issues 嗎？**
不需要。任何 issue 追蹤器都可以使用。GitHub 是支援最佳的路徑，因為其原生子 issue 與阻擋關聯讓前沿無需打開地圖即可見；GitLab、Linear、Jira 與本地 Markdown 都有人使用。兩個誠實的告誡。沒有原生阻擋功能的追蹤器意味著相依性圖必須從文字推斷，需要手動修正。而本地 Markdown 會將產出物放在儲存庫中，這是不建議的：將這些資料儲存在儲存庫中往往會導致意外持久化。開源維護者遇到的是相反的問題（公開追蹤器充滿 agent 產生的規劃 ticket），無論如何都傾向選擇本地 Markdown。

**Grilling 令人精疲力竭。每個問題都有三個段落那麼長。**
這是關於 wayfinder 最尖銳的當前抱怨，且仍未解決。一位使用者給出的剖析：冗長本身造成了決策疲勞，且過長的篇幅剝離了*為什麼*要問這個問題的背景，因此隨著地圖變長，你遺失了從決策到決策之間的脈絡。冗長似乎是當前這組[模型](https://www.aihero.dev/ai-coding-dictionary/model)的特性，而非該 skill 的問題，且尚未有修復發布。流通中的實踐者緩解措施：降低[推理強度 (reasoning effort)](https://www.aihero.dev/ai-coding-dictionary/effort)，並在你的全域 `CLAUDE.md` 中放入淺白文字指示。無論如何，請做好在此投入實質思考的心理準備，因為 wayfinder 要求你進行的思考量不是缺陷，而是其大部分價值的所在。

**我已經關閉的一項決策後來被證明是錯的。我該編輯舊 ticket 還是建立新 ticket？**
沒有官方指引，而 agent 的直覺是沒有幫助的：它往往會圍繞著糟糕的決策進行設計而非挑戰它，因此你必須手動引導。真正有效的是坦白告訴 wayfinder 發生了什麼變化；它會更新地圖、修訂受影響的 ticket，並在已關閉的 ticket 上留言。地圖中途的範圍變更是可以挽回的。一份你*特意設計*來改變的地圖則是劃定範圍的壞味道。

**`decision-mapping` 去哪裡了？**
就是這個 skill，在 v1.1 中重新命名為 `wayfinder`，並以 `/wayfinder` 呼叫。「Decision map」是術語且也不準確，因為四種 ticket 類型中只有一種本身真正算作決策。重新框架賦予該 skill 一套連貫的詞彙（目的地、戰爭迷霧、前沿、地圖），而不是額外堆疊出發明出來的術語。不過該單元保留了「decision」字眼：wayfinder ticket 被稱為**決策 ticket (decision ticket)**，正是為了防止人們將其理解為實作 ticket。

## 若運作正常，會符合以下情況

- 在單一 ticket 存在之前，目的地已經寫下並達成共識。
- 每個開啟的 ticket 讀起來都像是一個問題。任何寫著「建構 X」的 ticket 要麼是類型標記錯誤，要麼屬於地圖的下游。
- 你可以檢視追蹤器並看清哪些 ticket 是可領取的而無需打開地圖，因為這正是前沿透過原生阻擋自我呈現的方式。
- Session 解決一個 ticket，將答案發布為解決留言，關閉它，並在地圖的「迄今決策」中留下一行。然後它便停下來。
- **尚未規範**隨著時間推移而縮減。一片迷霧晉升為 ticket 後便會從該小節消失，而非同時存在於兩個地方。
- 當開場的廣度優先 grill 完全沒有發現迷霧時，該 skill 會停下來並告訴你該工作規模足夠小，可以跳過地圖。
- 完成地圖的 session 會引導你走向規格，而非 pull request。

## 它的定位

`wayfinder` 是一個**情境式入口匝道 (situational on-ramp)**，而非預設的正門。由 grill 主導的想法 → 交付鏈條仍是大多數工作的起點；wayfinder 是當想法過於龐大而無法在單一 session 中容納時你所登上的工具，並且它在 [to-spec](https://aihero.dev/skills-to-spec) 處重新匯入該鏈條，因為清除的地圖負責交接而非建構。

在底層，它主要是其他掛載了 wayfinder 排程機制的 skill：[grilling](https://aihero.dev/skills-grilling) 與 [domain-modeling](https://aihero.dev/skills-domain-modeling) 解決預設 ticket 類型，[prototype](https://aihero.dev/skills-prototype) 解決討論無法解決的 ticket，而 [research](https://aihero.dev/skills-research) 作為 subagent 執行，因此其閱讀內容絕不會進入你的 session。[handoff](https://aihero.dev/skills-handoff) 是進出的橋樑：從超出身型的對話進入地圖，當 session 中途出現支線任務時從地圖出來。對於其他任何事物，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整個集合中進行路由。
