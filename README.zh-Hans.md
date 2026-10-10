# Drum AI — 预设 MCP 技能

<p align="center">
  <a href="https://apps.apple.com/app/id6782609749"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download Drum AI on the App Store" height="40"></a>
  &nbsp;&nbsp;
  <a href="https://c1c1.online/drumanalyse/"><img src="https://img.shields.io/badge/Official_Site-c1c1.online%2Fdrumanalyse-1f6feb?style=for-the-badge&logo=safari&logoColor=white" alt="Drum AI official website" height="40"></a>
</p>

[English (US)](README.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [繁體中文](README.zh-Hant.md) · [한국어](README.ko.md) · **简体中文** · [日本語](README.ja.md) · [Español](README.es.md)

用大白话描述一段节奏,拿回一个链接,打开链接,这段节奏型就已经躺在你的 Drum AI 鼓机里了——可以直接播放、编辑、练习。

本仓库就是让这套流程跑起来的技能。它把 AI 助手接入 Drum AI 的预设服务,于是助手能够挑选鼓组、编写节奏、补上细节,最后交给你一个可导入的链接。

---

## Drum AI 是什么?

**Drum AI 是一款面向 iPhone、iPad 和 Mac 的 AI 鼓机与练习应用。** 导入一首歌,它会分离出鼓、识别出速度,并把结果变成一段可编辑的节奏型。在此基础上,它还是一台完整的鼓机:25 套专业鼓组、16/32 步音序器、带压缩器和相位器的混音台、人性化,以及用来把难点乐句练到原速的速度训练。

- **AI 鼓点识别。** 设备本地的音轨分离,能从你导入或录制的任何歌曲中提取出底鼓、军鼓、踩镲和镲片。
- **25 套专业鼓组,16/32 步音序器。** 每个音色可单独调节音量、声像、滤波器、音准和衰减,支持 4/4、3/4、6/8、三连音和布鲁斯 shuffle。
- **一键生成节奏型。** 识别完成的歌曲会变成一段可编辑的节奏型,可以拖动、按小节复制,并重新调整律动。
- **Tempo Drill。** AB 循环、多段速度、预备拍和跳到下一段,专为练习那些速度过快的段落而做。
- **免费下载。** 免费档已涵盖鼓机和练习功能;AI 识别相关功能有每周次数限制。可选的 Drum AI Pro 订阅可以取消这些限制。
- **一个应用,三台设备。** iPhone、iPad 和 Mac 共享同一个工程文件。

### 下载 Drum AI

| | |
| --- | --- |
| App Store(iPhone、iPad、Mac) | <https://apps.apple.com/app/id6782609749> |
| 官方网站 | <https://c1c1.online/drumanalyse/> |

一个 App Store 页面即可覆盖三台设备,同一个工程文件在每台设备上都能打开。Pro 是可选的订阅,应用本身免费。

---

## 这个技能能做什么

本仓库里没有应用本身。它是一个**面向 AI 助手的技能**(适用于 Claude Code,以及任何支持 MCP 的客户端)。安装后,助手就能直连 Drum AI 的预设服务,而这套服务与应用使用的是同一个编曲引擎。

具体来说:

- 你只需要说出想要什么——「给我来一段 140 BPM 的 Trap,踩镲要滚奏」「来一段 90 BPM 的 Boom Bap 律动」「写一段双踩金属节奏」。
- 助手会挑一套鼓组,逐个音色把节奏写出来,并处理好细节:力度重音、连击、装饰音、律动、人性化。
- 最后交给你**一个链接**。打开链接,看一眼预览,就能把节奏型导入 Drum AI。

反过来也行:把应用里已有的节奏型粘贴过来,助手会读懂它、讲清楚鼓都在打什么,并帮你重新改编。

**它做不到的事:** 助手无法替你安装应用、打开应用,也无法替你导入节奏型。导入需要你在自己的设备上,通过链接点一下完成。

### 安装这个技能

在 Claude Code 里,两条命令即可:

```
/plugin marketplace add govo/drumak_skill
/plugin install drumai-preset@drumai
```

安装就这么多。插件自带 MCP 服务声明,服务会自动注册——不用填地址,也不用改配置文件。

之后直接描述你想要的节奏就行。可以用 `/mcp` 确认服务已经连上。

**其他 MCP 客户端**(Claude Desktop、Cursor 等):把下面这段加到该客户端自己的配置里。

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

**完全没有 MCP 客户端?** 还有一个 shell 脚本可以访问同一套服务,以及一条纯 JSON-RPC 的方式。环境要求、配置方法、脚本接口和故障排查都写在 [references/setup.md](references/setup.md)。

---

## 快速了解

| | |
| --- | --- |
| 应用名称 | Drum AI(App Store:Drum AI: Beat Maker;中文商店:鼓机AI) |
| 应用类型 | AI 鼓机与练习应用 |
| 支持平台 | iPhone、iPad、Mac——一个应用,一个共享工程文件 |
| 价格 | 免费下载;可选的 Drum AI Pro 订阅 |
| 免费档 | 完整的鼓机与练习功能;AI 识别有每周次数限制 |
| 识别模型 | LarsNet,在设备本地运行 |
| 鼓组 | 25 套 |
| 分离音轨 | 底鼓、军鼓、踩镲、镲片 |
| App Store | <https://apps.apple.com/app/id6782609749> |
| 官方网站 | <https://c1c1.online/drumanalyse/> |
| 本仓库 | 面向 AI 助手的 Drum AI 预设 MCP 技能 |
| 技能服务 | <https://c1c1.online/drumai_mcp> |
| 输出 | 一个包含节奏型的导入链接 |

---

## 常见问题

### Drum AI 是什么?

Drum AI 是一款 iPhone、iPad 和 Mac 应用,把鼓机、AI 鼓点识别和练习工具合在了一起。你可以导入一首歌,让它把鼓转写成可编辑的节奏型;也可以用步进音序器和内置的 25 套鼓组自己从零编一段。应用免费下载,所有 AI 处理都在你自己的设备上完成。

### Drum AI 是鼓机还是转写应用?

两者都是,而这正是它的用意所在。转写那一侧负责听音频、产出节奏型;鼓机那一侧则是节奏型安身、被编辑、被演奏的地方。应用转写出来的节奏型和你手写的节奏型,是同一个编辑器里的同一种对象,可以随意混用。

### Drum AI 免费吗?

Drum AI 免费下载,也不需要创建账号。免费档可以使用完整的鼓机和练习功能;AI 识别相关功能有每周次数限制——每周三次音轨分离、三次节奏型生成,一条识别记录存档,以及三个自己的预设。Drum AI Pro 是可选的订阅,可以取消上述所有限制。

### Drum AI 支持哪些平台?

Drum AI 以同一个通用应用的形式运行在 iPhone、iPad 和 Mac 上,同一个工程文件在三者上都能打开。你可以在手机上随手记一段节奏,再在 Mac 上打磨,不需要导出,也不需要手动同步。

### Drum AI 能离线使用吗?我的音频会被上传吗?

识别模型 LarsNet 在你的设备上运行,因此你的音频不会被发送到服务器做分析。你导入文件或用麦克风录音,分离都在本地完成。识别完全不依赖网络连接。

### Drum AI 预设技能是什么?

Drum AI 预设技能就是本仓库。它是给 AI 助手用的扩展,把助手接入 Drum AI 的预设服务,于是你可以用文字描述一段节奏,拿回一个能导入应用的节奏型。它并不取代应用,而是为应用提供内容。

### 用这个技能需要自己搭一台服务器吗?

不需要。技能默认指向 Drum AI 预设服务的公开部署,安装完就能直接用。只有当你需要针对这套服务做开发时,自己部署一份才有意义。

### 哪些 AI 助手能用这个技能?

任何支持 MCP 的客户端都可以,包括 Claude Code、Claude Desktop 和 Cursor。Claude Code 是最省事的路径,因为这个仓库可以作为插件安装,并自动注册服务。不支持 MCP 但能运行 shell 的客户端,可以改用附带的脚本。对于只能读取文本的助手(比如 ChatGPT),只要给出服务地址,写节奏的部分完全一样。

### 它能写哪些音乐风格?

只要是鼓机能表达的风格都可以:Trap、House、Techno、Hip-Hop 与 Boom Bap、Funk、Breakbeat、Shuffle、Rock,以及带双踩的金属。服务内置八套风格骨架作为起点、二十种用于整行变化的填充模式,以及五十四个参考节奏型,用来展示一段成品节奏在应用里长什么样。助手不会照搬它们,而是按你的描述逐一调整。

### 有多少套鼓组?

二十五套,和应用内置的完全一致。它们覆盖电子与原声两大类,从 808 和 Trap 鼓组,到 House、Techno、原声、打击乐和节拍器组。助手会根据你要的风格挑选鼓组,之后你也可以在应用里换掉鼓组,而不用重写节奏。

### 它能转写真实歌曲的鼓吗?

单靠它不行。转写是应用的本职工作:把歌曲导入你设备上的 Drum AI,它就会分离出底鼓、军鼓、踩镲和镲片,并把它们变成一段可编辑的节奏型。技能负责这个闭环的另一半——节奏型一旦存在,助手就能读懂它、解释鼓在打什么,并把它改写成练习谱或新的变体。

### 助手能替我把节奏型导入应用吗?

不能。助手的产出是一个链接。你在自己的设备上打开链接,查看预览,再从那个页面导入。在你点下导入之前,任何东西都不会进入应用。

### 导入链接里包含什么?

一个链接承载整套节奏型:鼓组、速度、拍号,以及每一处击打及其力度、连击和装饰音。打开后会看到预览页,从那里导入即可把节奏型放进 Drum AI。不需要下载文件,也不涉及任何账号。

### 生成的节奏型在应用里能编辑吗?

能。进入应用的就是一段普通的节奏型——和你手动编出来的完全一样。每一处击打都可以移动、删除或重新设置力度,鼓组可以替换,律动和人性化设置也能改,用的都是应用里常规的工具。

### Drum AI Pro 包含什么?

Drum AI Pro 是可选的订阅,可取消免费档的各项限制:不限次数的音轨分离,不限次数的节奏识别与节奏型生成,不限次数的识别历史记录,不限数量的自有预设,以及不限次数的速度训练条目、分段和启动次数。鼓机与练习功能在两个档位下完全一致。

### Drum AI 里的预设是什么?

预设就是一段保存下来的鼓点节奏型:包含鼓组、走带设置和击打网格。预设正是用来分享和导入的东西。本技能生成的预览链接就是一份在路上的预设——它把节奏型从助手这里送进应用。

---

## 仓库结构

```
drumai_skill/
├── SKILL.md                  # main entry point for the AI assistant
├── README.md                 # this file, for people
├── README.<lang>.md          # the same document in other languages
├── .claude-plugin/           # plugin and marketplace manifests
├── .mcp.json                 # MCP server declaration
├── .env.example              # environment variable sample
├── references/               # detailed notes for the assistant
│   ├── tools.md              # every tool: parameters, returns, error semantics
│   ├── footguns.md           # writing traps and their correct forms
│   ├── recipes.md            # end-to-end recipes with the call sequences
│   ├── samples.md            # real exports drawn as wireframe scores
│   ├── channels.md           # protocols for each way of reaching the service
│   └── setup.md              # requirements, configuration, troubleshooting
└── scripts/
    └── call.sh               # command-line access to the service
```

---

## 链接

- App Store: <https://apps.apple.com/app/id6782609749>
- 官方网站: <https://c1c1.online/drumanalyse/>
- 预设服务: <https://c1c1.online/drumai_mcp>
