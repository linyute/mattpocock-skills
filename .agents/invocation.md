# 模型呼叫與使用者呼叫

此儲存庫中的每個 `SKILL.md` 都是一項技能。區分它們的唯一維度是**呼叫**，也就是誰可以取用它：

- **使用者呼叫**（User-invoked）：**僅能由人員輸入其名稱**來取用。在 frontmatter 中設定 `disable-model-invocation: true`（Claude Code），並在 `agents/openai.yaml` 中設定 `policy.allow_implicit_invocation: false`（Codex）。其 `description` 是**面向人員**的：瀏覽斜線指令的人員所閱讀的單行摘要。請移除觸發清單（「當使用者說…時使用」）。
- **模型呼叫**（Model-invoked）：可由**模型或使用者**取用。預設情況：省略 `disable-model-invocation` 以及 `agents/openai.yaml` 中的 `policy` 區塊。其 `description` 是**面向模型**的，並保留豐富的觸發詞句（「當使用者想要…、提及…、要求…時使用」），以便觸發自動呼叫。判斷一項技能是否應保持模型呼叫的測試標準是：_模型能否自主且有效地取用它？_（重用是提煉技能的原因，而非測試標準。）

每個環境都以各自的方式將使用者呼叫的技能排除在模型可取用的範圍之外，因此除了人員之外，沒有任何東西可以觸發它：其他技能都無法觸發。使用者呼叫的技能可以呼叫模型呼叫的技能，但絕不能取用另一個使用者呼叫的技能。

每項技能的 `SKILL.md` 旁邊也帶有一個 `agents/openai.yaml`。它包含 Codex UI 的 Metadata：用於技能選擇器的 `interface.display_name` 和 `interface.short_description`，以及對於使用者呼叫的技能，與 `disable-model-invocation` 配對的 `policy.allow_implicit_invocation: false`。請保持兩者同步：一項技能在兩個環境中要麼都是使用者呼叫，要麼兩者都不是。

分桶的 `README.md` 和最頂層的 `README.md` 會將項目分組為**使用者呼叫**與**模型呼叫**。

## 它們之間的依賴關係

依賴關係表示為明確指示以指定的技能**呼叫 Skill 工具**（`使用 "grilling" 呼叫 Skill 工具`），而不是深層的 `../other-skill/FILE.md` 交叉引用，也不是留給模型自行解讀的單純 `/skill` 風格提及。指名工具才是觸發它的關鍵：大多數環境將技能呼叫公開為模型呼叫的工具，將其明確寫出比在內文中留下 `/name` 並希望它被視為指令具有更高的命中率。去掉前導的 `/` 也能保持環境中立：單獨的技能名稱不帶有關於它屬於哪個環境觸發語法的假設。共享的參考文件存放在擁有它們的技能內部；其他技能透過使用它呼叫 Skill 工具來取用該資料，而不是透過跨資料夾連結。

這攸關**操作性**（operative）指示：技能本身的步驟告訴代理現在去執行另一項技能。僅列出技能名稱以供人員挑選的引導敘述（`ask-matt`、分桶的 `README.md`）並沒有呼叫任何內容，因此它保留 `/skill` 風格的名稱作為純文字標籤。

Skill 工具每次呼叫僅接受一項技能。需要兩項技能的步驟是兩次呼叫，而不是一次包含兩個名稱的呼叫：請明確說明（`呼叫 Skill 工具兩次，分別針對 "grilling" 與 "domain-modeling"`），而不是「使用 X 和 Y 呼叫它」，這會被解讀為同時接受兩者的單次呼叫。

整個慣例僅在指定的技能是**模型呼叫**時才成立。使用者呼叫的技能絕對無法透過這種方式取用：根據上述不變性，沒有其他技能可以呼叫它，包括在 Skill 工具中指定其名稱。當步驟的先決條件是使用者呼叫的技能時（例如 `setup-matt-pocock-skills`），請將其表述為供人員執行的指示：「告訴使用者執行 `/setup-matt-pocock-skills`」，絕不要作為 Skill 工具呼叫。

## 被動與主動領域工作

僅為獲取詞彙而_閱讀_ `GLOSSARY.md` 只是單行的內文指引，而不是 `domain-modeling` 技能。只有主動的建構/精煉規範（質疑術語、極端情況情境、撰寫 ADR、行內更新 `GLOSSARY.md`）才是 `domain-modeling`。
