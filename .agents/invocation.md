# 模型呼叫 vs 使用者呼叫

此儲存庫中的每個 `SKILL.md` 都是一個技能。將它們劃分的一個維度是**呼叫** — 誰可以存取它：

- **使用者呼叫** — **僅能由親自輸入其名稱的人類**存取。在 Frontmatter 中設定 `disable-model-invocation: true` (Claude Code)，並在 `agents/openai.yaml` 中設定 `policy.allow_implicit_invocation: false` (Codex)。其 `description` 是**面向人類的**：由瀏覽斜線命令的人所閱讀的單行摘要。請去除觸發條件清單（「當使用者說出…時使用」）。
- **模型呼叫** — 可由**模型或使用者**存取。預設情況：省略 `disable-model-invocation` 以及 `agents/openai.yaml` 中的 `policy` 區塊。其 `description` 是**面向模型的**，並保留豐富的觸發詞彙表達（「當使用者想要…、提及…、請求…時使用」），以便觸發自動呼叫。測試一個技能是否應該保持為模型呼叫的標準是：_模型是否能自主且有效地存取此技能？_（重複使用是擷取出技能的原因，而非測試標準。）

每個 Harness 都會以其自身的方式將使用者呼叫的技能排除在模型的存取範圍之外，因此除了人類之外沒有其他事物可以觸發它 — 沒有其他技能可以觸發。使用者呼叫的技能可以呼叫模型呼叫的技能，但絕不能存取另一個使用者呼叫的技能。

每個技能在其 `SKILL.md` 旁也帶有一個 `agents/openai.yaml`。它持有 Codex UI 中繼資料 — 適用於技能選擇器的 `interface.display_name` 和 `interface.short_description` — 以及針對使用者呼叫技能的 `policy.allow_implicit_invocation: false`（與 `disable-model-invocation` 配對）。請保持兩者同步：一個技能在兩個 Harness 中要麼都是使用者呼叫，要麼都不是。

分類 `README.md` 和最上層的 `README.md` 將條目分組為**使用者呼叫**和**模型呼叫**。

## 它們之間的相依性

相依性應以明確指示來表達：使用指定的技能**呼叫 Skill 工具**（`Call the Skill tool with "grilling"`），而不是使用深層的 `../other-skill/FILE.md` 交叉參照，也不是留下讓模型自行解讀的單獨 `/skill` 式提及。指名該工具才能觸發它：大多數 Harness 都會將技能呼叫公開為模型可呼叫的工具，而明確寫出這一點，比在文字中放入 `/name` 並希望它被解讀為命令，有更高的命中率。省略開頭的 `/` 也能讓這項慣例保持與 Harness 無關，而不是相反——單獨的技能名稱不會預設它所屬的是哪個 Harness 的觸發語法。共用的參考文件應放在擁有它們的技能內；其他技能應透過使用該技能呼叫 Skill 工具來取得這些內容，而不是跨資料夾建立連結。

這裡指的是**操作性**指示——技能自身的步驟要求代理程式立即執行另一個技能。僅為了讓人類選擇而列出技能名稱的路由文字（`ask-matt`、各分類的 `README.md`）並不是在進行呼叫，因此仍將 `/skill` 式名稱保留為純粹的標籤。

Skill 工具每次呼叫只接受一個技能。需要兩個技能的步驟應進行兩次呼叫，而不是在一次呼叫中傳入兩個名稱——請明確寫出這一點（`Call the Skill tool twice, for "grilling" and "domain-modeling"`），不要寫成「以 X 和 Y 呼叫它」，因為那會被理解為單次呼叫同時接受兩者。

這套慣例僅適用於指定的技能是**模型呼叫**的情況。使用者呼叫的技能永遠無法透過這種方式觸達，沒有例外——依據上述不變條件，任何其他技能都不能呼叫它，包括將其名稱提供給 Skill 工具。當某個步驟的前置條件是使用者呼叫的技能（例如 `setup-matt-pocock-skills`）時，應將其表述為供人類採取行動的指示——「告訴使用者執行 `/setup-matt-pocock-skills`」——絕不要表述為 Skill 工具呼叫。

## 被動 vs 主動領域工作

僅僅為了詞彙而_閱讀_ `CONTEXT.md` 只是單行的散文指標，而非 `domain-modeling` 技能。只有主動建構/精煉規範（挑戰術語、邊角案例情境、撰寫 ADR、內聯更新 `CONTEXT.md`）才是 `domain-modeling`。
