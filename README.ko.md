# Drum AI — Preset MCP 스킬

<p align="center">
  <a href="https://apps.apple.com/app/id6782609749"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download Drum AI on the App Store" height="40"></a>
  &nbsp;&nbsp;
  <a href="https://c1c1.online/drumanalyse/"><img src="https://img.shields.io/badge/Official_Site-c1c1.online%2Fdrumanalyse-1f6feb?style=for-the-badge&logo=safari&logoColor=white" alt="Drum AI official website" height="40"></a>
</p>

[English (US)](README.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [繁體中文](README.zh-Hant.md) · **한국어** · [简体中文](README.zh-Hans.md) · [日本語](README.ja.md) · [Español](README.es.md)

원하는 비트를 일상적인 말로 설명하기만 하면 링크 하나가 돌아옵니다. 그 링크를 열면 패턴이 Drum AI 드럼 머신에 들어가 있고, 바로 연주하고 편집하며 연습할 수 있습니다.

이 저장소는 그 과정을 가능하게 하는 스킬입니다. AI 어시스턴트를 Drum AI의 PRESET 서비스에 연결해 주므로, 어시스턴트가 키트를 고르고 패턴을 쓰고 디테일을 더한 뒤 가져오기용 링크를 건네줄 수 있습니다.

---

## Drum AI란 무엇인가요?

**Drum AI는 iPhone, iPad, Mac을 위한 AI 드럼 머신 겸 연습 앱입니다.** 곡을 가져오면 드럼을 분리하고 템포를 감지해 편집 가능한 패턴으로 만들어 줍니다. 거기서부터는 완전한 드럼 머신입니다. 24개의 프로 키트, 16/32스텝 시퀀서, 컴프레서와 페이저가 포함된 믹서, 휴머나이즈, 그리고 어려운 구간을 제 속도까지 끌어올리기 위한 템포 드릴을 갖추고 있습니다.

- **AI 드럼 인식.** 기기 안에서 실행되는 스템 분리가 가져오거나 녹음한 곡에서 킥, 스네어, 하이햇, 심벌즈를 뽑아냅니다.
- **24개 프로 키트, 16/32스텝 시퀀서.** 보이스별 레벨, 팬, 필터, 튠, 디케이에 더해 4/4, 3/4, 6/8, 트리플렛, 블루스 셔플을 지원합니다.
- **원탭 패턴 생성.** 인식된 곡이 드래그하고 마디 단위로 복사하며 그루브를 다시 입힐 수 있는 편집 가능한 패턴이 됩니다.
- **Tempo Drill.** AB 루프, 여러 개의 속도 구간, 카운트인, 다음 구간 건너뛰기를 지원하며, 너무 빠른 부분을 연습하기 위해 만들었습니다.
- **무료 다운로드.** 무료 등급에서도 드럼 머신과 연습 기능을 모두 쓸 수 있으며, AI 인식 기능에는 주간 제한이 있습니다. 선택형 Drum AI Pro 구독을 하면 이 제한이 사라집니다.
- **하나의 앱, 세 가지 기기.** iPhone, iPad, Mac이 같은 프로젝트 파일을 공유합니다.

### Drum AI 다운로드

| | |
| --- | --- |
| App Store (iPhone, iPad, Mac) | <https://apps.apple.com/app/id6782609749> |
| 공식 웹사이트 | <https://c1c1.online/drumanalyse/> |

하나의 App Store 등록 정보로 세 기기를 모두 지원하며, 같은 프로젝트 파일이 각 기기에서 열립니다. Pro는 선택형 구독이고 앱 자체는 무료입니다.

---

## 이 스킬은 무엇을 하나요?

이 저장소에는 앱이 들어 있지 않습니다. **AI 어시스턴트를 위한 스킬**(Claude Code, 그리고 MCP를 지원하는 모든 클라이언트)입니다. 설치하면 어시스턴트가 Drum AI의 PRESET 서비스에 직접 연결되며, 이는 앱이 사용하는 것과 동일한 시퀀싱 엔진입니다.

실제로는 이런 뜻입니다.

- 원하는 것을 말하면 됩니다. "롤링 하이햇이 들어간 140 BPM 트랩 비트 만들어 줘", "90 BPM 붐뱁 그루브 하나 줘", "더블 베이스 메탈 패턴 써 줘".
- 어시스턴트가 키트를 고르고, 보이스 하나하나씩 패턴을 쓰고, 디테일까지 챙깁니다. 벨로시티 액센트, 라쳇, 플램, 그루브, 휴머나이즈까지요.
- 그러고는 **링크 하나**를 건네줍니다. 링크를 열어 미리보기를 확인하고 패턴을 Drum AI로 가져오면 됩니다.

반대 방향도 됩니다. 앱에 이미 가지고 있는 패턴을 붙여 넣으면, 어시스턴트가 그것을 읽고 드럼이 어떻게 연주되는지 설명한 뒤 다시 손봐 줍니다.

**할 수 없는 일:** 어시스턴트는 앱을 설치하거나 열거나 패턴을 대신 가져올 수 없습니다. 가져오기는 링크를 통해 사용자 기기에서 탭 한 번이면 됩니다.

### 이 스킬 설치하기

Claude Code에서는 명령 두 줄이면 됩니다.

```
/plugin marketplace add govo/drumak_skill
/plugin install drumai-preset@drumai
```

이게 설치의 전부입니다. 플러그인이 자체 MCP 서버 선언을 함께 가지고 있어 서비스가 자동으로 등록되므로, 입력할 주소도 편집할 설정 파일도 없습니다.

그다음 원하는 비트를 설명하면 됩니다. 서버가 연결되었는지 확인하려면 `/mcp`를 실행하세요.

**다른 MCP 클라이언트**(Claude Desktop, Cursor 등): 해당 클라이언트의 설정에 아래 블록을 추가하세요.

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

**MCP 클라이언트가 아예 없나요?** 같은 서비스에 접근하는 셸 스크립트와 일반 JSON-RPC 경로가 있습니다. 요구 사항, 설정, 스크립트 인터페이스, 문제 해결은 [references/setup.md](references/setup.md)에 정리해 두었습니다.

---

## 한눈에 보기

| | |
| --- | --- |
| 앱 이름 | Drum AI (App Store: Drum AI: Beat Maker, 중국 스토어: 鼓机AI) |
| 무엇인가 | AI 드럼 머신 겸 연습 앱 |
| 플랫폼 | iPhone, iPad, Mac — 하나의 앱, 하나의 공유 프로젝트 파일 |
| 가격 | 무료 다운로드, 선택형 Drum AI Pro 구독 |
| 무료 등급 | 드럼 머신과 연습 기능 전체 이용 가능, AI 인식에는 주간 제한 |
| 인식 모델 | LarsNet, 기기 안에서 실행 |
| 드럼 키트 | 24개 |
| 분리하는 스템 | 킥, 스네어, 하이햇, 심벌즈 |
| App Store | <https://apps.apple.com/app/id6782609749> |
| 공식 웹사이트 | <https://c1c1.online/drumanalyse/> |
| 이 저장소 | AI 어시스턴트를 위한 Drum AI Preset MCP 스킬 |
| 스킬 서비스 | <https://c1c1.online/drumai_mcp> |
| 출력 | 패턴이 담긴 가져오기 링크 하나 |

---

## FAQ

### Drum AI란 무엇인가요?

Drum AI는 iPhone, iPad, Mac용 앱으로, 드럼 머신과 AI 드럼 인식, 연습 도구를 결합했습니다. 곡을 가져와 드럼을 편집 가능한 패턴으로 채보하게 할 수도 있고, 스텝 시퀀서와 24개 키트로 비트를 처음부터 직접 쓸 수도 있습니다. 무료로 다운로드할 수 있으며, 모든 AI 처리는 사용자 기기에서 이루어집니다.

### Drum AI는 드럼 머신인가요, 채보 앱인가요?

둘 다이며, 바로 그게 핵심입니다. 채보 쪽은 오디오를 듣고 패턴을 만들어 내고, 드럼 머신 쪽은 그 패턴이 살아 있고 편집되고 연주되는 곳입니다. 앱이 채보한 패턴과 직접 손으로 쓴 패턴은 같은 편집기 안의 같은 종류의 대상이므로, 둘을 자유롭게 섞어 쓸 수 있습니다.

### Drum AI는 무료인가요?

Drum AI는 무료로 다운로드할 수 있고, 만들어야 하는 계정도 없습니다. 무료 등급에서도 드럼 머신과 연습 기능 전체를 쓸 수 있으며, AI 인식 기능에는 주간 제한이 있습니다. 스템 분리와 패턴 생성이 각각 주 3회, 저장되는 인식 기록 1개, 직접 만든 PRESET 3개까지입니다. Drum AI Pro는 이런 제한을 모두 없애 주는 선택형 구독입니다.

### Drum AI는 어떤 플랫폼에서 실행되나요?

Drum AI는 iPhone, iPad, Mac에서 하나의 유니버설 앱으로 실행되며, 같은 프로젝트 파일이 세 기기 모두에서 열립니다. 휴대폰에서 비트를 대충 잡고 Mac에서 다듬을 때, 따로 내보내거나 손으로 동기화할 필요가 없습니다.

### Drum AI는 오프라인에서도 동작하나요? 제 오디오가 어딘가에 업로드되나요?

인식 모델인 LarsNet은 사용자 기기에서 실행되므로, 오디오가 분석을 위해 서버로 전송되지 않습니다. 파일을 가져오거나 마이크로 녹음하면 분리가 기기 안에서 이루어집니다. 인식은 네트워크 연결에 전혀 의존하지 않습니다.

### Drum AI Preset 스킬이란 무엇인가요?

Drum AI Preset 스킬은 바로 이 저장소입니다. AI 어시스턴트를 Drum AI의 PRESET 서비스에 연결해 주는 애드온으로, 비트를 말로 설명하면 앱으로 가져올 수 있는 패턴을 돌려받을 수 있습니다. 앱을 대체하는 것이 아니라 앱에 공급하는 역할입니다.

### 이 스킬을 쓰려면 제 서버가 필요한가요?

아니요. 이 스킬은 기본적으로 Drum AI PRESET 서비스의 공개 배포본을 가리키며, 설치 후 그대로 동작합니다. 직접 사본을 돌리는 것은 서비스를 대상으로 개발할 때만 유용합니다.

### 어떤 AI 어시스턴트가 이 스킬을 쓸 수 있나요?

Claude Code, Claude Desktop, Cursor를 비롯해 MCP를 지원하는 모든 클라이언트입니다. 가장 간단한 방법은 Claude Code인데, 이 저장소를 서비스를 자동으로 등록하는 플러그인으로 설치할 수 있기 때문입니다. MCP는 못 쓰지만 셸은 실행할 수 있는 클라이언트라면 함께 제공되는 스크립트를 대신 사용하면 됩니다. ChatGPT처럼 텍스트만 읽을 수 있는 어시스턴트라도 서비스 주소만 주어지면 패턴 작성 방식은 동일합니다.

### 어떤 음악 스타일을 쓸 수 있나요?

드럼 머신이 표현할 수 있는 모든 스타일입니다. 트랩, 하우스, 테크노, 힙합과 붐뱁, 펑크, 브레이크비트, 셔플, 록, 그리고 더블 베이스가 들어간 메탈까지요. 서비스에는 시작점으로 쓸 8개의 스타일 뼈대, 한 행을 변주하는 20가지 필 모드, 그리고 앱에서 완성된 비트가 어떤 모습인지 보여 주는 50개의 레퍼런스 패턴이 들어 있습니다. 어시스턴트는 이들을 그대로 적용하는 것이 아니라 사용자의 설명에 맞게 조정합니다.

### 드럼 키트는 몇 개나 있나요?

24개이며, 앱에 기본 포함된 것과 동일합니다. 808과 트랩 키트부터 하우스, 테크노, 어쿠스틱, 퍼커션 세트까지 전자음과 어쿠스틱 영역을 아우릅니다. 어시스턴트가 요청한 스타일에 맞는 키트를 고르며, 이후 앱에서 패턴을 다시 쓰지 않고도 키트를 바꿀 수 있습니다.

### 실제 곡의 드럼도 채보할 수 있나요?

그것만으로는 안 됩니다. 채보는 앱이 하는 일입니다. 기기의 Drum AI로 곡을 가져오면 앱이 킥, 스네어, 하이햇, 심벌즈를 분리해 편집 가능한 패턴으로 만들어 줍니다. 이 스킬은 그 순환의 나머지 절반으로, 패턴이 만들어지고 나면 어시스턴트가 그것을 읽고 드럼이 어떻게 연주되는지 설명한 뒤 연습용 악보나 새로운 변주로 다시 써 줍니다.

### 어시스턴트가 패턴을 앱으로 대신 가져와 주나요?

아니요. 어시스턴트의 출력은 링크입니다. 사용자가 기기에서 링크를 열고 미리보기를 확인한 뒤 그 페이지에서 가져오면 됩니다. 가져오기를 탭하기 전까지는 앱에 아무것도 전달되지 않습니다.

### 가져오기 링크에는 무엇이 들어 있나요?

링크 하나에 패턴 전체가 담깁니다. 키트, 템포, 박자표, 그리고 벨로시티와 라쳇, 플램이 포함된 모든 타격입니다. 링크를 열면 미리보기 페이지가 나오고, 거기서 가져오면 패턴이 Drum AI에 들어갑니다. 내려받을 파일도, 관여하는 계정도 없습니다.

### 생성된 패턴을 앱에서 편집할 수 있나요?

네. 앱에 도착하는 것은 평범한 패턴, 즉 직접 프로그램한 것과 똑같은 것입니다. 모든 타격을 옮기거나 지우거나 벨로시티를 다시 조정할 수 있고, 키트를 바꿀 수 있으며, 그루브와 휴머나이즈 설정도 앱의 일반 도구로 모두 변경할 수 있습니다.

### Drum AI Pro에는 무엇이 포함되나요?

Drum AI Pro는 무료 등급의 제한을 없애 주는 선택형 구독입니다. 무제한 스템 분리, 무제한 비트 인식과 패턴 생성, 무제한 인식 기록, 무제한 PRESET, 그리고 무제한 템포 드릴 항목·구간·실행을 제공합니다. 드럼 머신과 연습 기능은 두 등급에서 동일하게 동작합니다.

### Drum AI에서 PRESET이란 무엇인가요?

PRESET은 저장된 드럼 패턴으로, 키트와 전송 설정, 그리고 타격 그리드를 담고 있습니다. PRESET이 바로 공유하고 가져오는 대상입니다. 이 스킬이 만들어 내는 미리보기 링크는 이동 중인 PRESET으로, 패턴을 어시스턴트로부터 앱까지 실어 나릅니다.

---

## 저장소 구조

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

## 링크

- App Store: <https://apps.apple.com/app/id6782609749>
- 공식 웹사이트: <https://c1c1.online/drumanalyse/>
- Preset 서비스: <https://c1c1.online/drumai_mcp>
