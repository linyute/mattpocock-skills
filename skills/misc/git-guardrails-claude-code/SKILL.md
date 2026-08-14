---
name: 'git-guardrails-claude-code'
description: '設定 Claude Code Hook 以在危險的 Git 命令（push、reset --hard、clean、branch -D 等）執行前阻止它們。當使用者希望防止破壞性 Git 操作、新增 Git 安全 Hook，或在 Claude Code 中阻止 Git push/reset 時使用。'
---

# 設定 Git 安全護欄

設定一個 PreToolUse Hook，在 Claude 執行危險 Git 命令前對其進行攔截與阻止。

## 什麼會被阻止

- `git push`（包含 `--force` 的所有變體）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

當被阻止時，Claude 會看到一條訊息告知其沒有權限存取這些命令。

## 步驟

### 1. 詢問範疇

詢問使用者：僅為**此專案**安裝（`.claude/settings.json`）還是為**所有專案**安裝（`~/.claude/settings.json`）？

### 2. 複製 Hook 腳本

隨附的腳本位於：[scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

根據範疇將其複製至目標位置：

- **專案**：`.claude/hooks/block-dangerous-git.sh`
- **全域**：`~/.claude/hooks/block-dangerous-git.sh`

使用 `chmod +x` 使其可執行。

### 3. 向設定新增 Hook

新增至適當的設定檔案：

**專案**（`.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**全域**（`~/.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

如果設定檔案已經存在，將 Hook 合併至現有的 `hooks.PreToolUse` 陣列中 — 不要覆寫其他設定。

### 4. 詢問客製化

詢問使用者是否想要從阻止清單中新增或移除任何模式。據此編輯複製的腳本。

### 5. 驗證

執行快速測試：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

應帶著結束碼 2 離開並在 stderr 印出 BLOCKED 訊息。
