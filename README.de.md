# Drum AI — Preset-MCP-Skill

<p align="center">
  <a href="https://apps.apple.com/app/id6782609749"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download Drum AI on the App Store" height="40"></a>
  &nbsp;&nbsp;
  <a href="https://c1c1.online/drumanalyse/"><img src="https://img.shields.io/badge/Official_Site-c1c1.online%2Fdrumanalyse-1f6feb?style=for-the-badge&logo=safari&logoColor=white" alt="Drum AI official website" height="40"></a>
</p>

[English (US)](README.md) · **Deutsch** · [Français](README.fr.md) · [繁體中文](README.zh-Hant.md) · [한국어](README.ko.md) · [简体中文](README.zh-Hans.md) · [日本語](README.ja.md) · [Español](README.es.md)

Beschreibe einen Beat in normaler Sprache, du bekommst einen Link zurück, öffnest ihn – und das Pattern liegt in deiner Drum-Machine in Drum AI, fertig zum Abspielen, Bearbeiten und Üben.

Dieses Repository ist der Skill, der das möglich macht. Er verbindet einen KI-Assistenten mit dem PRESET-Dienst von Drum AI, sodass der Assistent ein Kit auswählen, das Pattern schreiben, die Feinheiten ergänzen und dir einen Link zum Importieren in die Hand geben kann.

---

## Was ist Drum AI?

**Drum AI ist eine KI-Drum-Machine und Übungs-App für iPhone, iPad und Mac.** Importiere einen Song, und sie trennt die Drums, erkennt das Tempo und macht daraus ein editierbares Pattern. Von dort aus ist sie eine vollwertige Drum-Machine: 24 Profi-Kits, ein 16/32-Step-Sequencer, ein Mixer mit Kompressor und Phaser, Humanize und ein Tempo-Drill, mit dem du dir eine schwere Passage auf Tempo hocharbeitest.

- **KI-Schlagzeugerkennung.** Die Stem-Trennung auf dem Gerät holt Kick, Snare, Hi-Hat und Becken aus jedem Song, den du importierst oder aufnimmst.
- **24 Profi-Kits, 16/32-Step-Sequencer.** Level, Pan, Filter, Tune und Decay pro Stimme, dazu 4/4, 3/4, 6/8, Triolen und Blues-Shuffle.
- **Pattern-Erzeugung per Fingertipp.** Aus einem erkannten Song wird ein editierbares Pattern, das du verschieben, Takt für Takt kopieren und neu grooven kannst.
- **Tempo Drill.** AB-Loop, mehrere Geschwindigkeitssegmente, Count-in und Skip-to-Next – gemacht zum Üben der Stellen, die zu schnell sind.
- **Kostenloser Download.** Die kostenlose Version deckt die Drum-Machine und die Übungsfunktionen ab; die KI-Erkennung hat wöchentliche Limits. Ein optionales Drum AI Pro-Abonnement hebt sie auf.
- **Eine App, drei Geräte.** iPhone, iPad und Mac teilen dieselbe Projektdatei.

### Drum AI herunterladen

| | |
| --- | --- |
| App Store (iPhone, iPad, Mac) | <https://apps.apple.com/app/id6782609749> |
| Offizielle Website | <https://c1c1.online/drumanalyse/> |

Ein einziger App-Store-Eintrag deckt alle drei Geräte ab, und dieselbe Projektdatei öffnet sich auf jedem davon. Pro ist ein optionales Abonnement; die App selbst ist kostenlos.

---

## Was dieser Skill macht

Dieses Repository enthält nicht die App. Es ist ein **Skill für KI-Assistenten** (Claude Code und jeder Client, der MCP spricht). Nach der Installation hat der Assistent eine direkte Verbindung zum PRESET-Dienst von Drum AI – derselben Sequencer-Engine, die auch die App verwendet.

Was das in der Praxis bedeutet:

- Du sagst, was du willst – „mach mir einen 140-BPM-Trap-Beat mit rollendem Hi-Hat“, „gib mir einen Boom-Bap-Groove mit 90 BPM“, „schreib mir ein Double-Bass-Metal-Pattern“.
- Der Assistent wählt ein Kit, schreibt das Pattern Stimme für Stimme und kümmert sich um die Details: Velocity-Akzente, Ratchets, Flams, Groove, Humanize.
- Du bekommst **einen Link**. Öffne den Link, sieh dir die Vorschau an und importiere das Pattern in Drum AI.

Du kannst auch den umgekehrten Weg gehen: Füge ein Pattern ein, das du bereits in der App hast, und der Assistent liest es aus, erklärt dir, was die Drums machen, und arbeitet es um.

**Was er nicht kann:** Der Assistent kann die App nicht installieren, nicht öffnen und das Pattern nicht für dich importieren. Der Import ist ein Fingertipp auf deinem eigenen Gerät, aus dem Link heraus.

