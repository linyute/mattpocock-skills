## 它的功能

`wayfinder` 會取得一項對於單個 Agent [階段作業](https://www.aihero.dev/ai-coding-dictionary/session) 而言過於龐大的工作 — 一個您可以說出其**目的地**但尚無法看到其路線的想法 — 並將其繪製為您的 Issue 追蹤器上**決策工單**的共享**地圖**，然後一次解決一個決策，直到前路清晰。

它負責規劃，而非執行。每張工單都包含一個問題，其解決方案是一個決策，而不是要執行的建構切片，且當在有人去建構該事物之前沒有任何需要決定的內容留存時，地圖即告完成。這一條規則將 wayfinder 工單與普通的實作 [工單](https://www.aihero.dev/ai-coding-dictionary/ticket) 區分開來，且這是 Agent 最常違反的規則。當地圖清空時，wayfinder 即完成交接；它不會繼續進入程式碼編寫。

## 何時使用它

您可透過輸入 `/wayfinder` 來呼叫此功能 — [Agent](https://www.aihero.dev/ai-coding-dictionary/agent) 不會主動使用它。

它是集合中最繁重、最密集的流程，因此觸發條件很狹窄：工作必須確實大於單個 Agent 階段作業所能容納的範圍，且通往目的地的路線必須是模糊的。區分很明確：`/grill-with-docs` 用於單一階段作業規劃，`/wayfinder` 用於多階段作業規劃。

| 您面前有的內容 | 要執行的內容 |
| --- | --- |
| 您可以在一次作業中定稿且範疇良好的功能 | [grill-me](https://aihero.dev/skills-grill-me)，或者當有程式碼庫時使用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| 綠地專案，或跨越多個階段作業且路線仍不明朗的建構 | `/wayfinder` |
| 決策已經完成的討論串 | [to-spec](https://aihero.dev/skills-to-spec) — 直接跳過地圖 |
| 已清空的 wayfinder 地圖 | [to-spec](https://aihero.dev/skills-to-spec)，然後執行 [to-tickets](https://aihero.dev/skills-to-tickets) 和 [implement](https://aihero.dev/skills-implement) |
| 已經變得過大的現有階段作業 | 說「交接給 `/wayfinder`」— [handoff](https://aihero.dev/skills-handoff) 既可以橋接到地圖中，也可以橋接出地圖 |

綠地專案並非必要條件。Wayfinder 常規用於遺留及半建構的程式碼庫，且在該處可以說更為敏銳，因為很多迷霧是「這裡已經實現了什麼」而不是「我們應該做什麼」。

## 先決條件

地圖及其工單位於儲存庫的 Issue 追蹤器上，因此 wayfinder 需要 [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) 所鋪設的追蹤器線路。該步驟編寫了一個「Wayfinding 操作」區段，描述了如何為 GitHub、GitLab 或本機 Markdown 表示地圖、其子工單、阻塞邊緣和前沿查詢。Wayfinder 透過您的 `CLAUDE.md` / `AGENTS.md` 中的指標而非固定路徑來解析該文件；在完全沒有設定追蹤器的情況下，它會退回到本機 Markdown 檔案。

追蹤器不是裝飾品。阻塞是在追蹤器自己的 UI 中視覺化呈現前沿的要素，且沒有原生依賴連結的追蹤器（例如自我託管的 Gitea）會使 wayfinder 降級為從地圖文字中推導阻塞項，這雖然可行但需要更緊密的監督。

## 地圖、迷霧與前沿

**地圖**是標有 `wayfinder:map` 的單一 Issue；其工單是其子 Issue。它是一個**索引，而非儲存庫** — 決策恰好存在於一個地方（其工單），而地圖僅對其進行摘要與連結。階段作業以低解析度載入地圖，並按需放大到單個工單中，這使得地圖可以持續增長，而無需每個階段作業都為其整個歷史記錄付出代價。

其中包含四項內容：

- **目的地** — 到達這張地圖終點的樣子。在建立任何工單之前，命名它是繪製地圖的第一步行動，因為目的地固定了測量每張工單的範疇。
- **迄今為止的決策** — 每個已關閉工單一行，各自連結到細節實際存在的地方。
- **尚未指定** — **戰爭迷霧**。您可以看出即將到來但尚無法精確表達的決策。迷霧與工單的測試在於您*現在*是否能精確陳述問題，而不是您是否能回答它。解決一張工單會清空其前方的迷霧，並將現在可指定的事物晉升為全新的工單。
- **超出範疇** — 經判定超出目的地的工作。迷霧只會*朝向*目的地聚集，因此超出範疇的工作會被關閉且永遠不會晉升。

**前沿**是開放的、未阻塞的、未經認領的工單 — 已知事物的邊緣。階段作業在進行任何工作之前透過將工單指派給自己來認領工單，因此指派者*即為*認領，且並行的階段作業會跳過它。工單在整個過程中都按名稱引用，絕不使用單純的 `#42`；在敘述中，一堵 Issue 編號牆是不可讀的。

## 四種決策工單類型

每張工單都帶有 `wayfinder:<type>` 標籤，且要麼是 **[HITL](https://www.aihero.dev/ai-coding-dictionary/human-in-the-loop)**（與為自己說話的人類合作完成），要麼是 **[AFK](https://www.aihero.dev/ai-coding-dictionary/afk)**（僅由 Agent 驅動）。HITL 工單僅透過即時交流解決；自己回答自己的 [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) 問題的 Agent 已破壞了規則。

| 類型 | 模式 | 何時使用它 | 解決方式 |
| --- | --- | --- | --- |
| `grilling` | HITL | 預設選項。問題可以透過討論來解決。 | 在全新的階段作業中透過 [grilling](https://aihero.dev/skills-grilling) 加上 [domain-modeling](https://aihero.dev/skills-domain-modeling) |
| `prototype` | HITL | 「這應該看起來如何」或「這應該如何運作」— 討論無法解決的問題。 | [prototype](https://aihero.dev/skills-prototype)，建構的產物作為資產從工單進行連結 |
| `research` | AFK | 工作目錄之外的事實正在阻塞決策。 | 在繪製地圖時啟動並在 `research/<name>` 分支上平行消除的 [research](https://aihero.dev/skills-research) [子 Agent](https://www.aihero.dev/ai-coding-dictionary/subagent) |
| `task` | 兩者皆可 | 沒有需要決定的內容，但手動工作阻塞了決策 — 設定權限、註冊服務、移動資料以便可以看到其形狀。 | 在可以的情況下由 Agent 單獨完成，否則為人類提供精確的清單 |

`task` 是唯一*執行*而非決定的類型，它透過解除對決策的阻塞來贏得其位置 — 絕不是透過交付目的地的一部分。這是實務中最常出錯的類型：Agent 將其解讀為實作步驟，並開始在地圖內部撰寫產品程式碼。

Research 是*每個階段作業一張工單*規則的唯一例外。

## 常見問題

**這與 `/grill-with-docs` 有何不同？我應該從哪一個開始？**
階段作業數量，而不是專案大小。`/grill-with-docs` 是單一階段作業規劃；wayfinder 是多階段作業規劃。如果您可以在一次對話中掌握整個內容，盤問 (grilling) 是更便宜且更好的工具，而 wayfinder 在那種情況下確實更慢且更密集。對其達成的社群簡稱：wayfinder 只有在工作無法放入單個階段作業時才有意義。這是目前為止被詢問最多的 wayfinder 問題，且它一直被詢問，因為描述沒有告訴您您自己的任務在該線上的位置 — 您必須自己判斷階段作業數量。

**當它詢問「目的地」時，是指本階段作業的終點還是所有內容的終點？**
整張地圖 — 整張地圖的目的地，而不僅僅是初始階段作業。這個問題讀起來很模糊，因為按定義 wayfinder 是一個多階段作業工具，因此階段作業範疇的答案永遠沒有意義。典型的目的地是移交的 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)、在開始規劃前鎖定決策、概念驗證，或是就地進行的變更（如資料遷移）。

**地圖已清空。為什麼我仍然需要 `/to-spec` 與 `/to-tickets` — wayfinder 不是已經撰寫了規格並製作了工單嗎？**
沒有。Wayfinder 的工單是決策工單，到了地圖關閉時，它們也全部關閉了。留下的是一張填滿連結決策的地圖，這不是建構計畫。[to-spec](https://aihero.dev/skills-to-spec) 將這些連結的決策收合為一個規格 — `/to-spec #<map_issue>` — 且 [to-tickets](https://aihero.dev/skills-to-tickets) 將其切片為曳光彈實作工單。將地圖直接循環進入 [implement](https://aihero.dev/skills-implement) 會跳過收合並丟棄連結的細節。只有當工作證明確實很小時，才直接進行實作。人們確實會執行簡化的管線並回報其可行；兩個額外的步驟為您換取了一個審查者或同事可以閱讀的明確規格產物，您越不是單打獨鬥，這一點就越重要。

**我的 Agent 在 wayfinder 階段作業中途開始撰寫生產環境程式碼。**
這是此 Skill 被回報最多的失敗，背後有一個真正的漏洞。Wayfinder 的「規劃，不執行」預設值可以在地圖的 **Notes** 中覆寫 — 但 Notes 是由 Agent 撰寫的，因此約束及其豁免存在於受約束方擁有的同一個檔案中。一名使用者看著 Agent 將「此地圖包含執行」寫入其自己的 Notes 中，然後在後續階段作業中將其作為自己的授權讀回，並在線上伺服器上進行建構。對於「我是指預設值」，在 Skill 內部沒有硬性停止。在有硬性停止之前：閱讀您沒有自己繪製的任何地圖上的 Notes，將實作保持在其自己的階段作業中，並將看起來像建構切片的任何 `wayfinder:task` 視為型別錯誤。

**我繪製了 27 張工單，到了第 13 張時，其餘的不再有意義。**
一個真實且重複回報的結果，逐字來自現場報告。Wayfinder 的預設本能是進行全面規劃，而後面工單基於前面工單無效假設的地圖，正是該 Skill 被指責的瀑布陷阱。有兩件事對其進行反擊。將地圖的範疇限制在有限的目的地，而不是整個產品 — 從業者一致回報，範疇限制在一個定義明確的 Epic 的地圖比蔓延的「實作 V1」表現更好，且規劃非常龐大的事物本來就不是目標 — 交付小幅增量才是。並且積極地進行 [prototype](https://www.aihero.dev/ai-coding-dictionary/prototyping)：路線保持最新狀態的全部原因是，在實作依賴它之前，不確定性已被便宜的具體產物所清空。Wayfinder 是「原型最大化」，而不是「規劃最大化」。

**我可以平行處理多張工單嗎？**
前沿旨在向您展示什麼是可以接手的，且存在阻塞邊緣以便平行工作在紙面上是安全的。在實務中，一次處理一張是更安全的預設值。一次處理兩張 grilling 工單的使用者會在一個階段作業中被詢問他們剛在另一個階段作業中回答過的問題，因為這些階段作業不共享 [內容](https://www.aihero.dev/ai-coding-dictionary/context)。prototype 工單上還有一個已知缺口：據回報，一個 Agent 建構了三個 UI 變體，自己選擇了一個，並關閉了工單 — 選擇應由您做出，且 Skill 目前沒有足夠大聲地說明這一點。如果您確實要平行執行，請先自己審查依賴圖。

**我必須使用 GitHub Issues 嗎？**
不需要 — 任何 Issue 追蹤器都可以使用。GitHub 是支援最好的路徑，因為其原生的子 Issue 和阻塞關係是無需開啟地圖即可使前沿可見的要素；GitLab、Linear、Jira 和本機 Markdown 都被使用。兩個誠實的警告：沒有原生阻塞的追蹤器意味著依賴圖是從文字推導出來的，需要手動修正。而本機 Markdown 將產物放在您的儲存庫中，這是不推薦的：將此材料儲存在儲存庫中往往會導致意外的持久化。開源維護者遇到相反的問題 — 公開追蹤器填滿了 Agent 產生的規劃工單 — 無論如何往往會選擇本機 Markdown。

**盤問令人精疲力竭。每個問題都有三段長。**
這是關於 wayfinder 最犀利的即時抱怨且尚未修復。一名使用者給出的分解：冗長本身會導致決策疲勞，且長度剝離了*為何*要提出問題的原因，因此隨著地圖變長，您會失去從決策到決策的鏈條。冗長看起來是目前這組 [模型](https://www.aihero.dev/ai-coding-dictionary/model) 的屬性，而不是 Skill 的屬性，且沒有任何修復落地。流通中的從業者緩解措施：執行較低的 [推理努力](https://www.aihero.dev/ai-coding-dictionary/effort)，並在全域 `CLAUDE.md` 中放置平實的語言指令。無論如何，預計在此花費真正的思考 — wayfinder 要求您進行的思考量不是缺陷，這才是其存在的大部分意義。

**我已經關閉的決策證明是錯誤的。我是編輯舊工單還是製作新工單？**
沒有官方指引，且 Agent 的本能是無效的：它傾向於圍繞不良決策進行設計，而不是挑戰它，因此您必須進行手動引導。可行的是坦率地告訴 wayfinder 改變了什麼 — 它會更新地圖，修訂受影響的工單，並對已關閉的工單進行留言。地圖中途的範疇變更是可恢復的。您*設計*為要變更的地圖是一種範疇臭味。

**`decision-mapping` 去哪裡了？**
它就是這個 Skill，在 v1.1 中重新命名為 `wayfinder` 並作為 `/wayfinder` 呼叫。「Decision map」是術語且不準確，因為四種工單類型中只有一種本身真的是決策。重新構想給予了 Skill 一個連貫的詞彙表 — 目的地、戰爭迷霧、前沿、地圖 — 而不是分層置頂的發明術語。不過，該單元保留了「決策」一詞：**決策工單**是 wayfinder 工單的稱呼，精確地是為了防止人們將其解讀為實作工單。

## 運作良好的指標

- 在單張工單存在之前，目的地已寫下並達成一致。
- 每張開啟的工單讀起來都是一個問題。任何讀起來像「建構 X」的工單要麼是型別錯誤，要麼屬於地圖的下游。
- 您可以查看追蹤器並在不安裝地圖的情況下看到哪些工單是可以接手的 — 這就是透過原生阻塞呈現其自身的前沿。
- 一個階段作業解決一張工單，將答案作為決議留言發布，關閉它，並在地圖的*迄今為止的決策*上記錄一行。然後它停止。
- **尚未指定**隨時間收縮。晉升為工單的一片迷霧會從該區段消失，而不是同時存在於兩個地方。
- 當開場的廣度優先盤問沒有發現任何迷霧時，Skill 會停止並告訴您工作量足夠小，可以跳過地圖。
- 完成地圖的階段作業會將您引向規格，而不是 Pull Request。

## 適用位置

`wayfinder` 是一個**情境匝道**，而不是預設的大門。盤問引導的想法 → 交付鏈仍然是大多數工作開始的地方；當想法大到無法在一個階段作業中掌握時，wayfinder 就是您爬上的工具，且它在 [to-spec](https://aihero.dev/skills-to-spec) 處重新匯合到該鏈上，因為清空的地圖會進行移交而不是建構。

在底層，它主要是其他穿著 wayfinder 排程的 Skill：[grilling](https://aihero.dev/skills-grilling) 和 [domain-modeling](https://aihero.dev/skills-domain-modeling) 解決預設工單類型，[prototype](https://aihero.dev/skills-prototype) 解決討論無法解決的工單，而 [research](https://aihero.dev/skills-research) 作為子 Agent 執行，因此其閱讀絕不會落在您的階段作業中。[handoff](https://aihero.dev/skills-handoff) 是進出地圖的橋樑 — 從超出自身範圍的對話進入地圖，在階段作業中途出現支線任務時離開地圖。對於任何其他內容，[ask-matt](https://aihero.dev/skills-ask-matt) 會在整個集合中進行引導。
