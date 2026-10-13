# Drum AI — Preset MCP 技能

<p align="center">
  <a href="https://apps.apple.com/app/id6782609749"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download Drum AI on the App Store" height="40"></a>
  &nbsp;&nbsp;
  <a href="https://c1c1.online/drumanalyse/"><img src="https://img.shields.io/badge/Official_Site-c1c1.online%2Fdrumanalyse-1f6feb?style=for-the-badge&logo=safari&logoColor=white" alt="Drum AI official website" height="40"></a>
</p>

[English (US)](README.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · **繁體中文** · [한국어](README.ko.md) · [简体中文](README.zh-Hans.md) · [日本語](README.ja.md) · [Español](README.es.md)

用白話描述一段節奏，拿回一個連結，打開連結，節奏型就已經進到你的 Drum AI 鼓機裡——可以直接播放、編輯，也能跟著練。

這個儲存庫就是讓這一切成真的技能。它把 AI 助理接到 Drum AI 的 PRESET 服務，讓助理能挑鼓組、寫節奏型、補上細節，最後交給你一個連結匯入。

連線方式有兩種，助理會採用第一個可用的：

| | 需要 | 可離線運作 |
| --- | --- | --- |
| **`drumai` 命令列工具**（首選——一行 Homebrew 安裝） | CLI | 可以 |
| **透過 MCP 的 Drum AI PRESET 服務**——無需安裝任何東西 | 支援 MCP 的用戶端 | 不行 |

CLI 之所以首選，是因為它完全在你自己的機器上執行：不需要連上任何服務，也不必設定任何位址；而且當 App 在同一台 Mac 上開著時，它能把節奏型直接送進去並播放。MCP 服務則完全不需要安裝，所以當你不想安裝任何東西時，它是更好的選擇。兩者產生的節奏型完全相同。

---

## Drum AI 是什麼？

**Drum AI 是一款適用於 iPhone、iPad 和 Mac 的 AI 鼓機與練習 App。** 匯入一首歌，它會分離出鼓、偵測速度，並把結果轉成可編輯的節奏型。從這裡開始，它就是一台完整的鼓機：25 組專業鼓組、16/32 步進音序器、內建壓縮器與移相器的混音器、人性化，以及能把困難樂句一路練到原速的 tempo drill。

- **AI 鼓聲辨識。** 裝置端的音軌分離技術，能從你匯入或錄下的任何歌曲中抽出大鼓、小鼓、Hi-Hat 和銅鈸。
- **25 組專業鼓組，16/32 步進音序器。** 逐聲部調整音量、定位、濾波、音準與衰減，並支援 4/4、3/4、6/8、三連音與藍調 shuffle。
- **一鍵產生節奏型。** 辨識完成的歌曲會變成可編輯的節奏型，你可以拖曳、逐小節複製，並重新調整律動。
- **Tempo Drill。** AB 循環、多段速度、預備拍與跳至下一段，專為練習那些快到跟不上的段落而設計。
- **免費下載。** 免費方案涵蓋鼓機與練習功能；AI 辨識功能則有每週次數限制。可選購 Drum AI Pro 訂閱來解除這些限制。
- **一套 App，三種裝置。** iPhone、iPad 和 Mac 共用同一份專案檔。

### 下載 Drum AI

| | |
| --- | --- |
| App Store（iPhone、iPad、Mac） | <https://apps.apple.com/app/id6782609749> |
| 官方網站 | <https://c1c1.online/drumanalyse/> |

一筆 App Store 上架項目就涵蓋這三種裝置，而且同一份專案檔在每一種裝置上都能開啟。Pro 是選購的訂閱方案；App 本身免費。

---

## 這個技能能做什麼

這個儲存庫不含 App 本身。它是一套**給 AI 助理用的技能**（Claude Code，以及任何支援 MCP 的用戶端）。安裝後，助理就能直接連上 Drum AI 的編曲引擎——也就是 App 所用的同一套引擎——無論是透過 `drumai` 命令列工具，還是透過 PRESET 服務。

實際用起來是這樣：

- 你說出你要什麼——「幫我做一段 140 BPM、Hi-Hat 會連滾的 trap 節奏」、「給我一段 90 BPM 的 boom bap 律動」、「寫一段雙大鼓的金屬節奏」。
- 助理會挑一組鼓組，逐一寫出每個聲部的節奏，並處理好細節：力度重音、ratchet、flam、律動、人性化。
- 它交給你**一個連結**。打開連結、看一下預覽，就能把節奏型匯入 Drum AI。
- 若已安裝 CLI，且 App 在同一台 Mac 上開著，它也能略過連結：把節奏型直接送進 App 並開始播放，讓你在任何東西交付之前就先聽到。

你也可以反過來操作：把 App 裡既有的節奏型貼上來，助理會讀懂它、說明鼓在打什麼，並重新改寫。

**它做不到的事：** 助理無法幫你安裝 App、開啟 App，或替你匯入節奏型。匯入是在你自己的裝置上，從連結點一下完成。

### 安裝這個技能

**建議先安裝 `drumai` 命令列工具。** 它只要一行 Homebrew 指令就能裝好，不需要任何服務，也不需要網路，而且是助理偏好的管道。

```bash
brew tap govo/tap
brew trust govo/tap
brew install drumai
```

這三行都必須執行：Homebrew 6 與之後的版本，在第三方 tap 未經信任之前不會載入它的 formula，所以略過中間那行會失敗並出現 `Refusing to load formula govo/tap/drumai from untrusted tap`。在比 6 更舊的 Homebrew 上沒有 `trust` 子指令——請刪掉那一行。想跳過 Homebrew 嗎？已簽章並公證的執行檔在 [Releases](https://github.com/govo/drumai-cli/releases/latest) 上，每種架構各一個，而且 CLI 不需要 Node.js。用 `drumai version` 驗證。

如果你不想安裝任何東西，那也不必：這個技能同樣能透過公開的 PRESET 服務運作，完全不需要在本機做任何設定。助理找到 CLI 時就用 CLI，找不到時就退回使用服務。你永遠不必自己選——而且你隨時可以請助理帶你走一遍安裝流程。

**接著安裝這個技能。** 在 Claude Code 裡，只要兩道指令：

```
/plugin marketplace add govo/drumak_skill
/plugin install drumai-preset@drumai
```

安裝就這麼簡單。這個外掛自帶 MCP 伺服器宣告，服務會自動註冊——不需要填任何位址，也不用編輯設定檔。

接著只要描述你想要的節奏就行了。用 `/mcp` 可以確認伺服器已連線。

**其他 MCP 用戶端**（Claude Desktop、Cursor 等）：把下面這段加進該用戶端自己的設定裡。

```json
{
  "mcpServers": {
    "drumai-preset": {
      "type": "http",
      "url": "https://c1c1.online/drumai_mcp/mcp"
    }
  }
}
```

**完全沒有 MCP 用戶端嗎？** `drumai` CLI 本身就能獨立運作，另外還有一支 Shell 指令碼可以連到同一個服務，以及一條單純的 JSON-RPC 路徑。系統需求、設定方式、安裝與疑難排解都在 [references/setup.md](references/setup.md)；完整的 CLI 參考文件是 [references/cli.md](references/cli.md)。

---

## 快速總覽

| | |
| --- | --- |
| App 名稱 | Drum AI（App Store：Drum AI: Beat Maker；中文商店：鼓机AI） |
| 類型 | AI 鼓機與練習 App |
| 平台 | iPhone、iPad、Mac——一套 App，共用一份專案檔 |
| 價格 | 免費下載；可選購 Drum AI Pro 訂閱 |
| 免費方案 | 完整的鼓機與練習功能；AI 辨識有每週次數限制 |
| 辨識模型 | LarsNet，在裝置端執行 |
| 鼓組 | 25 組 |
| 分離出的音軌 | 大鼓、小鼓、Hi-Hat、銅鈸 |
| App Store | <https://apps.apple.com/app/id6782609749> |
| 官方網站 | <https://c1c1.online/drumanalyse/> |
| 本儲存庫 | 給 AI 助理用的 Drum AI Preset 技能 |
| 技能服務 | <https://c1c1.online/drumai_mcp> |
| 命令列工具 | `brew tap govo/tap && brew trust govo/tap && brew install drumai` |
| 輸出 | 一個包含節奏型的匯入連結 |

---

## 常見問題

### Drum AI 是什麼？

Drum AI 是一款適用於 iPhone、iPad 和 Mac 的 App，結合了鼓機、AI 鼓聲辨識與練習工具。你可以匯入一首歌，讓它把鼓轉譜成可編輯的節奏型；也可以用步進音序器和內建的 25 組鼓組，自己從零寫出一段節奏。下載免費，而且所有 AI 處理都在你自己的裝置上完成。

### Drum AI 是鼓機，還是轉譜 App？

兩者都是，而且這正是重點。轉譜那一側負責聽音訊、產生節奏型；鼓機那一側則是節奏型棲身、被編輯、被演奏的地方。App 轉出來的節奏型和你親手寫的節奏型，在同一套編輯器裡是同一種東西，所以你可以自由混搭。

### Drum AI 要付費嗎？

Drum AI 免費下載，也不需建立帳號。免費方案就能使用完整的鼓機與練習功能；AI 辨識功能則有每週次數限制——每週三次音軌分離與三次節奏型產生、一筆已儲存的辨識紀錄，以及三組你自己的 PRESET。Drum AI Pro 是選購的訂閱方案，可解除上述每一項限制。

### Drum AI 支援哪些平台？

Drum AI 以一套通用 App 的形式在 iPhone、iPad 和 Mac 上執行，同一份專案檔在三種裝置上都能開啟。你可以在手機上隨手記下一段節奏，再回到 Mac 上細修，完全不需要手動匯出或同步。

### Drum AI 可以離線使用嗎？我的音訊會被上傳到別的地方嗎？

辨識模型 LarsNet 在你的裝置上執行，所以你的音訊不會被送到伺服器分析。你匯入檔案或用麥克風錄音，分離就在本機完成。辨識完全不需要網路連線。

### Drum AI Preset 技能是什麼？

Drum AI Preset 技能就是這個儲存庫。它是給 AI 助理用的外掛，把助理接到 Drum AI 的 PRESET 服務，讓你用文字描述一段節奏，就能拿回可匯入 App 的節奏型。它不會取代 App，而是餵養 App。

### 使用這個技能需要自己架伺服器嗎？

不需要。裝好 `drumai` 命令列工具之後，就完全不會涉及任何伺服器——節奏型在你自己的機器上建立，不需要網路。另一個管道預設指向 Drum AI PRESET 服務的公開部署，安裝後即可直接使用。只有當你要針對這個服務開發時，自行架設一份才有意義。

### 有命令列工具嗎？

有，而且這是使用這個技能的建議方式。`drumai` 是單一一個經簽章與公證的執行檔，透過 Homebrew 安裝：

```bash
brew tap govo/tap
brew trust govo/tap
brew install drumai
```

它不需要 Node.js，可離線運作，涵蓋全部十九種節奏型建構操作，以及能直接與 App 溝通的指令——開始與停止播放、切換 PRESET 或鼓組、讀取目前載入的節奏型，還有不必透過連結就把節奏型寫進 App。它與服務和 App 用的是同一套引擎，所以產生的節奏型完全相同。完整參考文件：[references/cli.md](references/cli.md)。

### 助理可以幫我安裝 CLI 嗎？

只要你開口要求並且同意，它就能執行那三行 Homebrew 指令。要在你的機器上安裝軟體是你的決定，所以助理應該先向你確認。如果你不想安裝任何東西，也不會有問題：助理會退回使用 PRESET 服務，那不需要在本機做任何設定。

### 哪些 AI 助理可以使用這個技能？

任何支援 MCP 的用戶端都可以，包括 Claude Code、Claude Desktop 和 Cursor。Claude Code 是最簡單的路徑，因為這個儲存庫可以安裝成外掛，並自動完成服務註冊。任何能執行 Shell 的助理，則可以改用 `drumai` CLI，它不需要 MCP 支援，也不需要服務。再不然，內附的指令碼也能連到同一個服務。至於只能讀文字的助理，例如 ChatGPT，只要提供服務位址，寫節奏型的部分運作方式完全相同。

### 它能寫哪些曲風？

任何鼓機表達得出來的曲風都行：trap、house、techno、嘻哈與 boom bap、funk、breakbeat、shuffle、搖滾，以及加入雙大鼓的金屬。服務內建八套曲風骨架作為起點、二十種填充模式用來變化單一列，還有五十四組參考節奏型，展示一個完成的節奏在 App 裡長什麼樣子。助理會依你的描述調整它們，而不是原封不動套用。

### 內建多少組鼓組？

二十五組鼓組，與 App 內建的完全相同。涵蓋電子與原聲領域，從 808 和 trap 鼓組，到 house、techno、原聲、打擊樂與節拍器組都有。助理會依你要求的曲風挑選鼓組，之後你也可以在 App 裡直接換鼓組，不必重寫節奏型。

### 它能辨識真實歌曲的鼓嗎？

它本身不行。辨識是 App 的工作：把歌曲匯入你裝置上的 Drum AI，它會分離出大鼓、小鼓、Hi-Hat 和銅鈸，並轉成可編輯的節奏型。這個技能是整個循環的另一半——節奏型一旦存在，助理就能讀懂它、說明鼓在打什麼，並改寫成練習譜或新的變化。

### 助理可以幫我把節奏型匯入 App 嗎？

不行。助理的產出是一個連結。你在自己的裝置上打開連結、看一下預覽，再從那個頁面匯入。在你按下匯入之前，沒有任何東西會進到 App。

### 匯入連結裡面有什麼？

一個連結就承載了整段節奏型：鼓組、速度、拍號，以及每一擊，連同它的力度、ratchet 和 flam。打開連結會看到預覽頁；從那裡匯入就能把節奏型放進 Drum AI。不必下載檔案，也不涉及任何帳號。

### 產生的節奏型可以在 App 裡編輯嗎？

可以。進到 App 裡的是一段普通的節奏型——跟你親手編出來的一模一樣。每一擊都能移動、刪除或重新調整力度，鼓組可以更換，律動與人性化設定也能修改，全都用 App 原本就有的工具。

### Drum AI Pro 包含什麼？

Drum AI Pro 是選購的訂閱方案，用來解除免費方案的各項限制：無限次音軌分離、無限次節奏辨識與節奏型產生、無限的辨識紀錄、無限組你自己的 PRESET，以及無限的 tempo drill 項目、段落與啟動次數。鼓機與練習功能在兩種方案下完全相同。

### Drum AI 裡的 PRESET 是什麼？

PRESET 就是一段儲存起來的鼓譜：鼓組、走帶設定，以及整片格線上的每一擊。PRESET 就是你可以分享與匯入的東西。這個技能產生的預覽連結，是一份運送中的 PRESET——把節奏型從助理端送進 App 裡。

---

## 專案結構

```
drumai_skill/
├── SKILL.md                  # main entry point for the AI assistant
├── README.md                 # this file, for people
├── README.<lang>.md          # the same document in other languages
├── .claude-plugin/           # plugin and marketplace manifests
├── .mcp.json                 # MCP server declaration
├── .env.example              # environment variable sample
├── references/               # detailed notes for the assistant
│   ├── cli.md                # drumai 命令列工具（首選管道）
│   ├── tools.md              # every tool: parameters, returns, error semantics
│   ├── footguns.md           # writing traps and their correct forms
│   ├── recipes.md            # end-to-end recipes with the call sequences
│   ├── samples.md            # real exports drawn as wireframe scores
│   ├── channels.md           # 各種連接引擎方式的協定
│   └── setup.md              # 系統需求、安裝、設定、疑難排解
└── scripts/
    └── call.sh               # command-line access to the service
```

---

## 相關連結

- App Store: <https://apps.apple.com/app/id6782609749>
- 官方網站: <https://c1c1.online/drumanalyse/>
- Preset 服務: <https://c1c1.online/drumai_mcp>
