# 模型呼叫 vs 使用者呼叫

此儲存庫中的每個 `SKILL.md` 都是一個技能。將它們劃分的一個維度是**呼叫** — 誰可以存取它：

- **使用者呼叫** — **僅能由親自輸入其名稱的人類**存取。在 Frontmatter 中設定 `disable-model-invocation: true` (Claude Code)，並在 `agents/openai.yaml` 中設定 `policy.allow_implicit_invocation: false` (Codex)。其 `description` 是**面向人類的**：由瀏覽斜線命令的人所閱讀的單行摘要。請去除觸發條件清單（「當使用者說出…時使用」）。
- **模型呼叫** — 可由**模型或使用者**存取。預設情況：省略 `disable-model-invocation` 以及 `agents/openai.yaml` 中的 `policy` 區塊。其 `description` 是**面向模型的**，並保留豐富的觸發詞彙表達（「當使用者想要…、提及…、請求…時使用」），以便觸發自動呼叫。測試一個技能是否應該保持為模型呼叫的標準是：_模型是否能自主且有效地存取此技能？_（重複使用是擷取出技能的原因，而非測試標準。）

每個 Harness 都會以其自身的方式將使用者呼叫的技能排除在模型的存取範圍之外，因此除了人類之外沒有其他事物可以觸發它 — 沒有其他技能可以觸發。使用者呼叫的技能可以呼叫模型呼叫的技能，但絕不能存取另一個使用者呼叫的技能。

每個技能在其 `SKILL.md` 旁也帶有一個 `agents/openai.yaml`。它持有 Codex UI 中繼資料 — 適用於技能選擇器的 `interface.display_name` 和 `interface.short_description` — 以及針對使用者呼叫技能的 `policy.allow_implicit_invocation: false`（與 `disable-model-invocation` 配對）。請保持兩者同步：一個技能在兩個 Harness 中要麼都是使用者呼叫，要麼都不是。

分類 `README.md` 和最上層的 `README.md` 將條目分組為**使用者呼叫**和**模型呼叫**。

## 它們之間的相依性

相依性表達為 **`/skill` 風格的散文呼叫**（「執行 `/grilling` 技能」），而非深層的 `../other-skill/FILE.md` 交叉參考。共享參考文件位於擁有它們的技能內部；其他技能透過呼叫該技能來存取該資料，而非透過跨資料夾連結。

## 被動 vs 主動領域工作

僅僅為了詞彙而_閱讀_ `CONTEXT.md` 只是單行的散文指標，而非 `domain-modeling` 技能。只有主動建構/精煉規範（挑戰術語、邊角案例情境、撰寫 ADR、內聯更新 `CONTEXT.md`）才是 `domain-modeling`。
