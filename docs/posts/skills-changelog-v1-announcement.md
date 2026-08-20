# v1：降低 63% 權杖消耗、/ask-matt、/writing-great-skills

[技能目錄](https://github.com/mattpocock/skills) 迎來了 v1 的重大里程碑。在累積超過 420 萬次下載與 13.5 萬顆 GitHub 星星之後，此次版本發布帶來了關鍵變更，大幅減少權杖消耗、依呼叫類型重構技能組織架構，並解鎖強大的新能力。

## 開始使用最新技能

安裝或更新至新版技能非常簡單。請使用以下指令：

```bash
npx skills add mattpocock/skills
```

![Terminal showing the interactive skill selection dialogue with Matt Pocock Skills and other categories](https://res.cloudinary.com/total-typescript/image/upload/v1781782533/ai-hero-images/kqe2yzwxhsx1gtkcqki6.png)

無論您是初次接觸這些技能，還是從早期版本進行升級，現在都是充分利用這些改進的最佳時機。

## 變更內容

### `disable-model-invocation`：降低 63% 的權杖消耗

v1 中最大的結構性變更是在各個技能中廣泛使用 `disable-model-invocation: true`。當您在技能上設定此旗標時，模型在決定要呼叫哪個技能時所檢視的上下文視窗中，將不再包含該技能的描述。

這個微小的變更為技能描述實現了 **63% 的權杖成本降低**——對於使用受限於上下文長度模型的任何人來說，這都是巨大的改進。

#### 這如何重新組織您的技能

以往，像 `/grill-with-docs` 這樣的技能包含在多個地方重複資訊的共用程式碼。現在這些程式碼已被擷取出來：

`/grilling` 技能包含了先前嵌入在其他技能中的核心訪談迴圈：

```
針對此計畫的各個層面持續不斷地對我進行訪談，
直到我們達成共同的理解為止。
```

由於 `/grilling` 技能**未**對模型停用，因此它仍然可以由 Agent 本身呼叫。這意味著您可以在其他技能之間自由共用它，而不會使它們的描述變得龐大。

`/grill-with-docs` 現在具有更簡單的 Front Matter 與內容：

```markdown
---
name: grill-with-docs
description: A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go.
disable-model-invocation: true
---

Run a `/grilling` session, using the `/domain-modeling` skill.
```

相同的原則也適用於其他重構的技能：

- **`/domain-modeling`** - 移至獨立技能中，與 `/grill-with-docs` 解耦
- **`/codebase-design`** - 擷取為具備深層模組詞彙的獨立技能
- **`/diagnosing-bugs`**（前身為 `/diagnose`）- 現在直接參照設計原則而不再重複它們

### 使用者呼叫與模型呼叫的技能

v1 引入了更清晰的分類法：**使用者呼叫（user-invoked）** 與 **模型呼叫（model-invoked）** 技能。

| 類型 | 用途 | 何時使用 |
| ----------------- | ------------------------------------------------------------- | --------------------------- |
| **使用者呼叫** | 編排工作流程；僅在您明確輸入時執行 | 您明確請求它們時 |
| **模型呼叫** | 模型可以自動選用的聚焦任務 | 模型選擇使用它們時 |

這種劃分意味著模型可以在需要時偶爾取用特定技能——診斷困難的錯誤、應用測試驅動開發，或對領域概念進行建模——而不會讓介面充斥著不必要的選項。

檢視工程讀我檔案，只有少數由模型呼叫的技能：

- `/diagnosing-bugs` - 用於複雜的除錯情境
- `/tdd` - 適用於測試驅動開發時
- `/domain-modeling` - 用於領域模型工作
- `/codebase-design` - 用於架構指引
- `/grilling` - 可重複使用的訪談迴圈

使用者呼叫的技能仍然是您編排工作的主要方式。

## 新技能與重大重寫

### 撰寫優秀技能：深度解析

其中一個備受矚目的新技能是 `/writing-great-skills`。Matt 花費了六到七個小時打造這個技能，包括一份針對每個術語條目的廣泛 `GLOSSARY.md`。

詞彙表涵蓋以下概念：

- **無操作（No-op）** - 應移除的無操作段落
- **蔓延（Sprawl）** - 不必要的擴展或重複
- **沉積物（Sediment）** - 殘留在技能中的累積冗餘
- **過早完成（Premature completion）** - 在完全理解之前過早結束
- **引導詞（Leading words）** - 已存在於模型預先訓練中的精簡概念

當您呼叫 `/writing-great-skills` 時，它會尋找重構技能並使用引導詞的機會——這些術語既有效率又為語言模型所熟悉。

光是這個技能就包含了足夠多的有用模式，很快就會有一部專屬影片來探索其完整深度。

### /ask-matt：用於導覽的路由技能

隨著使用者呼叫的技能數量增加，追蹤所有技能會產生認知負荷。新的 `/ask-matt` 技能透過充當路由器來解決這個問題——這是一個單一進入點，列出所有其他技能並說明何時使用每一項。

`/ask-matt` 記錄了：

- 如何使用目錄中的所有其他技能
- 主要工作流程以及如何進行編排
- 交接模式與交接期間的原型建構
- 如何判斷跨階段建構是否需要 PRD
- 上下文整潔度實踐
- 開始工作的不同切入點
- 透過 `/improve-codebase-architecture` 改進程式碼庫健康度

與其在 Discord 中提問或翻閱文件，技能本身就會教您如何使用完整的技能組合。這正是您一直在尋求的全面指南。

### 新增與重新命名的技能

v1 版本包含其他幾項變更：

- **`/writing-great-skills`** - 取代 `/write-a-skill`，提供更深入的參考資料
- **`/diagnosing-bugs`** - 前身為 `/diagnose`，現在具有更清晰的名稱
- **`/resolving-merge-conflicts`** - 用於 Git 合併與 Rebase 衝突的新獨立技能
- **`/codebase-design`** - 具備深層模組詞彙的新共用技能
- **`/domain-modeling`** - 用於建構專案領域模型的新共用技能
- **已移除** - `/caveman` 與 `/zoom-out` 技能已棄用

## 為何做出這些變更

這些改進體現了一個核心原則：**由使用者保持控制，而非 Agent**。模型是您編排的工具，而不是反過來。

是的，這意味著在瀏覽要使用哪個技能時，您需要承擔更多的認知負荷。但這正是 `/ask-matt` 存在的原因——無縫地引導您。

透過大幅減少權杖消耗並將使用者呼叫與模型呼叫技能分開，您解鎖了更強大的能力：設計更好的程式碼庫、修復更難的錯誤以及撰寫更好的技能——這一切都不會將上下文浪費在不必要的描述上。

---

[翻譯自 AI Hero](https://www.aihero.dev/skills/skills-changelog-v1-announcement)
