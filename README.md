<p>
  <a href="https://www.aihero.dev/s/skills-newsletter">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skills-repo-dark_2x.png">
      <source media="(prefers-color-scheme: light)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png">
      <img alt="Skills" src="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png" width="369">
    </picture>
  </a>
</p>

# 給真實工程師的技能

[![skills.sh](https://skills.sh/b/mattpocock/skills)](https://skills.sh/mattpocock/skills)

我每天用來進行真實工程開發的代理人技能 — 而非憑感覺寫程式碼。

開發真實的應用程式很困難。像 GSD、BMAD 與 Spec-Kit 這類方法試圖透過掌握流程來提供協助。但是在這樣做的同時，它們奪走了您的控制權，並使流程中的 bug 難以解決。

這些技能設計得小巧、易於調整且可組合。它們可以與任何模型搭配使用。它們建立在數十年的工程經驗之上。隨心所欲地摸索它們。讓它們成為您自己的技能。祝您使用愉快。

如果您想隨時了解這些技能的最新變更以及我建立的任何新技能，您可以與我電子報上的約 60,000 名其他開發者一同加入：

[訂閱電子報](https://www.aihero.dev/s/skills-newsletter)

## 安裝（30 秒設定）

兩種入門方式，兩種哲學。**[Claude Code 外掛程式](https://code.claude.com/docs/en/plugins)** 將整個集合安裝為受管理唯讀的套件，並在我發布時更新 — 您是在訂閱而非複製分支。**[skills.sh](https://skills.sh/mattpocock/skills)** 將可編輯的技能檔案複製到您的專案中，因此您可以修改它們並使其成為您自己的技能。選擇其中一種 — 同時安裝兩者會讓您擁有兩份每個技能。

### 1. 取得技能

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugins install mattpocock-skills
```

或者，在工作階段內部：

```
/plugin install mattpocock-skills
```

它在 Claude Code 的官方市集中，因此無需事先新增任何內容，且更新會自動到達。

</details>

<details>
<summary><strong>Codex 以及其他代理人</strong></summary>

```bash
npx skills@latest add mattpocock/skills
```

選擇您想要的技能，以及要在哪些編碼代理人上安裝它們。**安裝程式可讓您選擇要取得哪些技能 — 請確保 `setup-matt-pocock-skills` 是其中之一。**

原生 Codex 外掛程式已在路線圖中 — 參見 [`.agents/adr/0002-ship-as-a-claude-code-plugin.md`](./.agents/adr/0002-ship-as-a-claude-code-plugin.md)。

</details>

<details>
<summary><strong>適合愛摸索的人</strong></summary>

在任何代理人上使用相同的安裝程式 — 包括 Claude Code：

```bash
npx skills@latest add mattpocock/skills
```

它會將技能作為您擁有且可編輯的普通檔案寫入您的儲存庫。沒有任何內容會在您背後更新；當您需要時，使用 `npx skills update` 拉取我的最新變更。

</details>

### 2. 執行 `/setup-matt-pocock-skills`

在您的代理人中，每個儲存庫執行一次。它將：

- 詢問您想使用哪種 issue 追蹤器（GitHub、Linear 或本機檔案）
- 詢問您在 triage 時套用至 ticket 的標籤（`/triage` 使用標籤）
- 詢問您想將建立的任何文件儲存在何處

### 3. 砰 — 您準備好出發了。

## 為什麼存在這些技能

我建立這些技能是為了修復我在 Claude Code、Codex 及其他編碼代理人身上看到的常見失敗模式。

### #1：代理人沒有做我想做的事

> 「沒有人確切知道自己想要什麼」
>
> David Thomas & Andrew Hunt，[程式設計師昇華之路（The Pragmatic Programmer）](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**問題**。軟體開發中最常見的失敗模式是錯位。您以為開發人員知道您想要什麼。然後您看到他們建構的內容 — 並意識到他們根本沒有理解您。

這在 AI 時代完全相同。您與代理人之間存在溝通落差。對此的修復是**盤問工作階段** — 讓代理人向您詢問有關您正在建構的內容的詳細問題。

**修復方法**是使用：

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md) — 用於非程式碼用途
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — 與 [`/grill-me`](./skills/productivity/grill-me/SKILL.md) 相同，但新增了更多好東西（參見下方）

這些是我最受歡迎的技能。它們有助於您在開始前與代理人對齊，並深入思考您正在進行的變更。在您每次想要進行變更時使用它們。

### #2：代理人過於冗長

> 透過無處不在的語言，開發人員之間的對話與程式碼的表達都是從相同的領域模型衍生出來的。
>
> Eric Evans，[領域驅動設計（Domain-Driven-Design）](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**問題**：在專案開始時，開發人員與為其建構軟體的人（領域專家）通常使用不同的語言。

我對我的代理人也有同樣的緊張感。代理人通常被扔進專案中，並被要求在過程中邊做邊弄清楚術語。因此，他們在可以用 1 個字表達的地方使用了 20 個字。

對此的**修復方法**是共享語言。這是一份幫助代理人解碼專案中所用術語的文件。

<details>
<summary>
範例
</summary>

這是一個來自我的 `course-video-manager` 儲存庫的 [`CONTEXT.md`](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md) 範例。哪一個更容易閱讀？

- **修改前**：「當課程章節內的課堂被設為『真實』（即在檔案系統中給予一個位置）時會出現問題」
- **修改後**：「實體化串接存在問題」

這種簡潔性在一個又一個工作階段中獲得了回報。

</details>

這已內建於 [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md)。這是一個盤問工作階段，但它有助於您與 AI 建立共享語言，並在 ADR 中記錄難以解釋的決策。

很難解釋這有多強大。這可能是這個儲存庫中最酷的單一技巧。嘗試一下並親自體驗。

> [!TIP]
> 共享語言除了減少冗長之外還有許多其他好處：
>
> - **變數、函式與檔案使用共享語言進行一致的命名**
> - 結果，代理人**更容易導覽程式碼庫**
> - 代理人在**思考上花費的 Token 也更少**，因為它可以存取更簡潔的語言

### #3：程式碼無法運作

> 「始終採取小而審慎的步驟。回饋速率就是您的速度限制。切勿承擔過於龐大的任務。」
>
> David Thomas & Andrew Hunt，[程式設計師昇華之路（The Pragmatic Programmer）](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**問題**：假設您與代理人就建構內容達成了一致。當代理人*仍然*產出垃圾時會發生什麼？

是時候檢視您的回饋迴圈了。如果沒有關於其產出的程式碼實際如何執行的回饋，代理人將會是盲目運作。

**修復方法**：您需要通常的一整套回饋迴圈：靜態型別、瀏覽器存取權與自動化測試。

對於自動化測試，紅-綠-重構迴圈至關重要。這是在這裡代理人先寫一個失敗的測試，然後修復該測試。這有助於給予代理人一致水平的回饋，進而產生好得多的程式碼。

我建構了一個您可以插入任何專案的 **[`/tdd`](./skills/engineering/tdd/SKILL.md) 技能**。它鼓勵紅-綠-重構，並為代理人提供大量關於什麼是好測試與壞測試的指導。

對於除錯，我也建構了一個 **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)** 技能，將最佳除錯實踐包裝成一個嚴謹的迴圈，逐階段進行管制。

### #4：我們建構了一團泥球

> 「*每天*都投入於系統的設計。」
>
> Kent Beck，[極限程式設計解析（Extreme Programming Explained）](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> 「最優秀的模組是深層的。它們允許透過簡單的介面存取大量功能。」
>
> John Ousterhout，[軟體設計哲學（A Philosophy Of Software Design）](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**問題**：大多數用代理人建構的應用程式都非常複雜且難以變更。因為代理人可以極大地加快寫程式碼的速度，所以他們也會加速軟體熵。程式碼庫以前所未有的速度變得更加複雜。

對此的**修復方法**是一種全新的 AI 驅動開發方法：關心程式碼的設計。

這已融入這些技能的每一層：

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md) 在建立規格之前詢問您正在觸及哪些模組

最重要的是，[`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) 會勘測程式碼庫以尋找深化機會，並將候選項目移交給您。我建議每隔幾天在您的程式碼庫上執行一次。這是一次勘測，而不是救援：在真正古老的程式碼庫上，它會找到真實的候選項目，但它不會為您解開泥球。

### 總結

軟體工程基礎比以往任何時候都更加重要。這些技能是我將這些基礎濃縮為可重複實踐的最大努力，旨在幫助您交付職業生涯中最好的應用程式。祝您使用愉快。

## 參考

這些在一個軸線上劃分 — 誰可以呼叫它們。**使用者呼叫**的技能僅在您輸入它們時才可達（例如 `/grill-me`）；它們的工作是進行編排。**模型呼叫**的技能可以由您呼叫，*或者*當任務合適時由代理人自動尋求；它們持有一致且可重複的紀律。使用者呼叫的技能可以呼叫模型呼叫的技能，但切勿呼叫另一個使用者呼叫的技能。

### 工程

我每天用於程式碼工作的技能。

**使用者呼叫**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)** — 詢問哪種技能或流程適合您的情況。此儲存庫中使用者呼叫技能的路由器。
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** — 盤問工作階段，同時建構專案的領域模型，磨練術語並行內更新 `CONTEXT.md` 與 ADR。
- **[triage](./skills/engineering/triage/SKILL.md)** — 透過 triage 角色的狀態機移動 issue。
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — 掃描程式碼庫以尋找深化機會，將其展示為視覺化 HTML 報告，然後盤問您選擇的項目。
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)** — 為工程技能設定此儲存庫（issue 追蹤器、triage 標籤、領域文件配置）。在傳播使用其他工程技能之前，每個儲存庫執行一次。
- **[to-spec](./skills/engineering/to-spec/SKILL.md)** — 將目前的對話轉換為規格並將其發布到 issue 追蹤器。沒有面試 — 僅綜合您已經討論過的內容。
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)** — 將任何計畫、規格或對話分解為一組追蹤彈切片 ticket，每個 ticket 宣告其阻塞邊緣 — 在本機檔案中寫入文字，或在真實追蹤器上作為原生阻塞連結。
- **[implement](./skills/engineering/implement/SKILL.md)** — 建構由規格或一組 ticket 所描述的工作，在預先商定的接縫處驅動 `/tdd`，並在提交前以 `/code-review` 結束。
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)** — 將單一代理人工作階段無法容納的龐大工作區塊規劃為 issue 追蹤器上決策 ticket 的共享地圖 — 一次解決一個，直到通往目的地的道路清晰為止。

