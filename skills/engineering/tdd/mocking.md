# 何時使用 Mock

僅在**系統邊界**處進行 Mock：

- 外部 API（付款、電子郵件等）
- 資料庫（有時 — 偏好測試 DB）
- 時間/隨機性
- 檔案系統（有時）

不要 Mock：

- 您自己的類別/模組
- 內部協作者
- 您能控制的任何事物

## 為可 Mock 性而設計

在系統邊界處，設計易於 mock 的介面：

**1. 使用依賴注入（Dependency Injection）**

傳入外部依賴項，而不是在內部建立它們：

```typescript
// 容易 mock
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// 難以 mock
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. 偏好 SDK 風格的介面而非通用的擷取器**

為每個外部操作建立特定的函式，而不是帶有條件邏輯的單一通用函式：

```typescript
// 良好：每個函式都是獨立可 mock 的
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// 糟糕：Mock 需要在 mock 內部包含條件邏輯
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

SDK 方法意味著：
- 每個 mock 傳回一個特定形狀
- 測試設定中沒有條件邏輯
- 更容易看出測試執行了哪些端點
- 每個端點的型別安全性
