---
name: 'setup-pre-commit'
description: '在當前儲存庫中設定帶有 lint-staged（Prettier）、型別檢查與測試的 Husky pre-commit Hook。當使用者希望新增 pre-commit Hook、設定 Husky、設定 lint-staged，或新增提交時格式化/型別檢查/測試時使用。'
---

# 設定 Pre-Commit Hook

## 此技能設定的內容

- **Husky** pre-commit hook
- **lint-staged** 在所有暫存檔案上執行 Prettier
- **Prettier** 設定（如果缺乏）
- pre-commit hook 中的 **typecheck** 與 **test** 腳本

## 步驟

### 1. 偵測套件管理員

檢查 `package-lock.json`（npm）、`pnpm-lock.yaml`（pnpm）、`yarn.lock`（yarn）、`bun.lockb`（bun）。使用存在的任何一個。如果不確定預設為 npm。

### 2. 安裝依賴項

安裝為 devDependencies：

```
husky lint-staged prettier
```

### 3. 初始化 Husky

```bash
npx husky init
```

這會建立 `.husky/` 目錄並向 package.json 新增 `prepare: "husky"`。

### 4. 建立 `.husky/pre-commit`

寫入此檔案（Husky v9+ 不需要 shebang）：

```
npx lint-staged
npm run typecheck
npm run test
```

**調整**：以偵測到的套件管理員替代 `npm`。如果儲存庫在 package.json 中沒有 `typecheck` 或 `test` 腳本，省略那些行並告知使用者。

### 5. 建立 `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. 建立 `.prettierrc`（如果缺乏）

僅當不存在 Prettier 設定時建立。使用以下預設：

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. 驗證

- [ ] `.husky/pre-commit` 存在且可執行
- [ ] `.lintstagedrc` 存在
- [ ] package.json 中的 `prepare` 腳本為 `"husky"`
- [ ] `prettier` 設定存在
- [ ] 執行 `npx lint-staged` 以驗證其運作

### 8. 提交

暫存所有變更/建立的檔案並帶著留言提交：`Add pre-commit hooks (husky + lint-staged + prettier)`

這將通過新的 pre-commit Hook — 驗證每件事物正常運作的良好煙霧測試。

## 筆記

- Husky v9+ 不需要 Hook 檔案中的 shebang
- `prettier --ignore-unknown` 跳過 Prettier 無法解析的檔案（影像等）
- pre-commit 首先執行 lint-staged（快速、僅限暫存），然後進行完整的型別檢查與測試