### Diesen Skill installieren

In Claude Code genügen zwei Befehle:

```
/plugin marketplace add govo/drumak_skill
/plugin install drumai-preset@drumai
```

Das ist die gesamte Installation. Das Plugin bringt seine eigene MCP-Server-Deklaration mit, der Dienst registriert sich also automatisch – es gibt keine Adresse einzutragen und keine Konfigurationsdatei zu bearbeiten.

Dann beschreib einfach den Beat, den du haben willst. Mit `/mcp` prüfst du, ob der Server verbunden ist.

**Andere MCP-Clients** (Claude Desktop, Cursor und weitere): Füge diesen Block in die Konfiguration des jeweiligen Clients ein.

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

**Gar kein MCP-Client?** Es gibt ein Shell-Skript, das denselben Dienst erreicht, und einen reinen JSON-RPC-Weg. Voraussetzungen, Konfiguration, die Skript-Schnittstelle und Fehlerbehebung stehen in [references/setup.md](references/setup.md).

---

## Auf einen Blick

| | |
| --- | --- |
| App-Name | Drum AI (App Store: Drum AI: Beat Maker; chinesischer Store: 鼓机AI) |
| Was es ist | KI-Drum-Machine und Übungs-App |
| Plattformen | iPhone, iPad, Mac – eine App, eine gemeinsame Projektdatei |
| Preis | Kostenloser Download; optionales Drum AI Pro-Abonnement |
| Kostenlose Version | Komplette Drum-Machine und Übungsfunktionen; wöchentliche Limits bei der KI-Erkennung |
| Erkennungsmodell | LarsNet, läuft auf dem Gerät |
| Drum-Kits | 24 |
| Getrennte Stems | Kick, Snare, Hi-Hat, Becken |
| App Store | <https://apps.apple.com/app/id6782609749> |
| Offizielle Website | <https://c1c1.online/drumanalyse/> |
| Dieses Repository | Drum AI Preset MCP-Skill für KI-Assistenten |
| Skill-Dienst | <https://c1c1.online/drumai_mcp> |
| Ausgabe | Ein Import-Link mit dem Pattern |

---

## FAQ

### Was ist Drum AI?

Drum AI ist eine App für iPhone, iPad und Mac, die eine Drum-Machine, KI-Schlagzeugerkennung und ein Übungstool vereint. Du kannst einen Song importieren und die Drums in ein editierbares Pattern transkribieren lassen – oder mit dem Step-Sequencer und seinen 24 Kits selbst einen Beat von Grund auf schreiben. Der Download ist kostenlos, und die gesamte KI-Verarbeitung findet auf deinem eigenen Gerät statt.

### Ist Drum AI eine Drum-Machine oder eine Transkriptions-App?

Beides – und genau darum geht es. Die Transkriptionsseite hört Audio und erzeugt daraus ein Pattern; die Drum-Machine ist der Ort, an dem dieses Pattern lebt, bearbeitet und abgespielt wird. Ein von der App transkribiertes Pattern und eines, das du von Hand geschrieben hast, sind im selben Editor dieselbe Art von Objekt – du kannst also beide frei mischen.

### Ist Drum AI kostenlos?

Drum AI ist kostenlos erhältlich, und es ist kein Konto anzulegen. In der kostenlosen Version stehen die komplette Drum-Machine und die Übungsfunktionen zur Verfügung; die KI-Erkennung hat wöchentliche Limits – drei Stem-Trennungen und drei Pattern-Erzeugungen pro Woche, ein gespeicherter Erkennungseintrag und drei eigene PRESETs. Drum AI Pro ist ein optionales Abonnement, das jedes dieser Limits aufhebt.

### Auf welchen Plattformen läuft Drum AI?

Drum AI läuft als eine universelle App auf iPhone, iPad und Mac, und dieselbe Projektdatei öffnet sich auf allen drei Geräten. Du kannst einen Beat auf dem iPhone skizzieren und ihn auf dem Mac verfeinern, ohne etwas exportieren oder von Hand synchronisieren zu müssen.

### Funktioniert Drum AI offline? Wird mein Audio irgendwohin hochgeladen?

Das Erkennungsmodell LarsNet läuft auf deinem Gerät, dein Audio wird also nicht zur Analyse an einen Server geschickt. Du importierst eine Datei oder nimmst mit dem Mikrofon auf, und die Trennung findet lokal statt. Nichts an der Erkennung hängt von einer Netzwerkverbindung ab.

### Was ist der Drum AI Preset Skill?

Der Drum AI Preset Skill ist dieses Repository. Es ist ein Add-on für KI-Assistenten, das sie mit dem PRESET-Dienst von Drum AI verbindet, sodass du einen Beat in Worten beschreiben und ein Pattern zurückbekommst, das du in die App importieren kannst. Die App ersetzt er nicht – er versorgt sie.

