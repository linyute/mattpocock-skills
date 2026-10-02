# 將技能組作為原生 Claude Code 外掛程式發布；推遲原生 Codex 外掛程式

這些技能一直以來都可以透過 [skills.sh](https://skills.sh/mattpocock/skills)（`npx skills add mattpocock/skills`）進行安裝，該工具會將可編輯的技能檔案複製到使用者的專案中，橫跨 Claude Code、Codex 和其他 Agent-Skills 標準環境。一個常見的需求是**隨插即用**（plug-and-play）的分發方式：以唯讀、永遠保持最新的組合套裝來訂閱該集合，而不是由自己維護的 fork。這正是原生外掛程式系統所提供的功能。

我們發布原生 **Claude Code 外掛程式**，並在目前**推遲**原生 **Codex 外掛程式**。這種劃分是因為每個生態系統的外掛程式資訊清單（manifest）選擇技能的方式，與此儲存庫的分桶佈局（bucketed layout）有所衝突。

## 限制：分桶技能與單一路徑選擇

技能存放於 `skills/` 底下的分桶資料夾中：`engineering/` 與 `productivity/` 是**已推廣**（promoted，已發布）；`misc/`、`personal/`、`in-progress/` 與 `deprecated/` 則**未推廣**。外掛程式必須僅公開已推廣的集合，該集合橫跨了其中兩個分桶資料夾。

- **Claude Code**：`.claude-plugin/plugin.json` 接受 `skills` 作為**明確技能目錄路徑的陣列**。我們逐一列出已推廣的技能，毫無歧義地排除所有其他技能，並新增 `.claude-plugin/marketplace.json`，讓此儲存庫成為其自身的單一外掛程式市集。已完成端對端驗證：`claude plugin validate . --strict` 通過，且 `marketplace add` → `install` 能解析所有已推廣的技能。

- **Codex**：`.codex-plugin/plugin.json` 僅接受 `skills` 作為**單一路徑字串**（陣列會被拒絕並顯示 `missing or invalid plugin.json`），且 Codex 會遞迴探索其底下的 `SKILL.md` 檔案。無法從單一路徑指定兩個分桶資料夾，或挑選子集。我們測試並否決了兩種權宜方案：
  - 指向 `./skills/` 也會發布 `deprecated/`、`in-progress/`、`personal/` 與 `misc/`：這些是我們刻意不推廣的已廢棄、草稿及個人技能。
  - 指向各分桶之**符號連結**（symlinks）的精選扁平目錄無法在安裝後留存：Codex 會將外掛程式目錄樹複製到其快取中並**捨棄符號連結**，導致技能內容為空。

為 Codex 提供僅包含已推廣技能之單一路徑的唯一穩健方法為：(a) **重構**以使 `skills/` 僅包含已推廣技能（將未推廣的分桶移出，這在 `CLAUDE.md`、`scripts/link-skills.sh`、各分桶的 README 以及依賴 `in-progress/` 和 `personal/` 的本機開發工作流程中影響範圍甚大），或 (b) 將已推廣技能的**重複副本提交**到扁平目錄中（造成同步負擔與第二真相來源）。兩者皆為結構性決策，不應與發布 Claude 外掛程式綑綁在一起。這極可能是當初未提早發布外掛程式的最初、依稀記得的原因：資訊清單格式無法乾淨地表達分桶儲存庫的精選子集。

## 決策

- 現在發布 **Claude Code 外掛程式**（`.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`），精選為已推廣的集合，作為重點 v1.2 交付成果。
- 保留 **skills.sh** 作為通用安裝程式：它今天已經為 Codex 和其他環境提供服務，因此沒有 Codex 使用者會缺少安裝途徑。
- **推遲**原生 Codex 外掛程式，直到我們在重構 `skills/` 為僅推廣項與提交產生的扁平副本之間做出決定。待 Codex 支援 `skills` 陣列 / 包含清單，或在安裝時保留符號連結時再重新檢視。

## 此決策建立的不變性

- 每個已推廣的技能都在 `.claude-plugin/plugin.json` 的 `skills` 陣列中有一個條目（這原本就是 `CLAUDE.md` 的規則；現在它也把關了外掛程式的內容）。
- `.claude-plugin/plugin.json` 的 `version` 與 `package.json` 的版本同步：在發布時一併更新兩者。Claude 使用外掛程式的 `version` 來決定安裝的使用者何時會看到更新。

## 更新，2026-08-05

`mattpocock-skills` 已獲准加入 **Claude Code 官方市集**（設定名稱為 `claude-plugins-official`，來源儲存庫為 `anthropics/claude-plugins-official`），每個 Claude Code 安裝環境預設皆具備此市集。`claude plugins install mattpocock-skills` 現在是記錄的安裝途徑，上述的 `marketplace add` → `install` 路徑已作廢。安裝措辭位於 [.agents/install-block.md](../install-block.md)。

官方清單指向此儲存庫的 git URL 並直接讀取 `.claude-plugin/plugin.json`，因此它不依賴 `.claude-plugin/marketplace.json`。該檔案僅保留作為直接安裝儲存庫（未發布的提交，或分支）時的備用方案。

於 2026-08-05 在 Claude Code 2.1.222 上針對線上清單進行了驗證：

- `claude plugins install mattpocock-skills` 在未事先新增市集的情況下即可解析，並回報 `mattpocock-skills@claude-plugins-official`。
- `claude plugin details mattpocock-skills` 接著回報版本 1.2.0 並載入已推廣的技能。
- 清單的 `source` 為 `{"source": "url", "url": "https://github.com/mattpocock/skills.git", "sha": …}`：**sha 是固定的**（pinned），因此發布內容會在該固定 SHA 移動時送達安裝的使用者，而非在我們打標籤的當下。在撰寫本文時，固定點落後 `main` 兩個提交，這就是為什麼它列出 22 個技能而非 `plugin.json` 中的 24 個。
- 會話中的 `/plugin install mattpocock-skills` **未**執行：`/plugin` 在無前端（`claude -p`）會話中無法使用。它執行與 CLI 相同的解析器，且文件中記錄的範例格式為 `/plugin install <name>@claude-plugins-official`。
