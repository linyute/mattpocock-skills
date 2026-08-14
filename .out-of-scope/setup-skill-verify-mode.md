# `setup-matt-pocock-skills` 的驗證/檢查模式

本專案不會為 `setup-matt-pocock-skills` 新增專用的驗證/檢查模式（或獨立的驗證 skill）。

## 為何這屬於範圍之外

用於檢查 `docs/agents/*.md` 產出物是否仍符合種子範本 schema 的第二個 skill —— 或 `--verify` 旗標 —— 會重複既有 setup skill 已在對話中處理的工作。

預期的工作流程為：**執行 `/setup-matt-pocock-skills` 並告知其驗證你目前的設定。** 此 skill 是 prompt 驅動的，因此維護者可以將其範圍限制在驗證流程（「不要重寫任何內容，只需對照目前的種子範本檢查我現有的檔案並回報偏差」），而不需要獨立的程式碼路徑。新增旗標或同級 skill 會分散一個已經可透過自然語言進入點表達的功能的表面積。

將設定管理保持在單一 skill 中，也能避免種子範本演進時兩個 skill 彼此偏離的維護成本。

## 先前的請求

- #106 — Feature request: verify/check mode for setup-matt-pocock-skills
