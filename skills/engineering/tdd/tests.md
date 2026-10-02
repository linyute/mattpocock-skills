# 好的與壞的測試

## 好的測試

**整合風格**：透過真實介面進行測試，而非模擬內部組件。

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
- 在內部重構中依然有效
- 描述做什麼（WHAT），而非怎麼做（HOW）
- 每次測試一個邏輯斷言

## 壞的測試

**實作細節測試**：與內部結構耦合。

```typescript
// 不良：測試實作細節
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

危險信號：

- 模擬內部協作者
- 測試私有方法
- 斷言呼叫次數/順序
- 在無行為變更的重構中測試損壞
- 測試名稱描述怎麼做（HOW）而非做什麼（WHAT）
- 透過外部手段而非介面進行驗證

```typescript
// 不良：繞過介面進行驗證
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

**套套邏輯測試**：預期值重述實作，因此測試在結構上必定通過。

```typescript
// 不良：預期值以程式碼計算的方式重新計算
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// 良好：預期值是獨立且已知的常值
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
