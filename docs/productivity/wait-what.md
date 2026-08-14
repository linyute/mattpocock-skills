## 它的功能

`wait-what` 是當一則訊息沒有精確傳達時您輸入的內容。然後 [Agent](https://www.aihero.dev/ai-coding-dictionary/agent) 會重新推銷它剛剛說過的內容。它會新增您所缺失的背景資訊，用平實的英文撰寫，並使用您專案 `CONTEXT.md` 中的詞彙表。

該 Skill 長達三行。這是設計，而不是未完成的草稿。抗拒冗長的 Skill 會因增長而失敗：一個 400 行的簡潔 Skill 仍然會讓 [模型](https://www.aihero.dev/ai-coding-dictionary/model) 變得冗長，因為模型讀取的是篇幅，而不是訴求。這一個攜帶了單個精確的引導字詞，別無其他。

## 何時使用它

您可透過輸入 `/wait-what` 來呼叫此功能。Agent 不會主動使用它，且它也不應該主動使用它。只有您知道您何時停止跟隨。

在您注意到自己在瀏覽過目時立即使用它。Agent 已經偏離進入它發明的術語中、堆疊了五個首字母縮寫詞，或是解釋了一個您從未看過前提的決策。它會修復您已處於的對話。要完全阻止術語抵達，請使用 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)，它會在預先建構共享語言。

## 名稱就是機制

引導字詞是 **wait**。「保持簡潔」是關於 Agent 輸出的指令，且模型透過剪裁字詞並進一步讓您迷失來服從它。**Wait** 是關於*您的*狀態。它表示理解在此處失敗了。聽到「簡短一點」的 Agent 撰寫電報。聽到「等等，您把我弄糊塗了」的 Agent 會倒退並進行解釋。

這種差異就是整個 Skill。對冗長的每個流行修復都命名了*輸出*：`/tldr`、`/no-fluff`、`/talk-normal`。模型過度修正為更短且並不更清晰的穴居人語域。命名*聽眾*會一次要求兩半內容：更少的字詞**以及**您所缺失的背景資訊。

Skill 說重新推銷 **that**，而不是「上一條訊息」。讓您迷失的內容通常大於一個段落，因此 Agent 決定要倒退多遠。

## 它插入您已經擁有的語言中

內文重複使用了您的全域 `CLAUDE.md` 和專案的 `CONTEXT.md` 中已有的引導字詞。ASD-STE100 簡化技術英文設定了語域。無處不在的語言提供了名詞。Skill、`CLAUDE.md` 和 `CONTEXT.md` 尋求相同的 [權杖](https://www.aihero.dev/ai-coding-dictionary/token)，因此呼叫它不是一項新指令。它是 Agent 已經同意的指令的提醒。

如果沒有 `CONTEXT.md`，Skill 仍然有效。您只會失去領域詞彙表那一半。

## 運作良好的指標

- 重新推銷**更短且更清晰**，而不是更短且更生硬。
- 它新增了您所缺失的前提，而不是僅刪除字詞。
- 專案名詞取代了發明的名詞。`CONTEXT.md` 中的術語會傳回。
- 您可以連續使用兩次，且它不會降級為生硬。

## 適用位置

您可以在任何時間點、任何對話中、任何其他 Skill 內部使用 `wait-what`。它在事後修復一則訊息。真正的處方是預先達成一致的共享語言，那就是 [grill-with-docs](https://aihero.dev/skills-grill-with-docs)：一個在執行過程中執行 [domain-modeling](https://aihero.dev/skills-domain-modeling) 的 [盤問](https://www.aihero.dev/ai-coding-dictionary/grilling) 階段作業，以便您們雙方使用的字詞落入您的 `CONTEXT.md` 中。如果您不確定哪個 Skill 適合該時刻，[ask-matt](https://aihero.dev/skills-ask-matt) 會為您引導路線。
