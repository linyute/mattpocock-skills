# HTML 報告格式

架構審查會渲染為 OS 暫存目錄中的單一獨立 HTML 檔案。Tailwind 和 Mermaid 都來自 CDN。Mermaid 能可靠地處理圖形形狀的圖表；手動建立的 div 和內聯 SVG 則處理更具編輯質感的視覺效果（質量圖、橫截面圖）。將兩者結合 — 不要所有東西都依賴 Mermaid，否則會開始顯得普通。

## 骨架

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review — {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* 為 Tailwind 未能乾淨涵蓋的事物自訂小型圖層：
         虛線接縫線、具備手繪感的箭頭等 */
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

## 標頭

儲存庫名稱、日期與簡潔圖例：實線方塊 = 模組，虛線 = 接縫，紅色箭頭 = 洩漏，深色厚方塊 = 深度模組。沒有介紹段落 — 直接進入候選項。

## 候選項卡片

圖表承擔重任。散文簡潔平實，並自然使用來自 `/codebase-design` 技能的術語表術語。

每個候選項為一個 `<article>`：

- **標題** — 簡短，命名深化內容（例如「折疊 Order intake 管線」）。
- **標籤列** — 建議強度（`Strong` = 祖母綠，`Worth exploring` = 琥珀色，`Speculative` = 板岩灰），外加依賴項類別的標籤（`in-process``local-substitutable``ports & adapters``mock`）。
- **檔案** — 等寬清單，`font-mono text-sm`。
- **Before / After 圖表** — 核心重頭戲。兩欄並排。參見下方模式。
- **問題** — 一句話。痛點何在。
- **解決方案** — 一句話。改變了什麼。
- **優勢（Wins）** — 項目符號，每項 ≤6 個字。例如「測試僅觸及單一介面」、「Pricing 邏輯停止洩漏」、「刪除 4 個淺層包裝器」。
- **ADR 標註**（如適用）— 琥珀色框中的單行文字。

無需段落式的解釋。如果圖表需要段落才能被理解，請重新繪製圖表。

## 圖表模式

選擇適合候選項的模式。將它們混搭。不要讓每個圖表看起來都一樣 — 多樣性是重點的一部分。

### Mermaid 圖表（用於依賴項 / 呼叫流程的主力）

當重點是「X 呼叫 Y 呼叫 Z，看這混亂」時，請使用 Mermaid `flowchart` 或 `graph`。將其包裹在 Tailwind 樣式的卡片中，使其感覺不突兀。使用 classDef 設置樣式，將洩漏邊塗成紅色，將深度模組塗成深色。時序圖非常適合表示「變更前：6 次往返；變更後：1 次」。

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

### 手動建立的方塊與箭頭（當 Mermaid 的佈局困擾您時）

模組作為帶有邊框與標籤的 `<div>`。箭頭作為相對於容器絕對定位的內聯 SVG `<line>` 或 `<path>` 元素。當您希望「變更後」的圖表感覺像是一個帶有厚邊框、內部灰色化的深度模組時，請使用此方式 — Mermaid 無法渲染出正確的比重。

### 橫截面圖（適合分層淺層化）

堆疊水平條帶（`h-12 border-l-4`）以展示呼叫所穿過的圖層。變更前：6 個薄層，各自什麼都沒做。變更後：1 個標有合併職責的厚條帶。

### 質量圖（適合「介面與實作一樣寬」）

每個模組兩個矩形 — 一個代表介面表面積，一個代表實作。變更前：介面矩形幾乎與實作矩形一樣高（淺層）。變更後：介面矩形較短，實作矩形較高（深度）。

### 呼叫圖折疊

變更前：渲染為巢狀方塊的函式呼叫樹。變更後：同一棵樹折疊為單一方塊，現在變成內部的呼叫在其內部淡化顯示。

## 樣式指引

- 偏向編輯質感，非企業儀表板風格。留白豐富。標題可選用襯線體（`font-serif` 與 stone/slate 搭配良好）。
- 克制使用色彩：一種強調色（emerald 或 indigo），加上紅色的洩漏色與琥珀色的警告色。
- 圖表保持約 ~320px 高度，以便變更前/變更後能舒適地並排坐落，無需滾動。
- 圖表內部的模組標籤使用 `text-xs uppercase tracking-wider` — 它們讀起來應該像是示意圖，而非 UI。
- 唯一的腳本是 Tailwind CDN 和 Mermaid ESM 匯入。報告其餘部分是靜態的 — 沒有應用程式程式碼，沒有超出 Mermaid 自身渲染以外的互動性。

## 首要建議章節

一張較大的卡片。候選項名稱、說明原因的一句話、連至其卡片的錨點連結。就這樣。

## 語調

通俗易懂、精練 — 但架構名詞與動詞直接來自 `/codebase-design` 技能。精練不是偏離主題的藉口。

**精準使用：** 模組（module）、介面（interface）、實作（implementation）、深度（depth）、深（deep）、淺（shallow）、接縫（seam）、轉接器（adapter）、槓桿作用（leverage）、局部性（locality）。

**切勿替換：** 元件、服務、單元（替代模組）· API、簽名（替代介面）· 邊界（替代接縫）· 圖層、包裝器（代表模組時替代模組）。

**符合風格的文句短語：**

- 「Order intake 模組是淺層的 — 介面幾乎與實作相符。」
- 「Pricing 跨越接縫洩漏。」
- 「深化：單一介面，單一測試位置。」
- 「兩個轉接器證明了接縫的合理性：正式環境中的 HTTP，測試中的記憶體內。」

**優勢項目符號**以術語表術語命名獲益：*「局部性：Bug 集中在單一模組」*、*「槓桿作用：單一介面，N 個呼叫位置」*、*「介面縮小；實作吸收了包裝器」*。不要寫*「更容易維護」*或*「更乾淨的程式碼」* — 這些術語不在術語表中，不具備其立足之地。

不說客套話，不拐彎抹角，不說「值得注意的是…」。如果一句話可以作為項目符號，請將其作為項目符號。如果項目符號可以剪裁，請剪裁它。如果術語不在 `/codebase-design` 術語表中，請在發明新術語之前先調用現有的術語。
