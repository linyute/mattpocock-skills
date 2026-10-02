# 標準安裝區塊

一套安裝說明，統一措辭。`README.md`、`.changeset/*` 以及 `docs/` 下的每個頁面都必須採用**這套說明**，不可使用其他說法。先在此處修改，然後推播至各處。

`mattpocock-skills` 已列於 **Claude Code 官方市集**（設定名稱為 `claude-plugins-official`，來源儲存庫為 `anthropics/claude-plugins-official`），每個 Claude Code 安裝環境皆隨附該市集。無需事先新增市集。Anthropic 官方市集預設啟用自動更新（[discover-plugins](https://code.claude.com/docs/en/discover-plugins)），因此「更新會自動送達」是真實的主張，而非期望。

## Claude Code：外掛程式

<canonical-block name="claude-code">

```bash
claude plugins install mattpocock-skills
```

或從會話內部執行：

```
/plugin install mattpocock-skills
```

它位於 Claude Code 官方市集中，因此無需事先新增任何內容，且更新會自動送達。

</canonical-block>

## Codex 與其他代理：skills.sh

該外掛程式僅適用於 Claude Code。在其他所有環境中，[skills.sh](https://skills.sh/mattpocock/skills) 會將可編輯的技能檔案複製到專案中。在 `README.md` 上請使用完整集合形式：

<canonical-block name="skills-sh-whole-set">

```bash
npx skills@latest add mattpocock/skills
```

挑選您想要的技能，以及要將其安裝到哪些寫程式代理。**安裝程式允許您選擇要採用哪些技能：請確保包含 `setup-matt-pocock-skills`。**

</canonical-block>

…以及單一技能獨立列出時所使用的單一技能形式。請注意，**`docs/` 頁面不是此區塊的使用者**：ai-hero 會在內文上方呈現安裝小工具，因此若頁面寫出這些指令就會造成重複。請參閱 [writing-docs.md](./writing-docs.md)。

<canonical-block name="skills-sh-one-skill">

```bash
npx skills@latest add mattpocock/skills --skill=<name>
```

```bash
npx skills@latest update <name>
```

</canonical-block>

這三處皆固定拼寫為 `skills@latest`。`docs/` 底下的頁面過去曾各自帶有這些指令的副本；現在這些區塊已被刪除而非修正，因為網站本身會呈現安裝指令。

## 這兩種途徑互斥

外掛程式是您訂閱的受控唯讀組合套裝。skills.sh 則寫入由您擁有並可編輯的檔案。同時安裝這兩者會讓使用者獲得每項技能的重複複本：請務必告知「二擇一」。

## 非正式安裝說明

`.claude-plugin/marketplace.json` 使此儲存庫成為其自身的單一外掛程式市集（`/plugin marketplace add mattpocock/skills`，接著 `/plugin install mattpocock-skills@mattpocock`）。官方清單已取代它。該檔案僅保留作為直接安裝儲存庫（未發布的提交，或分支）時的備用方案，**不**向使用者公開說明。
