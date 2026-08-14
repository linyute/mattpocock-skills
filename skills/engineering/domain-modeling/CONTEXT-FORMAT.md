# CONTEXT.md 格式

## 結構

```md
# {上下文名稱}

{一或兩句話說明此上下文是什麼以及存在的原因。}

## Language

**Order**:
{一或兩句話對該術語的說明}
_Avoid_: Purchase, transaction

**Invoice**:
交付後發送給客戶的付款請求。
_Avoid_: Bill, payment request

**Customer**:
下訂單的人或組織。
_Avoid_: Client, buyer, account
```

## 規則

- **堅持見解。** 當同一概念存在多個詞彙時，選擇最好的一個，並將其他詞彙列在 `_Avoid_` 底下。
- **保持定義精煉。** 最多一或兩句話。定義它「是什麼」，而不是它「做什麼」。
- **僅包含特定於此專案上下文的術語。** 一般程式設計概念（逾時、錯誤型別、工具模式）即使專案大量使用也不屬於此處。新增術語之前，請詢問：這是此上下文特有的概念，還是一般程式設計概念？僅前者屬於此處。
- 當出現自然叢集時，**將術語分組在子標題下**。如果所有術語都屬於單一具凝聚力的領域，可以使用扁平清單。

## 單一 vs 多個上下文的儲存庫

**單一上下文（大多數儲存庫）：** 在儲存庫根目錄放一個 `CONTEXT.md`。

**多個上下文：** 在儲存庫根目錄放一個 `CONTEXT-MAP.md` 列出各個上下文、其所在位置以及彼此間的關係：

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — 接收並追蹤客戶訂單
- [Billing](./src/billing/CONTEXT.md) — 產生發票並處理付款
- [Fulfillment](./src/fulfillment/CONTEXT.md) — 管理倉庫揀貨與運送

## Relationships

- **Ordering → Fulfillment**: Ordering 發出 `OrderPlaced` 事件；Fulfillment 接收事件以開始揀貨
- **Fulfillment → Billing**: Fulfillment 發出 `ShipmentDispatched` 事件；Billing 接收事件以產生發票
- **Ordering ↔ Billing**: 共享 `CustomerId` 與 `Money` 型別
```

技能會推斷適用哪種結構：

- 如果 `CONTEXT-MAP.md` 存在，讀取它以尋找上下文
- 如果僅存在根目錄 `CONTEXT.md`，則為單一上下文
- 如果兩者皆不存在，在解決第一個術語時惰性建立根目錄 `CONTEXT.md`

當存在多個上下文時，推斷當前主題與哪一個相關。如果不清楚，請詢問。
