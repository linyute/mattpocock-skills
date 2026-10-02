#!/usr/bin/env node
// 將 package.json 的版本複製到 .claude-plugin/plugin.json。
// 作為 `npm run version` 的一部分執行，緊接著 `changeset version` 之後。
// 搭配 --check 時不作任何變更，若兩個版本不同則退出代碼 1。

import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const repo = join(dirname(fileURLToPath(import.meta.url)), "..");
const pluginPath = join(repo, ".claude-plugin", "plugin.json");

const { version } = JSON.parse(readFileSync(join(repo, "package.json"), "utf8"));
const source = readFileSync(pluginPath, "utf8");
const plugin = JSON.parse(source);

if (plugin.version === version) {
  console.log(`plugin.json 版本為 ${version}（已同步）`);
  process.exit(0);
}

if (process.argv.includes("--check")) {
  console.error(
    `plugin.json 版本為 ${plugin.version}，package.json 為 ${version}。請執行 \`node scripts/sync-plugin-version.mjs\`。`,
  );
  process.exit(1);
}

// 僅重寫版本行，以保留鍵值順序與格式。
const updated = source.replace(
  /("version"\s*:\s*")[^"]*(")/,
  `$1${version}$2`,
);

if (JSON.parse(updated).version !== version) {
  console.error(`在 ${pluginPath} 中找不到可替換的版本欄位。`);
  process.exit(1);
}

writeFileSync(pluginPath, updated);
console.log(`plugin.json 版本 ${plugin.version} -> ${version}`);
