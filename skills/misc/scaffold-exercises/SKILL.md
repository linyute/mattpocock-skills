---
name: 'scaffold-exercises'
description: '建立包含章節、問題、解答與解釋器且通過 Linter 的練習目錄結構。當使用者想要腳手架練習、建立練習存根，或設定新課程章節時使用。'
---

# 腳手架練習

建立通過 `pnpm ai-hero-cli internal lint` 的練習目錄結構，然後使用 `git commit` 進行提交。

## 目錄命名

- **章節（Sections）**：`exercises/` 內部的 `XX-section-name/`（例如 `01-retrieval-skill-building`）
- **練習（Exercises）**：章節內部的 `XX.YY-exercise-name/`（例如 `01.03-retrieval-with-bm25`）
- 章節編號 = `XX`，練習編號 = `XX.YY`
- 名稱為 dash-case（小寫，連字號）

## 練習變體

每個練習需要至少下列子資料夾之一：

- `problem/` - 帶有 TODO 的學生工作區
- `solution/` - 參考實作
- `explainer/` - 概念性材料，無 TODO

建立存根時，除非計劃另有說明，否則預設為 `explainer/`。

## 必需的檔案

每個子資料夾（`problem/`、`solution/`、`explainer/`）都需要一個滿足以下條件的 `readme.md`：

- **非空**（必須有真實內容，即使只有單一標題行也可運作）
- 沒有損壞的連結

建立存根時，建立包含標題與描述的最小 README：

```md
# Exercise Title

在此處寫下描述
```

如果子資料夾有程式碼，它還需要一個 `main.ts`（>1 行）。但對於存根，僅有 README 的練習是可以的。

## 工作流程

1. **解析計劃** — 擷取章節名稱、練習名稱與變體型態
2. **建立目錄** — 為每個路徑執行 `mkdir -p`
3. **建立存根 README** — 每個變體資料夾一個帶有標題的 `readme.md`
4. **執行 Lint** — `pnpm ai-hero-cli internal lint` 以進行驗證
5. **修復任何錯誤** — 迭代直到 Lint 通過

## Lint 規則摘要

Linter（`pnpm ai-hero-cli internal lint`）檢查：

- 每個練習都有子資料夾（`problem/`、`solution/`、`explainer/`）
- 至少存在 `problem/`、`explainer/` 或 `explainer.1/` 之一
- 主子資料夾中存在 `readme.md` 且非空
- 沒有 `.gitkeep` 檔案
- 沒有 `speaker-notes.md` 檔案
- README 中沒有損壞的連結
- README 中沒有 `pnpm run exercise` 命令
- 每個子資料夾都需要 `main.ts`，除非它是僅包含 README 的

## 移動/重命名練習

當重新編號或移動練習時：

1. 使用 `git mv`（而非 `mv`）重命名目錄 — 保留 Git 歷史紀錄
2. 更新數字字首以保持順序
3. 移動後重新執行 Lint

範例：

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## 範例：從計劃建立存根

給定如下計劃：

```
Section 05: Memory Skill Building
- 05.01 Introduction to Memory
- 05.02 Short-term Memory (explainer + problem + solution)
- 05.03 Long-term Memory
```

建立：

```bash
mkdir -p exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer
mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
mkdir -p exercises/05-memory-skill-building/05.03-long-term-memory/explainer
```

然後建立 README 存根：

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md -> "# Introduction to Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md -> "# Long-term Memory"
```
