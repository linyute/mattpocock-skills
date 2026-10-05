# mattpocock-skills

## 1.3.1

### 修補變更

- [#1121](https://github.com/mattpocock/skills/pull/1121) [`c5b9869`](https://github.com/mattpocock/skills/commit/c5b98691982c4f0d3a5e40ab09566b3b84721e00) 感謝 [@mattpocock](https://github.com/mattpocock)！`ask-matt` 不再表示 `diagnosing-bugs` 會在事後檢討時交接給 `improve-codebase-architecture`，因為這個步驟已移除。現在修正完成後，它會引導你前往 `/retro`，詢問哪些措施原本可以避免這個錯誤；若發現缺少接縫，則引導你前往 `/improve-codebase-architecture`。`diagnosing-bugs` 文件頁面也移除了相同的過時交接說明。感謝 @Ygilany 發現這個問題（[#1117](https://github.com/mattpocock/skills/issues/1117)）。

## 1.3.0

### 次要變更

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`2aecca1`](https://github.com/mattpocock/skills/commit/2aecca12ea9ff047f76c8178cb64dfeafd192abe) 感謝 [@mattpocock](https://github.com/mattpocock)！將 **`implement-spec`** 升級至 **Engineering** 分類，讓它納入 Claude Code 外掛程式、擁有文件頁面，並由 `ask-matt` 路由為逐張 ticket 執行 `implement` 的平行替代方案。

  `implement-spec`（使用者呼叫）會在單次執行中實作整份規格。它會將 tickets 視為**任務圖**，在各自的 worktree 中，針對已就緒的**前沿**執行實作者子代理人，並將所有變更整合至同一個**整合分支**，最後以 `code-review` 收尾。升級前所做的調整如下：

  - 目標改為整合分支，而非 PR。只有在 issue 追蹤器透過 PR 關閉工作，或你要求建立 PR 時，才會開啟草稿 PR；而且必須等到首次合併後才會建立（尚未比 main 多出任何提交的分支無法建立 PR）。若沒有 PR，tickets 會依照追蹤器關閉工作的方式解決。
  - 現在它會像其他同系列技能一樣參照 issue 追蹤器。若尚未提供追蹤器設定，它會請你執行 `/setup-matt-pocock-skills`，而不會默默預設使用 `gh`。
  - 每位實作者都會確認自己的 worktree 以整合分支為基礎，使用 `tdd` 建構 ticket，並在回報完成前將整合分支的最新進度合併至自己的分支，確保每次合併都是快轉合併。

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`2aecca1`](https://github.com/mattpocock/skills/commit/2aecca12ea9ff047f76c8178cb64dfeafd192abe) 感謝 [@mattpocock](https://github.com/mattpocock)！將 **`pr`** 升級至 **Engineering** 分類，讓它納入 Claude Code 外掛程式、擁有文件頁面，並由 `ask-matt` 路由為 PR 內文的收尾步驟。

  `pr`（模型呼叫）定義了 pull request 內文應有的形式：以能清楚呈現變更的精簡視覺摘要開場（偽程式碼、呼叫樹、檔案樹、Mermaid 圖或差異），接著提供變更有效的前後證據，並評估合併風險（單向或雙向門，以及影響範圍）。摘要視覺呈現改編自 Dex Horthy 的 `show-me`，並已在技能的 `CREDITS.md` 中註明來源。

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`2aecca1`](https://github.com/mattpocock/skills/commit/2aecca12ea9ff047f76c8178cb64dfeafd192abe) 感謝 [@mattpocock](https://github.com/mattpocock)！將 **`retro`** 升級至 **Engineering** 分類，讓它納入 Claude Code 外掛程式、擁有文件頁面，並由 `ask-matt` 路由為主流程中 `code-review` 之後的最後一個步驟。

  `retro`（使用者呼叫）回顧程式碼工作階段，並建議調整代理人的環境，而不是程式碼本身，例如導覽指引、自動化檢查、程式碼標準、引導檔案、工具使用效率及資訊存取方式。它會先分類每項程式碼標準相關發現：機械式違規應加入確定性的檢查（例如 linter 規則、pre-commit hook 或 CI 工作），而 `CODING_STANDARDS.md` 則保留給真正需要判斷的事項。儲存庫完全沒有防護措施，本身也是一項發現。

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`daa01d8`](https://github.com/mattpocock/skills/commit/daa01d8aa68ad5c61b68970ec2018d0ce9567be6) 感謝 [@mattpocock](https://github.com/mattpocock)！移除 **`resolving-merge-conflicts`** 技能。它已不再需要，也沒有替代技能：代理人可以在沒有專用技能的情況下處理進行中的 merge 或 rebase 衝突。此技能已從 Claude Code 外掛程式、README 與 `ask-matt` 路由器中移除。其文件頁面 `https://aihero.dev/skills-resolving-merge-conflicts` 仍會保留，並標示為已封存。

- [#1120](https://github.com/mattpocock/skills/pull/1120) [`006a52b`](https://github.com/mattpocock/skills/commit/006a52be23e0178375e083e30535fa8224471f3e) 感謝 [@mattpocock](https://github.com/mattpocock)！將技能讀寫領域文件時使用的 `CONTEXT.md`/`CONTEXT-MAP.md` 慣例，全面改名為 `GLOSSARY.md`/`GLOSSARY-MAP.md`。受影響的技能包括 `domain-modeling`、`grill-with-docs`、`improve-codebase-architecture`、`setup-matt-pocock-skills`、`triage`、`tdd`、`diagnosing-bugs`、`ask-matt`、`codebase-design`、`wait-what` 與 `pr`，此外也更新了文件頁面及本儲存庫根目錄的 glossary。

  如果你有這次變更之前建立的 `CONTEXT.md`（或 `CONTEXT-MAP.md`），請使用 `git mv` 將它改為新名稱：之後技能只會尋找 `GLOSSARY.md`/`GLOSSARY-MAP.md`。

### 修補變更

- [#848](https://github.com/mattpocock/skills/pull/848) [`f02e2ed`](https://github.com/mattpocock/skills/commit/f02e2ed3624d031272f8547742d23bf6bca8b072) 感謝 [@mattpocock](https://github.com/mattpocock)！`domain-modeling` 現在會在討論程式碼庫術語，以及直接撰寫或編輯 GLOSSARY.md 或 ADR 時觸發，取代原本較狹義的「釐清領域術語或通用語言」與「記錄架構決策」描述。也移除了「其他技能需要維護領域模型」這項但書，因為觸發技能時應由該技能明確說明這項工作。

- [#911](https://github.com/mattpocock/skills/pull/911) [`4f28947`](https://github.com/mattpocock/skills/commit/4f289474bad013fe2be8f8769d733f59d9103d6b) 感謝 [@mattpocock](https://github.com/mattpocock)！為 `to-spec`、`code-review`、`setup-matt-pocock-skills`、`writing-fragments`、`writing-shape` 與 `wait-what` 的 front matter 中 `description` 欄位加上引號。[#905](https://github.com/mattpocock/skills/issues/905) 移除 em dash 時遺留的未加引號冒號與空格，使每個區塊都成為無效 YAML，導致 `skills.sh` 在探索時略過這六項技能，因此無法透過 `npx skills` 列出或安裝。

- [#917](https://github.com/mattpocock/skills/pull/917) [`85f83d3`](https://github.com/mattpocock/skills/commit/85f83d3fde1d3a90d5c9a657f6998c79a6c37308) 感謝 [@mattpocock](https://github.com/mattpocock)！`grilling`：更新每輪範本，讓連續問題之間以水平分隔線（`---`）分開，避免文字連在一起。

- [#879](https://github.com/mattpocock/skills/pull/879) [`d419977`](https://github.com/mattpocock/skills/commit/d419977fe07d9e1607d3523f3579310bbb076b93) 感謝 [@mattpocock](https://github.com/mattpocock)！`grilling`：從 `SKILL.md` 移除 em dash，改用冒號與分號，讓指示以一般文字呈現。

- [#905](https://github.com/mattpocock/skills/pull/905) [`e6e9577`](https://github.com/mattpocock/skills/commit/e6e957797d8cceb5b351c0dc840369523f9fb8fb) 感謝 [@mattpocock](https://github.com/mattpocock)！從儲存庫所有敘述文字中移除 em dash（包括文件、`SKILL.md` 檔案、ADR、`README.md`、指令稿及 JSON/YAML Metadata），逐句改寫，使用逗號、冒號、句號、括號或連接詞，而非機械式替換字元。`CLAUDE.md`/`AGENTS.md` 現在也要求不要重新引入 em dash。

- [#878](https://github.com/mattpocock/skills/pull/878) [`e3e547b`](https://github.com/mattpocock/skills/commit/e3e547b57d549110a0aa6ff40fd7b871c01c76c9) 感謝 [@mattpocock](https://github.com/mattpocock)！在 `code-review`、`diagnosing-bugs`、`grill-with-docs`、`grill-me`、`improve-codebase-architecture`、`tdd`、`to-spec`、`to-tickets`、`triage` 與 `wayfinder` 中，統一跨技能呼叫方式，明確指示「呼叫 Skill 工具」，不再只使用 `/skill` 形式的文字描述。

  - 只在敘述中提到另一項技能（例如「執行 `/grilling` 技能」），並不能可靠地讓該技能載入。這個已記錄的問題正是 `grill-with-docs` 最常見回報的根源。直接指出工具（`Call the Skill tool with "grilling"`）是為了提高成功率。移除開頭的 `/` 也讓指示能跨執行環境使用，不再假設採用 Claude Code 的觸發語法。
  - 需要多項技能的步驟，現在會明確寫成多次呼叫（「呼叫 Skill 工具兩次，分別使用 `grilling` 與 `domain-modeling`」），而不是一次呼叫帶入兩個名稱。
  - 在 `.agents/invocation.md` 中記錄這項慣例，供未來技能遵循。

- [#880](https://github.com/mattpocock/skills/pull/880) [`1dab982`](https://github.com/mattpocock/skills/commit/1dab98299c3b81f560026c01b7ebf55ed5d91373) 感謝 [@mattpocock](https://github.com/mattpocock)！避免技能試圖透過 Skill 工具呼叫使用者呼叫的技能：修正 `.agents/invocation.md`、`to-spec`、`wayfinder`、`to-tickets`、`triage`、`code-review` 與 `diagnosing-bugs` 中違反「其他技能不得呼叫此技能」原則的跨技能參照。

  - `to-spec`、`wayfinder`、`to-tickets`、`triage` 與 `code-review` 原本都帶有「若尚未設定，請執行 `/setup-matt-pocock-skills`」的前置條件。PR [#878](https://github.com/mattpocock/skills/issues/878) 將其改寫為字面指示 `Call the Skill tool with "setup-matt-pocock-skills"`。但 `setup-matt-pocock-skills` 是使用者呼叫的技能，因此無論使用者呼叫或模型呼叫的技能都不能呼叫它。現在已將這五處改寫為請代理人告知使用者自行執行。
  - `diagnosing-bugs` 的第 6 階段原本也會在事後檢討時交接給 `improve-codebase-architecture`，但該技能同樣是使用者呼叫的。這項錯誤呼叫發生於自主執行且經常無人監督的修正流程，當時沒有人能介入處理。由於實務上很少觸發，因此直接移除交接，而不是只調整措辭。第 6 階段現在僅包含「清理」，機械式檢查清單保持不變。
  - 在 `.agents/invocation.md` 的「技能之間的相依關係」章節新增例外說明：只有目標技能為模型呼叫時，才能使用 `Call the Skill tool with "name"` 慣例。PR [#878](https://github.com/mattpocock/skills/issues/878) 新增該章節時，沒有將此慣例與上方八行所述的使用者呼叫和模型呼叫不變條件整合，這個落差正是問題擴散至六個呼叫位置，而非僅一處的主要原因。

  修正 [#453](https://github.com/mattpocock/skills/issues/453)。

- [#904](https://github.com/mattpocock/skills/pull/904) [`594f0f8`](https://github.com/mattpocock/skills/commit/594f0f83188921a60d45d63d6cdac509de20df2c) 感謝 [@mattpocock](https://github.com/mattpocock)！`wait-what`：當儲存庫透過 `GLOSSARY-MAP.md` 索引多個脈絡時，依照索引找到正確的 `GLOSSARY.md`，而非只使用根目錄的單一 `GLOSSARY.md`。

## 1.2.3

### 修補變更

- [#779](https://github.com/mattpocock/skills/pull/779) [`efce423`](https://github.com/mattpocock/skills/commit/efce423018fc6468a3239621f1c1bcaacc723801) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 使 `diagnosing-bugs` 隱蔽（redact）機密。

  - 在 `SKILL.md` 中新增 **Redact** 章節。該技能讓代理人顯示命令、輸出與擷取的構件；該章節使隱蔽處理成為每個項目的第一步 — 寫入 `<REDACTED>`、針對環境變數建立迴圈以使憑證留在環境中，且僅引用已擷取構件中帶有訊號的行。
  - 階段 1 的完成標準原本為「貼上呼叫與其輸出」。現在改為顯示已隱蔽的內容，且階段 1 向使用者要求**已隱蔽**的擷取構件。
  - 在 `scripts/hitl-loop.template.sh` 中備註 `capture` 會將其值印回終端機，因此它會在登入保持為 `step` 時進行觀察。

- [#781](https://github.com/mattpocock/skills/pull/781) [`14bfbbd`](https://github.com/mattpocock/skills/commit/14bfbbd8654a8d2910299e1a004c19c1979687d8) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 從 `code-review`、`codebase-design` 及 `improve-codebase-architecture` 中的子代理人派發指示中移除 Claude Code 的工具與代理人型別名稱，以便在 Codex 和其他測試環境上遵循該步驟。

- [#783](https://github.com/mattpocock/skills/pull/783) [`c0fd1e9`](https://github.com/mattpocock/skills/commit/c0fd1e973e040347d424e09934099f1bd6c2dee0) 感謝 [@mattpocock](https://github.com/mattpocock)！ - wizard：移除估計時間。範本移除了 `TOTAL_MINUTES` 與剩餘時間顯示，`stage` 僅接收名稱，且進度以階段計算。

## 1.2.2

### 修補變更

- [#766](https://github.com/mattpocock/skills/pull/766) [`4aaccb5`](https://github.com/mattpocock/skills/commit/4aaccb58d40559d7e3c59a029b2290ae5ba538de) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 使 `writing-for-agents` 再次可在 Codex 中由模型呼叫。

  - 從 `agents/openai.yaml` 中移除 `policy.allow_implicit_invocation: false`。Codex 先前將該技能過濾出模型可見的技能清單，因此其描述無法觸發它 — 只有明確提及 `$writing-for-agents` 才有效。
  - 更新過時的 `interface.display_name` 與 `interface.short_description`，它們先前仍命名舊的 `writing-great-skills` 技能。
  - 將技能在 `README.md` 與 `skills/productivity/README.md` 中從 **使用者呼叫** 清單移動至 **模型呼叫** 清單。

## 1.2.0

### 次要變更

- [#551](https://github.com/mattpocock/skills/pull/551) [`697d4ce`](https://github.com/mattpocock/skills/commit/697d4ce9742da558fd1ba6697c8e9775e2e302dd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 在每個技能的 Claude Code 前言中新增 Codex Metadata，以便該集合在兩個測試環境中均可運作而無需產生的副本。

  - 在每個 `SKILL.md` 旁新增一個帶有 Codex UI metadata（`interface.display_name`、`interface.short_description`）的 `agents/openai.yaml`。
  - 將每個使用者呼叫的技能標記為 `policy.allow_implicit_invocation: false`（Codex 中對應 `disable-model-invocation: true` 的機制），因此 Codex 將其排除在隱式呼叫之外，同時明確的 `$skill` 呼叫仍可運作。
  - 在 `.agents/invocation.md`、`CLAUDE.md` 及推廣分類桶的 README 中記錄雙測試環境呼叫模型。
  - 將 `AGENTS.md` 作為符號連結新增至 `CLAUDE.md`，以便 Codex 讀取相同的儲存庫指示。

- [#593](https://github.com/mattpocock/skills/pull/593) [`0f2bdbd`](https://github.com/mattpocock/skills/commit/0f2bdbdb06220d2df3718b8f0483157c6c8a8600) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 將 **`to-questionnaire`** 從 `in-progress/` 畢業移入 **Productivity** 分類桶，以便隨外掛程式發布。它將您無法單獨回答的決策轉化為 Markdown 問卷，給唯一可以回答的人 — 非同步填寫，或在會議中一起解決。

  其決定性的舉措是它就**傳送**而非主題盤問您：正常的盤問工作階段會詢問主題，而這恰好是您在這裡無法回答的，因此面試僅詢問問卷要寄給誰以及您需要收回什麼，然後將每個問題對準兩者之間的落差。

  現在連結為推廣技能 — 外掛程式條目、頂層 + Productivity README 的 **使用者呼叫** 底下、位於 `docs/productivity/to-questionnaire.md` 的文件頁面，以及在 `ask-matt` 中將其構建為 `/grill-me` 反向的獨立路線（盤問其他人，而非您自己）。

- [#680](https://github.com/mattpocock/skills/pull/680) [`b3376f8`](https://github.com/mattpocock/skills/commit/b3376f8d39848dd08572ec2667da4739a67c8c04) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 將 **`wizard`** 從 `in-progress/` 畢業移入 **Engineering** 分類桶，以便隨外掛程式發布 — 並使其可由模型呼叫。它會產生一個互動式 bash 指令稿，引導人類完成手動程序 — 第三方設定、一次性轉移、A→B 狀態轉變 — 開啟每個 URL、說明點擊內容、擷取數值，並將其寫入 `.env` 檔案與 GitHub Actions 金鑰。

  令人愉悅的 UX 已經由隨附的 `template.sh` 預先解決（包含剩餘時間進度、確認閘門、包含 WSL 在內的跨平台 URL 開啟、隱藏金鑰輸入、等冪 `.env` 更新/插入、帶有優雅降級的 `gh secret`/`gh variable` 寫入、關閉跳過摘要）。`STAGES` 標記之上的所有內容都是固定的函式庫，永遠不會進行手動編輯 — 技能的工作僅是界定程序範圍並撰寫其**階段**。

  工程而非生產力：它會讀取 `.env*`、`docker-compose*`、框架設定以及 `.github/workflows/` 中的每個 `secrets.*`/`vars.*` 參考以界定自身範圍、寫入 CI 金鑰，並使用 `bash -n` 與 `shellcheck` 驗證其輸出。

  因為它是模型呼叫的，代理人可以在遇到只有人類才能執行的步驟時立即尋求它，而不是將編號指示轉儲到聊天中並希望您遵循它們。輸入 `/wizard` 的運作方式與先前完全相同 — 模型呼叫只會*擴展*代理人的觸角。描述被撰寫為決定何時觸發的指標：產生的內容、四個觸發分支（佈署基礎設施、設定憑證或 CI 金鑰、導覽不熟悉的第三方儀表板、一次性轉移或過渡），以及明確的非觸發條件 — 不要針對代理人自身可以執行的步驟呼叫它。代理人可以做的工作，代理人應該做；精靈適用於您不會交給代理人的點擊、核准與儀表板存取。在寫入任何一行之前進行的階段清單確認現在兼作代理人在建構中途觸發時的提案。

  現在連結為推廣技能 — 外掛程式條目、頂層 + Engineering README 的 **模型呼叫** 底下、位於 `docs/engineering/wizard.md` 的文件頁面，以及在 `ask-matt` 中用於只有人類才能採取的步驟的獨立路線。模型呼叫也使其不受 [#693](https://github.com/mattpocock/skills/issues/693) 的影響，後者從 Claude 桌面與 Web 介面的清單中移除了使用者呼叫的技能。

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 圍繞兩個理念重新塑造 **`prototype`** 技能：示範是**單一可共享的 HTML 檔案**，而原型是**一手來源**。

  邏輯分支現在產出一個自包含檔案（純 HTML/CSS/JS，無建構，無伺服器）而非終端機應用程式 — 非開發人員可以透過雙擊開啟它，並在其自身的領域語言中驅動它：具標籤的狀態面板、隨時可用的自由操作按鈕，以及一組分頁**引導式流程演練**，每個演練都是在其下方配有按按鈕順序的情境。可攜式的純邏輯模組仍可提升至真實程式碼中；HTML 外殼則是一次性的。

  一次性不再意味著刪除。原型不再在回答其問題後被移除，而是作為可執行的證據擷取在獨立於 main 的一次性分支（`prototype/<name>`）上，並在實作 issue 上留有指向它的上下文指標 — 因此主分支僅保留已驗證的決策，而探索過程保持可尋找。答案（判定 + 問題）仍持久地擷取在 issue/ADR/commit 中。

- [#536](https://github.com/mattpocock/skills/pull/536) [`42a5b70`](https://github.com/mattpocock/skills/commit/42a5b70fcacc7baff1977b13f3919fb2f63af14e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 將技能集合發布為原生 **Claude Code 外掛程式**，列在 Claude Code 官方市集中。您現在可以訂閱推廣的技能作為受管理、唯讀的套件，而非複製可編輯檔案：

  ```bash
  claude plugins install mattpocock-skills
  ```

  或者，在工作階段內部：

  ```
  /plugin install mattpocock-skills
  ```

  無需事先新增市集 — 官方市集預設已設定。

  `.claude-plugin/plugin.json` 包含完整的外掛程式 metadata（版本、描述、作者、授權條款、關鍵字）以及推廣技能的明確清單。`skills.sh` 仍然是通用安裝程式（以及目前 Codex 與其他測試環境的路徑）；原生 Codex 外掛程式已被延後 — 原因參見 `.agents/adr/0002-ship-as-a-claude-code-plugin.md`。

- [#751](https://github.com/mattpocock/skills/pull/751) [`355fa74`](https://github.com/mattpocock/skills/commit/355fa7420b418af838998f7ec4365ceda1c8dfcc) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增 **`wait-what`** — 針對模型冗長問題的單字修正。在訊息未傳達到位的瞬間輸入它，代理人就會重新推銷它：一點上下文、ASD-STE100 簡化技術英語，以及來自您 `CONTEXT.md` 的無處不在語言。使用者呼叫，長度為三行。

  其機制在於名稱。簡潔技能因膨脹而失敗 — 400 行的技能仍會使模型保持冗長 — 因此這個技能是單一精確的前導詞，別無其他。描述*輸出*的名稱（`/tldr`、`/no-fluff`）會使模型剪裁詞彙並讓您更加迷失；命名*聆聽者*的狀態要求同時進行兩個部分：更少的字**以及**您所缺失的上下文。它還重用了您全域 `CLAUDE.md` 中已有的前導詞，因此技能、`CLAUDE.md` 與每個 `CONTEXT.md` 都會尋求相同的 Token。

  它修復了一則訊息；它無法阻止下一則訊息。治療術語的良藥是預先透過 `/grill-with-docs` 建構的共享語言；這是當您尚未擁有共享語言時所尋求的工具。

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 將 `/wayfinder` 單位命名為**決策 ticket**，並利用子代理人銷毀研究 ticket。

  人們不斷將 wayfinder ticket 誤讀為普通的*實作* ticket — 要執行的建構切片 — 而 wayfinder 將其用作**決策 ticket**：其解決方案為決策的問題。技能描述與其開頭行現在引入了該術語（並說明是什麼使其成為決策 ticket），且 `ask-matt` / 工程 README 簡介與文件頁面亦保持一致 — 一旦術語建立，"ticket" 仍為日常詞彙。`CONTEXT.md` 將**決策 ticket** 記錄為領域術語，因此「避免使用：ticket」的指導不再與 wayfinder 刻意使用該詞衝突。

  研究 ticket 不再停放以供單獨啟動的工作階段使用。研究仍保持為真實的 ticket 型別 — 它是下游決策所依賴的真正共享阻塞因素，而該依賴性正是前沿阻塞邊緣存在以進行算力的內容。改變的是其解決方式：因為研究是 AFK 的，繪圖不會停止並閱讀它。在建立 ticket 之後，繪圖工作階段會為每個研究 ticket 觸發一個 `/research` 子代理人以平行銷毀它，將結果擷取在具有上下文指標的一次性 `research/<name>` 分支上。研究 ticket 是*每個工作階段一個 ticket* 的唯一例外。

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - **重大變更：** 重新命名 **`writing-great-skills`** → **`writing-for-agents`**，重新建構它，並新增一個新的前導詞。

  參考資料現在涵蓋代理人消耗的任何文件 — 技能、`AGENTS.md` / `CLAUDE.md`、透過指標到達的文件 — 不僅僅是技能。`GLOSSARY.md` 已合併至 `SKILL.md`（每個術語一個權威處理；`_Avoid_` 同義詞清單與獨立的 Predictability 定義已移除）；僅限技能的機制（前言、模型呼叫 vs 使用者呼叫、路由器技能、拆分的呼叫切片）已公開至全新的 `SKILL-MECHANICS.md`。該技能現在為**模型呼叫**：它在建立或編輯技能或修改 `AGENTS.md`/`CLAUDE.md` 時觸發。更新了 `ask-matt` 的指標。在新名稱下重新安裝；舊名稱已移除（無別名）。

  精簡章節獲得了**快取**。單一事實來源現在超越文件延伸至環境中 — `package.json` 指令稿、設定檔、目錄配置、`--help` 輸出本身就是權威的，因此重述它們的文件是對尋找內容的快取，僅在尋找成本高昂時才值得載入。正面目標：快取代理人無法透過檢視找到的內容（未寫出的規範、選擇背後的原因、沒有設定承認的陷阱），並將單一檔案、單一命令的尋找留給環境，它們在那裡不會過時。

- [#533](https://github.com/mattpocock/skills/pull/533) [`45afd80`](https://github.com/mattpocock/skills/commit/45afd8074a8b7de5fe073845d080fa9dd6c429fa) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 為 **`improve-codebase-architecture`** 技能的 Explore 步驟新增 YAGNI 範圍過濾器。它不再均勻地掃描整個儲存庫，而是將範圍縮小到變更實際落地的位置：如果您指定方向，它就會採納，否則它會讀取最近約 20 條提交訊息，以使探索偏向積極開發的路徑。在無人觸及的程式碼中進行深化機會是您永遠無法兌現的重構 — 槓桿作用僅在您持續編輯的地方得到回報 — 因此報告停止整理儲存庫中休眠的角落。

### 修補變更

- [#763](https://github.com/mattpocock/skills/pull/763) [`77d207e`](https://github.com/mattpocock/skills/commit/77d207ef03219cc603e2832e1159cbdd1c91818e) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 磨練 `/ask-matt` — 路由器現在涵蓋階段邊界、兩個 wayfinder 錯誤以及兩個它從未提及的技能。

  **階段邊界。** **階段**是工作階段內部的一塊工作 — 盤問、實作、QA — 而兩者之間的邊界是您決定如何處理已建立上下文的地方。雙要點的 `Crossing sessions` 章節替換為包含所有五個選項順序的決策樹（**繼續**、`/clear`、`/handoff`、**子代理人**、`/compact`），並在新的 `PHASE-BOUNDARIES.md` 中公開推理。隨之帶來了三個修復：

  - **`/handoff` 被過度宣傳。** 它讀起來像是上下文視窗之間的一般橋樑。它是狹隘的：您僅在某些內容必須*移動*時才需要它 — 新的測試環境、新的目錄、同事或中途分叉的側向任務。它買到的是可攜性。
  - **`/compact` 是預設值，而非首選。** 它位於樹的底部，在它上方四個更便宜或更精確的問題之後。從那裡開始會產生一個對摘要平坦化的任何內容都自信錯誤的工作階段。
  - **完全缺失了兩個分支。** **繼續** 是首先要排除的分支 — 它是唯一保持對話作為一手來源而非其摘要的動作 — 且**子代理人**處理任何範圍足夠緊密以在 AFK 執行的內容。

  上下文衛生的逃生口現在顯示 `/compact` 而非 `/handoff`（相同的測試環境、相同的目錄、在邊界上 — 交接條款不適用），且智慧區域數字從 ~120k 更新為 ~150k Token。

  **Wayfinder 路由。** 人們最常對最繁重、認知要求最高的流程犯下的兩個錯誤：

  - **過度尋求它。** 它比單一盤問更慢且更密集，因此它被標記為最繁重的流程，並保留給真正無法容納在單一工作階段中的想法 — 範圍良好的功能屬於 `/grill-with-docs`，而非這裡。
  - **在交接時迷失方向。** 當地圖清空時，wayfinder 進行交接，它不會建構：在 `/to-spec`（它將地圖連結的決策簡化為可建構的計畫）合併至主流程，而不是將地圖直接循環至 `/implement`。直接轉至 `/implement` 僅適用於結果真正微小的努力。

  **遺失的路線。** `/grilling` 與 `/resolving-merge-conflicts` 完全沒有出現在路由器中，現在已加入其中，且 `grill-me` 從 `grill-with-docs` 中拆分出來，取決於您是否位於工作目錄中。

- [#502](https://github.com/mattpocock/skills/pull/502) [`44eed54`](https://github.com/mattpocock/skills/commit/44eed545186ffd0263e8004867750b80cfddd215) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 使 `/setup-matt-pocock-skills` 更具親和力，並使本機 markdown 追蹤器與目前的規格保持一致。

  - **Triage 標籤** 現在僅在安裝了 `triage` 技能時才會被詢問，然後作為單一推薦說是的問題（「保留預設的 triage 標籤？」）而非覆蓋盤問。當未安裝 `triage` 時，該章節 — 以及 `docs/agents/triage-labels.md` — 會被跳過。
  - **外部 PR 作為請求表面** 不再是設定問題。GitHub/GitLab 範本仍攜帶該旗標，預設關閉；使用者稍後可在 `docs/agents/issue-tracker.md` 中翻轉它。
  - **領域文件** 預設為單一上下文且無需詢問；僅當儲存庫顯示 monorepo 訊號時才會提供多上下文。
  - **本機 markdown ticket** 現在在 `.scratch/<feature>/issues/<NN>-<slug>.md` 下每個 ticket 一個檔案 — 切勿使用單一合併的 `tickets.md`。`/to-tickets` 與本機 issue 追蹤器範本現在達成一致，且規格檔案為 `spec.md`（而非 `PRD.md`）以匹配 `/to-spec`。

  `setup-matt-pocock-skills` 與 `to-tickets` 的文件頁面已重新同步。

- [#532](https://github.com/mattpocock/skills/pull/532) [`170ad48`](https://github.com/mattpocock/skills/commit/170ad48655825783d0193e850e31a9aac957bb95) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 為通用用途重述 **`grilling`** 的用詞。其描述與正文不再將面試限定於軟體計畫："this plan" → "this"，"enact the plan" → "act on it"，以及 "exploring the codebase" → "exploring the environment"。技術保持不變；它現在讀起來像是對任何計畫、決策或想法的壓力測試。

- [#593](https://github.com/mattpocock/skills/pull/593) [`a4b2009`](https://github.com/mattpocock/skills/commit/a4b2009a1a3ac9575506c10b4c84f08f9bba7a38) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 將 **`grilling`** 從一次一個問題重構為逐輪進行。它現在對映決策樹並在單一編號輪次中詢問整個**前沿** — 每個必備條件已解決的問題，然後從使用者的回答重新計算前沿並詢問下一輪。相同的 13 個問題落在大約 3 輪而不是 13 輪中。環境可以回答的事實被派發給背景子代理人，因此研究永遠不會阻塞該輪次：只有在執行中探索下游的問題才會等待它。當前沿為空時工作階段結束。

  一輪中的每個問題都以一個固定外形發出 — `❓ **Q1** - **<title>**`，然後是正文（散文或多個選項），然後是位於其自身 `➡️` 行上的建議。一輪讀起來像是一個可掃描的編號清單，每個建議都與問題在視覺上分離，因此您可以按編號回答而不需要引用問題。

  `grill-me`、`grill-with-docs` 與 `triage` 也一次一輪地執行前沿 — `triage` 的盤問步驟與 `grilling` 的 Codex `short_description` 現在這樣說明，而不是描述舊的節奏。一次一個問題的退場機制（全域 `CLAUDE.md` 中的一行）保持不變。

- [#752](https://github.com/mattpocock/skills/pull/752) [`c66bdee`](https://github.com/mattpocock/skills/commit/c66bdeeee002d81e3f8b21403c07f9a0d7bea6da) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 從儲存庫中移除六個技能。它們都沒有出現在 Claude Code 外掛程式中，但所有六個都可以透過 [skills.sh](https://skills.sh/mattpocock/skills) 安裝，該網站提供儲存庫中的所有技能 — 因此這是離開該清單的內容，以及每個技能的去向。

  四個退役的技能，每個都已被能更好完成工作的技能吸收：

  - **`ubiquitous-language`** → **`/domain-modeling`**，它建構與維護整個領域模型，而不是從單次對話中轉儲詞彙表。
  - **`design-an-interface`** → **`/codebase-design`**。沒有任何遺失：「設計兩次」技術 — 來自 Ousterhout 的平行子代理人產生截然不同的設計 — 作為 `DESIGN-IT-TWICE.md` 發布在該技能內部。
  - **`qa`** → **`/triage`** 與 **`/to-tickets`**。
  - **`request-refactor-plan`** → **`/to-spec`** 與 **`/improve-codebase-architecture`**。

  以及兩個僅屬於我自己的技能 — 綁定至我自己的機器，從未打算供其他人使用。`personal/` 分類桶隨之而去：

  - **`edit-article`**
  - **`obsidian-vault`**，它硬編碼了前往我自己 Obsidian vault 的路徑。

  `skills/deprecated/` 保持為分類桶，現在為空。`skills/in-progress/` 保持不變，現在根據其真實情況進行描述：一個測試頻道，故意發布，可透過 skills.sh 一次安裝一個技能。

- [#734](https://github.com/mattpocock/skills/pull/734) [`a2f9333`](https://github.com/mattpocock/skills/commit/a2f9333669ff53db762c87ecda5a15442060a3be) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 完成 `to-prd` → `to-spec` 的重新命名："spec" 現在是發布文字中唯一的術語。

  - **`to-spec`** 不再以「您可能知道此文件為 PRD」開頭 — 括號中的內容已從技能與其文件頁面中刪除。本機 markdown 追蹤器範本刪除了相同的對沖。
  - **`code-review`** 在其前言描述、雙軸摘要與規格來源搜尋順序中討論源頭的 issue/規格，而非 issue/PRD。兩個 README 均已重新同步。
  - **GitHub 與 GitLab 追蹤器範本** 現在顯示「此儲存庫的 Issue 與規格作為 GitHub/GitLab issue 存在」 — 當本機範本更新時，它們留在了 "PRD"，因此過時的術語傳播到了寫入它們的每個儲存庫中。
  - **`docs/engineering/research.md`** 指向 `https://aihero.dev/skills-to-prd`（重新命名技能的失效 slug）；它現在就像其他十九個文件頁面一樣連結 `to-spec`。

  CHANGELOG 與現有的變更集在記錄重新命名本身的內容中仍命名 PRD，這是正確的。

## 1.1.0

### 次要變更

- [#406](https://github.com/mattpocock/skills/pull/406) [`930a450`](https://github.com/mattpocock/skills/commit/930a450089f77a49af09001d955db8452a4b867d) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 使 **`ask-matt`** 路由器與完整技能集合保持最新。它現在對映了它所缺少的五個技能：**`tdd`**（作為 `implement` 驅動的紅-綠引擎編織到主流程中）、**`diagnosing-bugs`**（新的「事物損壞」入口 — 先前沒有針對 bug 的路線）、**`domain-modeling`** 與 **`codebase-design`**（新的「底下詞彙」章節），以及 **`grilling`**（共享的面試原語）。`prototype` 作為獨立項目被充實，且描述從「使用者呼叫的技能」擴大到「技能」。`CLAUDE.md` 中新增了一條維護規則，以便任何未來的技能新增/重新命名/移除或流程變更都會觸發 `ask-matt` 的重新檢查，位於現有文件頁面重新同步規則旁。

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 推廣並強化 **`code-review`**。進行中的 **`review`** 技能重命名為 **`code-review`** 並從 `in-progress/` 移動至 `engineering/`：它現在隨外掛程式發布，列在頂層與 Engineering README（模型呼叫）中，並在 `docs/engineering/code-review.md` 擁有一個文件頁面。`/implement` 技能與文件指向 `/code-review`。

  它還在其 Standards 軸上獲得了常開的 **Fowler 壞氣味基準** — 精選的 ~12 個高訊號「程式碼中的壞氣味」（神秘名稱、重複程式碼、依戀情結、資料泥塊、基本型別偏執、重複開關、發散式修改、發散式變更、誇誇其談的未來性、訊息鏈、中間人、被拒絕的遺產）作為固定基準行內化至 `SKILL.md` 中，位於儲存庫記錄的任何內容旁，而非新的第三軸。兩條約束規則保持其安全：記錄的儲存庫標準覆蓋基準，且每個壞氣味都作為裁量評估報告，決非硬性違規。

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 在兩個戰線上磨練 **`grilling`**。

  **確認閘門。** 在您確認已達到共享理解之前，代理人不會執行計畫 — 將技能現有的「共享理解」完成標準轉化為明確的停止閘門。`description` 還招募了預訓練的 **`grill`** 前導詞（「無情地盤問使用者」）以磨練呼叫，並且文件頁面已重新同步。

  **事實 vs. 決策。** 盤問現在將*事實*（尋找它們 — 探索程式碼庫）與*決策*（將每一個提交給人類並等待他們的回答）拆分開來。舊的總體規則 — 「如果可以透過探索程式碼庫來回答問題，請改為探索程式碼庫」 — 是為即時人類情況撰寫的，但一旦另一個技能在解決 ticket 框架內執行盤問，它就被讀取為自主回答*決策*的許可。將兩者分離可防止盤問代理人衝在前面回答自己的問題。

- [#463](https://github.com/mattpocock/skills/pull/463) [`af6d692`](https://github.com/mattpocock/skills/commit/af6d6922c3e2b5288eef155346cbe319e4ed3bd0) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 在 **`writing-great-skills`** 中新增兩個相鄰的轉向失敗模式，兩者都關於您認為「關閉」的語言如何仍然轉向代理人。**否定** — *大象* — 是透過禁止進行轉向：命名*不要*做什麼會將被禁止的行為拖入上下文中並使其*更加*可用而非更少（*不要思考大象*），因此解藥是提示**正面**內容。**負空間** — 虛空 — 是對您所*遺漏*的內容所進行轉向的盲目：技能拒絕的每個決策都被委派給代理人的先驗知識而非保持中立，因此解藥是閱讀草稿中的沉默並審慎決定每個遺漏（填補它，或將其作為真實的**分支**留空）。保留為兩個條目，而非一個 — 它們帶有不同的診斷與不同的解藥 — 每個都是完整的 `GLOSSARY.md` 條目加上 `SKILL.md` 失敗模式要點，匹配每個其他失敗模式的攜帶方式。

- [`850873c`](https://github.com/mattpocock/skills/commit/850873cd73d5f81826ebf512ad35d2b1e113001f) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 使 **`prototype`** 技能可由模型呼叫，以便代理人可以自主尋求它（其他技能也可以）。其描述圍繞前導詞 *prototype* 重新撰寫 — 回答設計問題的一次性程式碼 — 每個分支一個觸發器（狀態/邏輯健全性檢查，或 UI 探索）。

- [#409](https://github.com/mattpocock/skills/pull/409) [`0d74d01`](https://github.com/mattpocock/skills/commit/0d74d01cbc64ca27778a49b38599f70c534e76a0) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增 **`research`** 技能 — 一個小型、可由模型呼叫的技能，啟動**背景代理人**以針對**一手來源**（官方文件、原始碼、規格、第一方 API）調查問題，然後在儲存庫保留此類筆記的任何位置留下單一引用的 Markdown 檔案。這是可委派的閱讀腿力活：在它閱讀時您繼續工作，並拿回一份文件來進行盤問、計畫或設計。列在頂層與 Engineering README（模型呼叫）中、新增至 `.claude-plugin/plugin.json`、在 `docs/engineering/research.md` 提供文件頁面，並在 `ask-matt` 中作為獨立項目路由。

- [#469](https://github.com/mattpocock/skills/pull/469) [`a0329ba`](https://github.com/mattpocock/skills/commit/a0329ba95751f58566ed7ab484475917a68f1629) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 將 **`to-issues`** 技能拆分為精簡的**流程**與**參考**章節，並教導它處理**廣泛的重構** — 單一機械化變更（例如重新命名欄位），其**破壞半徑**散布至整個程式碼庫，一次打破數千個呼叫位置，因此沒有垂直切片可以落地為綠色。起草步驟現在指向兩個共置的參考區塊：用於普通追蹤彈的**垂直切片規則**，以及**廣泛重構**，後者透過**擴展–縮減**切片變更（在舊表單旁擴展新表單、按破壞半徑大小分批移轉呼叫位置，然後縮減舊表單）以使 CI 批次保持綠色 — 或當無法做到時，僅在最終的整合與驗證 issue 上。Issue 正文範本也移動至參考中。

- [#464](https://github.com/mattpocock/skills/pull/464) [`386d4ff`](https://github.com/mattpocock/skills/commit/386d4ff719a7c420ad1454232d0436b01f1b8c17) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 統一計畫技能。**`to-prd` 重新命名為 `to-spec`** — "spec" 現在是單一的貫穿術語（為了可發現性，它仍以「您可能知道此文件為 PRD」開頭）。**`to-plan` 與 `to-issues` 合併為一個 `to-tickets` 技能，且 `to-issues` 被刪除。**

  `to-tickets` 將計畫、規格或對話分解為一組 **ticket** — 追蹤彈垂直切片，每個切片宣告其**阻塞邊緣**。根據 `/setup-matt-pocock-skills` 設定的追蹤器，該單一構件有兩種讀取方式：**本機檔案**（`tickets.md`）將邊緣寫為文字，您手動由上至下處理它；**真實追蹤器**將其寫為原生阻塞連結，因此任何阻塞因素已完成的 ticket 都位於前沿上，且多個代理人可以同時執行。邊緣無論如何都存在於 ticket 中 — 介質僅決定是否有任何內容平行對其採取行動。

  發布偏好追蹤器的**原生子 issue** 用於父項 → 切片，以及**原生阻塞邊緣**用於在追蹤器支援的地方使用 `Blocked by`，保留 `## Parent` / `## Blocked by` 正文章節作為後備。「要建構的內容」範本指向 `/prototype` 程式碼所在的位置，而非行內化來自其的程式碼片段。

  `ask-matt` 的主流程現在將 `idea → /to-spec → /to-tickets → /implement` 進行路由，且在 `docs/engineering/to-spec.md` 與 `docs/engineering/to-tickets.md` 有面向人類的文件頁面。

- [#464](https://github.com/mattpocock/skills/pull/464) [`0557d57`](https://github.com/mattpocock/skills/commit/0557d57579d9b3d39839fdaf8d4a6542b17539ce) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 確定 wayfinder 在文件中的地位為**情境入口**，而非新的主要進入流程 — 盤問引導的*想法 → 發布*鏈保持為正門（將 wayfinder 冠為預設主幹是 v2 規模的舉措，而非 1.1）。**`ask-matt`** 路由器現在命名了 wayfinder 的具體觸發條件 — 新創專案或龐大的功能建構，單一工作階段無法容納 — 且兩個盤問正門（**`grill-me`**、**`grill-with-docs`**）指向 *向上* 到 wayfinder 以應對無法在單一工作階段中保持的努力，因此入口可以從讀者實際開始的位置被發現。

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 畢業並重構 **`wayfinder`** — 用於規劃單一代理人工作階段無法容納的龐大工作的技能。它從 `in-progress/` 移動至 `engineering/`（外掛程式條目、頂層 + Engineering README 的 **使用者呼叫** 底下、位於 `docs/engineering/wayfinder.md` 的文件頁面，以及 `ask-matt` 中的路線），作為成熟技能落地。使其到達那裡的重命名與重構：

  - **`decision-mapping` 重命名為 `wayfinder`**，呼叫為 `/wayfinder`。「Decision map」過於術語化且不準確 — 實際上只有一種 ticket 型別是決策。相反，重構畫出了一條穿過迷霧問題的路線，給出一個連貫的前導詞框架 — **戰爭之霧**、**前沿**、**地圖** — 而非在其之上堆疊發明的術語。
  - **目的地作為前導詞。** 尋路（Wayfinding）尋找通往目的地的*道路*；它不會急於建構它。命名目的地是繪圖的第一步 — 它固定了範圍並塑造了每個 ticket — 因此地圖獲得了一個 `## Destination` 欄位，每個工作階段都對其進行定位，且 triage 在任何 ticket 存在前將其固定。
  - **計畫，而非執行。** 地圖產出**決策，而非可交付成果**；當在某人建構該事物之前沒有剩餘需要決策的內容時，它就完成了。一項努力可以在其 Notes 中覆蓋此項。
  - **地圖是索引，而非儲存庫。** 決策僅存在於一個地方 — 其 ticket — 因此地圖僅要約與連結，決不重述；將迷霧畢業至 ticket 會清除已畢業的補丁，使沒有內容逗留在兩個地方。
  - **預設為協作。** 地圖從本機 Markdown 檔案轉移至儲存庫的 issue 追蹤器：單一 `wayfinder:map` issue，其 ticket 是其子 issue — 團隊可以觀察的單一共享 URL。工作階段以低解析度載入地圖，並根據需要放大至 ticket。Wayfinder 在 `docs/agents/issue-tracker.md` 的指標背後保持與追蹤器無關（GitHub、GitLab、本機 markdown），且 `setup-matt-pocock-skills` 為「Wayfinding 操作」章節提供種子。
  - **透過指派索取，而非標籤。** 工作階段透過將 ticket 指派給主導開發人員來索取 ticket — 受指派人*就是*索取 — 將標籤詞彙解放給單獨的 `wayfinder:<type>`。
  - **原生阻塞。** 阻塞偏好追蹤器的原生依賴關係，它在追蹤器自身的 UI 中視覺化呈前沿，因此人類無需開啟地圖即可看到可取得的內容。GitHub 與 GitLab 範本說明了原生配方，並附帶正文規範後備方案。
  - **迷霧 vs. 超出範圍，拆分。** 兩個名稱明確的地圖章節 — `## Not yet specified`（隨著前沿推進而畢業的範圍內迷霧）與 `## Out of scope`（判定超越目的地、關閉、決不畢業的工作） — 因此超越目的地的工作不再讀取為可取得的前沿。
  - **第四種 `task` ticket 型別。** 用於阻塞決策的字面手動工作（佈署存取權、移動資料、註冊服務） — 唯一一種進行*執行*而非決策的型別，透過解除阻塞決策來獲得其地位。
  - **HITL / AFK ticket 分類。** 每個 ticket 型別都是 **HITL**（人在迴圈中 — 盤問、原型）或 **AFK**（代理人單獨 — 研究；任務可以是兩者之一）。HITL ticket 僅透過即時交流解決，因此「等待人類」落出了標籤之外 — 回答自己問題的盤問代理人根據定義打破了 HITL。（這修復了學生關於 `/wayfinder` 盤問*自身*而非人類的報告。）
  - **恢復無迷霧早期退出。** 如果開頭的廣度優先盤問未浮現任何迷霧，則旅程小到足以容納在單一工作階段中 — 因此它會停止並詢問您希望如何繼續，而不是建構無人需要的地圖。

### 修補變更

- [#464](https://github.com/mattpocock/skills/pull/464) [`639df6e`](https://github.com/mattpocock/skills/commit/639df6e7386dfddc739b2aecdeff37a876f2483b) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 將 **`tdd`** 重構為僅供參考的技能，並新增缺少的反模式。

  **僅供參考。** 紅 → 綠 → 重構迴圈由模型已持有的前導詞錨定，因此按部就班的工作流程在很大程度上重述了該迴圈。刪除了工作流程與每個週期的檢查清單；將其一個持久的想法 — 垂直切片 / 追蹤彈 — 折疊到反模式章節與短暫的迴圈規則清單中。引入 **接縫（seam）** 作為測試去向的前導詞：僅在預先商定的接縫處進行測試，在編寫任何測試之前與使用者確認。還刪除了重構階段 — TDD 現在是紅 → 綠；重構屬於審查階段，因此重構規則與 `refactoring.md` 移動了出去（其歸宿是 `code-review`）。

  **恆真測試。** 新增了恆真測試反模式：斷言以程式碼計算方式重新計算的測試在結構上通過，並給予零信心 — 與已涵蓋的實作耦合反模式不同。作為同級在相同位置新增：哲學原則（期望值必須來自獨立的事實來源）、檢查清單閘門，以及 `tests.md` 中的 BAD/GOOD 範例對。

- [`e00eadb`](https://github.com/mattpocock/skills/commit/e00eadb4bb32c3d5a631ead1a5ed5d6a7c5f74e2) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 擴展 **`triage`** 技能以 triage 外部 Pull Request，將 PR 視為附加了程式碼的 issue，通過相同的角色與狀態機執行。PR 與 issue 行內流動（由每個儲存庫的設定切換開關管制），發現僅浮現外部 PR，僅限 bug 的「重現」步驟被泛化為單一「驗證聲明」步驟，且冗餘檢查將已實作的請求解決為 `wontfix` 而不會污染範圍外知識庫。`setup-matt-pocock-skills` 獲得了 GitHub/GitLab 的 PR 作為請求表面切換開關。

- [#472](https://github.com/mattpocock/skills/pull/472) [`d869d45`](https://github.com/mattpocock/skills/commit/d869d45afc32beab1c2d1350f8de5e81589512cd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 修復 **`wayfinder`** 硬編碼 issue-tracker 文件路徑的問題，這破壞了套件其餘部分所依賴的間接定址。

  `to-issues`、`to-prd` 與 `triage` 從不命名路徑 — 它們透過 `setup-matt-pocock-skills` 寫入 `CLAUDE.md` / `AGENTS.md` 的 `### Issue tracker` 區塊來解析追蹤器，該區塊指向追蹤器文件所在的位置。Wayfinder 相反地固定了字面的 `docs/agents/issue-tracker.md`，因此在將代理人文件保留在其他地方的儲存庫中，它靜默地後退至本機 markdown 追蹤器 — 甚至是其 `CLAUDE.md` 清晰宣告了 GitHub issue 的儲存庫。它現在透過相同的指標解析該文件，並按名稱閱讀其「Wayfinding 操作」章節，保持整個套件中的間接定址一致。

## 1.0.1

### 修補變更

- [`d20ee26`](https://github.com/mattpocock/skills/commit/d20ee2684e2a9442698ac3c1e0f2c5b68c4cf296) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 使 **`teach`** 技能重用優先。課程現在由 `./assets/` 中可重用的**元件**建構 — 樣式表、測驗小工具、模擬器、圖表助手。重用是預設做法：代理人在撰寫課程之前閱讀 `./assets/`、從現有內容建構，並將任何新的與可重用的內容提取為元件，而非行內化它。

## 1.0.0

### 重大變更

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增 **`ask-matt`** 技能 — 一個使用者呼叫的路由器，指向適合您情況的技能或流程。

  **重大變更：** `ask-matt` 在此儲存庫中的其他使用者呼叫技能上進行路由，因此它期望安裝它們。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增共享的設計技能並將現有技能重新接線至其上。

  - 全新 **`codebase-design`** 技能 — 深層模組詞彙（模組、介面、深度、接縫、轉接器）以及在小型介面背後放置大量行為的原則。先前存在於 `improve-codebase-architecture/LANGUAGE.md` 中的語言現在存在於此處，經泛化以跨技能重用。
  - 全新 **`domain-modeling`** 技能 — 主動建構與磨練專案的領域模型，對照詞彙表對術語進行壓力測試，並保持 `CONTEXT.md` 與 ADR 為最新狀態。
  - `improve-codebase-architecture` 現在從 `/codebase-design` 汲取其架構詞彙，並從 `/domain-modeling` 汲取其領域模型。
  - `tdd` 現在倚賴 `/codebase-design` 進行介面設計指導 — 其行內 `deep-modules.md` / `interface-design.md` 備註已被移除，轉而採用共享技能。
  - `grill-with-docs` 現在透過 `/domain-modeling` 行內建構領域模型。

  **重大變更：** 概念上這些技能現在依賴全新的 `codebase-design` / `domain-modeling` 技能，因此您也必須安裝它們。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 移除 **`caveman`** 與 **`zoom-out`** 技能。

  - `caveman` 是我測試的另一個技能的副本，從未打算公開。
  - `zoom-out` 在實踐中未被使用，因此已被從儲存庫中移除。

  **重大變更：** 兩個技能均已被移除。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 將 **`diagnose`** 技能重新命名為 **`diagnosing-bugs`**。

  **重大變更：** 作為 `/diagnosing-bugs` 呼叫 — 舊的 `/diagnose` 名稱不再存在。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 以 **`writing-great-skills`** 替換 **`write-a-skill`**。

  - 移除了 `write-a-skill`。
  - 新增了 `writing-great-skills`（及其 `GLOSSARY.md`） — 良好的撰寫與編輯技能參考資料：使技能可預測的詞彙與原則，將無作業（no-op）追捕至句子級別。
  - 將 `grilling` 揭示為模型呼叫的技能 — `grill-me` 與 `grill-with-docs` 背後可重用的面試迴圈。

  **重大變更：** `write-a-skill` 已被移除；請改用 `writing-great-skills`。

### 次要變更

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 新增 **`resolving-merge-conflicts`** 技能 — 用於解決進行中 git 合併或 rebase 衝突的迴圈。獨立，不依賴其他技能。

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 在整個文件中將技能分類學從 **Commands / Skills** 重新命名為 **User-invoked / Model-invoked**，並新增定義該拆分的 `docs/invocation.md`：使用者呼叫的技能僅在您輸入時才可達，並且存在於進行編排；當任務合適時，模型呼叫的技能也可以自動到達。使用者呼叫的技能可以呼叫模型呼叫的技能，但切勿呼叫另一個使用者呼叫的技能。

### 修補變更

- [`47bde84`](https://github.com/mattpocock/skills/commit/47bde84da032afb2e5058f997f3bbca47d321dbd) 感謝 [@mattpocock](https://github.com/mattpocock)！ - 緊縮 **`review`** 技能：快速失敗的 ref 檢查、單一來源的規則，以及無作業裁剪。
