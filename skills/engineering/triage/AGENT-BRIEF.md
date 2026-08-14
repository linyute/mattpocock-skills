# 撰寫 Agent 簡報

Agent 簡報是當 GitHub 議題或 PR 移動至 `ready-for-agent` 時發布的結構化留言。它是離線 Agent 將展開工作的權威規格。原始內文與討論是上下文 — Agent 簡報則是合約。

簡報說明 **Agent 應該做什麼**，延伸至兩個表面：對於議題，那是從無到有建構變更；對於 PR，那是*對現有差異*殘留要發揮的事物 — 完成它、補平缺口、解決審查意見。無論哪種方式原則相同；下方的 PR 範例展示了差異。

## 原則

### 耐用性高於精準度

議題可能會在 `ready-for-agent` 中停留數天或數週。程式碼庫在此期間會發生變更。撰寫簡報使其即使在檔案被重命名、移動或重構時也能保持有用。

- **要**描述介面、型別與行為合約
- **要**命名特定型別、函式簽名或設定形狀，以便 Agent 尋找或修改
- **不要**引用檔案路徑 — 它們會過時
- **不要**引用行號
- **不要**假設目前的實作結構將保持不變

### 行為導向，而非程序導向

描述系統應該做**什麼**，而不是**如何**實作它。Agent 將重新探索程式碼庫並做出自己的實作決策。

- **良好：**「`SkillConfig` 型別應該接受一個型別為 `CronExpression` 的可選 `schedule` 欄位」
- **糟糕：**「開啟 src/types/skill.ts 並在第 42 行新增 schedule 欄位」
- **良好：**「當使用者在沒有引數的情況下執行 `/triage` 時，他們應該看到需要關注議題的摘要」
- **糟糕：**「在主處理常式函式中新增 switch 語句」

### 完整的驗收標準

Agent 需要知道何時完成。每個 Agent 簡報都必須具備具體、可測試的驗收標準。每個標準應該可以獨立驗證。

- **良好：**「執行 `gh issue list --label needs-triage` 會傳回已經通過初始分類的議題」
- **糟糕：**「分揀應該正確運作」

### 明確的範疇邊界

說明範疇之外的內容。這可以防止 Agent 畫蛇添足或對鄰近功能做出假設。

## 範本

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** 需要發生的單行說明

**Current behavior:**
描述現在發生的情況。對於 Bug，這是損壞的行為。
對於增強功能，這是該功能建立在其上的現狀。

**Desired behavior:**
描述 Agent 工作完成後應該發生的情況。
對邊界情況與錯誤條件保持具體。

**Key interfaces:**
- `TypeName` — 需要改變什麼以及原因
- `functionName()` 傳回型別 — 目前傳回什麼 vs 應該傳回什麼
- 設定形狀 — 所需的任何新設定選項

**Acceptance criteria:**
- [ ] 具體、可測試的標準 1
- [ ] 具體、可測試的標準 2
- [ ] 具體、可測試的標準 3

**Out of scope:**
- 在此議題中**不**應該改變或處理的事物
- 看似相關但獨立的鄰近功能
```

## 範例

### 良好的 Agent 簡報（Bug）

```markdown
## Agent Brief

**Category:** bug
**Summary:** 技能描述擷斷會截斷字詞中間，產生損壞的輸出

**Current behavior:**
當技能描述超過 1024 個字元時，無論單字邊界為何，它都會在剛好
1024 個字元處被擷斷。這會產生在單字中間結束的描述
（例如 "Use when the user wants to confi"）。

**Desired behavior:**
擷斷應該在 1024 個字元前的最後一個單字邊界處中斷
並附加 "..." 以表示擷斷。

**Key interfaces:**
- `SkillMetadata` 型別的 `description` 欄位 — 不需要型別變更，
  但填入它的驗證/處理邏輯需要尊重
  單字邊界
- 任何讀取 SKILL.md frontmatter 並擷取描述的函式

**Acceptance criteria:**
- [ ] 低於 1024 字元的描述保持不變
- [ ] 超過 1024 字元的描述在 1024 字元前的最後一個單字邊界處被擷斷
      1024 字元之前
