---
"mattpocock-skills": patch
---

在 `to-spec`、`code-review`、`setup-matt-pocock-skills`、`writing-fragments`、`writing-shape` 與 `wait-what` 中為 `description` front matter 加上引號。在 #905 清理破折號時遺留的未加引號冒號加空格導致每個區塊變成無效的 YAML，使得 `skills.sh` 在探索期間略過了這全部六個項目，且無法透過 `npx skills` 列出或安裝。
