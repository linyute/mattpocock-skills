---
name: 'wayfinder'
description: '在 issue tracker 上以決策 ticket 的共享地圖形式規劃巨量工作（超過單一 Agent 工作階段所能容納），並逐一解決它們，直到通往目的地的道路清晰為止。'
disable-model-invocation: true
---

一個粗略的想法出現了，它對於單一 Agent 工作階段而言過於龐大，且籠罩在迷霧中：從這裡到**目的地**的路徑目前尚不可見。尋路（Wayfinding）的重點在於尋找那條道路，而非盲目衝向目的地。此技能在儲存庫的 issue tracker 上將路徑繪製成**共享地圖**，然後逐一處理其**決策 ticket**（解決方式為做出決策的問題，而非要執行的建構切片），直到路線清晰為止。

每個任務的目的地各不相同，為其命名是繪製地圖的第一步：它塑造了每個 ticket。它可能是交付並迭代的規格、在規劃開始前鎖定的決策，或是就地進行的變更（如資料結構遷移）。該地圖與領域無關：工程工作、課程內容，凡是符合此形式的皆可。

## 規劃，而非動手執行

Wayfinder 預設為**規劃**：每個 ticket 解決一個決策，當道路清晰且在有人動手執行之前沒有需要決定的事項時，地圖即告完成。直接動手做事的衝動通常表示你已經到達了地圖的邊界，是交接的時候了。一項努力可以在其 **Notes** 中覆寫此設定，將執行工作納入地圖本身，但若非如此，請產出決策，而非交付項目。

## 依名稱參照

每張地圖和 ticket 都是一個 issue，因此它有一個**名稱**：即其標題。在人類閱讀的所有內容中（敘述、地圖的 Decisions-so-far），請依該名稱參照它，絕不要使用單純的識別碼、編號或代稱。一整面 `#42, #43, #44` 是難以閱讀的；名稱則一目了然。識別碼和 URL 並未消失；名稱會包裹其連結，但它們附帶*在名稱之內*，絕不代表名稱本身。

## 地圖

地圖是本儲存庫 issue tracker 上的單一 issue，標記為 `wayfinder:map`，這是標準工件。其 ticket 為地圖的子 issue。

地圖是**索引**，而非儲存庫。它列出已做出的決策並指向包含其詳細資訊的 ticket；決策僅存在於恰好一個地方，即其 ticket，因此地圖絕不重述它，僅作摘要和連結。

**地圖、其子 ticket、阻礙和前沿查詢在實體上存在於何處取決於 tracker。** issue tracker 應該已經提供給你。如果沒有，請告訴使用者執行 `/setup-matt-pocock-skills`。請參閱 tracker 文件的「尋路操作」一節，以了解*此*儲存庫如何表達它們。若尚未提供 tracker，預設為本地 Markdown tracker。

### 地圖內文

低解析度的完整地圖，每個工作階段載入一次。未結 ticket **不**列於此：它們是未結子 issue，透過查詢找到。

```markdown
## Destination

<what reaching the end of this map looks like: the spec, decision, or change this effort is finding its way to. One or two lines; every session orients to it before choosing a ticket.>

## Notes

<domain; skills every session should consult; standing preferences for this effort>

## Decisions so far

<!-- the index: one line per closed ticket, enough to judge relevance, then zoom the link for the detail the ticket holds -->

- [<closed ticket title>](link): <one-line gist of the answer>

## Not yet specified

<!-- see "Fog of war": in-scope fog you can't ticket yet; graduates as the frontier advances -->

## Out of scope

<!-- see "Out of scope": work ruled beyond the destination; closed, never graduates -->
```

### Ticket

每個 ticket 都是地圖的**子 issue**；tracker 的 issue 識別碼是其識別標識。其內文為問題，大小設定為單一 100K 權杖的 Agent 工作階段：

```markdown
## Question

<the decision or investigation this ticket resolves>
```

