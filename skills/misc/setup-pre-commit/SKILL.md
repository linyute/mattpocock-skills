---
name: 'setup-pre-commit'
description: '在目前儲存庫中設定含有 lint-staged (Prettier)、型別檢查與測試的 Husky pre-commit 勾點。當使用者想要新增 pre-commit 勾點、設定 Husky、設定 lint-staged，或新增提交時格式化/型別檢查/測試時使用。'
---

# 設定 Pre-Commit 勾點

## 此操作所設定的項目

- **Husky** pre-commit 勾點
- **lint-staged** 對所有暫存檔案執行 Prettier
- **Prettier** 設定（若缺少）
- pre-commit 勾點中的 **typecheck** 與 **test** 指令碼

## 步驟

### 1. 偵測套件管理器

檢查 `package-lock.json`（npm）、`pnpm-lock.yaml`（pnpm）、`yarn.lock`（yarn）、`bun.lockb`（bun）。使用存在的那個。若不明確，預設使用 npm。

### 2. 安裝相依套件

安裝為 devDependencies：

```
husky lint-staged prettier
```

### 3. 初始化 Husky

```bash
npx husky init
```

這會建立 `.husky/` 目錄並在 package.json 中新增 `prepare: "husky"`。

### 4. 建立 `.husky/pre-commit`

撰寫此檔案（Husky v9+ 不需要 shebang）：

```
npx lint-staged
npm run typecheck
npm run test
```

**調整**：將 `npm` 替換為偵測到的套件管理器。若儲存庫的 package.json 中沒有 `typecheck` 或 `test` 指令碼，請省略這些行並告知使用者。

### 5. 建立 `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. 建立 `.prettierrc`（若缺少）

僅在不存在 Prettier 設定時建立。使用以下預設值：

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
- [ ] package.json 中的 `prepare` 指令碼為 `"husky"`
- [ ] `prettier` 設定存在
- [ ] 執行 `npx lint-staged` 以驗證其正常運作

### 8. 提交

暫存所有變更/建立的檔案，並以以下訊息提交：`Add pre-commit hooks (husky + lint-staged + prettier)`

這將觸發執行新的 pre-commit 勾點：能很好地進行全面煙霧測試以確認一切正常運作。

## 附註

- Husky v9+ 不需要勾點檔案中的 shebang
- `prettier --ignore-unknown` 會略過 Prettier 無法剖析的檔案（影像等）
- pre-commit 會先執行 lint-staged（快速、僅針對暫存檔案），然後執行完整的型別檢查與測試
