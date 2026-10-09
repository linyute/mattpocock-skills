# mattpocock/skills：一套完整的端到端 AI 開發工作流程

<iframe width="560" height="315" src="https://www.youtube.com/embed/M6mYodf0dJM?si=-g8iP-uqxEuxvxST" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 前言

哈囉朋友們，我突然意識到自己從來沒有為我的 skills 儲存庫（repo）製作過一部正式的教學。在錄製這段影片時，這個 repo 已經累積了 16.2 萬顆星、擁有 750 萬次下載，但我居然從未出過教學。

我經常收到這類問題：

- 使用這些 skills 的順序是什麼？
- 該如何安裝？
- 又該如何設定？

所以這部影片將帶大家走一遍使用這些 skills 時的核心工作流程。我們不會深入探討進階或最新的功能，而是專注在讓你快速上手所需的核心流程。

為了帶大家操作，我會使用自己的一個工作專案——AI Hero CLI。這是一個驅動我課程中許多練習的命令列介面（CLI）。我之前還沒把 skills 設定給這個 repo 使用過，所以現在正好是個絕佳機會。

如果你想在全新專案中設定我的 skills，只要在一個空目錄下執行相同步驟即可。因此無論是在現有專案（brownfield）還是全新專案（greenfield）中，操作方式都完全相同。

## 一、安裝 Skills

### 執行安裝指令

打開終端機，輸入：

`npx skills@latest add mattpocock/skills`

這裡有兩個前提：

1. 電腦必須安裝 Node.js，因為 `npx` 來自 Node.js。
2. 它會執行來自 Vercel 的 `skills.sh` 命令列安裝程式，基本上就是安裝名為 `mattpocock/skills` 的 GitHub 儲存庫，接著引導你完成幾個設定問題。

### 選擇要安裝的 Skills

首先提示需要安裝相關套件，確認後它會執行一些步驟，接著列出一長串可安裝的 skills。這裡一共找到了 38 個 skills，數量相當多。上下捲動可以看到它們被分為兩組：

- **`mattpocock/skills`**：經過我驗證、認為足夠成熟可以公開發布的技能。
- **其他 skills**：我目前正在實驗、未來可能會移除的技能。

建議移動到最上方，按空白鍵選取（這裡的介面操作有點不太順暢，但往上捲動確認後即全選），接著按下 Enter，這樣就選取了所有官方 skills。我個人對 Vercel 的這個 CLI 介面不太滿意，未來可能會更換或自己發布一套，但目前就先這樣用。

### 選擇 Agent

好處是它支援將 skills 設定給任何 Agent 使用。我自己使用 Claude Code，但你可以往下捲動選擇自己需要的工具（使用空白鍵選取）。

預設情況下它支援 Cursor、Codex、Claude 等通用工具；但只要使用像 Claude Code 這類支援 Claude skills 的工具，就需要額外進行設定。按下 Enter 後，即完成 Claude Code 的 skills 配置。

### 選擇安裝範圍

接下來是「安裝範圍（Installation scope）」，決定 skills 要安裝在當前目錄還是全域（Global）。這取決於團隊的規範：

- **團隊協作**：建議選擇專案級（project），這樣大家在每個專案中都能使用相同技能集，並共同維護決策。
- **個人開發**：全域安裝即可。

我按下 Enter 安裝在使用者家目錄（Home directory），並選擇官方推薦的「symlink（符號連結）」方式。另一個選項是直接複製到 agent 與 `.claude` 資料夾，但做法較不俐落，直接選 symlink 即可。

### 確認安裝摘要

畫面隨後會顯示安裝摘要。Socket 出現了一個關於 `to-spec` 的提醒，我稍後再看；確認無誤後繼續安裝，所有 skills 便安裝完成。

### 驗證安裝結果

現在可以在這裡直接執行 Claude（或你使用的任何 Agent）。我輸入 `hello` 離開目前的 Agent 初始畫面。根據所使用的工具環境不同，呈現方式會有所差異；在 Claude Code 中，只要輸入 `/`（斜線），就可以看到剛才安裝的各種可用技能，例如 `grill-me`、`grilling`、`way-finder`、`grill-with-docs` 等等。

