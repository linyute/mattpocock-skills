---
name: 'setup-ts-deep-modules'
description: '將 dependency-cruiser 連線至 TypeScript 儲存庫，使每個套件成為深層模組 — 實作隱藏在子資料夾中，僅能透過其進入點檔案存取。由使用者呼叫。'
disable-model-invocation: true
---

# 設定 TS 深層模組

將此儲存庫中的每個套件都打造為**深層模組（deep module）**：小介面背後隱藏大量行為。套件的公開表面是其**進入點（entry points）** — 套件根目錄處的檔案 — 且其子資料夾中的每件事物都是隱藏的。此技能安裝 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 以及使進入點成為唯一進入方式的規則，然後證明規則發揮作用。

關於詞彙（深層模組、介面、接縫、深度），請使用「codebase-design」呼叫 Skill 工具，並在全文採用其用語。

## 其強制的形狀

```
src/packages/
  <name>/
    index.ts        ← 進入點（公開）。從外部匯入此檔案。
    client.ts       ← 另一個進入點。套件可以暴露多個進入點。
    lib/            ← 實作：對外部隱藏，彼此可自由匯入。
    tests/          ← 同處測試 + 測試用具（子資料夾，故為私有）。
```

公開表面是套件的**根目錄檔案** — 而非單一指定的 `index.ts`。按照慣例，實作存在於 `lib/`，測試存在於 `tests/`，給予每個套件相同的雙資料夾形狀。不過規則本身是通用的：*任何*子資料夾中的*任何事物*都是私有的，因此您絕不需要擴充設定來新增資料夾。

四條規則，皆為 `error`：

1. **進入點邊界** — 套件外部的程式碼（應用程式程式碼或另一個套件）僅能匯入該套件的進入點（其根目錄檔案），絕不能匯入其子資料夾中的任何事物。
2. **套件內部自由** — 套件本身的檔案可自由相互匯入。
3. **透過進入點測試** — `<pkg>/tests/` 下的檔案可匯入任何套件的進入點及其自身的 `tests/` 測試用具，但絕不能匯入任何套件的子資料夾內部（甚至是他們自己的）。跨套件的整合測試是可以的；深層匯入則不行。
4. **無循環依賴** — 沒有依賴循環。

**進入點，而非桶子檔案（barrel）。** 因為公開表面是*每個*根目錄檔案，套件可以暴露幾個微小的進入點（`index.ts`、`client.ts`、`server.ts`），而不是將所有事物都擠過一個巨型的 `index.ts`。不鼓勵重新匯出整個子樹的桶子檔案 — 保持進入點微小並將實作隱藏在子資料夾中。

分層（哪些套件可以依賴哪些套件）是*另一個*關切事項，並在設定中留作註解存根供此儲存庫填入。

## 步驟

### 1. 偵測環境

- **套件管理員** — `pnpm-lock.yaml` → pnpm、`yarn.lock` → yarn、`bun.lockb` → bun，否則為 npm。在下方的每個命令中使用它（`pnpm`/`yarn`/`npm run`/`bunx`）。
- **套件根目錄** — 如果 `src/` 存在則使用 `src/packages`，否則使用 `packages`。如果儲存庫已經有不同的明顯慣例，請與使用者確認選擇。
- **現有設定** — 檢查是否存在 `.dependency-cruiser.*` 檔案。如果存在，**切勿**覆寫它：將四條規則與選項合併進去，並告知使用者您新增了什麼。

**完成條件：** 套件管理員、套件根目錄與現有設定狀態皆已獲悉。

### 2. 安裝 dependency-cruiser

使用偵測到的套件管理員將 `dependency-cruiser` 安裝為 devDependency。

**完成條件：** `dependency-cruiser` 位於 `devDependencies` 中。

### 3. 撰寫設定

將 [`dependency-cruiser.config.cjs`](./dependency-cruiser.config.cjs) 複製至儲存庫根目錄作為 `.dependency-cruiser.cjs`。將 `PACKAGES_ROOT` 設定為步驟 1 偵測到的根目錄。規則是基於路徑深度的且與副檔名無關，因此無需調整其他任何內容。

