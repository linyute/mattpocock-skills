#!/usr/bin/env bash
#
# 精靈 — 逐步引導使用者完成人工流程。
# 由 /wizard 技能產生。
#
# "STAGES" 標記以上的所有內容均為精靈函式庫：請勿手動編輯
# 它。請在該標記下方撰寫各步驟的階段。

set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────
# 精靈函式庫 — 順暢且一致的 UX。在每個精靈中皆相同。
# ──────────────────────────────────────────────────────────────────────────

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
  BOLD=$(tput bold); DIM=$(tput dim); RESET=$(tput sgr0)
  BLUE=$(tput setaf 4); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); RED=$(tput setaf 1)
else
  BOLD=""; DIM=""; RESET=""; BLUE=""; GREEN=""; YELLOW=""; RED=""
fi

# 作者在階段區段的頂部設定此變數。
TOTAL_STAGES=0

_STAGE_INDEX=0
ENV_FILE="${ENV_FILE:-.env}"
WRITTEN_ENV=()    # 本次執行寫入 ENV_FILE 的鍵名 (KEY)
WRITTEN_SECRET=() # 本次執行設定的密鑰名稱 (NAME)
SKIPPED=()        # 無法執行的項目（例如缺少 gh）

# _clear — 清除終端機畫面，使螢幕上僅顯示目前步驟。當
# 輸出非終端機時不執行任何操作，以保持管道日誌的可讀性。
_clear() {
  [[ -t 1 ]] || return 0
  if command -v tput >/dev/null 2>&1; then tput clear; else printf '\033[2J\033[3J\033[H'; fi
}

# banner "Title" — 開場畫面：說明此精靈的功能。
banner() {
  _clear
  printf '\n%s%s  %s%s\n' "$BOLD" "$BLUE" "$1" "$RESET"
  printf '%s  %s 個階段%s\n\n' "$DIM" "$TOTAL_STAGES" "$RESET"
  printf '%s  由您操作瀏覽器；此精靈會確切告知您該做什麼，並\n' "$DIM"
  printf '  擷取您複製回來的數值。隨時可使用 Ctrl-C 停止，稍後\n'
  printf '  重新執行 — 它會記住已儲存的數值。%s\n' "$RESET"
  pause "準備好開始了嗎？"
}

# stage "Name" — 清除螢幕，然後宣告階段並顯示進度。
# 清除螢幕可讓螢幕上僅保留目前步驟。
stage() {
  _clear
  _STAGE_INDEX=$((_STAGE_INDEX + 1))
  printf '\n%s%s▸ 階段 %s/%s · %s%s\n' \
    "$BOLD" "$BLUE" "$_STAGE_INDEX" "$TOTAL_STAGES" "$1" "$RESET"
}

# say "..." — 普通的指示文字行。
say()  { printf '  %s\n' "$1"; }
# step "..." — 使用者在瀏覽器中執行的操作步驟。
step() { printf '  %s•%s %s\n' "$BLUE" "$RESET" "$1"; }
note() { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }
warn() { printf '  %s⚠ %s%s\n' "$YELLOW" "$1" "$RESET"; }

# open_url URL — 在使用者的瀏覽器中開啟，支援跨平台（包含 WSL）。
open_url() {
  local url="$1"
  printf '  %s↗ 正在開啟%s %s\n' "$GREEN" "$RESET" "$url"
  { if   command -v wslview     >/dev/null 2>&1; then wslview "$url"
    elif command -v explorer.exe >/dev/null 2>&1; then explorer.exe "$url"
    elif command -v xdg-open    >/dev/null 2>&1; then xdg-open "$url"
    elif command -v open        >/dev/null 2>&1; then open "$url"
    else warn "無法開啟瀏覽器 — 請手動存取：$url"; fi
  } >/dev/null 2>&1 || warn "無法開啟瀏覽器 — 請手動存取：$url"
}

# pause "msg" — 等待使用者確認已完成人工操作部分。
pause() {
  printf '  %s%s%s ' "$DIM" "${1:-按下 Enter 以繼續}" "$RESET"
  read -r _ || true
}

# confirm "question" — y/N 確認關卡；若為 yes 則傳回成功。
confirm() {
  local reply=""
  printf '  %s? %s [y/N] ' "$YELLOW" "$1"
  read -r reply || true
  [[ "$reply" =~ ^[Yy] ]]
}

