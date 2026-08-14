# 規範安裝區塊

單一安裝說明，單一用字。`README.md`、`.changeset/*` 以及 `docs/` 下的每一個頁面都必須使用**這個**說明，別無其他。請先在此處修改，然後進行傳播。

`mattpocock-skills` 列在 **Claude Code 的官方市集中** — 設定名稱為 `claude-plugins-official`，來源儲存庫為 `anthropics/claude-plugins-official` — 這是每個 Claude Code 安裝版開箱即用的。不需要先新增任何市集。Anthropic 官方市集預設開啟自動更新（[discover-plugins](https://code.claude.com/docs/en/discover-plugins)），因此「自動接收更新」是真實的說明，而非願景。

## Claude Code — 外掛程式

<canonical-block name="claude-code">

```bash
claude plugins install mattpocock-skills
```

或者，在工作階段內部：

```
/plugin install mattpocock-skills
```

它位於 Claude Code 的官方市集中，因此不需要先新增任何內容，且更新會自動到達。

</canonical-block>

## Codex 與其他 Agent — skills.sh

外掛程式僅限 Claude Code 使用。在其他任何地方，[skills.sh](https://skills.sh/mattpocock/skills) 都會將可編輯的技能檔案複製到專案中。在 `README.md` 上請使用全套形式：

<canonical-block name="skills-sh-whole-set">

```bash
npx skills@latest add mattpocock/skills
```

選擇您想要的技能，以及要安裝它們的程式編寫 Agent。**安裝程式會讓您選擇要取得哪些技能 — 請確保 `setup-matt-pocock-skills` 是其中之一。**

</canonical-block>

…以及在單獨提及單一技能的任何地方使用單一技能形式。請注意，**`docs/` 頁面並非此區塊的使用者**：ai-hero 會在內文上方呈現安裝元件，因此寫出命令的頁面會產生重複。請參閱 [writing-docs.md](./writing-docs.md)。

<canonical-block name="skills-sh-one-skill">

```bash
npx skills@latest add mattpocock/skills --skill=<name>
```

```bash
npx skills@latest update <name>
```

</canonical-block>

`skills@latest` 是這三者中固定的拼寫方式。`docs/` 下的頁面過去包含這些命令的自身副本；這些區塊現在已刪除而非修正，因為網站會自行呈現安裝命令。

## 這兩種途徑是互斥的

外掛程式是您訂閱的管理式唯讀套件。skills.sh 則會寫入由您擁有與編輯的檔案。同時安裝這兩者會讓使用者擁有兩份相同的技能 — 請始終說明「選擇其中之一」。

## 非安裝說明

`.claude-plugin/marketplace.json` 使該儲存庫成為其自身的單一外掛程式市集（`/plugin marketplace add mattpocock/skills`，接著 `/plugin install mattpocock-skills@mattpocock`）。官方清單取代了它。它作為直接安裝儲存庫（未發布的認可或分支）的備用方案被保留，且**不**會對使用者進行文件說明。