**模型呼叫**

- **[prototype](./skills/engineering/prototype/SKILL.md)** — 建構一次性原型以回答設計問題 — 用於狀態/邏輯問題的單一可共享 HTML 檔案，或是可從單一路線切換的多個截然不同的 UI 變體。
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)** — 針對棘手 bug 和效能退化的嚴謹診斷迴圈：建立在此 bug 上變紅的回饋迴圈 → 最小化 → 假設 → 裝備儀表 → 修復 → 退化測試。
- **[research](./skills/engineering/research/SKILL.md)** — 針對高信任度的一手來源調查問題，並將結果作為引用的 Markdown 檔案擷取在儲存庫中，作為背景代理人執行。
- **[tdd](./skills/engineering/tdd/SKILL.md)** — 具有紅-綠-重構迴圈的測試驅動開發。一次一個垂直切片建構功能或修復 bug。
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)** — 主動建構與磨練專案的領域模型 — 對照詞彙表對術語進行挑戰，透過邊界情況情境進行壓力測試，並行內更新 `CONTEXT.md` 與 ADR。
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)** — 設計深層模組的共享紀律與詞彙：在小型介面背後隱藏大量行為，放置在乾淨的接縫處，可透過該介面進行測試。
- **[code-review](./skills/engineering/code-review/SKILL.md)** — 自固定點以來對差異進行雙軸審查：**標準**（是否遵循儲存庫的程式碼標準，加上 Fowler 壞氣味基準？）與**規格**（是否忠實地實作了源頭的 issue/規格？），作為平行子代理人執行，因此兩者都不會污染另一個。
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)** — 逐區塊解決進行中的 git 合併或 rebase 衝突，透過追溯至每一方一手來源的意圖進行解決，然後完成操作 — 切勿 `--abort`。
- **[wizard](./skills/engineering/wizard/SKILL.md)** — 產生一個互動式 bash 精靈，引導人類完成只有他們才能執行的步驟：佈署基礎設施、設定憑證或 CI 金鑰、導覽不熟悉的第三方儀表板，或執行一次性轉移或過渡。

