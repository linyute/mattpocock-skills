# 領域文件

工程技能在探索程式碼庫時應如何取用此儲存庫的領域文件。

## 探索之前，請先閱讀以下內容

- 儲存庫根目錄下的 **`GLOSSARY.md`**，或
- 儲存庫根目錄下的 **`GLOSSARY-MAP.md`**（若存在）：它指向每個上下文的 `GLOSSARY.md`。請閱讀與該主題相關的每一個。
- **`docs/adr/`**：閱讀涉及您即將處理領域的 ADR。在多上下文儲存庫中，亦請檢查 `src/<context>/docs/adr/` 以取得上下文範圍的決策。

若這些檔案中的任一個不存在，請**靜默繼續**。不要標記它們的缺失；不要事先建議建立它們。`/domain-modeling` 技能（透過 `/grill-with-docs` 與 `/improve-codebase-architecture` 調用）會在術語或決策實際獲得解決時延遲建立它們。

## 檔案結構

單一上下文儲存庫（大多數儲存庫）：

```
/
├── GLOSSARY.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

多上下文儲存庫（根目錄下存在 `GLOSSARY-MAP.md`）：

```
/
├── GLOSSARY-MAP.md
├── docs/adr/                          ← 全系統決策
└── src/
    ├── ordering/
    │   ├── GLOSSARY.md
    │   └── docs/adr/                  ← 上下文專屬決策
    └── billing/
        ├── GLOSSARY.md
        └── docs/adr/
```

## 使用術語表的詞彙

當您的輸出命名領域概念時（在 issue 標題、重構提案、假設、測試名稱中），請使用 `GLOSSARY.md` 中定義的術語。不要偏離使用術語表明確避免的同義詞。

若您需要的概念尚未存在於術語表中，這是一個訊號：要麼是您正在發明專案未使用的語言（請重新考慮），要麼是存在真正的缺口（為 `/domain-modeling` 記錄下來）。

## 標記 ADR 衝突

若您的輸出與既有 ADR 相牴觸，請明確提出而非靜默覆寫：

> _與 ADR-0007（事件溯源訂單）衝突，但值得重新討論，因為……_
