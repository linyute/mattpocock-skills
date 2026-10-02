技能依分桶資料夾組織於 `skills/` 底下：

- `engineering/`：每日程式碼工作
- `productivity/`：每日非程式碼工作流程工具
- `misc/`：保留但很少使用，未推廣
- `in-progress/`：測試版（beta）：刻意公開，徵求意見，未隨外掛程式發布
- `deprecated/`：不再使用

`engineering/` 或 `productivity/`（**已推廣**的分桶）中的每項技能都必須在頂層 `README.md` 中有所提及，且在 `.claude-plugin/plugin.json` 的 `skills` 陣列中有一個條目（Claude Code 外掛程式發布的內容完全對應此推廣集合）。`misc/`、`in-progress/` 與 `deprecated/` 中的技能絕不能出現在這兩者之中。

安裝指令逐字複製自 [.agents/install-block.md](./.agents/install-block.md)。`.claude-plugin/marketplace.json` 使此儲存庫成為其自身的單一外掛程式市集（安裝區塊所說明的備用方案，非正式說明的途徑）。修改任何一個資訊清單後，請執行 `claude plugin validate . --strict`。發布 Claude 外掛程式但（暫時）不發布 Codex 外掛程式的原因位於 [.agents/adr/0002-ship-as-a-claude-code-plugin.md](./.agents/adr/0002-ship-as-a-claude-code-plugin.md)。

頂層 `README.md` 中的每個技能條目都必須將技能名稱連結至其 `SKILL.md`。

每個分桶資料夾都有一個 `README.md`，以單行描述列出該分桶中的每項技能，並將技能名稱連結至其 `SKILL.md`。已推廣分桶的 `README.md` 和頂層 `README.md` 將條目分組為**使用者呼叫**與**模型呼叫**；未推廣分桶的 `README.md`（`misc/`、`in-progress/`）則使用扁平清單。

`engineering/` 與 `productivity/` 中的技能在 `docs/<bucket>/<skill-name>.md` 也有面向人員的文件頁面（文件目錄樹鏡射了 `skills/` 底下的這兩個分桶資料夾）。無論哪個分桶，發布的 URL 均為 `https://aihero.dev/skills-<skill-name>`：文件路徑僅用於儲存庫組織。當您在 `engineering/` 或 `productivity/` 中新增、重新命名或變更技能行為時，請依照 [.agents/writing-docs.md](./.agents/writing-docs.md) 建立或重新同步其文件頁面。完成的頁面包含四個章節：**它的作用**、**何時取用它**、**常見問題**以及**運作良好的徵兆**。`writing-docs.md` 包含範本、章節順序以及尋找問題的方向。未推廣分桶（`misc/`、`in-progress/`、`deprecated/`）中的技能**沒有**文件頁面。唯一的例外是直接被移除的已推廣技能：其頁面會予以保留並標註為已封存（參見 `writing-docs.md`）。

每個 `SKILL.md` 要麼是使用者呼叫（`disable-model-invocation: true` 加上 `agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`，僅人員可取用），要麼是模型呼叫（模型或人員可取用）。請參閱 [.agents/invocation.md](./.agents/invocation.md)。

[`ask-matt`](./skills/engineering/ask-matt/SKILL.md) 是對應每項人員可取用技能及其關聯的路由器。重新同步文件頁面的相同觸發條件也適用於它：每當您新增、重新命名、移除人員可取用的技能或變更其融入流程的方式時，請重新閱讀 `ask-matt` 的 `SKILL.md` 並更新它以保持地圖精確：它從未提及的新技能，或它仍然引導前往的過時技能，都是說謊的路由器。

若要將 `deprecated/` 和 `misc/` 之外的每項技能（重新）連結到本機環境技能目錄（`~/.claude/skills`、`~/.agents/skills`），請執行 `scripts/link-skills.sh`。每個條目都是指向此儲存庫的符號連結，因此 `git pull` 可保持安裝的技能最新；在新增、移除或重新命名技能後請重新執行該指令碼。

此儲存庫的任何文章敘述中（`SKILL.md` 檔案、文件、`README.md`、`CHANGELOG.md`、ADR、changeset、程式碼註解）均不得使用破折號。在句子想要使用破折號的地方，請改用逗號、冒號、句號、括號或連接詞重寫，依句子實際需要而定；絕不要進行盲目的字元替換。
