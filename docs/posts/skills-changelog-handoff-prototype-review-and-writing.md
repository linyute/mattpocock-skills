# 技能變更紀錄：/handoff、/prototype、/review 與 /writing

<iframe width="560" height="315" src="https://www.youtube.com/embed/DNqsMXH6Eog?si=f9qUcZ0d6JwpOPZp" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

我已經為我的 [技能儲存庫](https://github.com/mattpocock/skills) 新增了兩個全新的技能：`/handoff` 和 `/prototype`。這兩者都極大地升級了我與 Agent 協作的方式，特別是在規劃階段。

該儲存庫的成長速度非常驚人——社群的迴響令人難以置信。

![GitHub stars chart showing rapid growth](https://res.cloudinary.com/total-typescript/image/upload/v1778496092/ai-hero-images/lawlzqfblajwx3p0ugu7.png)

我還修復了 `/grill-with-docs`、`/to-prd` 和 `/to-issues` 中的一些錯誤。同時，我還搶先分享一些正在開發中的寫作與程式碼審查技能。

## `/handoff`

新的 [`/handoff`](https://github.com/mattpocock/skills) 技能可以將您目前的對話精簡為一份交接文件，供另一個 Agent 接續處理。它會建立一個暫存檔案，用於摘要上下文、掌握該階段的氛圍與意圖，並建議下一個 Agent 應該使用哪些技能。

這解決了一個常見的問題：當您深入進行訪談階段達到 60K 個權杖（tokens）時，需要建構原型或修復錯誤。與其將這些工作塞進剩餘的上下文視窗中，您可以將其交接給一個擁有完整上下文的全新 Agent。之後您甚至可以將學到的內容交接回原始階段。

主要有兩種模式：**即發即忘（fire and forget）**（在階段中途啟動一個 Agent 來修復錯誤）與 **DIY 子 Agent（DIY sub-agent）**（在規劃期間交接、執行一些工作，然後交接回來）。此技能位於生產力區塊，因為它的用途不僅限於工程工作。

## `/prototype`

新的 [`/prototype`](https://github.com/mattpocock/skills) 技能可建構一次性原型，以便在確定採用之前釐清設計決策。這對 AI 工程至關重要，因為您需要將原型用作研究和探針，以解答唯有透過檢視程式碼才能釐清的未知問題。

雖然 UI 原型是顯而易見的使用情境，但該技能也支援業務邏輯原型。當您有複雜的狀態機或隨時間變化的實體時，可以建構一個小型的互動式終端機應用程式，透過難以在紙上推導的極端情況來推演狀態。

對於 UI 工作，它會產生幾個完全不同的變體，並附帶一個浮動按鈕以在它們之間切換。您可以沿著設計樹向下瀏覽，組合來自不同變體的元素並捨棄其他元素。這對於讓離開座位的 Agent 擅長前端開發至關重要——您需要有人類參與其中以提供品味，因為 AI 通常看不到它正在建構的內容。

## 錯誤修復

[`/grill-with-docs`](https://github.com/mattpocock/skills) 技能有時太急於實作而不是提出問題。修復方法是將支援資訊包裝在 XML 標籤中，以減少其相對於核心指令的「干擾度」。這向 LLM 發出訊號，表示 `<supporting-info>` 內部的內容優先順序應稍微降低。

[`/to-prd`](https://github.com/mattpocock/skills) 與 [`/to-issues`](https://github.com/mattpocock/skills) 現在都會套用 `ready-for-agent-triage` 標籤，而不是 `needs-triage`。一旦您使用這些技能建立了 Issue，它們就已經準備好供 Agent 使用——不需要額外分流。

## 開發中預覽

目前有一套三階段的寫作技能正在開發中：**碎片（fragments）**、**節拍（beats）** 與 **形塑（shape）**。其理論基礎來自於作家如何將靈感記錄在日誌中，最終融入故事之中。您口述碎片（想法），然後寫下節拍（貫穿故事的路徑），接著進行最後的形塑潤飾，以確保聽起來不像是由 AI 產生的。

此外還即將推出一個 **review** 技能，它將同時啟動兩個平行的子 Agent：一個檢查 diff 是否遵循儲存庫的程式碼撰寫標準，另一個檢查它是否忠實地實作了原始 Issue 或 PRD。另一個獨立技能將從您的儲存庫中擷取程式碼撰寫標準，以使標準檢查更加有效。

---

[翻譯自 AI Hero](https://www.aihero.dev/skills/skills-changelog-handoff-prototype-review-and-writing)
