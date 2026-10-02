#!/usr/bin/env bash
#
# 精靈（wizard）逐步引導人員完成手動流程。
# 由 /wizard 技能產生。
#
# 「STAGES」標記以上的所有內容均為精靈函式庫：請勿手動編輯它。
# 請在該標記下方編寫每個步驟的階段。

set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────
# 精靈函式庫：愉快、一致的使用者體驗，在每個精靈中皆完全相同。
# ──────────────────────────────────────────────────────────────────────────

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
  BOLD=$(tput bold); DIM=$(tput dim); RESET=$(tput sgr0)
  BLUE=$(tput setaf 4); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); RED=$(tput setaf 1)
else
  BOLD=""; DIM=""; RESET=""; BLUE=""; GREEN=""; YELLOW=""; RED=""
fi

# 作者在 stages 章節頂端設定此項。
TOTAL_STAGES=0

_STAGE_INDEX=0
ENV_FILE="${ENV_FILE:-.env}"
WRITTEN_ENV=()    # 本次執行寫入 ENV_FILE 的鍵
WRITTEN_SECRET=() # 本次執行設定的 Secret 名稱
SKIPPED=()        # 我們無法執行的事項（例如缺少 gh）

# _clear 清除終端機畫面，讓螢幕上僅顯示當前步驟。若輸出非終端機則為
# 無操作（No-op），確保管線傳輸的日誌維持可讀性。
_clear() {
  [[ -t 1 ]] || return 0
  if command -v tput >/dev/null 2>&1; then tput clear; else printf '\033[2J\033[3J\033[H'; fi
}

# banner "標題" 顯示開場框架：此精靈的作用。
banner() {
  _clear
  printf '\n%s%s  %s%s\n' "$BOLD" "$BLUE" "$1" "$RESET"
  printf '%s  %s 個階段%s\n\n' "$DIM" "$TOTAL_STAGES" "$RESET"
  printf '%s  您負責操作瀏覽器；此精靈會確切告訴您要做什麼，\n' "$DIM"
  printf '  並擷取您複製回來的數值。可隨時按 Ctrl-C 停止，稍後\n'
  printf '  重新執行，因為它會記住已儲存的數值。%s\n' "$RESET"
  pause "準備好開始了嗎？"
}

# stage "名稱" 清除螢幕，接著宣告一個階段並顯示進度。
# 清除畫面可保持螢幕上僅顯示當前步驟。
stage() {
  _clear
  _STAGE_INDEX=$((_STAGE_INDEX + 1))
  printf '\n%s%s▸ 階段 %s/%s · %s%s\n' \
    "$BOLD" "$BLUE" "$_STAGE_INDEX" "$TOTAL_STAGES" "$1" "$RESET"
}

# say "..." 印出純文字指示行。
say()  { printf '  %s\n' "$1"; }
# step "..." 是人員在瀏覽器中執行的帶有編號感的操作。
step() { printf '  %s•%s %s\n' "$BLUE" "$RESET" "$1"; }
note() { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }
warn() { printf '  %s⚠ %s%s\n' "$YELLOW" "$1" "$RESET"; }

# open_url URL 在人員的瀏覽器中開啟該網址，支援跨平台（包含 WSL）。
open_url() {
  local url="$1"
  printf '  %s↗ 正在開啟%s %s\n' "$GREEN" "$RESET" "$url"
  { if   command -v wslview     >/dev/null 2>&1; then wslview "$url"
    elif command -v explorer.exe >/dev/null 2>&1; then explorer.exe "$url"
    elif command -v xdg-open    >/dev/null 2>&1; then xdg-open "$url"
    elif command -v open        >/dev/null 2>&1; then open "$url"
    else warn "無法開啟瀏覽器；請手動造訪：$url"; fi
  } >/dev/null 2>&1 || warn "無法開啟瀏覽器，請手動造訪：$url"
}

# pause "msg" 等待人員確認已完成手動部分。
pause() {
  printf '  %s%s%s ' "$DIM" "${1:-按 Enter 鍵繼續}" "$RESET"
  read -r _ || true
}

