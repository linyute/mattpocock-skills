---
name: 'setup-ts-deep-modules'
description: '在 TypeScript 儲存庫中配置 dependency-cruiser，使每個套件都成為深層模組，實作隱藏於子資料夾中且僅能透過進入點檔案存取。由使用者呼叫。'
disable-model-invocation: true
---

# 設定 TS 深層模組

讓此儲存庫中的每個套件都成為**深層模組**：在小型介面背後蘊含大量行為。套件的公開表層是其**進入點**（位於套件根目錄的檔案），而其子資料夾中的所有內容皆被隱藏。此技能會安裝 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 以及使進入點成為唯一存取途徑的規則，接著證明這些規則切實生效。

關於詞彙（深層模組、介面、接縫、深度），請使用 "codebase-design" 呼叫 Skill 工具，並在整個過程中使用其語言。

## 此機制所強制執行的架構形態

```
src/packages/
  <name>/
    index.ts        ← 進入點（公開）。從外部匯入此檔案。
    client.ts       ← 另一個進入點。套件可公開多個進入點。
    lib/            ← 實作：對外部隱藏，內部檔案可自由互相匯入。
    tests/          ← 同處配置的測試 + fixtures（子資料夾，因此為私有）。
```

公開表層是套件的**根目錄檔案**，而非單一指定的 `index.ts`。依照慣例，實作位於 `lib/`，測試位於 `tests/`，使每個套件具有相同的雙資料夾架構形態。不過該規則本身是通用的：*任何*子資料夾中的*任何內容*都是私有的，因此你永遠不需要為了新增資料夾而擴充設定。

四條規則，全部設定為 `error`：

1. **進入點邊界**：套件外部的程式碼（應用程式程式碼或另一個套件）僅能匯入該套件的進入點（其根目錄檔案），絕不能匯入其子資料夾中的任何內容。
2. **套件內部自由度**：套件本身的檔案可以自由互相匯入。
3. **透過進入點測試**：`<pkg>/tests/` 下的檔案可以匯入任何套件的進入點及其本身的 `tests/` fixtures，但絕不能匯入任何套件的子資料夾內部項目（甚至不能匯入自己的）。跨套件的整合測試完全可行；深層匯入則不允許。
4. **禁止循環依賴**：不存在相依性循環。

**進入點，而非 barrel 檔案。** 由於公開表層是*每個*根目錄檔案，套件可以公開數個小型進入點（`index.ts`、`client.ts`、`server.ts`），而不是將所有項目集中匯入匯出於一個龐大的 `index.ts`。不建議使用重新匯出整個子樹的 barrel 檔案；保持進入點精簡，並將實作隱藏於子資料夾中。

分層（哪些套件可以相依於哪些套件）是*另一個*不同的考量，並作為加上註解的虛設常式保留在設定中，供此儲存庫後續填寫。

## 步驟

### 1. 偵測環境

- **套件管理器**：`pnpm-lock.yaml` → pnpm，`yarn.lock` → yarn，`bun.lockb` → bun，否則為 npm。在下方的每個指令中都使用它（`pnpm`/`yarn`/`npm run`/`bunx`）。
- **套件根目錄**：若 `src/` 存在則使用 `src/packages`，否則使用 `packages`。若儲存庫已有其他明顯慣例，請與使用者確認選擇。
- **現有設定**：檢查是否存在 `.dependency-cruiser.*` 檔案。若存在，**請勿**覆寫：合併這四條規則與選項，並告知使用者你新增了什麼內容。

**完成標準：** 套件管理器、套件根目錄及現有設定狀態皆已確認。

### 2. 安裝 dependency-cruiser

使用偵測到的套件管理器將 `dependency-cruiser` 安裝為 devDependency。

**完成標準：** `dependency-cruiser` 已出現在 `devDependencies` 中。

### 3. 撰寫設定

將 [`dependency-cruiser.config.cjs`](./dependency-cruiser.config.cjs) 複製到儲存庫根目錄，命名為 `.dependency-cruiser.cjs`。將 `PACKAGES_ROOT` 設定為步驟 1 中偵測到的根目錄。這些規則是基於路徑深度且與副檔名無關，因此無需調整其他任何內容。