- [ ] 擷斷的描述以 "..." 結尾
- [ ] 包含 "..." 的總長度不超過 1024 個字元

**Out of scope:**
- 改變 1024 字元限制本身
- 多行描述支援
```

### 良好的 Agent 簡報（增強功能）

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** 新增 `.out-of-scope/` 目錄支援，用於追蹤被拒絕的功能請求

**Current behavior:**
當功能請求被拒絕時，議題會帶有 `wontfix` 標籤並加上留言關閉。
對於決策或推理沒有持久記錄。
未來的類似請求需要維護者回憶或搜尋
先前的討論。

**Desired behavior:**
被拒絕的功能請求應記載在 `.out-of-scope/<concept>.md`
檔案中，擷取決策、推理以及連至請求該功能的所有議題的連結。
當分揀新議題時，這些檔案應該被
檢查是否有符合項。

**Key interfaces:**
- `.out-of-scope/` 中的 Markdown 檔案格式 — 每個檔案都應該有一個
  `# Concept Name` 標題、`**Decision:**` 行、`**Reason:**` 行，
  以及帶有議題連結的 `**Prior requests:**` 清單
- 分揀工作流程應該儘早讀取所有 `.out-of-scope/*.md` 檔案
  並根據概念相似度比對傳入的議題與這些檔案

**Acceptance criteria:**
- [ ] 將功能關閉為 wontfix 會建立/更新 `.out-of-scope/` 中的檔案
- [ ] 該檔案包含決策、推理以及連至關閉議題的連結
- [ ] 如果匹配的 `.out-of-scope/` 檔案已存在，新議題會
      附加至其 "Prior requests" 清單，而非建立重複檔案
- [ ] 在分揀期間，當新議題符合先前的拒絕時，會檢查並浮現現有的 `.out-of-scope/` 檔案

**Out of scope:**
- 自動化匹配（由人類確認匹配）
- 重新開啟先前被拒絕的功能
- Bug 報告（僅功能拒絕進入 `.out-of-scope/`）
```

### 良好的 Agent 簡報（PR）

對於 PR，「Current behavior」描述了差異的狀態，且簡報要求 Agent 完成或修復它，而不是從頭建構。

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** 完成貢獻者針對 `triage list` 的 `--json` 輸出旗標

**Current behavior:**
該 PR 新增了一個 `--json` 旗標，將議題清單序列化為 JSON。理想
路徑可運作，且差異符合專案的命令結構。殘留兩個缺口：
錯誤仍列印為人類文字（非 JSON），且新旗標沒有
測試覆蓋率。

**Desired behavior:**
使用 `--json` 時，所有輸出 — 包含錯誤 — 在 stdout 上都是格式良好的 JSON，
且命令的結束碼保持不變。當缺乏旗標時，現有的
人類可讀輸出保持原封不動。

**Key interfaces:**
- 命令的錯誤路徑在 `--json` 下應發出 `{ "error": string }`
  而不是純文字錯誤
- 重用 PR 已經新增的現有序列化器；不要引入第二個

**Acceptance criteria:**
- [ ] `triage list --json` 針對成功與錯誤情況皆發出有效的 JSON
- [ ] 結束碼與非 JSON 命令相符
- [ ] 測試覆蓋 `--json` 成功輸出與一個錯誤情況
- [ ] 預設（非 JSON）輸出位元組對位元組保持不變

**Out of scope:**
- 將 `--json` 新增至任何其他命令
- 改變 PR 已經定義的成功負載的 JSON 形狀
```

### 糟糕的 Agent 簡報

```markdown
## Agent Brief

**Summary:** 修復分揀 Bug

**What to do:**
分揀那邊損壞了。看看主要檔案並修復它。
大約 150 行附近的函式有問題。

**Files to change:**
- src/triage/handler.ts (第 150 行)
- src/types.ts (第 42 行)
```

這很糟糕，因為：

- 沒有類別
- 描述模糊（「分揀那邊損壞了」）
- 引用了會過時的檔案路徑與行號
- 沒有驗收標準
- 沒有範疇邊界
- 沒有當前 vs 期望行為的描述
