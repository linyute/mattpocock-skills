<p>
  <a href="https://www.aihero.dev/s/skills-newsletter">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skills-repo-dark_2x.png">
      <source media="(prefers-color-scheme: light)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png">
      <img alt="Skills" src="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png" width="369">
    </picture>
  </a>
</p>

# 獻給真正工程師的技能

[![skills.sh](https://skills.sh/b/mattpocock/skills)](https://skills.sh/mattpocock/skills)

我每天用來進行真正工程開發的代理技能，而不是憑感覺寫程式（vibe coding）。

開發真正的應用程式很困難。像 GSD、BMAD 與 Spec-Kit 這類方法試圖透過掌控整個流程來提供協助。但在這樣做的同時，它們剝奪了您的控制權，並使流程中的錯誤難以解決。

這些技能旨在保持精簡、易於調整且具備可組合性。它們適用於任何模型。它們建立在數十年的工程經驗之上。隨意探索並修改它們。將它們變成您自己的工具。盡情享受吧。

如果您想隨時掌握這些技能的變更，以及我建立的任何新技能，您可以與大約 60,000 名其他開發者一起加入我的電子報：

[訂閱電子報](https://www.aihero.dev/s/skills-newsletter)

## 安裝（30 秒設定）

兩種進入途徑，兩種哲學。**[Claude Code 外掛程式](https://code.claude.com/docs/en/plugins)**將整個集合安裝為受控的唯讀組合套裝，當我發布時會自動更新，因此您是訂閱而非 fork。**[skills.sh](https://skills.sh/mattpocock/skills)** 會將可編輯的技能檔案複製到您的專案中，讓您可以探索修改並將其變成自己的工具。請二擇一：同時安裝兩者會讓您擁有每項技能的重複複本。

### 1. 取得技能

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugins install mattpocock-skills
```

或從會話內部執行：

```
/plugin install mattpocock-skills
```

它位於 Claude Code 官方市集中，因此無需事先新增任何內容，且更新會自動送達。

</details>

<details>
<summary><strong>Codex 與其他代理</strong></summary>

```bash
npx skills@latest add mattpocock/skills
```

挑選您想要的技能，以及要將其安裝到哪些寫程式代理。**安裝程式允許您選擇要採用哪些技能，因此請確保包含 `setup-matt-pocock-skills`。**

原生 Codex 外掛程式已列入規劃藍圖（請參閱 [`.agents/adr/0002-ship-as-a-claude-code-plugin.md`](./.agents/adr/0002-ship-as-a-claude-code-plugin.md)）。

</details>

<details>
<summary><strong>適合喜歡動手調整的人</strong></summary>

在任何代理（包括 Claude Code）上使用相同的安裝程式：

```bash
npx skills@latest add mattpocock/skills
```

它會將技能作為您擁有且可編輯的普通檔案寫入您的儲存庫。沒有任何內容會在您不知情的情況下更新；當您需要時，使用 `npx skills update` 拉取我的最新變更。

</details>

### 2. 執行 `/setup-matt-pocock-skills`

在您的代理中，每個儲存庫執行一次。它將會：

- 詢問您想使用哪種問題追蹤器（GitHub、Linear 或本機檔案）
- 詢問您在分類工單時套用哪些標籤（`/triage` 使用標籤）
- 詢問您想將我們建立的任何文件儲存在哪裡

### 3. 搞定，您已準備就緒。

## 為什麼這些技能存在

我建立這些技能是為了修復我在 Claude Code、Codex 和其他寫程式代理中看到的常見失敗模式。

### #1：代理沒有按照我的意願執行

> "No-one knows exactly what they want"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**問題所在**。軟體開發中最常見的失敗模式就是未對齊。您以為開發者明白您的需求。接著您看到他們建構出來的東西，才發現他們完全沒有理解您。

這在 AI 時代完全一樣。您與代理之間存在溝通落差。解決方法就是進行**盤問會話（grilling session）**：讓代理針對您正在建構的內容向您提出深入詳細的問題。

**解決方案**是使用：

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md) - 用於非程式碼用途
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) - 與 [`/grill-me`](./skills/productivity/grill-me/SKILL.md) 相同，但增加了更多好處（見下文）

這些是我最受歡迎的技能。它們幫助您在開始之前與代理達成共識，並深入思考您要進行的變更。在您_每次_想要進行變更時都使用它們。

### #2：代理實在太囉嗦了

> With a ubiquitous language, conversations among developers and expressions of the code are all derived from the same domain model.
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**問題所在**：在專案開始時，開發者與為其建構軟體的人員（領域專家）通常說著不同的語言。

我在我的代理身上感受到了相同的緊張關係。代理通常被直接丟進專案中，並被要求在執行過程中自行搞懂行話。因此它們在只需要 1 個詞的地方用了 20 個詞。

對此的**解決方案**是共享語言。這是一份幫助代理理解專案中所使用行話的文件。

<details>
<summary>
範例
</summary>

這是來自我的 `course-video-manager` 儲存庫的[詞彙表](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md)範例（在該固定的提交中仍名為 `CONTEXT.md`，那是技能重新命名慣例之前的名稱）。哪一個更容易閱讀？

- **修改前**："There's a problem when a lesson inside a section of a course is made 'real' (i.e. given a spot in the file system)"
- **修改後**："There's a problem with the materialization cascade"

這種簡潔性在一個又一個會話中發揮了極大的價值。

</details>

這已內建於 [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md)。這是一場盤問會話，但能幫助您與 AI 建立共享語言，並在 ADR 中記錄難以解釋的決策。

很難用言語形容這有多強大。這可能是此儲存庫中最酷的一項技術。試試看，您就會明白。

> [!TIP]
> 共享語言除了減少囉嗦之外，還有許多其他好處：
>
> - **變數、函式與檔案名稱保持一致**，皆採用共享語言命名
> - 因此，代理**更容易在程式碼庫中導航**
> - 代理在**思考上花費的 Token 也更少**，因為它能使用更簡潔的語言

### #3：程式碼無法運作

> "Always take small, deliberate steps. The rate of feedback is your speed limit. Never take on a task that’s too big."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**問題所在**：假設您和代理在要建構的內容上達成了一致。當代理_仍然_產出糟糕的內容時會發生什麼事？

該檢視您的回饋迴圈了。如果缺乏關於產出的程式碼實際如何執行的回饋，代理就像是在盲目摸索。

**解決方案**：您需要常見的一整套回饋迴圈：靜態型別、瀏覽器存取以及自動化測試。

對於自動化測試而言，紅燈-綠燈-重構迴圈至關重要。代理會先撰寫失敗的測試，然後修復該測試。這有助於為代理提供一致水準的回饋，進而產出品質好得多的程式碼。

我建構了一個 **[`/tdd`](./skills/engineering/tdd/SKILL.md) 技能**，您可以將其插入任何專案中。它鼓勵紅燈-綠燈-重構，並為代理提供關於何謂優良測試與不良測試的充分指引。

針對偵錯，我還建構了 **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)** 技能，將最佳偵錯實踐封裝到一個有紀律的迴圈中，分階段把關。

### #4：我們建構了一團大爛泥

> "Invest in the design of the system _every day_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**問題所在**：大多數使用代理建構的應用程式都非常複雜且難以變更。因為代理可以大幅加速寫程式的速度，它們也加速了軟體的熵增。程式碼庫正以前所未有的速度變得更加複雜。

對此的**解決方案**是 AI 輔助開發的全新方法：重視程式碼的設計。

這內建在這些技能的每一層中：

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md) 在建立規格之前會詢問您正在接觸哪些模組

至關重要的是，[`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) 會審視程式碼庫以尋找深化的機會，並將候選項呈現給您。我建議每隔幾天就在您的程式碼庫上執行一次。它是一次調查，而非救援：在真正老舊的程式碼庫上，它會找到真正的候選項，但它不會替您理清混亂。

### 總結

軟體工程的基礎比以往任何時候都更加重要。這些技能是我盡最大努力將這些基礎提煉為可重複實踐的方法，以協助您交付職業生涯中最好的應用程式。盡情享受吧。

## 參考資訊

這些技能在一個維度上劃分：誰可以呼叫它們。**使用者呼叫**技能只有在您輸入時才可取用（例如 `/grill-me`）；它們的職責是統籌協調。**模型呼叫**技能可由您呼叫，_或_在任務適合時代理會自動取用；它們包含可重複使用的規範。使用者呼叫的技能可以呼叫模型呼叫的技能，但絕不能呼叫另一個使用者呼叫的技能。

### Engineering

我每天用於程式碼工作的技能。

**使用者呼叫**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**：詢問哪種技能或流程適合您的情況。此儲存庫中使用者呼叫技能的路由器。
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**：同時建構專案領域模型的盤問會話，讓術語更精準並行內更新 `GLOSSARY.md` 與 ADR。
- **[triage](./skills/engineering/triage/SKILL.md)**：透過分類角色的狀態機推進問題。
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**：掃描程式碼庫以尋找深化機會，以視覺化 HTML 報告呈現，接著深入盤問您挑選的項目。
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**：為工程技能設定此儲存庫（問題追蹤器、分類標籤、領域文件配置）。在使用其他工程技能之前，每個儲存庫執行一次。
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**：將目前的對話轉為規格並發布至問題追蹤器。無需訪談，僅綜合您已討論過的內容。
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**：將任何計劃、規格或對話拆解為一組示蹤彈（tracer-bullet）工單，各自宣告其阻礙邊界，寫入本機檔案中的文字，或作為真實追蹤器上的原生阻礙連結。
- **[implement](./skills/engineering/implement/SKILL.md)**：建構規格或工單集合中所述的工作，在預先約定的接縫處驅動 `/tdd`，並在提交前以 `/code-review` 收尾。
- **[implement-spec](./skills/engineering/implement-spec/SKILL.md)**：在單一整合分支上實作完整規格。將工單視為任務圖，在就緒的前沿執行實作者子代理以實現最大並行度，接著以 `/code-review` 收尾。
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**：將超過單個代理會話所能容納的龐大工作區塊規劃為問題追蹤器上的決策工單共享地圖，並逐一解決它們，直到通往目的地的途徑明確為止。
- **[retro](./skills/engineering/retro/SKILL.md)**：在會話結束後針對寫程式代理的環境（導航、自動化檢查、程式碼規範、引導檔案、工具）提出改進建議，依嚴重程度由高至低排列。

**模型呼叫**

- **[prototype](./skills/engineering/prototype/SKILL.md)**：建構拋棄式原型以回答設計問題，可以是回答狀態/邏輯問題的單一可共享 HTML 檔案，或是可從單一路徑切換的數種截然不同的 UI 變化。
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**：針對棘手錯誤與效能退化的有紀律診斷迴圈：建立在此錯誤上變紅的回饋迴圈 → 最小化 → 假設 → 檢測 → 修復 → 回歸測試。
- **[research](./skills/engineering/research/SKILL.md)**：針對高信任度的主要來源調查問題，並將發現記錄為儲存庫中附有引用的 Markdown 檔案，作為背景代理執行。
- **[tdd](./skills/engineering/tdd/SKILL.md)**：採用紅燈-綠燈-重構迴圈的測試驅動開發。一次一個垂直切片地建構功能或修復錯誤。
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**：主動建構並精煉專案的領域模型：對照詞彙表質疑術語，透過極端情況情境進行壓力測試，並行內更新 `GLOSSARY.md` 與 ADR。
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**：設計深層模組的共享規範與詞彙：在微小的介面背後封裝大量行為，置於乾淨的接縫處，並可透過該介面進行測試。
- **[code-review](./skills/engineering/code-review/SKILL.md)**：針對固定時間點以來的 diff 進行雙維度審查：**規範**（是否遵循儲存庫的程式碼規範，加上 Fowler 程式碼壞味道基準線？）與**規格**（是否忠實實作原始問題/規格？），作為平行子代理執行以避免相互干擾。
- **[pr](./skills/engineering/pr/SKILL.md)**：Pull Request 內文應採取的架構：將摘要作為讓變更清晰明瞭的最小視覺呈現，證明其可運作的修改前後證據，以及合併風險評估（單向門或雙向門，加上影響範圍）。
- **[wizard](./skills/engineering/wizard/SKILL.md)**：產生互動式 bash 精靈，引導人員完成只有他們才能執行的步驟：佈建基礎設施、設定憑證或 CI 秘密、瀏覽不熟悉的第三方儀表板，或執行單次遷移或切換。

### Productivity

一般工作流程工具，非程式碼專用。

**使用者呼叫**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**：針對計劃或設計接受持續深入的訪談，直到設計樹的每個分支都獲得解決。
- **[handoff](./skills/productivity/handoff/SKILL.md)**：將目前的對話精簡為交接文件，以便另一個代理可以繼續進行該工作。
- **[teach](./skills/productivity/teach/SKILL.md)**：跨多個會話向使用者教授新技能或概念，使用當前目錄作為有狀態的教學工作區。
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**：將您無法獨自回答的決策轉換為 Markdown 問卷，供唯一能回答的人填寫，可以非同步填寫，也可以在會議中一起填寫。它盤問您關於寄出的細節（受眾是誰、您需要回覆什麼），而非主題本身。
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**：在訊息無法被理解的當下觸發此技能。代理會以通俗的英語，使用您的 `GLOSSARY.md` 詞彙，配合您所缺少的背景資訊重新解釋。

**模型呼叫**

- **[grilling](./skills/productivity/grilling/SKILL.md)**：針對計劃、決策或想法對使用者進行持續深入的訪談，直到設計樹的每個分支都獲得解決。作為 `grill-me`、`grill-with-docs`、`triage`、`wayfinder` 與 `improve-codebase-architecture` 背後可重複使用的訪談基本單元。
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**：為代理撰寫文件：技能、AGENTS.md/CLAUDE.md 以及代理透過指標取用的任何文件。
