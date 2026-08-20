# 技能變更紀錄：Ubiquitous Language -> /grill-with-docs

擁有超過 4.66 萬顆星，我的 [技能儲存庫](https://github.com/mattpocock/skills) 已經成為我對工程深層思考的精華彙整。我現在正在做的是定期發布有關技能變更的最新資訊，而這些影片就像變更紀錄一樣，讓您可以掌握最新的變更動態。

這些技能旨在讓您下載到自己的環境設定中並立即開始使用。它們代表了我每天在自己的工作中所使用的方法與技術。

## 儲存庫結構變更

第一個重大變更是儲存庫結構。技能現在被組織成不同的類別：

| 類別 | 用途 |
| --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| [**生產力技能**](https://github.com/mattpocock/skills/tree/main/skills/productivity) | 適用於一般工作流程工具的技能，非特定於程式碼 |
| [**工程技能**](https://github.com/mattpocock/skills/tree/main/skills/engineering) | 主要收藏——我每天使用並建議深入學習的技能 |
| [**其他雜項技能**](https://github.com/mattpocock/skills/tree/main/skills/misc) | 偶爾使用的技能；尚不確定它們在儲存庫中的永久位置 |
| [**已棄用**](https://github.com/mattpocock/skills/tree/main/skills/deprecated) | 正在淘汰或被更新的替代方案取代的技能 |
| [**個人技能**](https://github.com/mattpocock/skills/tree/main/skills/personal) | 我個人使用的技能，分享出來供靈感參考而非核心用途 |

您現在可以放心忽略 `misc` 和 `deprecated` 資料夾。

## 重大變更與新功能

### `/ubiquitous-language` -> `/grill-with-docs`

[`/ubiquitous-language`](https://github.com/mattpocock/skills/tree/main/skills/deprecated/ubiquitous-language) 技能已被棄用，並合併到一個強大的新技能中：[`/grill-with-docs`](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs)。

**變更內容：**

- 改為建立 `context.md` 檔案，而不是建立 `ubiquitous-language.md` 檔案
- 在單一階段中結合訪談環節與文件記錄
- 支援多個界定上下文（bounded contexts），這是一種常見的領域驅動設計（DDD）模式

這意味著您可以擁有：

- 針對系統不同部分的不同上下文（例如訂單與計費）
- 每個部分都有自己的 `context.md` 和通用語言
- 不需要整套應用程式使用單一的通用語言

**[`/grill-with-docs`](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs) 對比 [`/grill-me`](https://github.com/mattpocock/skills/tree/main/skills/productivity/grill-me)：**

| 功能 | `/grill-with-docs` | `/grill-me` |
| ------------ | ------------------ | ------------------------------------------- |
| **最適合** | 程式碼庫 | 一般用途（生活、工作、創意專案） |
| **輸出** | `context.md`、ADR | 靈活的文件 |
| **位置** | Engineering 資料夾 | Productivity 資料夾 |

[`/grill-me`](https://github.com/mattpocock/skills/tree/main/skills/productivity/grill-me) 完全沒有改變，只是進行了重新組織。甚至有人用它來為母親撰寫悼詞，效果非常好。

### `/grill-with-docs` - 架構決策記錄（ADRs）

[`/grill-with-docs`](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs) 現在包含 ADR（架構決策記錄）。當以下三個條件都成立時，您應該建立 ADR：

1. 難以復原
2. 在沒有上下文的情況下令人驚訝
3. 這是真實權衡取捨的結果

您與 AI 在這些非顯而易見的決策上達成共識，可以防止 AI 重複提出相同的糟糕想法。

### `/improve-codebase-architecture` - 全新 `LANGUAGE.md`

[`/improve-codebase-architecture`](https://github.com/mattpocock/skills/tree/main/skills/engineering/improve-codebase-architecture) 獲得了重大升級，附帶了用於討論程式碼庫改進的完整語言定義。

該技能現在使用精確的術語來描述架構概念。例如：

```md
**`Module`**

任何具有介面與實作的項目。刻意與規模無關——同樣適用於函式、類別、套件或跨層切片。

**`Interface`**

呼叫者為了正確使用該模組所必須知道的一切。包括型別簽章，但也包括不變量、順序限制、錯誤模式、必要組態以及效能特性。

**`Implementation`**

模組內部的內容——其程式碼本體。與 Adapter 不同：某個事物可以是一個大型實作的小型 Adapter（Postgres 儲存庫），也可以是一個小型實作的大型 Adapter（記憶體內假資料）。
```

擁有這種通用語言可以避免冗長的對話，並讓您與 AI 在什麼是良好的程式碼庫上保持一致。

### `/setup-matt-pocock-skills` - Issue 追蹤系統的靈活性

技能現在可以與**任何** Issue 追蹤系統搭配使用，而不僅僅是 GitHub Issues。

**過去：** 像 [`/to-issues`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-issues) 這樣的工程技能是專門針對 GitHub Issues 進行調整的。

**現在：** 技能會說「將 Issue 發布到 Issue 追蹤系統」，但它是如何知道是哪一個的？

答案是一個新技能：[`/setup-matt-pocock-skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/setup-matt-pocock-skills)。

這透過建立一個 `CLAUDE.md` 檔案來建立每個儲存庫的組態結構，其中包含：

- 您的 Issue 追蹤系統位置
- 分流標籤
- 領域文件路徑

**自訂追蹤系統：** 由於這些是由 LLM 驅動的 Agent，您可以接入任何自訂 Issue 追蹤系統，甚至是未正式支援的工具。

設定流程如下所示：

```
設定 Matt Pocock 技能
→ 安裝所有工程技能
→ 挑選您想要的技能
→ 執行：matt-pocock set-up-matt-pocock-skills
```

產生的 `CLAUDE.md` 非常精簡且乾淨：

```
issues live at: github/issues at mattpocock.sandcastle
issue tracker: logged in here
```

這是漸進式揭露的——Agent 僅在需要時才取得此組態。

## 全新實驗性技能

### `/diagnose`

[`/diagnose`](https://github.com/mattpocock/skills/tree/main/skills/engineering/diagnose) 用於修復棘手的錯誤。每次進行除錯時都可以執行此技能。

**流程：**

1. 建立回饋迴圈
2. 在該迴圈中重現錯誤
3. 對錯誤提出假設（呈現排序後的假設）
4. 檢測（新增日誌以觀察行為）
5. 進行修復

**注意：** AI 目前在這些階段中跳得太快。該技能仍在持續調校中。

### `/triage`

[`/triage`](https://github.com/mattpocock/skills/tree/main/skills/engineering/triage) 用於對非您建立的 Issue 進行分流，通常是您待辦清單中的 Issue。

**使用情境：** 您的 PM 新增了關於他們想要的功能的模糊筆記；分流功能會對其進行整理。

**運作方式：** 使用具有類別角色和狀態角色的狀態機。

**類別角色：**
- `bug` - 某些功能損壞
- `enhancement` - 新功能或改進

**狀態角色：**
- `needs-triage` - 維護者需要進行評估
- `needs-info` - 等待回報者提供更多資訊
- `ready-for-agent` - 規格已完整，可供離開座位的 Agent 處理
- `ready-for-human` - 需要人工實作
- `wontfix` - 不會處理

每個經過分流的 Issue 都會獲得恰好一個類別角色和一個狀態角色。我將其用於我的開源儲存庫，效果非常好。我可以新增模糊的訊息、產生用以釐清的留言，並讓 Issue 準備好供 AI 接手。

## 取得更多更新

所有技能更新以及充分發揮 Agent 潛力的技巧都會發布在 [aihero.dev/skills](https://aihero.dev/skills)。這是一份專為技能打造的專屬電子報。

感謝一路以來的關注。希望您喜歡這些更新，就如同我享受製作它們一樣。我們很快再見！

---

[翻譯自 AI Hero](https://www.aihero.dev/skills/skills-changelog-ubiquitous-language-grill-with-docs)