### Brauche ich einen eigenen Server, um diesen Skill zu nutzen?

Nein. Der Skill verweist standardmäßig auf eine öffentliche Instanz des PRESET-Dienstes von Drum AI und funktioniert nach der Installation unverändert. Eine eigene Kopie zu betreiben ist nur sinnvoll, wenn du gegen den Dienst entwickelst.

### Welche KI-Assistenten können diesen Skill nutzen?

Jeder Client, der MCP unterstützt, darunter Claude Code, Claude Desktop und Cursor. Claude Code ist der einfachste Weg, weil sich dieses Repository als Plugin installieren lässt, das den Dienst automatisch registriert. Clients, die kein MCP können, aber eine Shell ausführen können, nutzen stattdessen das mitgelieferte Skript. Bei Assistenten, die nur Text lesen können, etwa ChatGPT, funktioniert das Schreiben von Patterns genauso, sobald die Dienst-Adresse angegeben ist.

### Welche Musikstile kann er schreiben?

Jeden Stil, den eine Drum-Machine ausdrücken kann: Trap, House, Techno, Hip-Hop und Boom Bap, Funk, Breakbeat, Shuffle, Rock und Metal mit Double Bass. Der Dienst liefert acht Stil-Skelette als Ausgangspunkt, zwanzig Fill-Modi zum Variieren einer Spur und zweiundzwanzig Referenz-Patterns, die zeigen, wie ein fertiger Beat in der App aussieht. Der Assistent passt jedes davon an deine Beschreibung an, statt es wortwörtlich anzuwenden.

### Wie viele Drum-Kits gibt es?

Vierundzwanzig Kits – dieselben, die auch die App mitbringt. Sie decken elektronisches und akustisches Terrain ab, von 808s und Trap-Kits bis zu House-, Techno-, Akustik- und Percussion-Sets. Der Assistent wählt ein Kit passend zum gewünschten Stil, und du kannst das Kit in der App später austauschen, ohne das Pattern neu zu schreiben.

### Kann er die Drums eines echten Songs transkribieren?

Nicht von sich aus. Die Transkription erledigt die App: Importiere den Song auf deinem Gerät in Drum AI, und sie trennt Kick, Snare, Hi-Hat und Becken heraus und macht daraus ein editierbares Pattern. Der Skill ist die andere Hälfte des Kreislaufs – sobald das Pattern existiert, kann der Assistent es lesen, erklären, was die Drums machen, und es in ein Übungs-Chart oder eine neue Variation umschreiben.

### Kann der Assistent das Pattern für mich in die App importieren?

Nein. Die Ausgabe des Assistenten ist ein Link. Du öffnest den Link auf deinem Gerät, siehst dir die Vorschau an und importierst von dieser Seite aus. Nichts erreicht die App, bevor du auf Importieren tippst.

### Was enthält der Import-Link?

Ein Link transportiert das ganze Pattern: das Kit, das Tempo, die Taktart und jeden Hit mit seiner Velocity, seinen Ratchets und Flams. Beim Öffnen erscheint eine Vorschauseite; der Import von dort legt das Pattern in Drum AI ab. Es gibt keine Datei zum Herunterladen und kein Konto.

### Ist das erzeugte Pattern in der App editierbar?

Ja. Was in der App ankommt, ist ein ganz normales Pattern – genau das, was du auch von Hand programmiert hättest. Jeder Hit lässt sich verschieben, löschen oder in der Velocity anpassen, das Kit kann gewechselt werden, und die Groove- und Humanize-Einstellungen lassen sich ändern, alles mit den normalen Werkzeugen der App.

### Was ist in Drum AI Pro enthalten?

Drum AI Pro ist ein optionales Abonnement, das die Limits der kostenlosen Version aufhebt: unbegrenzte Stem-Trennung, unbegrenzte Beat-Erkennung und Pattern-Erzeugung, unbegrenzter Erkennungsverlauf, unbegrenzt viele eigene PRESETs und unbegrenzte Tempo-Drill-Einträge, -Segmente und -Starts. Die Drum-Machine und die Übungsfunktionen arbeiten in beiden Versionen gleich.

### Was ist ein PRESET in Drum AI?

Ein PRESET ist ein gespeichertes Drum-Pattern: das Kit, die Transport-Einstellungen und das Raster der Hits. PRESETs sind das, was du teilst und importierst. Der Vorschau-Link, den dieser Skill erzeugt, ist ein PRESET auf dem Weg – er transportiert das Pattern vom Assistenten in die App.

---

## Repository-Aufbau

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

## Links

- App Store: <https://apps.apple.com/app/id6782609749>
- Offizielle Website: <https://c1c1.online/drumanalyse/>
- Preset-Dienst: <https://c1c1.online/drumai_mcp>
