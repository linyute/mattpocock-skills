技能被組織到 `skills/` 底下的分類桶資料夾中：

- `engineering/` — 日常程式碼工作
- `productivity/` — 日常非程式碼工作流程工具
- `misc/` — 保留但很少使用，未推廣
- `in-progress/` — 測試版：故意公開、尋求回饋，未隨外掛程式發布
- `deprecated/` — 不再使用

`engineering/` 或 `productivity/`（**推廣**的分類桶）中的每個技能都必須在頂層 `README.md` 中包含參考，並在 `.claude-plugin/plugin.json` 的 `skills` 陣列中包含一個條目（Claude Code 外掛程式發布的正是推廣的集合）。`misc/`、`in-progress/` 與 `deprecated/` 中的技能切勿出現在這兩者中。

安裝命令一字不差地複製自 [.agents/install-block.md](./.agents/install-block.md)。`.claude-plugin/marketplace.json` 使該儲存庫成為其自身的單一外掛程式市集 — 這是安裝區塊說明的後備方案，而非記載的文件途徑。在修改任一清單後執行 `claude plugin validate . --strict`。為什麼採用 Claude 外掛程式但（尚未）採用 Codex 外掛程式的原因記錄在 [.agents/adr/0002-ship-as-a-claude-code-plugin.md](./.agents/adr/0002-ship-as-a-claude-code-plugin.md)。

頂層 `README.md` 中的每個技能條目都必須將技能名稱連結至其 `SKILL.md`。

每個分類桶資料夾都有一個 `README.md`，其中列出了分類桶中的每個技能以及單行描述，技能名稱連結至其 `SKILL.md`。推廣分類桶的 `README.md` 與頂層 `README.md` 將條目分組為 **使用者呼叫** 和 **模型呼叫**；非推廣分類桶的 `README.md`（`misc/`、`in-progress/`）使用單層清單。

`engineering/` 與 `productivity/` 中的技能在 `docs/<bucket>/<skill-name>.md` 中也有一個面向人類的文件頁面（文件樹在 `skills/` 下對映這兩個分類桶資料夾）。無論分類桶為何，已發布的 URL 均為 `https://aihero.dev/skills-<skill-name>` — 文件路徑僅用於儲存庫組織。當您在 `engineering/` 或 `productivity/` 中新增、重新命名或變更技能的行為時，請遵循 [.agents/writing-docs.md](./.agents/writing-docs.md) 建立或重新同步其文件頁面。完成的頁面包含四個章節 — **它的作用**、**何時使用它**、**常見問題**、**運作正常的標誌** — 且 `writing-docs.md` 包含範本、章節順序以及尋找問題的位置。非推廣分類桶（`misc/`、`in-progress/`、`deprecated/`）中的技能**沒有**文件頁面。

每個 `SKILL.md` 要麼是使用者呼叫（`agents/openai.yaml` 中的 `disable-model-invocation: true` 加 `policy.allow_implicit_invocation: false`，僅人類可達），要麼是模型呼叫（模型或使用者均可達）。參見 [.agents/invocation.md](./.agents/invocation.md)。

[`ask-matt`](./skills/engineering/ask-matt/SKILL.md) 是路由器，它對映每個使用者可達的技能以及它們的相互關係。重新同步文件頁面的相同觸發條件也適用於它：每當您新增、重新命名、移除或變更使用者可達技能如何配合流程時，請重新閱讀 `ask-matt` 的 `SKILL.md` 並進行更新，以使地圖保持準確 — 它從未提及的新技能，或它仍然路由到的過時技能，都是說謊的路由器。

若要將每個技能（重新）連結到本機測試環境技能目錄（`~/.claude/skills`、`~/.agents/skills`），請執行 `scripts/link-skills.sh`。每個條目都是指向此儲存庫的符號連結，因此 `git pull` 可以保持已安裝技能為最新狀態；在新增、移除或重新命名技能後重新執行指令稿。
