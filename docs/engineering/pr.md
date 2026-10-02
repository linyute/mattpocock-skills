## 功能說明

`pr` 規範了 pull request 內文應具備的架構形態：展示變更的**摘要（Summary）**、證明其運作正常的**證據（Evidence）**、以及評估合併風險程度的**合併危險度（Merge Danger）**。它是一份格式參考指南，而非工作流程。它不會推送分支、建立 PR 或決定納入哪些內容；它是在 [agent](https://www.aihero.dev/ai-coding-dictionary/agent) 撰寫 PR 內文時，指導其應具備的外觀形式。

摘要是一張圖，而非一段文字。預設的 PR 內文通常以散文敘述 diff，而本技能則挑選能闡明重點的**最小檢視表**（虛擬碼、呼叫樹、元件樹、檔案樹、Mermaid 圖表或定型 diff），並將其周圍的文字保持精簡。審查者本來就會開啟 diff；PR 內文的職責是在他們閱讀 diff 之前，先向他們展示其結構形態。

## 何時使用

輸入 `/pr`，或者每當 agent 撰寫 PR 內文時，它會自動取用該技能。

| 你的情境 | 建議使用的技能 |
| --- | --- |
| 分支已就緒，需要一份審查者能快速掃描的內文 | `pr` |
| 程式碼已寫好但尚未有人進行審查 | 先使用 [code-review](https://aihero.dev/skills-code-review)，再使用 `pr` |
| PR 已建立且審查意見陸續回覆 | 本集合中目前尚無對應技能；`pr` 僅負責撰寫內文 |

## 內文範本

包含以下三個章節，依序排列：

- **Summary**：一或多個小型視覺圖，每個皆置於其所支援的精簡文字旁。使用一個，有時使用數個，極少全部使用。僅保留審查者所需的呼叫、檔案、props 與邊界。
- **Evidence**：修改前後對照。當變更屬於視覺層面且[環境](https://www.aihero.dev/ai-coding-dictionary/environment)支援擷取時，螢幕截圖是最強力的證據；否則應提供先前失敗而現在通過的具體測試（以虛擬碼撰寫），或是變更後的 console 輸出。
- **Merge Danger**：指出該變更是**單向門（one-way door）**還是**雙向門（two-way door）**，及其**爆炸半徑（blast radius）**。雙向門的回退成本很低；單向門（具破壞性的遷移、公開 API 的移除、難以逆轉的決策）則不然。爆炸半徑指明變更若出錯可能破壞的事物：版面位移、API 的取用端、行動裝置回應能力。

門的判定是主導核心。它將「合併是否安全？」從直覺感受轉變為審查者可以表示異議的明確主張，並指導審查者如何分配其[人工審查（human review）](https://www.aihero.dev/ai-coding-dictionary/human-review)心力：爆炸半徑小的雙向門可以快速瀏覽；單向門則值得仔細審讀。

## 常見問題

**我可以信任 agent 自己的門判定嗎？**

不能盲目信任，而這正是要求明確陳述的原因。撰寫該變更的 agent 同時也是對其評分的人，而自我報告在寫出「雙向門、爆炸半徑小」時最令人放心。可逆性在 diff 中也往往難以察覺：正如一位使用者所言，「rollback 一個 commit 並不能收回已寄出的一批電子郵件」，且功能開關推播僅在第一次寫入新格式之前維持雙向性。該技能賦予 agent 一項定義（破壞性操作與難以逆轉的決策屬於單向門），而非檢查清單，因此請務必嚴格審視 Merge Danger 這一行。有兩件事能提供幫助：確保 agent 眼前擁有 [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) 或 [spec](https://www.aihero.dev/ai-coding-dictionary/spec)，而不僅僅是 diff；並且將你的儲存庫一律視為單向門的變更（schema 遷移、對外發布或刪除的任何內容）寫在 agent 做出判斷前能讀取到的位置。

**它會幫我建立 PR 嗎？**

不會。`pr` 僅負責內文。[implement](https://aihero.dev/skills-implement) 以 commit 到當前分支結束，而要求提供建立 PR 的技能或選項（例如 `/to-pr`，或讓 `implement` 建立 PR 而非 commit）仍屬於開放提議；某位使用者的因應方案是對 `implement` 加入單行本機覆寫指示，要求其建立 PR。[implement-spec](https://aihero.dev/skills-implement-spec) 是例外：當你的 issue tracker 透過 PR 關閉工作或你主動要求時，它會開啟草稿 PR。由於 `pr` 是由模型呼叫的，因此每當你要求 agent 建立 PR 時，其說明都會採用這種形態。

**這難道不會只是產生另一堵文字與圖表牆嗎？**

這正是其設計所要防止的失敗模式，但仍有可能發生。使用者對 agent 撰寫的 PR 內文抱怨始終如一：「摘要很長，但我需要的只是知道變更了什麼、如何驗證、可能破壞什麼、以及合併是否安全。」該技能指示 agent 略過前言、文字保持精簡，並選取最小檢視表，通常是一個視覺圖且極少包含全部。若你仍收到堆疊的圖表，表示 agent 忽略了該指示；若內文龐大是因為 diff 本身龐大，那問題出在 PR 的規模，`pr` 不會替你拆分 PR。

**我的儲存庫已經有 PR 範本。哪一個優先？**

預設情況下兩者皆不優先：`pr` 自帶範本，且不會尋找 `.github/pull_request_template.md` 或類似檔案。若干使用者要求本技能遵循儲存庫的範本，若放任不管，agent 會針對同一份文件持有兩份互相競爭的指示。請在儲存庫的 agent 文件中予以規範，例如填寫儲存庫範本並在其下方加入 Summary、Evidence 與 Merge Danger。

**輸出是 HTML 嗎？為什麼 Mermaid 圖表沒有渲染？**

輸出是 markdown 格式的 PR 內文，而非 HTML 網頁。GitHub 與 GitLab 會在 PR 說明中渲染 Mermaid 區塊，但終端機不會，因此當 agent 在本機向你展示時，圖表看起來就像原始文字。使用 CLI harness 的使用者透過 ASCII Mermaid 渲染器或讓 agent 在 PR 附加 HTML 版本來因應。Mermaid 僅是六種檢視表之一；呼叫樹、檔案樹或定型 diff 在任何地方讀起來都一樣。

**它可以分類整理收到的審查意見嗎？**

不能。它寫完內文後即停止。分流其他開發者或審查機器人的評論（哪些值得處理、哪些不是問題）曾被多次提出要求，但這並非本技能的職責。

**當 PR 變動時，它會保持內文最新狀態嗎？**

不會。它是在某個時間點撰寫內文，若 PR 在審查期間發生變動，該內文就會過期。在實質變更後，請要求 agent 重寫內文；因為它是在重新撰寫 PR 內文，所以適用相同的形態。

**我的變更沒有使用者介面。Evidence 中該放什麼？**

除了螢幕截圖之外的一切。螢幕截圖僅在變更屬於視覺層面時才是最強力的證據；對於遷移、背景工作或重構，證據是先前失敗而現在通過的確切測試，或者是變動的 console 輸出。單純陳述「測試通過」只是一項主張，並非修改前後對照。

**它可以將內文標記為由 LLM 撰寫嗎？**

它本身不能。某位使用者的做法是在儲存庫的 agent 文件中加入常態指示，要求 agent 撰寫的每個 issue、comment 與 PR 結尾都附帶一行揭露聲明。該規則應置於儲存庫中（以涵蓋 agent 發布的所有內容），而非置於單一類型文件的範本中。

## 運作正常的指標

- 在開啟 diff 之前，僅憑 Summary 的視覺圖就能清楚知道 PR 變更了什麼。
- 內文沒有任何前言：直接從 Summary 標題開始。
- Evidence 章節展示修改前後對照，而非宣稱測試通過。
- 每個 PR 都陳述了門的類型與爆炸半徑，且單向門會促使你放慢速度仔細審讀。

## 適用位置

當建構作為 pull request 提交時，`pr` 位於審查與 retro 之間：`to-spec → to-tickets → implement → code-review → pr → retro`。它是由模型呼叫的，因此在該鏈條之外，每當 agent 撰寫 PR 內文時它也會自行觸發。

- [code-review](https://aihero.dev/skills-code-review) 在其之前執行，因為 PR 內文應當描述已經審查過的 diff。
- [implement](https://aihero.dev/skills-implement) 產出內文所描述的 commits。

當你不確定當前情境需要哪項技能時，[ask-matt](https://aihero.dev/skills-ask-matt) 可在整個技能集合間進行路由。
