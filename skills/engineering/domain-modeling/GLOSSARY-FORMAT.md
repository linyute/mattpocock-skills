# GLOSSARY.md 格式 (GLOSSARY.md Format)

## 結構 (Structure)

```md
# {上下文名稱}

{一或兩句話描述此上下文是什麼以及它存在的原因。}

## 語言

**Order**:
{該術語的一或兩句話描述}
_Avoid_: Purchase, transaction

**Invoice**:
商品交付後傳送給客戶的付款請求。
_Avoid_: Bill, payment request

**Customer**:
下訂單的個人或組織。
_Avoid_: Client, buyer, account
```

## 規則 (Rules)

- **具備明確主張。** 當同一概念存在多個詞彙時，挑選最佳者並將其他詞彙列於 `_Avoid_` 下。
- **保持定義緊湊。** 最多一到兩句話。定義它是「什麼」，而非它「做什麼」。
- **僅納入特定於此專案上下文的術語。** 一般程式設計概念（逾時、錯誤型別、公用程式模式）即使專案廣泛使用也不屬於此處。新增術語前請自問：這是此上下文特有的概念，還是一般程式設計概念？僅有前者屬於此處。
- 當出現自然集群時，**在子標題下將術語分組**。若所有術語皆屬於單一凝聚區域，扁平清單即可。

## 單一 vs 多重上下文儲存庫 (Single vs multi-context repos)

**單一上下文（大多數儲存庫）：** 儲存庫根目錄下單一 `GLOSSARY.md`。

**多重上下文：** 儲存庫根目錄下的 `GLOSSARY-MAP.md` 列出各個上下文、它們所在之處，以及它們之間的關聯：

```md
# 詞彙表地圖 (Glossary Map)

## 上下文

- [Ordering](./src/ordering/GLOSSARY.md)：接收並追蹤客戶訂單
- [Billing](./src/billing/GLOSSARY.md)：產生發票並處理付款
- [Fulfillment](./src/fulfillment/GLOSSARY.md)：管理倉庫揀貨與出貨

## 關聯性

- **Ordering → Fulfillment**：Ordering 發出 `OrderPlaced` 事件；Fulfillment 取用事件以開始揀貨
- **Fulfillment → Billing**：Fulfillment 發出 `ShipmentDispatched` 事件；Billing 取用事件以產生發票
- **Ordering ↔ Billing**：`CustomerId` 與 `Money` 的共享型別
```

此技能會推論適用哪種結構：

- 若 `GLOSSARY-MAP.md` 存在，讀取它以尋找上下文
- 若僅存在根目錄 `GLOSSARY.md`，為單一上下文
- 若兩者皆不存在，在解決第一個術語時延遲建立根目錄 `GLOSSARY.md`

當存在多個上下文時，推論目前主題與哪一個相關。若不明確，請詢問。