### 生產力

通用工作流程工具，非特定於程式碼。

**使用者呼叫**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — 接受關於計畫或設計的不間斷面試，直到設計樹的每個分支都被解決。
- **[handoff](./skills/productivity/handoff/SKILL.md)** — 將目前的對話精簡為交接文件，以便另一個代理人可以繼續工作。
- **[teach](./skills/productivity/teach/SKILL.md)** — 在多個工作階段中教導使用者新技能或概念，使用目前目錄作為具狀態的教學工作區。
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)** — 將您無法單獨回答的決策轉化為 Markdown 問卷，給唯一可以回答的人 — 非同步填寫，或在會議中一起解決。它就傳送對象（給誰、您需要收回什麼）盤問您，而非就主題盤問。
- **[wait-what](./skills/productivity/wait-what/SKILL.md)** — 在訊息未傳達到位時立即觸發此功能。代理人以您缺失的上下文，以簡明英語，使用您的 `CONTEXT.md` 詞彙重新推銷它。

**模型呼叫**

- **[grilling](./skills/productivity/grilling/SKILL.md)** — 就計畫、決策或想法對使用者進行不間斷的面試，直到設計樹的每個分支都得到解決。`grill-me`、`grill-with-docs`、`triage`、`wayfinder` 與 `improve-codebase-architecture` 背後可重複使用的面試原語。
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)** — 為代理人撰寫文件：技能、AGENTS.md/CLAUDE.md，以及代理人透過指標到達的任何文件。
