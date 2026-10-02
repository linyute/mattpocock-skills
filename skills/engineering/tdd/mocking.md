# 何時進行模擬 (Mock)

僅在**系統邊界**進行模擬：

- 外部 API（付款、電子郵件等）
- 資料庫（有時 - 優先使用測試資料庫）
- 時間/隨機性
- 檔案系統（有時）

不要模擬：

- 你自己的類別/模組
- 內部協作者
- 任何由你控制的事物

## 針對可模擬性進行設計

在系統邊界，設計易於模擬的介面：

**1. 使用依賴注入 (Dependency Injection)**

傳入外部相依性，而非在內部建立它們：

```typescript
// 易於模擬
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// 難以模擬
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. 偏好 SDK 風格的介面而非通用的擷取函式**

為每個外部操作建立特定函式，而非使用帶有條件邏輯的單一通用函式：

```typescript
// 良好：每個函式均可獨立模擬
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// 不良：模擬需要在模擬內部使用條件邏輯
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

SDK 方式代表著：
- 每個模擬回傳一個特定形狀
- 測試設定中沒有條件邏輯
- 更容易看出測試運用了哪些端點
- 針對每個端點具有型別安全性
