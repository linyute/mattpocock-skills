---
name: 'migrate-to-shoehorn'
description: '將測試檔案從 `as` 型別斷言遷移至 @total-typescript/shoehorn。當使用者提及 shoehorn、想要取代測試中的 `as`，或需要部分測試資料時使用。'
---

# 遷移至 Shoehorn

## 為什麼選擇 shoehorn？

`shoehorn` 讓你可以在測試中傳遞部分資料，同時保持 TypeScript 正常運作。它以具備型別安全特性的替代方案取代 `as` 斷言。

**僅限測試程式碼。** 絕不要在正式環境程式碼中使用 shoehorn。

在測試中使用 `as` 的問題：

- 被告誡不要使用它
- 必須手動指定目標型別
- 針對刻意寫錯的資料必須使用雙重斷言（`as unknown as Type`）

## 安裝

```bash
npm i @total-typescript/shoehorn
```

## 遷移模式

### 僅需少數屬性的大型物件

前：

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ...還有 20 個屬性
};

it("gets user by id", () => {
  // 僅在乎 body.id 但必須偽造整個 Request
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ...偽造所有 20 個屬性
  });
});
```

後：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("gets user by id", () => {
  getUser(
    fromPartial({
      body: { id: "123" },
    }),
  );
});
```

### `as Type` → `fromPartial()`

前：

```ts
getUser({ body: { id: "123" } } as Request);
```

後：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

前：

```ts
getUser({ body: { id: 123 } } as unknown as Request); // 故意使用錯誤型別
```

後：

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

## 各函式的使用時機

| 函式            | 使用情境                                           |
| --------------- | -------------------------------------------------- |
| `fromPartial()` | 傳遞仍通過型別檢查的部分資料                       |
| `fromAny()`     | 傳遞故意設為錯誤的資料（保留自動完成功能）         |
| `fromExact()`   | 強制使用完整物件（稍後可替換為 fromPartial）       |

## 工作流程

1. **收集需求** - 詢問使用者：
   - 哪些測試檔案中的 `as` 斷言引發了問題？
   - 他們是否正在處理僅有某些屬性重要的龐大物件？
   - 他們是否需要針對錯誤測試傳遞故意寫錯的資料？

2. **安裝與遷移**：
   - [ ] 安裝：`npm i @total-typescript/shoehorn`
   - [ ] 尋找包含 `as` 斷言的測試檔案：`grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"`
   - [ ] 將 `as Type` 替換為 `fromPartial()`
   - [ ] 將 `as unknown as Type` 替換為 `fromAny()`
   - [ ] 從 `@total-typescript/shoehorn` 加入匯入項目
   - [ ] 執行型別檢查進行驗證
