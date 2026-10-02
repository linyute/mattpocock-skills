#!/usr/bin/env bash
# 人機協同（Human-in-the-loop）重現迴圈。
# 複製此檔案，編輯下方的步驟並執行它。
# 代理執行此指令碼；使用者依照其終端機中的提示進行操作。
#
# 用法：
#   bash hitl-loop.template.sh
#
# 兩個輔助函式：
#   step "<instruction>"          → 顯示指示，等待按下 Enter
#   capture VAR "<question>"      → 顯示問題，將回應讀取至 VAR
#
# 在最後，擷取到的數值會印出為 KEY=VALUE 供代理進行解析。
#
# `capture` 會將其值印回終端機供代理讀取，
# 因此請擷取觀察結果，並將登入交由使用者作為 `step` 處理。

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [完成後請按 Enter] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- 於此行下方編輯 ---------------------------------------------------------

step "開啟應用程式 http://localhost:3000 並登入。"

capture ERRORED "按一下「Export」按鈕。是否拋出錯誤？(y/n)"

capture ERROR_MSG "貼上錯誤訊息（或輸入 'none'）："

# --- 於此行上方編輯 ---------------------------------------------------------

printf '\n--- 已擷取 ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