我的 skills 與市面上許多其他 repo 最大的不同在於：**它們大多是由使用者主動調用的（user-invoked）**。這代表當我檢視 context 時，不會有大量技能描述強行佔用上下文空間，且技能描述都十分精簡精準。即使下載了所有技能，總共也僅佔用約 660 個 tokens，對 context 的負擔極低。

## 二、專案設定：`setup-mattpocock-skills`

安裝完成後，第一步要執行 `setup-mattpocock-skills`。我的 skills 依賴專案內的一些設定，這個步驟會協助完成配置。設定過程包含三個問題。

### 1. 議題追蹤系統（Issue Tracker）

流程中會產生規格（specs）與任務（tickets），需要有地方儲存。選項非常自由，可以使用 GitHub Issues、本地 Markdown 文件，或任何工具。

Skills 會根據本地配置自動判斷，因此要整合 Jira 或 Linear，只要直接告訴 Agent 即可。許多人常問：「如何讓你的 skills 支援 Jira、Beads 或 Linear？」其實它本來就支援，只要在執行設定時說「幫我設定為 Jira」即可。不過這裡我選擇使用本地 Markdown。

### 2. 分流標籤（Triage Labels）

Skills 依賴一組標籤來傳達 tickets 的相關資訊。這裡直接採用預設值即可；想了解更多可以參考 triage skill 的文件。

### 3. 領域文件（Domain Documentation）

Skills 偏好在專案中保留少量文件（如 `context.md` 與架構決策紀錄 ADR）。這裡會詢問要使用單一 context（Single-context）還是多重 context（Multi-context）：

- **單一 context**：絕大多數情況下的選擇。
- **多重 context**：適用於大型 Monorepo 且內部有許多不同界限上下文（Bounded Contexts）的場景。

### 設定結果

設定完成後，它在專案中建立並更新了一些檔案。最主要的是在 `claude.md` 中新增了連結，分別指向 Issue Tracker 文件、Triage 標籤以及領域文件（位於 `docs/agents/domain/issue-tracker`），並設定將所有 issues 與 specs 儲存於 scratch 檔案中。至此，專案設定正式完成。

## 三、開始使用：`ask-matt`

那麼該如何開始？在開始之前，介紹一個好用的技能：`ask-matt`。這個技能本質上就是「我的數位分身」，它清楚掌握這個 repo 的所有知識以及開發步驟。因此可以直接詢問：

`ask-matt：我要如何開始？我想在這裡進行一些程式碼修改，建議的主流程是什麼？`

送出後查看回覆（附帶一提，我的語音輸入轉錄使用的是 Whisper Flow）。它清楚列出了從「想法到發布（Idea to Ship）」的核心流程。由於目前已有既有程式庫，建議從主流程頂端開始，並在**單一、未中斷的 context window** 中依序向下推進。

隨時注意 context window 的大小與消耗的 tokens，是高效運用 AI 的關鍵。

### 主流程概覽

1. **`grill-with-docs`**：透過訪談釐清並收斂想法。因為是在專案目錄下執行，它具備狀態感知能力，會將獲得的結論記錄到 `context.md` 與 ADR 中。這個步驟是將「我想修改 X」轉化為清晰、具體且有據可依的計畫。
2. **`prototype`**（選用）：如果問題需要可執行的驗證，可以使用此技能（並透過 `handoff` 銜接）；若不需要則可跳過。
3. **`implement`**：完成訪談後，可直接調用此技能開始實作。
4. **`to-spec` 與 `to-tickets`**（大型任務）：若任務規模龐大、需要跨多個工作階段（sessions），則改用這兩個技能拆解工作。

## 四、實戰示範：核心流程逐步解析

### 步驟 1：使用 `grill-with-docs` 進行訪談

`grill-with-docs` 會根據你想做的事情進行提問。例如輸入：

`grill-with-docs：我想移除這個 CLI 中大部分的內部工具（internal tooling），只保留對外公開的功能。這裡有太多多餘的程式碼，我想為 repo 瘦身。`

初始需求可以非常模糊，`grill-with-docs` 會藉由一系列追問來補齊細節。它會開始遍歷專案程式碼（這裡我使用的是 Claude Code 搭配 Opus 4.8 中等運算資源模式；這些 skills 支援不同的模型、工具與參數設定）。它快速建立了專案架構圖，並鎖定包含 11 個子指令的 internal 命名空間，拋出第一個問題。

這就是訪談（grilling）過程：持續回答問題，直到雙方達成共識。