# confirm "問題" 是一個 y/N 檢查點；回答 yes 時回傳成功。
confirm() {
  local reply=""
  printf '  %s? %s [y/N] ' "$YELLOW" "$1"
  read -r reply || true
  [[ "$reply" =~ ^[Yy] ]]
}

# _existing KEY: ENV_FILE 中 KEY 的目前值（若有）。
_existing() {
  [[ -f "$ENV_FILE" ]] || return 1
  local line; line=$(grep -E "^${1}=" "$ENV_FILE" | tail -n1) || return 1
  printf '%s' "${line#*=}"
}

# ask KEY "Prompt" 將值讀取至 $KEY。重新執行時提供現有的 .env 值
# 作為預設值（按 Enter 保留）。可見輸入（非秘密）。
ask() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[按 Enter 保留目前值]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -r input || true
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# ask_secret KEY "Prompt" 與 ask 類似，但輸入會隱藏。
ask_secret() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[按 Enter 保留目前值]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -rs input || true
  printf '\n'
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# write_env KEY VALUE 將 KEY=VALUE 更新或插入 ENV_FILE（若不存在則建立；替換
# 任何現有行）。具等冪性。
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

# set_secret NAME VALUE 透過 gh 設定 GitHub Actions 儲存庫 Secret。若 gh
# 無法使用或未驗證，則降級為發出警告（並記錄下來）。
set_secret() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if printf '%s' "$value" | gh secret set "$name" >/dev/null 2>&1; then
      WRITTEN_SECRET+=("$name")
      printf '  %s✓ 已設定%s GitHub secret %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub secret $name (手動設定：gh secret set $name)")
  warn "已略過 GitHub secret $name：gh 尚未就緒；請稍後設定"
}

# set_var NAME VALUE 設定 GitHub Actions 儲存庫變數（非秘密）。
set_var() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if gh variable set "$name" --body "$value" >/dev/null 2>&1; then
      printf '  %s✓ 已設定%s GitHub variable %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub variable $name")
  warn "已略過 GitHub variable $name，gh 尚未就緒；請稍後設定"
}

# finish 清除畫面，接著顯示所有已設定項目的結束摘要。
finish() {
  _clear
  printf '\n%s%s  ✓ 設定完成%s\n' "$BOLD" "$GREEN" "$RESET"
  (( ${#WRITTEN_ENV[@]} ))    && note "已寫入 ${#WRITTEN_ENV[@]} 個數值至 $ENV_FILE: ${WRITTEN_ENV[*]}"
  (( ${#WRITTEN_SECRET[@]} )) && note "已設定 ${#WRITTEN_SECRET[@]} 個 GitHub secret: ${WRITTEN_SECRET[*]}"
  if (( ${#SKIPPED[@]} )); then
    printf '\n'; warn "仍需手動完成的事項："
    for s in "${SKIPPED[@]}"; do note "  - $s"; done
  fi
  printf '\n'
}

# ──────────────────────────────────────────────────────────────────────────
# STAGES：請在此章節編寫。人員執行的每個步驟對應一個 stage()。
# 替換下方的範例。設定 TOTAL_STAGES 以符合您編寫的階段數量。
# ──────────────────────────────────────────────────────────────────────────

TOTAL_STAGES=1

banner "Stripe 設定"

# ── 範例階段：請替換為您的實際步驟 ───────────────────────────
stage "Stripe：API 金鑰"
say "我們將取得您的 Stripe 測試金鑰並儲存以供本機開發 + CI 使用。"
open_url "https://dashboard.stripe.com/test/apikeys"
step "在 API keys 頁面上，複製可發布金鑰（以 pk_test_ 開頭）。"
ask STRIPE_PUBLISHABLE_KEY "貼上可發布金鑰："
step "在 Secret key 該列按一下「Reveal test key」，然後複製它。"
ask_secret STRIPE_SECRET_KEY "貼上 Secret 金鑰："
write_env STRIPE_PUBLISHABLE_KEY "$STRIPE_PUBLISHABLE_KEY"
write_env STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"
set_secret STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"   # CI 需要此項
# ──────────────────────────────────────────────────────────────────────────

finish
