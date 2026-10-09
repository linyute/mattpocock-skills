# 我每天都在用的 5 個 Agent Skills

<iframe width="560" height="315" src="https://www.youtube.com/embed/EJyuu6zlQCg?si=lbPXsjyI_vm1ipAb" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

我當了將近十年的工程師。現在，流程比以往任何時候都更重要。

你手上有一整隊水準中等到良好的工程師，隨時可以調度。但這些工程師有一個致命缺陷：他們沒有記憶，不記得自己以前做過什麼。

這意味著你需要極為嚴格且定義明確的流程，才能讓他們完成有用的工作。身為開發者，你得不斷引導你的 agent，讓它們維持在正確的軌道上。

我的解決方式，就是建立大量的 agent skills。我設計的每一個 skill，都能幫我把自己的流程編碼化，讓 AI 每一次都有一條嚴格的路徑可以依循：

![Repository of engineer skills and processes](https://res.cloudinary.com/total-typescript/image/upload/v1773675111/ai-hero-images/pgyy6kr82bhjliy774jx.png)

結果呢？AI 所產出的程式碼品質大幅提升。


**工具組：** [grill-me](../productivity/grill-me.md) · [to-spec](../engineering/to-spec.md) · [to-tickets](../engineering/to-tickets.md) · [tdd](../engineering/tdd.md) · [improve-codebase-architecture](../engineering/improve-codebase-architecture.md) · [查看所有 skills →](https://github.com/linyute/mattpocock-skills/tree/main/skills)

## 1. `/grill-me`：充實一個想法

[閱讀指南](../productivity/grill-me.md) · [GitHub](https://github.com/linyute/mattpocock-skills/blob/main/skills/productivity/grill-me/SKILL.md)

```bash
npx skills@latest add mattpocock/skills
```

這是我最愛的 skill。它只有三句話，卻極具影響力。

**Grill Me Skill：**

> 針對這項計畫的每一個面向，不停地訪問我，直到我們達成共識。沿著設計樹的每一個分支往下走，逐一解決各項決策之間的相依關係。最後，如果某個問題可以藉由探索程式碼庫來回答，就改為去探索程式碼庫。

「設計樹」（design tree）的概念出自 Frederick P. Brooks 的《The Design of Design》。它的想法是：在設計某樣東西時，你必須走遍設計樹上的所有分支。

舉例來說，你可能正在設計一個搜尋頁面，需要在進階搜尋介面與簡單的文字方塊之間做選擇。如果選了進階搜尋，你就得搞清楚所有的篩選條件與排序方式。你要一路沿著這棵樹往下走，直到完全理解你的設計，才開始動手寫程式碼。

![Claude asking clarifying questions about a feature](https://res.cloudinary.com/total-typescript/image/upload/v1773675112/ai-hero-images/p1coswbfzivaglbxkose.png)

當我呼叫這個 skill 時，我想要與 LLM 達成共識。Claude Code 在計畫模式下，往往很早就吐出一份計畫，在我們真正彼此理解之前就先建立了文件。但 grill me skill 會強迫這場對話發生。

在一次為我的課程影片編輯器新增功能的對話中，Claude 問了我 16 個問題。而那還算是相對短的一次拷問。對於真正複雜的功能，我曾經歷過長達近半小時、包含 30、40 甚至 50 個問題的拷問。

![16 interview questions displayed in the conversation](https://res.cloudinary.com/total-typescript/image/upload/v1773675113/ai-hero-images/a0vvhui4lkubi5b2aqq9.png)

**重點心得：Skill 不必很長也能發揮巨大影響。你只需要在對的時機選用對的字詞。**

## 2. `/to-spec`：從對話到文件

[閱讀指南](../engineering/to-spec.md) · [GitHub](https://github.com/linyute/mattpocock-skills/blob/main/skills/engineering/to-spec/SKILL.md)

```bash
npx skills@latest add mattpocock/skills
```

_（這個 skill 以前叫做 `/to-prd`。工作內容相同，名稱更清楚。）_

一旦我與 LLM 達成共識，就會呼叫我的下一個 skill：`/to-spec`。

這個 skill 會請 LLM 把這份共識整理成一份規格書（spec），也就是你可能熟知的 PRD。關鍵在於，它_不會_訪問你。拷問已經完成了，所以 `/to-spec` 只會綜整對話中既有的內容。

工作流程：

- 探索儲存庫，讓規格書立基於目前程式碼的現況
- 勾勒出功能將被測試的接縫（seams），並確認它們符合你的預期
- 依範本撰寫規格書，並發佈到專案的問題追蹤系統

任何規格書中最重要的部分是使用者故事（user stories）。它們借鑑敏捷（Agile）方法論，以語言描述系統所期望的行為。

![User stories section of a spec](https://res.cloudinary.com/total-typescript/image/upload/v1773675114/ai-hero-images/mpombfwy8uz2rr1xy1yi.png)

## 3. `/to-tickets`：把終點拆解成旅程

[閱讀指南](../engineering/to-tickets.md) · [GitHub](https://github.com/linyute/mattpocock-skills/blob/main/skills/engineering/to-tickets/SKILL.md)

```bash
npx skills@latest add mattpocock/skills
```

_（前身為 `/to-issues`。）_

規格書描述的是你的目的地，但你真正需要的是抵達那裡的旅程。

這正是 `/to-tickets` skill 所做的事。它會接收一份規格書，並將其轉換成一個由各自獨立、可隨時領取的票證（ticket）所組成的看板（Kanban board）。

流程如下：

1. 收集脈絡 — 你剛剛進行的對話，或是你指定的規格書
2. 探索程式碼庫
3. **草擬垂直切片** - 將規格書拆解成票證，以便快速挖出「未知的未知」

這裡適用[曳光彈（tracer bullet）](https://www.aihero.dev/tracer-bullets)的比喻。每張票證都是一個貫穿所有整合層的薄薄垂直切片，而不是只涵蓋單一層的水平切片。

這個 skill 也會建立票證之間的阻擋關係。例如，某張票證可能不受任何票證阻擋，因此可以獨立領取。如果你有平行的 agent 設定，讓多個 agent 能同時作業，這會非常有用。

![Four GitHub issues created as vertical slices](https://res.cloudinary.com/total-typescript/image/upload/v1773675116/ai-hero-images/qaodyngpkcdpfwdvi1do.png)


<SkillsCta
	heading="還有更多精彩內容"
	subtitle="grill-with-docs、domain-modeling 與 triage 讓這套工具組更完整，另有隨演進持續更新的變更記錄。"
	cta="查看完整 skill 集"
/>

## 4. `/tdd`：提升程式碼品質

[閱讀指南](../engineering/tdd.md) · [GitHub](https://github.com/linyute/mattpocock-skills/blob/main/skills/engineering/tdd/SKILL.md)

```bash
npx skills@latest add mattpocock/skills
```

你要如何落實執行一份 skill？如何讓實作穩如磐石並提升程式碼品質？

答案是使用 TDD skill。TDD 是測試驅動開發（Test-Driven Development）的縮寫，它會強制（或者更準確地說，鼓勵）agent 遵循紅燈-綠燈-重構（red-green-refactor）的循環。

這個 skill 內容相當豐富，涵蓋了重構、模擬（mocking）以及何謂深層模組（deep modules）的理念。**確實做好 TDD，一直是改善 agent 產出最穩定的方法。**

工作流程從確認需要哪些介面變更開始。當 AI 檢視一個糟糕的程式碼庫時，它看到的是許多細小且缺乏區別的模組。但如果你將其重組為較大的模組，並在上方提供精簡的介面，AI 就能輕鬆許多地在其中穿梭。

接著這個 skill 會：

- 確認要測試哪些行為
- 為可測試性設計介面
- 一次撰寫一個測試（測試先行）
- 實作程式碼讓測試通過
- 尋找可重構的候選項目

與 agent 一起進行紅燈-綠燈-重構實在太棒了。它建立出一個持續運作直到完成的循環。

![TDD workflow diagram showing the red-green-refactor cycle](https://res.cloudinary.com/total-typescript/image/upload/v1773675117/ai-hero-images/lz08tqnibbua15wpkq2n.png)

## 5. `/improve-codebase-architecture`：讓你的程式碼對 Agent 友善

[閱讀指南](../engineering/improve-codebase-architecture.md) · [在 GitHub 上檢視](https://github.com/mattpocock/skills/tree/main/skills/engineering/improve-codebase-architecture)

```bash
npx skills@latest add mattpocock/skills
```

TDD 對你的程式碼庫要求很高。在結構不良的程式碼庫中，測試邊界並不清楚。你該在哪裡測試？在哪一層測試？

當你的程式碼庫具有清晰的模組邊界時，測試就容易得多。

`/improve-codebase-architecture` skill 會自然地探索你的程式碼庫，尋找令人困惑之處：

- 在哪些地方，理解一個概念需要在許多小檔案之間來回跳轉？
- 在哪些地方，純函式只是為了可測試性而被抽取出來，但真正的錯誤卻藏在它們被呼叫的方式中？
- 在哪些地方，緊密耦合的模組造成了整合風險？

接著它會提出可深化的候選項目 — 也就是將淺層模組深化為深層模組的機會。

![Three different interface designs presented side-by-side](https://res.cloudinary.com/total-typescript/image/upload/v1773675118/ai-hero-images/xcsyngiu3zdojvugipqz.png)

每週做一次，或是在一波密集開發之後做一次。隨著你持續精進程式碼庫，你會發現 agent 的產出品質隨之提升。

**如果你的程式碼庫是垃圾，AI 就會在這個程式碼庫裡產出垃圾。**


以上是七個中的五個。其餘的 — grill-with-docs、domain-modeling、triage — 以及更新的變更記錄，都放在 [/skills](https://github.com/linyute/mattpocock-skills/tree/main/skills)。

## 為何這很重要：把 AI 當作工程師對待

要讓 agent 產出的程式碼品質提升，最成功的方法就是把它們當作人來對待。沒錯，是有著古怪限制的人 — 沒有記憶、被複製出來後就直接開工的人。但終究還是人。

[前往 skills 儲存庫](https://github.com/mattpocock/skills)開始使用吧。

<SkillsNewsletterCta
	heading="這套工具組持續演進中"
	subtitle="Matt 一發佈新的 skill 或指南，你就能第一時間收到。"
/>

---

[翻譯自 AI Hero](https://www.aihero.dev/5-agent-skills-i-use-every-day)
