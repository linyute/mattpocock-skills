# 良好與糟糕的測試

## 良好的測試

**整合風格**：透過真實介面進行測試，而不是內部零件的 mock。

```typescript
// 良好：測試可觀察的行為
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

特性：

- 測試使用者/呼叫者在乎的行為
- 僅使用公開 API
- 在內部重構中存活
- 描述「做什麼（WHAT）」，而不是「如何做（HOW）」
- 每個測試單一邏輯斷言

## 糟糕的測試

**實作細節測試**：與內部結構耦合。

```typescript
// 糟糕：測試實作細節
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

警訊：

- Mock 內部協作者
- 測試私有方法
- 斷言呼叫次數/順序
- 當重構且行為未改變時測試損壞
- 測試名稱描述「如何做（HOW）」而非「做什麼（WHAT）」
- 透過外部手段而非介面進行驗證

```typescript
// 糟糕：繞過介面進行驗證
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// 良好：透過介面進行驗證
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**同義反覆（Tautological）測試**：預期值重述了實作，因此測試憑藉結構通過。

```typescript
// 糟糕：預期值以程式碼計算的方式被重新計算
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// 良好：預期值為獨立、已知的實字
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
