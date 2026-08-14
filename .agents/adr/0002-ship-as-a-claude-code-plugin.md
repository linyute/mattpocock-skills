# 將技能套件作為原生 Claude Code 外掛程式發布；暫緩原生 Codex 外掛程式

這些技能過去一直可以透過 [skills.sh](https://skills.sh/mattpocock/skills)（`npx skills add mattpocock/skills`）進行安裝，它會跨 Claude Code、Codex 和其他 Agent-Skills 標準 Harness 將可編輯的技能檔案複製到使用者的專案中。一個反覆出現的需求是**隨插即用**的分發方式：將此套件作為您無需編輯、唯讀且始終保持最新的套件進行訂閱，而非由您擁有的分支。這正是原生外掛程式系統所提供的。

我們發布原生 **Claude Code 外掛程式**，且目前**暫緩**原生 **Codex 外掛程式**。這種分拆是由於各個生態系統的外掛程式資訊清單如何針對此儲存庫的分組版面配置選擇技能所迫使的。

## 約束條件：分組技能 vs. 單一路徑選擇

技能儲存在 `skills/` 下的分組資料夾中 — `engineering/` 和 `productivity/` 是**推廣的**（發布）；`misc/`、`personal/`、`in-progress/` 以及 `deprecated/` 則**不是**。外掛程式必須僅公開推廣的集合，該集合跨越其中兩個分組資料夾。

- **Claude Code** — `.claude-plugin/plugin.json` 接受 `skills` 作為**顯式技能目錄路徑的陣列**。我們逐一列出推廣的技能，以零模糊度排除其他所有內容，並新增 `.claude-plugin/marketplace.json` 以使該儲存庫成為其自身的單一外掛程式市集。端到端驗證：`claude plugin validate . --strict` 通過，且 `marketplace add` → `install` 解析所有推廣的技能。

- **Codex** — `.codex-plugin/plugin.json` 僅接受 `skills` 作為**單一路徑字串**（陣列會因 `missing or invalid plugin.json` 而被拒絕），且 Codex 會在其下方以遞迴方式搜尋 `SKILL.md` 檔案。無法從單一路徑命名兩個分組資料夾，或精選子集。測試並拒絕了兩個逃生口：
  - 指向 `./skills/` 也會發布 `deprecated/`、`in-progress/`、`personal/` 和 `misc/` — 即我們刻意不推廣的已停用、草稿和個人技能。
  - 精選的符號連結（**Symlinks**）扁平目錄在安裝後無法存留：Codex 會將外掛程式樹複製到其快取中並**丟棄符號連結**，導致技能抵達時為空。

為 Codex 提供僅限推廣的單一路徑的唯一穩健方法是 (a) **重構**，使 `skills/` 僅包含推廣的技能（將未推廣的分組移出 — 在 `CLAUDE.md`、`scripts/link-skills.sh`、分組 README 以及依賴 `in-progress/` 和 `personal/` 的本機開發工作流程中產生巨大的影響範圍），或 (b) **提交推廣技能的重複副本**到扁平目錄中（同步負擔和第二個單一事實來源）。這兩者都是結構性決策，而非在發布 Claude 外掛程式時要打包進去的內容。這極有可能是當初半被遺忘、未能早點發布外掛程式的原始原因：資訊清單格式無法清晰表達分組儲存庫的精選子集。

## 決策

- 現在發布 **Claude Code 外掛程式**（`.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`），精選至推廣的集合，作為標題 v1.2 的交付項目。
- 保持 **skills.sh** 作為通用安裝程式 — 它今天已經為 Codex 和其他 Harness 提供服務，因此沒有 Codex 使用者會失去安裝途徑。
- **暫緩**原生 Codex 外掛程式，直到我們在將 `skills/` 重構為僅推廣與提交產生的扁平副本之間做出決定。當 Codex 支援 `skills` 陣列 / 包含清單，或在安裝時保留符號連結時，再重新審視。

## 這所建立的不變量

- 每個推廣的技能在 `.claude-plugin/plugin.json` 的 `skills` 陣列中都有一個條目（這已經作為 `CLAUDE.md` 規則存在；它現在也把關外掛程式的內容）。
- `.claude-plugin/plugin.json` 的 `version` 會追蹤 `package.json` 的版本 — 在發布時將兩者一起升級。Claude 使用外掛程式的 `version` 來決定已安裝的使用者何時會看到更新。

## 更新，2026-08-05

`mattpocock-skills` 已被接受進入 **Claude Code 的官方市集** — 設定名稱為 `claude-plugins-official`，來源儲存庫為 `anthropics/claude-plugins-official` — 這是每個 Claude Code 安裝版預設具備的。`claude plugins install mattpocock-skills` 現在是已記錄的文件說明途徑，且上述的 `marketplace add` → `install` 途徑已被取代。安裝說明文字部位於 [.agents/install-block.md](../install-block.md)。

官方清單指向此儲存庫的 Git URL 並直接閱讀 `.claude-plugin/plugin.json`，因此它不依賴 `.claude-plugin/marketplace.json`。該檔案僅作為直接安裝儲存庫（未發布的認可或分支）的備用方案保留。

於 2026-08-05 在 Claude Code 2.1.222 上針對即時清單進行驗證：

- `claude plugins install mattpocock-skills` 解析時無需先新增市集，並報告 `mattpocock-skills@claude-plugins-official`。
- `claude plugin details mattpocock-skills` 接著報告版本 1.2.0 並載入推廣的技能。
- 清單的 `source` 為 `{"source": "url", "url": "https://github.com/mattpocock/skills.git", "sha": …}` — **SHA 被固定了**，因此當該固定移動時發布才會到達已安裝的使用者，而非在我們標記 Tag 的那一刻。在撰寫本文時，固定落在 `main` 後面的兩個認可處，這就是為什麼它列出 22 個技能而非 `plugin.json` 中的 24 個。
- 工作階段內的 `/plugin install mattpocock-skills` **未**進行操作 — `/plugin` 在 Headless（`claude -p`）工作階段中不可用。它執行與 CLI 相同的解析器，且記錄的文件範例形式為 `/plugin install <name>@claude-plugins-official`。
