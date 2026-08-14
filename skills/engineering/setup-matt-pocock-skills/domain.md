# 領域文件

工程技能在探索程式碼庫時應如何讀取此儲存庫的領域文件。

## 探索前請閱讀這些

- 儲存庫根目錄下的 **`CONTEXT.md`**，或
- 儲存庫根目錄下的 **`CONTEXT-MAP.md`**（如果存在）— 它指向每個上下文的 `CONTEXT.md`。閱讀與主題相關的每一個。
- **`docs/adr/`** — 閱讀觸及您即將工作領域的 ADR。在多上下文儲存庫中，也請檢查 `src/<context>/docs/adr/` 了解特定上下文範疇的決策。

如果這些檔案中有任何一個不存在，請**靜默繼續**。不要標記它們的缺失；不要提前建議建立它們。`/domain-modeling` 技能（透過 `/grill-with-docs` 與 `/improve-codebase-architecture` 存取）會在術語或決策實際得到解決時惰性建立它們。

## 檔案結構

單一上下文儲存庫（大多數儲存庫）：

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

多上下文儲存庫（根目錄存在 `CONTEXT-MAP.md`）：

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← 系統層面的決策
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← 特定上下文的決策
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## 使用術語表的詞彙

當您的輸出命名一個領域概念時（在議題標題、重構提案、假設、測試名稱中），請使用 `CONTEXT.md` 中定義的術語。不要偏離為術語表明確避免的同義詞。

如果您需要的概念尚未存在於術語表中，這是一個訊號 — 要麼您正在發明專案未使用的語言（重新考慮），要麼存在真實的缺口（為 `/domain-modeling` 記錄下來）。

## 標記 ADR 衝突

如果您的輸出與現有 ADR 矛盾，請明確浮現出來，而非靜默覆寫：

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_
