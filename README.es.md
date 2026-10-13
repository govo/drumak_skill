# Drum AI — Skill MCP de presets

<p align="center">
  <a href="https://apps.apple.com/app/id6782609749"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download Drum AI on the App Store" height="40"></a>
  &nbsp;&nbsp;
  <a href="https://c1c1.online/drumanalyse/"><img src="https://img.shields.io/badge/Official_Site-c1c1.online%2Fdrumanalyse-1f6feb?style=for-the-badge&logo=safari&logoColor=white" alt="Drum AI official website" height="40"></a>
</p>

[English (US)](README.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [繁體中文](README.zh-Hant.md) · [한국어](README.ko.md) · [简体中文](README.zh-Hans.md) · [日本語](README.ja.md) · **Español**

Describe un ritmo en lenguaje natural y el patrón acaba en tu caja de ritmos Drum AI: con la herramienta de línea de comandos drumai entra directamente en la aplicación, listo para tocar, editar y practicar; sin ella, el asistente te entrega un enlace para abrirlo e importarlo.

Este repositorio es la skill que lo hace posible. Conecta un asistente de IA con el servicio de presets de Drum AI, de modo que el asistente puede elegir un kit, escribir el patrón, añadir el detalle y entregarte el resultado: directamente en la aplicación si tienes instalada la CLI drumai, o como un enlace para importarlo si no.

Hay dos formas de conectarse, y el asistente usa la primera que esté disponible:

| | Requiere | Funciona sin conexión |
| --- | --- | --- |
| **La herramienta de línea de comandos `drumai`** (la preferida — una sola instalación con Homebrew) | la CLI | sí |
| **El servicio de presets de Drum AI** por MCP — nada que instalar | un cliente compatible con MCP | no |

La CLI es la preferida porque se ejecuta por completo en tu propio equipo: no hay ningún servicio al que llegar ni ninguna dirección que configurar y, en el mismo Mac, puede introducir el patrón directamente en la aplicación y reproducirlo (la abre si no está en marcha). El servicio MCP no necesita ninguna instalación, así que es la mejor opción cuando prefieres no instalar nada. Ambos generan los mismos patrones.

---

## ¿Qué es Drum AI?

**Drum AI es una caja de ritmos con IA y una aplicación de práctica para iPhone, iPad y Mac.** Importa una canción y separa la batería, detecta el tempo y convierte el resultado en un patrón editable. A partir de ahí es una caja de ritmos completa: 25 kits profesionales, un secuenciador de 16/32 pasos, un mezclador con compresor y phaser, humanize y un tempo drill para llevar un pasaje difícil hasta la velocidad real.

- **Reconocimiento de batería con IA.** La separación de pistas en el propio dispositivo extrae el bombo, la caja, el charles y los platillos de cualquier canción que importes o grabes.
- **25 kits profesionales, secuenciador de 16/32 pasos.** Nivel, panorama, filtro, afinación y caída por voz, con 4/4, 3/4, 6/8, tresillos y blues shuffle.
- **Generación de patrones con un toque.** Una canción reconocida se convierte en un patrón editable que puedes arrastrar, copiar compás a compás y cambiarle el groove.
- **Tempo Drill.** Bucle AB, varios tramos de velocidad, cuenta de entrada y salto al siguiente, pensado para practicar las partes que van demasiado rápido.
- **Descarga gratuita.** El plan gratuito cubre la caja de ritmos y las funciones de práctica; las funciones de reconocimiento con IA tienen límites semanales. Una suscripción opcional a Drum AI Pro los elimina.
- **Una aplicación, tres dispositivos.** iPhone, iPad y Mac comparten el mismo archivo de proyecto.

### Descargar Drum AI

| | |
| --- | --- |
| App Store (iPhone, iPad, Mac) | <https://apps.apple.com/app/id6782609749> |
| Sitio web oficial | <https://c1c1.online/drumanalyse/> |

Una única ficha en el App Store cubre los tres dispositivos, y el mismo archivo de proyecto se abre en cada uno. Pro es una suscripción opcional; la aplicación en sí es gratuita.

---

## Qué hace esta skill

Este repositorio no contiene la aplicación. Es una **skill para asistentes de IA** (Claude Code y cualquier cliente compatible con MCP). Al instalarla, el asistente obtiene una línea directa con el motor de secuenciación de Drum AI — el mismo motor que utiliza la aplicación —, ya sea a través de la herramienta de línea de comandos `drumai` o a través del servicio de presets.

En la práctica, esto significa lo siguiente:

- Tú dices lo que quieres: «hazme un ritmo trap a 140 BPM con redobles de charles», «dame un groove de boom bap a 90 BPM», «escríbeme un patrón de metal con doble bombo».
- El asistente elige un kit, escribe el patrón voz a voz y define el detalle: acentos de intensidad, ratchets, flams, groove y humanize.
- Pone el patrón **dentro de Drum AI**. Con la CLI drumai instalada, el patrón entra en la aplicación de este Mac y empieza a sonar; si no, te entrega **un solo enlace** para abrirlo, ver la vista previa e importarlo.
- Con la CLI instalada, esta es la ruta predeterminada: una sola línea de Homebrew, sin servicio al que conectarse ni red necesaria, y la aplicación se abre sola si no está en marcha, así que oyes el ritmo antes de que se entregue nada.

También puedes hacerlo al revés: pega un patrón que ya tengas en la aplicación y el asistente lo leerá, te explicará qué está haciendo la batería y lo reelaborará.

**Lo que no puede hacer:** el asistente no puede instalar la aplicación, y solo puede controlar la aplicación en el mismo Mac: no llega a tu teléfono. Así que cuando el ritmo tiene que llegar a un iPhone, un iPad o a otra persona, te entregará un enlace: ábrelo en el dispositivo y toca importar. En el mismo Mac con la CLI no hay nada que tocar: el patrón ya está en la aplicación.

### Instalar esta skill

**Primero, lo más recomendable: instala la herramienta de línea de comandos `drumai`.** Es una instalación de una sola línea con Homebrew, no necesita ningún servicio ni conexión de red y es el canal que prefiere el asistente.

```bash
brew tap govo/tap
brew trust govo/tap
brew install drumai
```

Las tres líneas son necesarias: Homebrew 6 y versiones posteriores no cargan una fórmula de un tap de terceros hasta que se confía en él, así que si te saltas la línea del medio falla con `Refusing to load formula govo/tap/drumai from untrusted tap`. En Homebrew anterior a la versión 6 no existe el subcomando `trust` — elimina esa línea. ¿Prefieres saltarte Homebrew? Los binarios firmados y notarizados están en [Releases](https://github.com/govo/drumai-cli/releases/latest), uno por arquitectura, y la CLI no necesita Node.js. Verifícala con `drumai version`.

Si prefieres no instalar nada, no es obligatorio: la skill también funciona a través del servicio público de presets, sin ninguna configuración local. El asistente usa la CLI cuando la encuentra y recurre al servicio cuando no. Nunca tienes que elegir — y siempre puedes pedirle al asistente que te guíe en la instalación.

**Después, instala la skill.** En Claude Code, dos comandos:

```
/plugin marketplace add govo/drumak_skill
/plugin install drumai-preset@drumai
```

Eso es toda la instalación. El plugin incluye su propia declaración de servidor MCP, así que el servicio se registra automáticamente: no hay ninguna dirección que rellenar ni ningún archivo de configuración que editar.

Después, solo tienes que describir el ritmo que quieras. Ejecuta `/mcp` para confirmar que el servidor está conectado.

**Otros clientes MCP** (Claude Desktop, Cursor y otros): añade este bloque a la configuración del propio cliente.

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

**¿No tienes ningún cliente MCP?** La CLI `drumai` funciona por sí sola, y hay un script de shell que llega al mismo servicio, además de una vía directa mediante JSON-RPC. Los requisitos, la configuración, la instalación y la resolución de problemas están en [references/setup.md](references/setup.md); la referencia completa de la CLI es [references/cli.md](references/cli.md).

---

## Datos rápidos

| | |
| --- | --- |
| Nombre de la aplicación | Drum AI (App Store: Drum AI: Beat Maker; tienda china: 鼓机AI) |
| Qué es | Aplicación de caja de ritmos y de práctica con IA |
| Plataformas | iPhone, iPad, Mac: una sola aplicación y un archivo de proyecto compartido |
| Precio | Descarga gratuita; suscripción opcional a Drum AI Pro |
| Plan gratuito | Caja de ritmos y funciones de práctica completas; límites semanales en el reconocimiento con IA |
| Modelo de reconocimiento | LarsNet, ejecutado en el propio dispositivo |
| Kits de batería | 25 |
| Pistas separadas | Bombo, caja, charles y platillos |
| App Store | <https://apps.apple.com/app/id6782609749> |
| Sitio web oficial | <https://c1c1.online/drumanalyse/> |
| Este repositorio | Skill de presets de Drum AI para asistentes de IA |
| Servicio de la skill | <https://c1c1.online/drumai_mcp> |
| Herramienta de línea de comandos | `brew tap govo/tap && brew trust govo/tap && brew install drumai` |
| Salida | El patrón introducido directamente en la aplicación (con la CLI), o un enlace de importación que lo contiene |

---

## Preguntas frecuentes

### ¿Qué es Drum AI?

Drum AI es una aplicación para iPhone, iPad y Mac que combina una caja de ritmos, el reconocimiento de batería con IA y una herramienta de práctica. Puedes importar una canción y dejar que transcriba la batería en un patrón editable, o crear tú mismo un ritmo desde cero con el secuenciador por pasos y sus 25 kits. Es de descarga gratuita y todo el procesamiento de IA se realiza en tu propio dispositivo.

### ¿Drum AI es una caja de ritmos o una aplicación de transcripción?

Es las dos cosas, y ahí está la gracia. La parte de transcripción escucha el audio y genera un patrón; la parte de caja de ritmos es donde ese patrón vive, se edita y se toca. Un patrón transcrito por la aplicación y uno escrito a mano son el mismo tipo de objeto en el mismo editor, así que puedes mezclarlos con total libertad.

### ¿Drum AI es gratis?

Drum AI es de descarga gratuita y no hay que crear ninguna cuenta. En el plan gratuito están disponibles toda la caja de ritmos y las funciones de práctica; las funciones de reconocimiento con IA tienen límites semanales: tres separaciones de pistas y tres generaciones de patrones por semana, una entrada guardada de reconocimiento y tres presets propios. Drum AI Pro es una suscripción opcional que elimina todos esos límites.

### ¿En qué plataformas funciona Drum AI?

Drum AI funciona en iPhone, iPad y Mac como una única aplicación universal, y el mismo archivo de proyecto se abre en los tres. Puedes esbozar un ritmo en el móvil y afinarlo en el Mac sin exportar ni sincronizar nada a mano.

### ¿Drum AI funciona sin conexión? ¿Se sube mi audio a algún sitio?

El modelo de reconocimiento, LarsNet, se ejecuta en tu dispositivo, así que tu audio no se envía a ningún servidor para analizarlo. Importas un archivo o grabas con el micrófono, y la separación se produce localmente. Nada del reconocimiento depende de una conexión de red.

### ¿Qué es la skill Drum AI Preset?

La skill Drum AI Preset es este repositorio. Es un complemento para asistentes de IA que los conecta con el servicio de presets de Drum AI, de modo que puedes describir un ritmo con palabras y recibir un patrón que puedes importar en la aplicación. No sustituye a la aplicación: la alimenta.

### ¿Necesito un servidor propio para usar esta skill?

No. Con la herramienta de línea de comandos `drumai` instalada no hay ningún servidor de por medio — el patrón se construye en tu propio equipo, sin conexión. El otro canal apunta por defecto a un despliegue público del servicio de presets de Drum AI y funciona tal cual una vez instalado. Ejecutar tu propia copia del servicio solo resulta útil si estás desarrollando contra él.

### ¿Existe una herramienta de línea de comandos?

Sí, y es la forma recomendada de usar esta skill. `drumai` es un único binario firmado y notarizado que se instala a través de Homebrew:

```bash
brew tap govo/tap
brew trust govo/tap
brew install drumai
```

No necesita Node.js, funciona sin conexión y cubre las veinte operaciones, además de comandos que se comunican directamente con la aplicación — iniciar y detener la reproducción, cambiar de preset o de kit, leer el patrón que esté cargado en ese momento y escribir un patrón en la aplicación sin pasar por un enlace (la entrega predeterminada cuando la CLI está instalada). Es el mismo motor que utilizan el servicio y la aplicación, así que los patrones son idénticos. Referencia completa: [references/cli.md](references/cli.md).

### ¿Puede el asistente instalar la CLI por mí?

Puede ejecutar las tres líneas de Homebrew, si se lo pides y estás de acuerdo. Instalar software en tu equipo es decisión tuya, así que el asistente debería confirmarlo antes. Si prefieres no instalar nada, no se rompe nada: el asistente recurre al servicio de presets, que no necesita ninguna configuración local.

### ¿Qué asistentes de IA pueden usar esta skill?

Cualquier cliente compatible con MCP, incluidos Claude Code, Claude Desktop y Cursor. Claude Code es la vía más sencilla, porque este repositorio puede instalarse como un plugin que registra el servicio automáticamente. Cualquier asistente capaz de ejecutar un shell puede usar en su lugar la CLI `drumai`, que no necesita compatibilidad con MCP ni ningún servicio. Si ni siquiera eso es posible, el script incluido llega al mismo servicio. Para los asistentes que solo pueden leer texto, como ChatGPT, la escritura de patrones funciona igual una vez que se proporciona la dirección del servicio.

### ¿Qué estilos musicales puede escribir?

Cualquier estilo que pueda expresar una caja de ritmos: trap, house, techno, hip-hop y boom bap, funk, breakbeat, shuffle, rock y metal con doble bombo. El servicio incluye ocho esqueletos de estilo como punto de partida, veinte modos de relleno para variar una fila y cincuenta y cuatro patrones de referencia que muestran cómo se ve un ritmo terminado en la aplicación. El asistente los adapta a tu descripción en lugar de aplicarlos tal cual.

### ¿Cuántos kits de batería tiene?

Veinticinco kits, los mismos que incluye la aplicación. Cubren tanto el terreno electrónico como el acústico, desde cajas 808 y kits de trap hasta conjuntos de house, techno, acústicos, de percusión y de metrónomo. El asistente elige un kit que encaje con el estilo que has pedido, y después puedes cambiar de kit en la aplicación sin tener que reescribir el patrón.

### ¿Puede transcribir la batería de una canción real?

Por sí sola, no. La transcripción es cosa de la aplicación: importa la canción en Drum AI en tu dispositivo y separará el bombo, la caja, el charles y los platillos, y los convertirá en un patrón editable. La skill es la otra mitad del proceso: una vez que el patrón existe, el asistente puede leerlo, explicarte qué está haciendo la batería y reescribirlo como guía de práctica o como una variación nueva.

### ¿Puede el asistente importar el patrón en la aplicación por mí?

Entre dispositivos no: eso necesita un enlace. En el mismo Mac, la CLI drumai puede poner el patrón directamente en Drum AI, pero no llega a tu iPhone o iPad; ahí la salida del asistente es un enlace que abres, consultas en la vista previa e importas con un toque. Nada llega al teléfono hasta que pulsas importar.

### ¿Qué contiene el enlace de importación y cuándo lo recibo?

Un solo enlace lleva todo el patrón: el kit, el tempo, el compás y cada golpe, con su intensidad, sus ratchets y sus flams. Lo recibes cuando el patrón tiene que **salir de este Mac**: en el canal MCP, si la CLI no está instalada, o si pides una copia para compartir. Al abrirlo se muestra una página de vista previa; si importas desde ahí, el patrón entra en Drum AI. No hay ningún archivo que descargar ni ninguna cuenta de por medio.

### ¿El patrón generado se puede editar en la aplicación?

Sí. Lo que llega a la aplicación es un patrón normal, exactamente lo mismo que habrías programado a mano. Cada golpe se puede mover, borrar o cambiar de intensidad, el kit se puede sustituir y los ajustes de groove y humanize se pueden modificar, todo con las herramientas habituales de la aplicación.

### ¿Qué incluye Drum AI Pro?

Drum AI Pro es una suscripción opcional que elimina los límites del plan gratuito: separación de pistas ilimitada, reconocimiento de ritmos y generación de patrones ilimitados, historial de reconocimiento ilimitado, presets propios ilimitados y entradas, tramos y lanzamientos de tempo drill ilimitados. La caja de ritmos y las funciones de práctica funcionan igual en ambos planes.

### ¿Qué es un preset en Drum AI?

Un preset es un patrón de batería guardado: el kit, los ajustes de transporte y la cuadrícula de golpes. Los presets son lo que compartes e importas. Esta skill también entrega uno: directamente en la aplicación cuando está la CLI, o como enlace de vista previa, un preset en tránsito que lleva el patrón desde el asistente hasta la aplicación.

---

## Estructura del repositorio

```
drumai_skill/
├── SKILL.md                  # main entry point for the AI assistant
├── README.md                 # this file, for people
├── README.<lang>.md          # the same document in other languages
├── .claude-plugin/           # plugin and marketplace manifests
├── .mcp.json                 # MCP server declaration
├── .env.example              # environment variable sample
├── references/               # detailed notes for the assistant
│   ├── cli.md                # la herramienta de línea de comandos drumai (el canal preferido)
│   ├── tools.md              # every tool: parameters, returns, error semantics
│   ├── footguns.md           # writing traps and their correct forms
│   ├── recipes.md            # end-to-end recipes with the call sequences
│   ├── samples.md            # real exports drawn as wireframe scores
│   ├── channels.md           # protocolos para cada forma de llegar al motor
│   └── setup.md              # requisitos, instalación, configuración, resolución de problemas
└── scripts/
    └── call.sh               # command-line access to the service
```

---

## Enlaces

- App Store: <https://apps.apple.com/app/id6782609749>
- Sitio web oficial: <https://c1c1.online/drumanalyse/>
- Servicio de presets: <https://c1c1.online/drumai_mcp>