每個 ticket 均帶有 `wayfinder:<type>` 標籤，為 `research`、`prototype`、`grilling`、`task` 之一（請參閱 [Ticket 類型](#ticket-類型)）。

工作階段透過將 ticket 指派給主導該地圖的開發者來**認領**它，這是進行任何工作**之前**的首要動作，以便並行工作階段跳過它。該指派對象*即是*認領標記：未結且未指派的 ticket 即為未認領。

阻礙使用 tracker 的**原生**相依性關聯：這至關重要，因為它在 tracker 自身的 UI 中*以視覺化方式*呈現前沿，因此人類無需開啟地圖即可看見哪些項目可領取。只有缺乏原生阻礙的 tracker 才會退回使用內文慣例。當阻礙某 ticket 的每個 ticket 都已關閉時，該 ticket 即**解除阻礙**；**前沿**是未結、未受阻礙、未認領的子項目，即已知事物的邊緣。

答案不是內文的一部分；它在解決時記錄（請參閱[沿著地圖進行工作](#沿著地圖進行工作)）。解決 ticket 時建立的資產會從 issue 連結，而非貼在內文中。

## Ticket 類型

每個 ticket 要麼是 **HITL**（人類參與，*與*代表自己的人類共同處理），要麼是 **AFK**（由 Agent 單獨推動）。HITL ticket 僅能透過該即時交流解決；Agent 絕不能代表人類的一方（回答自己問題的盤問 Agent 已經打破了此規則）。

- **研究 (Research)** (AFK)：閱讀文件、第三方 API 或本機資源（如知識庫），以找出決策所等待的事實。由呼叫帶有 "research" 的 Skill 工具之子 Agent 解決。當需要目前工作目錄之外的知識時使用。
- **原型 (Prototype)** (HITL)：藉由呼叫帶有 "prototype" 的 Skill 工具製作廉價、粗糙、具體的工件（大綱、初步想法、虛設代碼或 UI/邏輯程式碼）以供回應，進而提高討論的保真度。將原型作為資產連結。當「它應該長什麼樣子」或「它應該如何運作」是關鍵問題時使用。
- **盤問 (Grilling)** (HITL)：對話。預設情況。一律呼叫 Skill 工具兩次，分別針對 "grilling" 和 "domain-modeling"。
- **任務 (Task)** (HITL 或 AFK)：在做出*決策*之前必須進行的手動工作：無須決策、原型製作或研究，但在完成之前討論都會受阻。註冊服務以便評估其 API、佈建存取權限、移動資料以便檢視其形狀。這是唯一一種*動手做*而非決策的類型，它透過解除決策的阻礙來取得其地位，而非透過交付目的地。Agent 盡可能單獨推動它 (AFK)；否則它會交給人類一份精確的檢查清單 (HITL)。工作完成時即解決；答案記錄完成了什麼以及後續 ticket 相依的任何衍生事實（認證位置、新 URL、資料列數）。

## 戰爭迷霧

地圖*刻意*保持不完整：不要繪製你尚無法看見的內容。在進行中的 ticket 之外存在著**戰爭迷霧**：對你預期即將到來但尚無法確定的決策和調查的模糊檢視，因為它們取決於仍未解決的問題。解決 ticket 會清除其前方的迷霧，將目前可明確說明的內容逐一晉升為新的 ticket，直到通往目的地的道路清晰且不再殘留任何 ticket 為止。

地圖的 **Not yet specified** 區段是記錄該模糊檢視的地方：存疑的問題、稍後重新審視的領域。它是*邁向*目的地的未發現前沿：這裡的一切都在範圍之內，只是尚不夠明確而無法開立 ticket。在檢視允許的範圍內盡可能自由或完整地撰寫；它同時也作為閱讀該工作進展方向的協作者的路標。

**迷霧還是 Ticket？** 檢驗標準在於你現在是否能精確陳述問題，而*非*你現在是否能回答它。

- **開立 Ticket：** 當問題已經很明確時，即使它受阻且你尚無法對其採取行動。
- **尚未明確說明：** 當你尚無法如此明確地表達它時。不要將迷霧預先切成 ticket 大小的碎片：它比 ticket 更粗略，一旦前沿到達該處，一塊迷霧可能會晉升為多個 ticket，或一個都沒有。

**Not yet specified** 不包含已決定的內容（Decisions so far）、已經是進行中的 ticket，以及超出範圍的內容（下一節）。

## 範圍之外

迷霧只會*朝向*目的地聚集。目的地固定了範圍，因此超出它的工作屬於**範圍之外**：它不是迷霧，也不屬於 **Not yet specified**。它在地圖上獲得自己的 **Out of scope** 區段：你在*本*工作中自覺排除的工作。是範圍而非明確性將其歸入此處。

超出範圍的工作絕不晉升（前沿停在目的地），因此只有在重新劃定目的地時才會重現，且屆時是作為全新工作，而非恢復進行。

將某事項判定為超出範圍是一種劃定範圍的行為，而非路線上的一步。當已經存在的 ticket 結果坐落在目的地之外時（在繪製地圖時誤納入範圍，或因某項解決方案而暴露），**關閉它**（已關閉的 ticket 明確離開前沿），並在 **Out of scope** 區段留下一行：摘要加上為什麼超出範圍，並連結已關閉的 ticket。它不進入 **Decisions so far**，後者記錄實際走過的路徑；範圍邊界並不是其上的一步。

## 呼叫

兩種模式。無論哪種方式，**每個工作階段絕不解決超過一個 ticket**，研究 ticket 除外。

### 繪製地圖

使用者帶入粗略的想法進行呼叫。

1. **命名目的地。** 呼叫 Skill 工具兩次，分別針對 "grilling" 和 "domain-modeling"，以鎖定此地圖尋找路徑的目標：規格、決策或變更。目的地固定了範圍，因此先確定它。
2. **繪製前沿地圖。** 再次進行盤問，這次採**廣度優先**：橫跨整個空間展開，而非深入任何單一執行緒，浮現未決決策和現在可採取的第一步。**如果這沒有浮現出迷霧**（通往目的地的道路已經清晰，整個旅程足夠小以容納在單一工作階段中），你不需要地圖。停止並詢問使用者希望如何進行。
3. **建立地圖**（標籤 `wayfinder:map`）：填妥 Destination 和 Notes，Decisions-so-far 留空，將迷霧勾勒至 **Not yet specified**。
4. **建立你現在能明確說明的 ticket** 作為地圖的子 issue，然後在**第二階段**連結阻礙邊（issue 在能夠互相參照之前需要識別碼）。連結會將它們分類為前沿和受阻；你尚無法明確說明的每件事都保留在迷霧中：即 **Not yet specified** 區段。
5. **啟動研究子 Agent。** 對於你剛建立的每個 `research` ticket，啟動一個呼叫帶有 "research" 的 Skill 工具之子 Agent 以並行解決它，將其調查結果擷取在拋棄式 `research/<name>` 分支上，並附帶來自 ticket 的情境指標。
6. 停止：繪製地圖是一個工作階段的工作；它不親手解決任何問題。

### 沿著地圖進行工作

使用者帶入地圖（URL 或編號）進行呼叫。Ticket 是**選用**的：若沒有指定，由你挑選下一個決策，而非使用者。

1. 載入**地圖**：低解析度檢視，而非每個 ticket 內文。
2. 選擇 ticket。若使用者指定了一個，請使用它。否則依序挑選第一個前沿 ticket。**認領它**：在進行任何工作之前將其指派給自己。
3. 解決它。**依需要縮放**：依需求擷取任何相關或已關閉 ticket 的完整內文；呼叫 `## Notes` 區塊所指名的任何技能的 Skill 工具。若有疑問，呼叫 Skill 工具兩次，分別針對 "grilling" 和 "domain-modeling"。
4. 記錄解決方案：將答案作為**解決留言**發布，**關閉** issue，並在地圖的 Decisions-so-far **附加情境指標**。
5. 新增新浮現的 ticket（先建立後連結）；晉升答案已使其明確說明的任何迷霧，從 **Not yet specified** 中清除每個晉升的區塊，使其僅作為新 ticket 存在。若答案揭示某個 ticket（此 ticket 或另一個）坐落在目的地之外，**將其判定為超出範圍**，而非在路線上解決它。若決策使地圖的其他部分無效，請更新或刪除那些 ticket。

使用者可能會平行執行未受阻礙的 ticket，因此請預期其他工作階段會同時編輯 tracker。
