// @ts-check
// dependency-cruiser 的深層模組 (Deep-module) 強制規範。
//
// 套件根目錄下的每個套件都是一個深層模組 (DEEP MODULE)：在小型介面
// 背後隱藏大量行為。套件的「公開表面」為其「入口點」—
// 即位於套件根目錄的檔案。實作內容位於「子資料夾」中且為
// 私有的 — 依慣例 `lib/` 存放實作，`tests/` 存放測試，
// 雖然任何子資料夾均為私有。套件可暴露數個小型入口點
// (index.ts, client.ts, server.ts, …) — 優先採用此方式而非單一巨型
// barrel index。
//
// 您在此處唯一需要編輯的項目是 PACKAGES_ROOT。

/** 套件存放處。每個套件為一個直接子目錄（扁平結構，無嵌套）。 */
const PACKAGES_ROOT = "src/packages";

// --- 衍生模式（無需編輯） -------------------------------------
const R = PACKAGES_ROOT;
/**
 * 套件的私有內部元件：套件子資料夾內部的任何嵌套內容。
 * 套件的根目錄檔案為其入口點，且在此「不」比對 —
 * 它們維持可從外部匯入的狀態。
 */
const PACKAGE_INTERNALS = `^${R}/[^/]+/[^/]+/`;

/** @type {import('dependency-cruiser').IConfiguration} */
module.exports = {
  forbidden: [
    {
      name: "entrypoint-boundary-from-app",
      comment:
        "應用程式/根目錄程式碼可以匯入套件的入口點（其根目錄檔案），但不能匯入其子資料夾內部的任何內容。",
      severity: "error",
      from: { pathNot: `^${R}/` }, // 匯入者「不」在任何套件內部
      to: { path: PACKAGE_INTERNALS },
    },
    {
      name: "entrypoint-boundary-across-packages",
      comment:
        "套件自己的檔案可以自由相互匯入，但只能透過其他套件的入口點存取「其他」套件 — 絕不能存取其內部元件。",
      severity: "error",
      // 匯入者位在套件 ($1) 內部，但不是測試檔案
      from: { path: `^${R}/([^/]+)/`, pathNot: `^${R}/[^/]+/tests/` },
      to: {
        path: PACKAGE_INTERNALS,
        pathNot: `^${R}/$1/`, // 相同套件 → 套件內部自由匯入
      },
    },
    {
      name: "tests-through-entrypoints",
      comment:
        "套件的測試與其他使用者一樣透過其入口點對其進行測試：它們可以匯入任何套件的入口點以及自己的 tests/ 測試夾具 (fixtures)，但絕不能匯入任何套件的內部元件 — 甚至是它們自己的內部元件也不行。",
      severity: "error",
      from: { path: `^${R}/([^/]+)/tests/` }, // 位於套件 $1 中的測試檔案
      to: {
        path: PACKAGE_INTERNALS,
        pathNot: `^${R}/$1/tests/`, // 自己的 tests/ 測試夾具 → 允許
      },
    },
    {
      name: "tests-folder-is-private",
      comment:
        "套件的 tests/ 資料夾只能從測試中存取 — 其他任何內容都不得匯入測試夾具。",
      severity: "error",
      from: { pathNot: `^${R}/[^/]+/tests/` }, // 匯入者本身不是測試
      to: { path: `^${R}/[^/]+/tests/` },
    },
    {
      name: "no-circular",
      comment: "無循環相依性。若您想允許套件外部存在循環，請將範圍限定於 `^${R}/`。",
      severity: "error",
      from: {},
      to: { circular: true },
    },

    // --- 分層 (Layering)（可選，預設關閉） ----------------------------------
    // 介面隱藏控制您「如何」匯入（透過入口點）。
    // 分層控制「哪些」套件可以相依於哪些套件。在此處新增您自己的規則，
    // 例如：
    //
    // {
    //   name: "ui-may-not-depend-on-billing",
    //   severity: "error",
    //   from: { path: `^${R}/ui/` },
    //   to:   { path: `^${R}/billing/` },
    // },
  ],
  options: {
    doNotFollow: { path: "node_modules" },
    tsConfig: { fileName: "tsconfig.json" },
    enhancedResolveOptions: {
      extensions: [".ts", ".tsx", ".js", ".jsx", ".json"],
    },
  },
};