# _existing KEY — ENV_FILE 中 KEY 的目前數值（若有）。
_existing() {
  [[ -f "$ENV_FILE" ]] || return 1
  local line; line=$(grep -E "^${1}=" "$ENV_FILE" | tail -n1) || return 1
  printf '%s' "${line#*=}"
}

# ask KEY "Prompt" — 將數值讀取至 $KEY。重新執行時提供現有 .env
# 的數值作為預設值（按 Enter 保持原值）。可見輸入（非秘密）。
ask() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[按 Enter 保持目前數值]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -r input || true
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# ask_secret KEY "Prompt" — 類似 ask，但輸入內容會隱藏。
ask_secret() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[按 Enter 保持目前數值]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -rs input || true
  printf '\n'
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# write_env KEY VALUE — 將 KEY=VALUE 更新/插入至 ENV_FILE（若不存在則建立；
# 覆蓋任何現有資料行）。具等冪性 (Idempotent)。
write_env() {
  local key="$1" value="$2" tmp
  touch "$ENV_FILE"
  tmp=$(mktemp)
  grep -vE "^${key}=" "$ENV_FILE" > "$tmp" || true
  printf '%s=%s\n' "$key" "$value" >> "$tmp"
  mv "$tmp" "$ENV_FILE"
  WRITTEN_ENV+=("$key")
  printf '  %s✓ 已寫入%s %s → %s\n' "$GREEN" "$RESET" "$key" "$ENV_FILE"
}

# set_secret NAME VALUE — 透過 gh 設定 GitHub Actions 儲存庫密鑰。若 gh
# 不可用或未驗證，則降級發出警告（並予以記錄）。
set_secret() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if printf '%s' "$value" | gh secret set "$name" >/dev/null 2>&1; then
      WRITTEN_SECRET+=("$name")
      printf '  %s✓ 已設定%s GitHub 密鑰 %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub 密鑰 $name (請手動設定：gh secret set $name)")
  warn "已跳過 GitHub 密鑰 $name — gh 未準備就緒；請稍後設定"
}

# set_var NAME VALUE — 設定 GitHub Actions 儲存庫變數（非秘密）。
set_var() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if gh variable set "$name" --body "$value" >/dev/null 2>&1; then
      printf '  %s✓ 已設定%s GitHub 變數 %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub 變數 $name")
  warn "已跳過 GitHub 變數 $name — gh 未準備就緒；請稍後設定"
}

# finish — 清除螢幕，然後提供所有已設定內容的結束摘要。
finish() {
  _clear
  printf '\n%s%s  ✓ 設定完成%s\n' "$BOLD" "$GREEN" "$RESET"
  (( ${#WRITTEN_ENV[@]} ))    && note "已寫入 ${#WRITTEN_ENV[@]} 個數值至 $ENV_FILE: ${WRITTEN_ENV[*]}"
  (( ${#WRITTEN_SECRET[@]} )) && note "已設定 ${#WRITTEN_SECRET[@]} 個 GitHub 密鑰: ${WRITTEN_SECRET[*]}"
  if (( ${#SKIPPED[@]} )); then
    printf '\n'; warn "仍需手動完成的項目："
    for s in "${SKIPPED[@]}"; do note "  - $s"; done
  fi
  printf '\n'
}

# ──────────────────────────────────────────────────────────────────────────
# STAGES — 請撰寫此區段。使用者進行的每個步驟對應一個 stage()。
# 請替換下方的範例。將 TOTAL_STAGES 設定為與您撰寫的階段數量一致。
# ──────────────────────────────────────────────────────────────────────────

TOTAL_STAGES=1

banner "Stripe 設定"

# ── 範例階段：請替換為您的實際步驟 ───────────────────────────
stage "Stripe — API 金鑰"
say "我們將取得您的 Stripe 測試金鑰，並儲存供本機開發 + CI 使用。"
open_url "https://dashboard.stripe.com/test/apikeys"
step "在 API 金鑰頁面上，複製可公開金鑰 (以 pk_test_ 開頭)。"
ask STRIPE_PUBLISHABLE_KEY "貼上可公開金鑰："
step "點擊 Secret key 哪一行的 'Reveal test key'，然後複製它。"
ask_secret STRIPE_SECRET_KEY "貼上秘密金鑰："
write_env STRIPE_PUBLISHABLE_KEY "$STRIPE_PUBLISHABLE_KEY"
write_env STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"
set_secret STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"   # CI 需要此項目
# ──────────────────────────────────────────────────────────────────────────

finish
