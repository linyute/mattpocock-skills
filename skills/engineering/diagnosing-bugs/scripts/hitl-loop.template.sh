#!/usr/bin/env bash
# 人機協同 (Human-in-the-loop) 重現迴圈。
# 複製此檔案，編輯下方步驟，然後執行它。
# Agent 執行此腳本；使用者在終端機中跟隨提示操作。
#
# 使用方式：
#   bash hitl-loop.template.sh
#
# 兩個輔助函式：
#   step "<指示>"          → 顯示指示，等待按下 Enter
#   capture 變數 "<問題>"      → 顯示問題，將回應讀取至變數
#
# 在最後，擷取到的數值會印出為 KEY=VALUE 供 Agent 解析。
#
# `capture` 會將其數值印回終端機，由 Agent 讀取 — 因此
# 擷取觀察結果，並將登入操作留給使用者作為一個 `step`。

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [完成時請按 Enter] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- 請在下方編輯 ---------------------------------------------------------

step "開啟位於 http://localhost:3000 的應用程式並登入。"

capture ERRORED "點擊「匯出」按鈕。是否拋出錯誤？(y/n)"

capture ERROR_MSG "貼上錯誤訊息（或輸入 'none'）："

# --- 請在上方編輯 ---------------------------------------------------------

printf '\n--- 已擷取 ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