**完成標準：** `.dependency-cruiser.cjs` 已存在且具有正確的 `PACKAGES_ROOT`，並且四條禁止規則皆已就緒。

### 4. 將其連接至檢查流程

- 新增 `lint:boundaries` 指令碼：`depcruise <packages-root>`（或 `depcruise src`）。
- 將其整合至儲存庫的統籌檢查指令中，即已經執行型別檢查的指令（例如 `check` / `ci` / `validate` 指令碼）。**請勿**更動 `tsconfig` 或新增路徑別名。
- 若沒有統籌指令碼，請新增 `lint:boundaries` 並告知使用者在 CI 中納入它。

**完成標準：** `lint:boundaries` 已存在，並作為與型別檢查相同指令的一部分執行。

### 5. 建構範例套件結構

建立已提交的 `<packages-root>/example/` 作為可供複製的範本：

- `index.ts` 為進入點。匯出一個委派給內部檔案的函式（使套件明確呈現*深層*特性，而非單純的傳遞轉發）。
- `lib/impl.ts`：位於**子資料夾**中的內部檔案，由 `index.ts` 匯入，無法從外部直接存取。
- `tests/example.test.ts` **僅**匯入 `../index`（進入點），並針對公開函式進行斷言驗證。

告知使用者這是一個可複製或刪除的入門範本。

**完成標準：** 範例套件已存在，透過根目錄進入點公開其行為，並將 `impl` 隱藏在子資料夾中。

### 6. 證明規則切實生效

這是整個技能的完成準則：在發生違規時不會失敗的設定是毫無價值的。

1. 執行 `lint:boundaries`。在乾淨的範例上它必須**通過**。
2. 暫時在 `tests/example.test.ts` 中新增深層匯入（例如 `import { thing } from "../lib/impl"`）。再次執行 `lint:boundaries`；它必須因 `tests-through-entrypoints` 而**失敗**。
3. 還原深層匯入。再執行一次，必須**通過**。

**完成標準：** 你已觀察到一次通過、接著在深層匯入時失敗、然後再次通過。若步驟 2 沒有失敗，表示規則配置不正確，請在完成前進行修復。

### 7. 記錄慣例

**在套件資料夾中**撰寫 `README.md`（`<packages-root>/README.md`，位於其所規範的套件旁），涵蓋：`src/packages/<name>/` 配置（根目錄為進入點，`lib/` 放實作，`tests/` 放測試）、「僅透過套件的進入點（其根目錄檔案）匯入」，以及如何執行 `lint:boundaries`。明確**不鼓勵使用 barrel 檔案**：公開數個小型進入點，而不是透過單一 index 重新匯出整個子樹。內容保持為可複製的程式碼片段加上四條規則（每條一段）。

接著從儲存庫的代理人指示檔案（若存在則為 `CLAUDE.md`，否則為 `AGENTS.md`，兩者皆不存在時則建立 `AGENTS.md`）新增指向它的**情境指標**。一行即足夠，例如 `Packages are deep modules: see [src/packages/README.md](./src/packages/README.md) before adding or importing one.`。這能讓代理人發現邊界規則，而不是踩到違規地雷。

**完成標準：** `<packages-root>/README.md` 已存在且不鼓勵 barrel 檔案，並且儲存庫的 `CLAUDE.md`/`AGENTS.md` 已連結至該檔案。

## 附註

- 設定中的 `$1` 反向引用（dependency-cruiser 的群組比對）可讓套件存取自己的內部項目，而外部人員則無法存取。請勿將其扁平化拆分成個別的套件專用規則。
- 公開與私有是由**深度**決定的：套件的根目錄檔案為進入點；子資料夾中的任何項目皆為私有。慣用的子資料夾為 `lib/`（實作）和 `tests/`，但規則中並未寫死這些名稱：任何子資料夾都是私有的，因此新增資料夾永遠不需要變更設定。新增進入點只需新增根目錄檔案（不使用 barrel）。
- 套件結構是**扁平的**：根目錄下一層的直接子項目。套件內部可以根據需要任意巢狀嵌套；套件內不能包含另一個套件。
- 使用 `.cjs`（而非 `.js`），使設定中的 `module.exports` 即使在 `"type": "module"` 儲存庫中也能正常運作。
