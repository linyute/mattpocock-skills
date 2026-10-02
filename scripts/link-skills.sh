#!/usr/bin/env bash
set -euo pipefail

# 注意：此為僅供開發使用的指令碼，供此儲存庫的維護者使用。
# 這不是受支援的安裝程式。對其進行的修改或修改請求
# 將不予核准。
#
# 將儲存庫中的所有技能連結至各代理環境所使用的本機技能目錄：
#   - ~/.claude/skills: Claude Code
#   - ~/.agents/skills: Codex 與其他相容 Agent Skills 的環境
# 每個條目都是指向此儲存庫的符號連結，因此只需 `git pull`
# 即可保持安裝的技能最新。

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

# 收集一次儲存庫的技能，連結至各個目的地。`deprecated/`
# 已淘汰，而 `misc/` 雖有保留但很少使用且未推廣（請參閱
# 各分桶各自的 README）：兩者皆不屬於日常使用的技能
# 目錄，因此在此皆予以略過，就如同其他所有將未推廣技能
# 排除在外的地方一樣。`in-progress/` 仍然會被連結：它是刻意公開的，
# 徵求意見回饋，而此本機安裝正是該回饋迴圈
# 運作之處。
names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -not -path '*/misc/*' -print0)

for DEST in "${DESTS[@]}"; do
  # 若 $DEST 是解析為此儲存庫的符號連結，我們最終會將各個技能的
  # 符號連結寫回儲存庫本身的 skills/ 目錄樹中。檢測並退出，
  # 而非污染工作副本。
  if [ -L "$DEST" ]; then
    resolved="$(readlink -f "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "錯誤：$DEST 是指向此儲存庫的符號連結 ($resolved)。" >&2
        echo "請將其移除 (rm \"$DEST\") 並重新執行；指令碼將會將其重新建立為真正的目錄。" >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$DEST"

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -rf "$target"
    fi

    ln -sfn "$src" "$target"
    echo "已連結 $name -> $src ($DEST)"
  done
done

