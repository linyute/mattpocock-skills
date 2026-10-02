# HTML 報告格式

架構審查會在作業系統的暫存目錄中呈現為單一自包含的 HTML 檔案。Tailwind 與 Mermaid 均來自 CDN。Mermaid 能可靠地處理圖狀架構圖；手刻的 div 與行內 SVG 則處理較偏編輯風格的視覺效果（質量圖、橫截面圖）。兩者混合使用：不要所有東西都依賴 Mermaid，否則看起來會千篇一律。

## 鷹架（Scaffold）

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review for {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* small custom layer for things Tailwind doesn't cover cleanly:
         dashed seam lines, hand-drawn-feeling arrow heads, etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## 頁首（Header）

儲存庫名稱、日期與精簡圖例：實線框 = 模組（module），虛線 = 接合點（seam），紅色箭頭 = 洩漏（leakage），深色粗框 = 深模組（deep module）。沒有引言段落。直接切入候選項。

## 候選卡片（Candidate card）

圖表承載核心內容。文字精簡、直白，並直接使用術語表詞彙（來自 `/codebase-design` 技能），不加繁文縟節。

每個候選項為一個 `<article>`：

- **標題**：簡短，命名深化之處（例如「收斂訂單接收管線」）。
- **徽章列**：建議強度（`Strong` = 祖母綠，`Worth exploring` = 琥珀色，`Speculative` = 板岩灰），外加相依性類別的標籤（`in-process`、`local-substitutable`、`ports & adapters`、`mock`）。
- **檔案**：等寬字型清單，`font-mono text-sm`。
- **修改前／修改後圖表**：核心重點。雙欄並排。請參閱下方的模式。
- **問題**：一句話。痛點所在。
- **解決方案**：一句話。做了什麼變更。
- **效益**：項目符號，每項 ≤6 個字。例如「測試僅針對單一介面」、「定價邏輯不再洩漏」、「刪除 4 個淺包裝器」。
- **ADR 標註**（若適用）：琥珀色底框中的一行字。

不要寫成段的解釋。如果圖表需要一段話才能看懂，請重新繪製圖表。

## 圖表模式

挑選適合候選項的模式。混合使用它們。不要讓每張圖看起來都一樣。多樣性也是重點之一。

### Mermaid 圖表（相依性／呼叫流程的主力）

當重點在於「X 呼叫 Y 呼叫 Z，看看有多混亂」時，使用 Mermaid `flowchart` 或 `graph`。將其包裝在 Tailwind 樣式的卡片中，讓它不顯得突兀。使用 classDef 將洩漏的邊線標為紅色，並將深模組標為深色。循序圖很適合用於「修改前：6 次往返；修改後：1 次」。

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### 手刻方塊與箭頭（當 Mermaid 的排版不合心意時）

將模組做成帶有邊框與標籤的 `<div>`。箭頭作為行內 SVG `<line>` 或 `<path>` 元素，絕對定位在相對容器上方。當你想讓「修改後」的圖表呈現出一個帶粗邊框、內部淡化處理的深模組時，請使用此方式，因為 Mermaid 無法以適當的份量呈現該效果。

### 橫截面（適合層狀淺薄結構）

堆疊水平色帶（`h-12 border-l-4`）以顯示呼叫所穿過的層次。修改前：6 個各自毫無作為的薄層。修改後：1 個標記有整合責任的厚色帶。

### 質量圖（適合「介面與實作一樣寬」的情況）

每個模組兩個矩形：一個代表介面表面積，一個代表實作。修改前：介面矩形幾乎與實作矩形一樣高（淺）。修改後：介面矩形較矮，實作矩形較高（深）。

### 呼叫圖摺疊

修改前：呈現為巢狀方塊的函式呼叫樹。修改後：同一棵樹摺疊為單一方塊，現已內化的呼叫以淡化方式顯示於其內部。

## 樣式指引

- 偏向編輯刊物風格，而非企業儀表板風格。寬裕的留白。標題可選用襯線體（`font-serif` 與 stone/slate 搭配良好）。
- 謹慎用色：單一強調色（祖母綠或靛藍），加上洩漏用的紅色與警告用的琥珀色。
- 圖表高度保持約 320px，以便修改前／修改後舒適並排而無需捲動。
- 圖表內的模組標籤使用 `text-xs uppercase tracking-wider`，使其讀起來像示意圖而非 UI。
- 唯一的指令碼是 Tailwind CDN 與 Mermaid ESM import。除此之外報告皆為靜態：沒有應用程式程式碼，除了 Mermaid 本身的算圖外沒有任何互動。

## 最首要建議區段

一個較大的卡片。候選項名稱、一句話說明原因、連至其卡片的錨點連結。僅此而已。

## 語氣

平實直白、精簡，但架構名詞與動詞直接取自 `/codebase-design` 技能。精簡不可作為偏離術語的藉口。

**嚴格使用：** module、interface、implementation、depth、deep、shallow、seam、adapter、leverage、locality。

**絕不可替換：** component、service、unit（代替 module）· API、signature（代替 interface）· boundary（代替 seam）· layer、wrapper（在指涉 module 時代替 module）。

**符合風格的句型：**

- "Order intake module is shallow: interface nearly matches the implementation."
- "Pricing leaks across the seam."
- "Deepen: one interface, one place to test."
- "Two adapters justify the seam: HTTP in prod, in-memory in tests."

**效益項目符號**以術語表詞彙指明效益：*"locality: bugs concentrate in one module"*、*"leverage: one interface, N call sites"*、*"interface shrinks; implementation absorbs the wrappers"*。不要寫 *"easier to maintain"* 或 *"cleaner code"*，因為這些詞不在術語表中，沒有存在的價值。

不說模稜兩可的話、不說客套贅詞、不出現「值得注意的是……」。如果一句話能做成項目符號，就做成項目符號。如果項目符號能刪減，就刪減。如果一個術語不在 `/codebase-design` 術語表中，在創造新詞之前請先選用已有的詞。