本次訪談僅進行了約 6 個問題；規模較大的專案通常需要 20 個問題左右。最後產出了一份明確的計畫：預計刪除 10 個指令檔案、刪除 3 個測試，並重新調整共用模組的引用關係。

### 步驟 2：判斷是否需要拆解任務

這裡我使用的是 Claude Code 的 auto 模式（非 plan 模式）。此時面臨一個分水嶺：

**小型任務**：如果不需要跨多個 session，可以直接跳過 `to-spec` 與 `to-tickets`，輸入 `/implement this` 開始實作。

我個人認為大語言模型的「黃金思考區間（Smart Zone）」大約在 140k tokens 以內；超過 140k 後容易出現注意力衰退或幻覺。目前 context 還剩約 100k 的額度，要刪除 10 個指令綽綽有餘，正常情況下直接執行 `implement` 即可交由模型完成。

**大型任務**：為了示範完整流程，假設這是一項龐大、單一 session 無法負擔、需要拆分到多個 context windows 的工作。這時我們不直接執行 `implement`，而是繼續以下步驟。

### 步驟 3：使用 `to-spec` 產生規格

輸入：

`to-spec`

它的作用是將剛才所有討論（約 46.1k tokens）壓縮並淬鍊成一份正式文件，儲存至本地 Markdown（Issue Tracker）中。這份 spec 定義了本次衝刺的**最終目標狀態**，包含：

- 問題定義
- 解決方案
- 使用者故事
- 實作決策
- 測試決策

在最後階段，可用它來比對實作是否符合規格。

### 步驟 4：使用 `to-tickets` 拆解任務

產生 spec 後，在同一個 session 中接著輸入：

`to-tickets`

它會將規格進一步拆解為實作計畫。每個 ticket 的大小都應控制在單一 context window（Smart Zone）可容納的範圍內。它預設拆成了 3 個 tickets，但對於這個任務來說略顯瑣碎，因此我讓它精簡合併為單一 ticket（輸出於 `tickets.md`）。

以較大的專案為例：我日前執行的一個大型清理任務，其 spec 底下拆解了 11 個子 issues（tickets），每個 ticket 各自對應一個獨立的 session，清楚標明該 session 需要構建的內容，將龐大工程拆解成 Agent 易於消化的工作單元。

### 步驟 5：清除 context 並開始實作

回到目前專案，我們得到了一個結構清晰的 ticket。接著執行清除 context：

`clear`

清空 context 後，輸入：

`implement this @tickets`

此時 Agent 同時擁有定義目標的 spec 與指導路徑的 tickets，具備了開始實作所需的一切資訊。

手動執行時，原則上是**依序實作每個 ticket**。每完成一個 ticket，若確認 context 仍在 Smart Zone 內，可視情況繼續下一個；但通常建議在每個 ticket 之間都清空一次 context。

### 步驟 6：程式碼審查與最終規格比對

全部實作完成後，會進入程式碼審查（Code Review）與最終規格比對。本次實作僅消耗約 42.7k tokens，在 `implement` 腳本的尾聲，它自動執行了型別檢查（Type check）、建置（Build）與驗證，並載入了 `code-review` 技能。

該審查從兩個維度進行：

1. **比對原始 spec**：確保實作沒有遺漏任何規格要求。
2. **比對專案規範**：若專案無自訂規範，則預設套用 Martin Fowler 的經典規則檢查程式碼壞味道（Code Smells）。

由子 Agent（sub-agents）來執行 Review 非常關鍵。若由負責撰寫程式碼的主 Agent 自行審查，往往容易產生盲點；指派全新 context 的子 Agent 能提供更客觀、高品質的審查結果。

審查結果顯示各項驗收條件與規範均通過，並已自動提交 commit 至當前分支，整個流程圓滿完成。

## 總結

這個核心工作流程可以濃縮為：

**事前對齊想法（`grill-with-docs`） → 跨 Session 任務拆解（`to-spec` / `to-tickets`） → 執行實作（`implement`） → 自動程式碼審查（`code-review`）**

這套主流程貫穿了我所有的日常開發工作。至於未列入主流程的其他功能，大多是我正在實驗與優化的工具，目的是讓這套迭代循環更快速、更易用。

若想掌握最新釋出的 skills 與即時更新，歡迎訂閱相關電子報與頻道。感謝收看，祝開發順利！