**完成條件：** `.dependency-cruiser.cjs` 存在且帶有正確的 `PACKAGES_ROOT`，且四條禁止規則皆存在。

### 4. 將其連線至檢查中

- 新增 `lint:boundaries` 腳本：`depcruise <packages-root>`（或 `depcruise src`）。
- 將其納入儲存庫的總括檢查命令中 — 已經執行型別檢查的命令（例如 `check` / `ci` / `validate` 腳本）。**切勿**動到 `tsconfig` 或新增路徑別名。
- 如果沒有總括腳本，新增 `lint:boundaries` 並告知使用者將其包含在 CI 中。

**完成條件：** `lint:boundaries` 存在，且作為型別檢查相同命令的一部分執行。

### 5. 腳手架範例套件

建立一個已提交的 `<packages-root>/example/` 作為複製範本：

- `index.ts` — 進入點。匯出一個委派給內部檔案的函式（使套件顯而易見是*深層的*，而非透傳）。
- `lib/impl.ts` — **子資料夾**中的內部檔案，由 `index.ts` 匯入，無法從外部直接存取。
- `tests/example.test.ts` — **僅**匯入 `../index`（進入點），並針對公開函式進行斷言。

告知使用者這是一個供複製或刪除的起始範本。

**完成條件：** 範例套件存在，透過根目錄進入點暴露其行為，並將 `impl` 隱藏在子資料夾中。

### 6. 證明規則發揮作用

這是整個技能的完成標準 — 不會在違規時失敗的設定是毫無價值的。

1. 執行 `lint:boundaries`。它必須在乾淨的範例上**通過**。
2. 暫時在 `tests/example.test.ts` 中新增深層匯入（例如 `import { thing } from "../lib/impl"`）。再次執行 `lint:boundaries` — 它必須帶著 `tests-through-entrypoints` **失敗**。
3. 還原深層匯入。再次執行 — 它必須**通過**。

**完成條件：** 您已觀察到一次通過，然後在深層匯入上一次失敗，然後再次通過。如果步驟 2 沒有失敗，代表規則未正確連線 — 請在完成前修復。

### 7. 記載慣例

**在套件資料夾中**撰寫 `README.md`（`<packages-root>/README.md`）— 位於其管轄的套件旁 — 涵蓋：`src/packages/<name>/` 佈局（根目錄處的進入點、實作用的 `lib/`、測試用的 `tests/`）、「僅透過套件進入點（其根目錄檔案）匯入」，以及如何執行 `lint:boundaries`。明確**不鼓勵桶子檔案（barrel files）** — 暴露幾個微小進入點，而不是透過一個 index 重新匯出整個子樹。將其控制在複製範本片段再加上各佔一個段落的四條規則。

然後從儲存庫的 Agent 指示檔案（如果存在為 `CLAUDE.md`，否則為 `AGENTS.md`；若兩者皆不存在則建立 `AGENTS.md`）向其新增**上下文指標**。單行就足夠了，例如 `Packages are deep modules — see [src/packages/README.md](./src/packages/README.md) before adding or importing one.`。這是使 Agent 能發現邊界規則而非在上面絆倒的原因。

**完成條件：** `<packages-root>/README.md` 存在且不鼓勵桶子檔案，且儲存庫的 `CLAUDE.md`/`AGENTS.md` 連結至它。

## 筆記

- 設定的 `$1` 反向引用（dependency-cruiser 的群組匹配）是允許套件存取其自身的內部而外部人員不能的原因 — 不要將它們扁平化為單獨的每個套件規則。
- 公開 vs 私有是由**深度**決定的：套件的根目錄檔案是進入點；子資料夾中的任何內容都是私有的。傳統的子資料夾是 `lib/`（實作）與 `tests/`，但規則沒有硬編碼它們 — 任何子資料夾都是私有的，因此新資料夾絕不需要變更設定。新增進入點只是新增一個根目錄檔案 — 沒有桶子檔案。
- 套件是**扁平的**：根目錄下的單一層級直接子項目。套件的內部可以隨意深層嵌套；套件不可包含另一個套件。
- 使用 `.cjs`（而非 `.js`），使設定的 `module.exports` 即使在 `"type": "module"` 儲存庫中也能運作。
