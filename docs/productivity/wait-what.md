## 它的作用

`wait-what` 是當訊息無法被理解時您所輸入的指令。[代理](https://www.aihero.dev/ai-coding-dictionary/agent)隨後會重新陳述剛才的發言。它會補充您所缺少的背景資訊，以通俗的英語撰寫，並使用專案中 `GLOSSARY.md` 的詞彙。

該技能只有三行長。這是刻意的設計，而非未完成的草稿。試圖對抗冗長的技能往往因體積膨脹而失敗：一個四百行的簡潔性技能仍然會讓[模型](https://www.aihero.dev/ai-coding-dictionary/model)變得冗長，因為模型讀取的是篇幅大小，而非懇求。此技能只帶有一個精確的引導詞，別無其他。

## 何時取用它

您透過輸入 `/wait-what` 來呼叫它。代理不會自行取用它，也不應該取用。只有您知道自己何時開始跟不上了。

一旦注意到自己開始略讀時請立即使用。這表示代理已陷入自己發明的行話、堆疊了五個縮寫，或是解釋了一個您從未見過其前提的決策。它可以修復您當前所處的對話。若要徹底阻止行話出現，請使用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，它會預先建構共享語言。

## 名稱即機制

引導詞是 **wait**（等一下）。「保持簡潔」是一條針對代理輸出的指示，模型會透過刪減字詞並讓您更加困惑來遵從它。**Wait** 關乎*您*的狀態。它表明理解在此處失敗了。聽到「簡明扼要」的代理會寫出電報。聽到「等等，我聽不懂」的代理會後退一步並進行解釋。

這種差異正是整個技能的精髓。所有針對冗長的反覆修復都針對*輸出*命名：`/tldr`、`/no-fluff`、`/talk-normal`。模型會過度修正為穴居人風格（caveman register），變得更短但沒有更清晰。針對*聆聽者*命名則能同時要求兩個面向：更少的字詞**以及**您所缺少的背景資訊。

技能指示重新陳述**那個**（that），而非「上一則訊息」。讓您困惑的內容通常大於一個段落，因此代理會決定要退回多遠。

## 它融入您已擁有的語言

內文重用了您的全域 `CLAUDE.md` 與專案的 `GLOSSARY.md` 中已有的引導詞。ASD-STE100 簡化技術英語設定了風格語調。通用語言提供了名詞。技能、`CLAUDE.md` 與 `GLOSSARY.md` 取用相同的 [Token](https://www.aihero.dev/ai-coding-dictionary/token)，因此呼叫它並非一項新指示。它是對代理已經同意的指示的提醒。

若您沒有 `GLOSSARY.md`（且沒有指向當前情境的 `GLOSSARY-MAP.md`），該技能仍然有效。您只會失去領域詞彙的那一半優勢。

## 運作良好的徵兆

- 重新陳述的內容**更短且更清晰**，而非更短且更生硬。
- 它補充了您所缺少的前提，而非僅僅刪減字詞。
- 專案名詞取代了發明的名詞。`GLOSSARY.md` 中的術語重新出現。
- 您可以連續使用兩次，且它不會退化為簡短生硬。

## 它在系統中的位置

您可以在任何對話中的任何時刻、在任何其他技能內部使用 `wait-what`。它在事後修復單則訊息。真正的解方是預先約定的共享語言，那便是 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)：一場在進行中執行 [domain-modeling](https://aihero.dev/skills-domain-modeling) 的[盤問](https://www.aihero.dev/ai-coding-dictionary/grilling)會話，使雙方使用的詞彙沉澱在您的 `GLOSSARY.md` 中。如果您不確定當下適合哪項技能，[ask-matt](https://aihero.dev/skills-ask-matt) 會為您引導。
