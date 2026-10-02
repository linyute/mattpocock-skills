# 撰寫 Agent 簡報

Agent 簡報是在 GitHub issue 或 PR 轉移至 `ready-for-agent` 時所發布的結構化留言。它是離線 Agent 工作時所依據的權威規格說明。原始內文和討論僅是情境脈絡：Agent 簡報才是真正的契約。

此簡報陳述了 **Agent 應該做什麼**，這延伸至兩個層面：對於 issue 而言，這是從無到有建構變更；對於 PR 而言，這是*針對現有差異*還需要完成的工作：完成它、消除差距、處理審查重點。兩種情況下的原則相同；下方的 PR 範例展示了其中的差異。

## 原則

### 耐久性重於精確性

此 issue 可能會在 `ready-for-agent` 狀態停留數天或數週。與此同時，程式碼庫將會變更。撰寫簡報時應使其在檔案重命名、移動或重構時依然有用。

- **要**描述介面、型別與行為契約
- **要**指明 Agent 應尋找或修改的特定型別、函式簽名或設定結構
- **不要**參照檔案路徑：它們會過期
- **不要**參照行號
- **不要**假設當前的實作結構將維持不變

### 行為導向，而非程序導向

描述系統應該做**什麼**，而非**如何**實作它。Agent 將會重新探索程式碼庫並做出自己的實作決策。

- **良好：**「`SkillConfig` 型別應接受 `CronExpression` 型別的選用 `schedule` 欄位」
- **不良：**「開啟 src/types/skill.ts 並在第 42 行新增一個 schedule 欄位」
- **良好：**「當使用者在沒有引數的情況下執行 `/triage` 時，他們應該看到需要注意的 issue 摘要」
- **不良：**「在主要處理常式函式中新增一個 switch 陳述式」

### 完整的驗收準則

Agent 需要知道何時算完成。每份 Agent 簡報都必須具有具體、可測試的驗收準則。每個準則應能獨立驗證。

- **良好：**「執行 `gh issue list --label needs-triage` 會傳回已通過初始分類的 issue」
- **不良：**「分流應該正常運作」

### 明確的範圍邊界

陳述哪些內容超出範圍。這可以防止 Agent 畫蛇添足或對相鄰功能做出假設。

## 範本

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** one-line description of what needs to happen

**Current behavior:**
Describe what happens now. For bugs, this is the broken behavior.
For enhancements, this is the status quo the feature builds on.

**Desired behavior:**
Describe what should happen after the agent's work is complete.
Be specific about edge cases and error conditions.

**Key interfaces:**
- `TypeName`: what needs to change and why
- `functionName()` return type: what it currently returns vs what it should return
- Config shape: any new configuration options needed

**Acceptance criteria:**
- [ ] Specific, testable criterion 1
- [ ] Specific, testable criterion 2
- [ ] Specific, testable criterion 3

**Out of scope:**
- Thing that should NOT be changed or addressed in this issue
- Adjacent feature that might seem related but is separate
```

## 範例

### 良好的 Agent 簡報 (bug)

```markdown
## Agent Brief

**Category:** bug
**Summary:** Skill description truncation drops mid-word, producing broken output

**Current behavior:**
When a skill description exceeds 1024 characters, it is truncated at exactly
1024 characters regardless of word boundaries. This produces descriptions
that end mid-word (e.g. "Use when the user wants to confi").

**Desired behavior:**
Truncation should break at the last word boundary before 1024 characters
and append "..." to indicate truncation.

**Key interfaces:**
- The `SkillMetadata` type's `description` field: no type change needed,
  but the validation/processing logic that populates it needs to respect
  word boundaries
- Any function that reads SKILL.md frontmatter and extracts the description

**Acceptance criteria:**
- [ ] Descriptions under 1024 chars are unchanged
- [ ] Descriptions over 1024 chars are truncated at the last word boundary
      before 1024 chars
- [ ] Truncated descriptions end with "..."
- [ ] The total length including "..." does not exceed 1024 chars

**Out of scope:**
- Changing the 1024 char limit itself
- Multi-line description support
```

### 良好的 Agent 簡報 (enhancement)

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** Add `.out-of-scope/` directory support for tracking rejected feature requests

**Current behavior:**
When a feature request is rejected, the issue is closed with a `wontfix` label
and a comment. There is no persistent record of the decision or reasoning.
Future similar requests require the maintainer to recall or search for the
prior discussion.

**Desired behavior:**
Rejected feature requests should be documented in `.out-of-scope/<concept>.md`
files that capture the decision, reasoning, and links to all issues that
requested the feature. When triaging new issues, these files should be
checked for matches.

**Key interfaces:**
- Markdown file format in `.out-of-scope/`: each file should have a
  `# Concept Name` heading, a `**Decision:**` line, a `**Reason:**` line,
  and a `**Prior requests:**` list with issue links
- The triage workflow should read all `.out-of-scope/*.md` files early
  and match incoming issues against them by concept similarity

**Acceptance criteria:**
- [ ] Closing a feature as wontfix creates/updates a file in `.out-of-scope/`
- [ ] The file includes the decision, reasoning, and link to the closed issue
- [ ] If a matching `.out-of-scope/` file already exists, the new issue is
      appended to its "Prior requests" list rather than creating a duplicate
- [ ] During triage, existing `.out-of-scope/` files are checked and surfaced
      when a new issue matches a prior rejection

**Out of scope:**
- Automated matching (human confirms the match)
- Reopening previously rejected features
- Bug reports (only enhancement rejections go to `.out-of-scope/`)
```

### 良好的 Agent 簡報 (PR)

對於 PR，「目前行為」描述了差異的狀態，簡報要求 Agent 完成或修復它，而非從頭建構。

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** Finish the contributor's `--json` output flag for `triage list`

**Current behavior:**
The PR adds a `--json` flag that serializes the issue list to JSON. The happy
path works and the diff matches the project's command structure. Two gaps
remain: errors are still printed as human text (not JSON), and the new flag has
no test coverage.

**Desired behavior:**
With `--json`, all output (including errors) is well-formed JSON on stdout,
and the command's exit codes are unchanged. The existing human-readable output
is untouched when the flag is absent.

**Key interfaces:**
- The command's error path should emit `{ "error": string }` under `--json`
  instead of the plain-text error
- Reuse the existing serializer the PR already added; don't introduce a second

**Acceptance criteria:**
- [ ] `triage list --json` emits valid JSON for both success and error cases
- [ ] Exit codes match the non-JSON command
- [ ] A test covers the `--json` success output and one error case
- [ ] Default (non-JSON) output is byte-for-byte unchanged

**Out of scope:**
- Adding `--json` to any other command
- Changing the JSON shape of the success payload the PR already defined
```

### 不良的 Agent 簡報

```markdown
## Agent Brief

**Summary:** Fix the triage bug

**What to do:**
The triage thing is broken. Look at the main file and fix it.
The function around line 150 has the issue.

**Files to change:**
- src/triage/handler.ts (line 150)
- src/types.ts (line 42)
```

這樣是不良的，因為：
- 沒有類別
- 描述模糊（「分流的東西壞了」）
- 參照將會過期的檔案路徑和行號
- 沒有驗收準則
- 沒有範圍邊界
- 沒有目前行為與預期行為的說明
