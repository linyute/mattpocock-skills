# v1.3：/implement-spec、/pr、/retro 與 GLOSSARY.md

<iframe width="560" height="315" src="https://www.youtube.com/embed/BsJGo1wFTvQ?si=qajy8A9R4WxQBboP" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

我的技能組合 1.3 版發布了。寫程式碼變便宜了，閱讀程式碼卻沒有。因此這次發布的重點是圍繞程式碼的一切：三個技能從 `in-progress/` 畢業，進入 **Engineering** 分類；一個技能被刪除；還有一個檔案重新命名，需要你採取行動。

完整的異動內容請見 [v1.3.1 release](https://github.com/mattpocock/skills/releases/tag/v1.3.1)。本頁說明的是這對你而言有什麼改變。

## 如何更新

如果你是用 `/plugin install` 安裝的，更新會自動下載。否則：

```bash
npx skills update
```

接著檢查你的 skills 資料夾。如果 `resolving-merge-conflicts` 還在，就把它刪除。先前的更新並不會一律移除已刪除的技能。

## 重大變更：`CONTEXT.md` → `GLOSSARY.md`

技能讀寫領域文件（domain doc）的慣例名稱，在所有地方都重新命名了：`CONTEXT.md` 現在改為 `GLOSSARY.md`，`CONTEXT-MAP.md` 現在改為 `GLOSSARY-MAP.md`。這些技能只會尋找新的檔名。如果 `/grill-with-docs` 或 `/domain-modeling` 曾經為你建立過這個檔案，請將它移動：

```bash
git mv CONTEXT.md GLOSSARY.md
git mv CONTEXT-MAP.md GLOSSARY-MAP.md
```

在團隊中，請在一次 commit 中完成這件事，讓每個人都一併拉取。如果有人在檔案移動之前就先更新了技能，他們的代理人（agent）會在舊檔案旁邊建立一個全新、空白的 `GLOSSARY.md`。

舊名稱來自 DDD 的 **bounded context（限界上下文）**。我實質上仍然在做 DDD，只是不這麼稱呼它，但 `CONTEXT.md` 這個名稱太模糊了。它無法讓代理人在正確的時機拉入這個檔案，也讓人感到困惑。隨著時間過去，這個檔案也逐漸縮減，最後只剩下一份詞彙表。所以現在這個名稱如實反映了它的內容。行為沒有任何改變，只是檔名變了。

受影響的技能有：`domain-modeling`、`grill-with-docs`、`improve-codebase-architecture`、`setup-matt-pocock-skills`、`triage`、`tdd`、`diagnosing-bugs`、`ask-matt`、`codebase-design`、`wait-what` 以及 `pr`。

## 主循環

主流程的前半段沒有改變：`/grill-with-docs` → `/to-spec` → `/to-tickets`。這段流程會產出一份 **spec（規格）** 和一組 **tickets（工單）**。三個新技能則是後半段：

- **`/implement-spec`** 接收規格與工單，並把所有內容都實作完成。
- **`/pr`** 接收實作結果，撰寫一份人類能快速審閱的 PR 說明。
- **`/retro`** 回顧這次工作階段（session），並對儲存庫做出修改，讓下一次執行更好。

## 新增：`/implement-spec`

`/implement` 仍然存在。它一次只處理一張工單，而你是調度者（dispatcher）。`/implement-spec`（使用者呼叫）則是在一次執行中、在一條 **整合分支（integration branch）** 上，建構整份規格：這是一條分支，每張工單的工作都會逐一併入其中，然後才會接近 main 分支。

處理一組工單有三種做法：

1. **手動循環。** 你說「實作第一張工單」，等待，清空情境（context），再說「實作第二張工單」。你自己就是那個 for 迴圈。這一點也不好玩。
2. **確定性循環。** 由一支腳本讀取每張工單，並對它執行 `/implement`。這是我推薦大多數人採用的方式。它每次執行的方式都一樣，可靠又便宜，但需要耐心去設定與調校。[Sandcastle](https://github.com/mattpocock/sandcastle) 就是其中一個範例。
3. **代理人循環。** 由代理人（agent）代替人類來盯著整個流程。這就是 `/implement-spec`。

代理人循環比確定性循環更差。但在你的軟體工廠尚未調校好之前，它是開始進行「離開電腦（AFK）」工作的好方法，而且我使用它的頻率遠超過我原本的預期。之所以現在可行，是因為子代理人（subagent）現在可以衍生出自己的子代理人。

工單並不是一份步驟清單，而是 **一張帶有阻擋關係（blocking relationships）的工作圖（task graph）**，而這些關係是由 `/to-tickets` 寫入的。因此永遠存在一個 **前緣（frontier）**：也就是目前沒有任何東西阻擋的那些工單。整個執行流程如下：

1. 讀取規格與工單，並在自己的子代理人中探索程式碼庫。
2. 建立整合分支。
3. 為前緣上的每一張工單啟動一個實作者子代理人，各自在獨立的 worktree 中運作。每一個都會用 `/tdd` 來建構自己的工單。
4. 一個合併者子代理人會將每張完成的工單併入整合分支。前緣隨之推進，新的工單也會分配到實作者。
5. 當整張工作圖完成後，它會對整條整合分支呼叫 `/code-review`，並啟動一個修復者（fixer）。

目標是整合分支，而不是一個 PR。只有在你的議題追蹤系統（issue tracker）透過 PR 來結案，或你主動要求時，才會開啟一個草稿 PR。

有兩個尚未打磨的地方。結果是 **一條巨大的分支**，目前還沒有好的解法。你可以使用堆疊式 PR（stacked PR），但我不想讓這件事變得只限於 GitHub。而 worktree 並不能消除衝突，只是把衝突推遲到合併時發生：兩張工單可能會以兩個不同的名稱新增同一個欄位。

把它當作一個「如何實作一份規格」的基礎版本，並在它之上建構屬於你自己的版本。

## 新增：`/pr`

對於要併入 main 分支的工作而言，PR 仍然是最大的瓶頸。`/pr`（模型呼叫）的目的，是讓人類的審閱盡可能又快又簡單。它所做的，就是給代理人一個 PR 說明的範本，分成三個段落。

**Summary（摘要）** 是一張圖，而不是一段文字：用最小的視覺化方式，把這次變更講清楚。可以是虛擬碼（pseudocode）、呼叫樹（call tree）、檔案樹、Mermaid 圖，或是一張 diff 示意圖。這些視覺化手法來自 Dex Horthy 的 `show-me` 技能，該技能已在自己的 `CREDITS.md` 中致謝。

**Evidence（證據）** 是一組 **之前** 與 **之後** 的對照：一個原本失敗、現在通過的測試。如果不要求提供確切的證據，代理人很容易只說「這應該可以運作，我讀過程式碼了」。當你要求提供證據時，代理人通常會多跑一個測試，或多截一張畫面。證據就是你學會信任代理人輸出結果的方式。

**Merge Danger（合併風險）** 回答兩個問題：

- **單向門還是雙向門？** 雙向門是一個你可以走回頭路的變更：還原（revert）這個 commit，你就回到原點。單向門則會在真實世界中造成影響。一次資料庫遷移（migration）會刪除一個欄位。一次回滾（rollback）並不能把已經寄出的一批電子郵件收回。
- **影響範圍（blast radius）。** 如果出了問題，會造成多大的損害？是一個按鈕，還是你函式庫的每一個使用者。

Merge Danger 告訴你應該把審閱時間花在哪裡。一個影響範圍小的雙向門：快速瀏覽過去就好。一個單向門：要慢慢仔細讀。要讓代理人能做出好的判斷，請提供規格給它，而不只是 diff。

[v1.3 release PR](https://github.com/mattpocock/skills/pull/1120) 就是用這個技能寫成的。

這是我所見過最可靠的模型呼叫技能之一。在 Opus 5.5 上，每次代理人撰寫 PR 說明時它都會載入，你完全不需要特別去想它。如果你已經有自己的 PR 說明技能，歡迎從這個技能中擷取你喜歡的部分。

## 新增：`/retro`

我的技能組合對你的要求很多。長久以來，一直是你自己要負責改善儲存庫：讓 `AGENTS.md` 保持精簡、讓技能保持犀利、加入良好的 lint 規則、讓程式碼容易導覽。我在自己的儲存庫上一直是手動做這些事，所以我把它整理成一個技能。

`/retro`（使用者呼叫）是 retrospective（回顧）的縮寫。對一次編碼工作階段（session）執行它，無論是目前這一次還是較早之前的，它都會針對代理人的 **環境（environment）** 提出變更建議，而不是針對程式碼本身。它會讀取真實的工作階段紀錄，因此能看到代理人向你隱瞞的問題。代理人抱怨的程度，遠不及它原本應該抱怨的程度。它會硬著頭皮繼續做下去，功能最終還是被做出來了。

它會檢視七個面向：

- 這個程式碼庫有多容易導覽？
- 這個問題能不能用一個 **自動化檢查（automated check）** 來攔截？
- 是否有一條 **編碼標準（coding standard）**，可以讓審閱者來強制執行？
- 全域的 `AGENTS.md` 健康狀況如何？
- 工具使用的經濟性是否良好，還是某個工具正在浪費 token？
- 指示與引導檔案中是否存在 **沒有效果的規則（no-ops）**？（「撰寫乾淨、可讀的程式碼」這句話什麼都沒改變，刪掉它。）
- 代理人是否擁有它所需要的全部資訊？

最重要的兩點是檢查與標準。一個 **機械式（mechanical）** 的違規，一律改用確定性的檢查來處理：自訂的 lint 規則、pre-commit hook，或是一個 CI 工作。`CODING_STANDARDS.md` 則只保留給 **判斷性（judgement call）** 的事項。一項檢查可能會失敗。但 Markdown 檔案裡的一句話不會失敗。一個完全沒有任何防護機制的儲存庫，本身就是一項發現。

所以這個循環是：找出一個錯誤，執行 `/retro`，然後讓這個錯誤下次不可能再發生。你的 `AGENTS.md` 會隨著時間變得更短，而不是更長。

`/retro` 是人在迴圈中（human-in-the-loop）的設計。在你從它的清單中挑選之前（清單依嚴重程度由高到低排序），它不會改動任何東西。請用你自己的判斷：有些發現對你來說並不重要。大多數人都會問我該如何將它自動化。別這麼做。自動化的 retro 會找出偽陽性（false positives），不斷去修正它們，最終把你的儲存庫帶往不該去的方向。取而代之的做法是，在你有空的時候，對一批工作階段樣本執行它，或是在代理人做出奇怪行為的那次工作階段上執行它。

`/ask-matt` 現在把 `/retro` 放在主流程的最後一步，緊接在 `/code-review` 之後。它也會在 `/diagnosing-bugs` 之後，引導你前往 `/retro`，詢問什麼樣的做法原本可以避免這個錯誤發生。

## 移除：`/resolving-merge-conflicts`

合併衝突的解決是一個執行環境（harness）層面的事，而不是技能層面的事。沒有人可以選擇不處理它，而代理人本來就能夠在不需要專屬技能的情況下，處理進行中的合併或 rebase 衝突。沒有任何東西取代它。它會從 Claude Code 外掛、README 以及 `/ask-matt` 中移除。

如果你使用的是能力較弱的模型，可能仍然會想要用它。[已封存的文件頁面](https://aihero.dev/skills-resolving-merge-conflicts) 仍然存在。你可以把這個技能複製到你的儲存庫中。

## 變更：技能改為呼叫 Skill 工具

當一個技能要使用另一個技能時，現在會寫成「呼叫 Skill 工具，使用 "grilling"」，而不是「執行 `/grilling` 技能」。在文字敘述中提到另一個技能的名稱，並不能可靠地載入它。這正是 `/grill-with-docs` 最常被回報的問題的成因。這種新的寫法同時也與執行環境（harness）無關，因為它不假設一定存在 Claude Code 的 `/` 語法。

一個技能無法呼叫使用者呼叫型的技能。因此，當某個技能需要用到 `/setup-matt-pocock-skills` 時，現在會改為告訴你自己去執行它。

## 變更：較小的項目

- **六個技能可以再次安裝了。** `to-spec`、`code-review`、`setup-matt-pocock-skills`、`writing-fragments`、`writing-shape` 與 `wait-what` 的 `description` 欄位中有一個未加引號的冒號，導致 YAML 格式無效，使得 `npx skills` 略過了它們。現已修正。
- **不再使用破折號（em-dash）。** 儲存庫中每一個破折號都已手動重寫。
- **`/grilling`** 會在一輪問題之間加上一條水平分隔線。
- **`/domain-modeling`** 會在你討論程式碼庫術語，或編輯 `GLOSSARY.md` 或 ADR 時觸發。
- **`/diagnosing-bugs`** 不再於最後交接給 `/improve-codebase-architecture`。這個步驟很少真正被觸發。第 6 階段現在只做清理工作。
- **`/wait-what`** 會在有多個情境（context）的儲存庫中，依循 `GLOSSARY-MAP.md` 找到正確的 `GLOSSARY.md`。

---

[翻譯自 AI Hero](https://www.aihero.dev/skills/skills-changelog-v13-implement-spec-pr-retro-and-glossary-md)
