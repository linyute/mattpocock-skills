---
name: 'git-guardrails-claude-code'
description: '設定 Claude Code 勾點，在危險的 git 指令（push、reset --hard、clean、branch -D 等）執行前予以封鎖。當使用者想要防止破壞性的 git 操作、新增 git 安全勾點，或在 Claude Code 中封鎖 git push/reset 時使用。'
---

# 設定 Git 防護機制

設定 PreToolUse 勾點，在 Claude 執行危險的 git 指令前進行攔截並封鎖。

## 被封鎖的項目

- `git push`（包含 `--force` 在內的所有變體）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

當被封鎖時，Claude 會看到一則訊息，告知其無權存取這些指令。

## 步驟

### 1. 詢問範圍

詢問使用者：**僅為此專案**（`.claude/settings.json`）安裝，還是**為所有專案**（`~/.claude/settings.json`）安裝？

### 2. 複製勾點指令碼

隨附的指令碼位於：[scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

根據範圍將其複製到目標位置：

- **專案**：`.claude/hooks/block-dangerous-git.sh`
- **全域**：`~/.claude/hooks/block-dangerous-git.sh`

使用 `chmod +x` 使其具備可執行權限。

### 3. 將勾點新增至設定

新增至相應的設定檔：

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

若設定檔已存在，將該勾點合併至現有的 `hooks.PreToolUse` 陣列中。請勿覆寫其他設定。

### 4. 詢問自訂需求

詢問使用者是否要從封鎖清單中新增或移除任何模式。相應編輯複製的指令碼。

### 5. 驗證

執行快速測試：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

應以代碼 2 結束並在 stderr 印出 BLOCKED 訊息。
