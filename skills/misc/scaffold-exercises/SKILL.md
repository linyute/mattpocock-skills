---
name: 'scaffold-exercises'
description: '建立可通過檢查的練習目錄結構，包含章節、問題、解答與解說。當使用者想要架構練習、建立練習虛設常式或設定新的課程章節時使用。'
---

# 架構練習鷹架

建立可通過 `pnpm ai-hero-cli internal lint` 的練習目錄結構，接著以 `git commit` 進行提交。

## 目錄命名

- **章節**：位於 `exercises/` 內的 `XX-section-name/`（例如 `01-retrieval-skill-building`）
- **練習**：位於章節內的 `XX.YY-exercise-name/`（例如 `01.03-retrieval-with-bm25`）
- 章節編號 = `XX`，練習編號 = `XX.YY`
- 名稱使用連字號分隔（小寫，連字號）

## 練習變體

每個練習都需要至少以下其中一個子資料夾：

- `problem/` - 含有 TODO 的學生工作區
- `solution/` - 參考實作
- `explainer/` - 概念素材，無 TODO

建立虛設常式時，除非計畫另有指明，否則預設使用 `explainer/`。

## 必要檔案

每個子資料夾（`problem/`、`solution/`、`explainer/`）都需要一個符合以下條件的 `readme.md`：

- **非空白**（必須有實際內容，即使只有一行標題也行）
- 沒有無效連結

建立虛設常式時，建立一個包含標題與描述的最簡 readme：

```md
# Exercise Title

Description here
```

若子資料夾包含程式碼，它還需要一個 `main.ts`（>1 行）。但對於虛設常式而言，僅有 readme 的練習是可行的。

## 工作流程

1. **剖析計畫** - 擷取章節名稱、練習名稱與變體類型
2. **建立目錄** - 針對每個路徑執行 `mkdir -p`
3. **建立虛設常式 readme** - 每個變體資料夾一個帶有標題的 `readme.md`
4. **執行檢查** - 執行 `pnpm ai-hero-cli internal lint` 進行驗證
5. **修復任何錯誤** - 持續迭代直到通過檢查

## 檢查規則摘要

檢查工具（`pnpm ai-hero-cli internal lint`）會檢查：

- 每個練習都有子資料夾（`problem/`、`solution/`、`explainer/`）
- 至少存在 `problem/`、`explainer/` 或 `explainer.1/` 之一
- 主要子資料夾中存在 `readme.md` 且非空白
- 沒有 `.gitkeep` 檔案
- 沒有 `speaker-notes.md` 檔案
- readme 中沒有無效連結
- readme 中沒有 `pnpm run exercise` 指令
- 除非是僅有 readme 的情況，否則每個子資料夾都需要 `main.ts`

## 移動/重新命名練習

當重新編號或移動練習時：

1. 使用 `git mv`（而非 `mv`）重新命名目錄 - 保留 git 歷史記錄
2. 更新數字前綴以維持順序
3. 移動後重新執行檢查

範例：

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## 範例：從計畫建立虛設常式

給定如下計畫：

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

接著建立 readme 虛設常式：

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md -> "# Introduction to Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md -> "# Long-term Memory"
```
