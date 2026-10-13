# Drum AI — Skill MCP Preset

<p align="center">
  <a href="https://apps.apple.com/app/id6782609749"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download Drum AI on the App Store" height="40"></a>
  &nbsp;&nbsp;
  <a href="https://c1c1.online/drumanalyse/"><img src="https://img.shields.io/badge/Official_Site-c1c1.online%2Fdrumanalyse-1f6feb?style=for-the-badge&logo=safari&logoColor=white" alt="Drum AI official website" height="40"></a>
</p>

[English (US)](README.md) · [Deutsch](README.de.md) · **Français** · [繁體中文](README.zh-Hant.md) · [한국어](README.ko.md) · [简体中文](README.zh-Hans.md) · [日本語](README.ja.md) · [Español](README.es.md)

Décrivez un rythme en langage courant, recevez un lien, ouvrez ce lien, et le pattern se retrouve dans votre boîte à rythmes Drum AI — prêt à être joué, modifié et travaillé.

Ce dépôt contient la skill qui rend tout cela possible. Elle relie un assistant IA au service PRESET de Drum AI, pour que l'assistant puisse choisir un kit, écrire le pattern, ajouter les détails et vous remettre un lien à importer.

Il y a deux façons de se connecter, et l'assistant prend la première disponible :

| | Nécessite | Fonctionne hors ligne |
| --- | --- | --- |
| **L'outil en ligne de commande `drumai`** (préféré — une seule installation Homebrew) | la CLI | oui |
| **Le service PRESET de Drum AI** via MCP — rien à installer | un client compatible MCP | non |

La CLI est préférée parce qu'elle tourne entièrement sur votre propre machine : il n'y a aucun service à joindre ni adresse à configurer, et tant que l'app est ouverte sur le même Mac, elle peut pousser le pattern directement dedans et le jouer. Le service MCP ne demande aucune installation, ce qui en fait le meilleur choix si vous préférez ne rien installer. Les deux produisent les mêmes patterns.

---

## Qu'est-ce que Drum AI ?

**Drum AI est une boîte à rythmes IA et une app d'entraînement, pour iPhone, iPad et Mac.** Importez un morceau : elle sépare la batterie, détecte le tempo et transforme le résultat en un pattern modifiable. À partir de là, c'est une boîte à rythmes complète : 25 kits pro, un séquenceur 16/32 pas, une table de mixage avec compresseur et phaser, l'humanisation, et un tempo drill pour amener un passage difficile au tempo.

- **Reconnaissance de batterie par IA.** La séparation de pistes sur l'appareil isole la grosse caisse, la caisse claire, le charleston et les cymbales de tout morceau que vous importez ou enregistrez.
- **25 kits pro, séquenceur 16/32 pas.** Niveau, panoramique, filtre, accord et decay par voix, avec 4/4, 3/4, 6/8, triolets et blues shuffle.
- **Génération de patterns en un geste.** Un morceau reconnu devient un pattern modifiable que vous pouvez déplacer, copier mesure par mesure et regroover.
- **Tempo Drill.** Boucle AB, segments de vitesse multiples, décompte et passage au suivant, pensés pour travailler les passages trop rapides.
- **Téléchargement gratuit.** La version gratuite couvre la boîte à rythmes et les fonctions d'entraînement ; les fonctions de reconnaissance IA sont soumises à des limites hebdomadaires. Un abonnement Drum AI Pro facultatif les supprime.
- **Une app, trois appareils.** iPhone, iPad et Mac partagent le même fichier de projet.

### Télécharger Drum AI

| | |
| --- | --- |
| App Store (iPhone, iPad, Mac) | <https://apps.apple.com/app/id6782609749> |
| Site officiel | <https://c1c1.online/drumanalyse/> |

Une seule fiche App Store couvre les trois appareils, et le même fichier de projet s'ouvre sur chacun. Pro est un abonnement facultatif ; l'app elle-même est gratuite.

---

## Ce que fait cette skill

Ce dépôt ne contient pas l'app. C'est une **skill pour assistants IA** (Claude Code, et tout client qui parle MCP). L'installer donne à l'assistant une ligne directe vers le moteur de séquençage de Drum AI — le même moteur que celui utilisé par l'app — soit via l'outil en ligne de commande `drumai`, soit via le service PRESET.

Concrètement :

- Vous dites ce que vous voulez — « fais-moi un beat trap à 140 BPM avec un charleston en roulement », « donne-moi un groove boom bap à 90 BPM », « écris un pattern metal avec double grosse caisse ».
- L'assistant choisit un kit, écrit le pattern voix par voix et règle les détails : accents de vélocité, ratchets, flams, groove, humanisation.
- Il vous remet **un lien**. Ouvrez-le, regardez l'aperçu et importez le pattern dans Drum AI.
- Avec la CLI installée et l'app ouverte sur le même Mac, il peut aussi se passer du lien : pousser le pattern directement dans l'app et lancer la lecture, pour que vous l'entendiez avant toute livraison.

L'inverse fonctionne aussi : collez un pattern que vous avez déjà dans l'app, et l'assistant le lira, vous expliquera ce que joue la batterie et le retravaillera.

**Ce qu'elle ne peut pas faire :** l'assistant ne peut pas installer l'app, l'ouvrir ni importer le pattern à votre place. L'import se fait d'un seul geste, sur votre appareil, depuis le lien.

### Installer cette skill

**Commencez par installer l'outil en ligne de commande `drumai`.** C'est une installation Homebrew sur une seule ligne, sans service ni réseau, et c'est le canal que l'assistant préfère.

```bash
brew tap govo/tap
brew trust govo/tap
brew install drumai
```

Les trois lignes sont nécessaires : Homebrew 6 et les versions ultérieures ne chargent pas une formule venant d'un tap tiers tant qu'elle n'est pas approuvée, donc sauter la ligne du milieu échoue avec `Refusing to load formula govo/tap/drumai from untrusted tap`. Sur une version de Homebrew antérieure à 6, il n'y a pas de sous-commande `trust` — supprimez cette ligne. Vous préférez éviter Homebrew ? Les binaires signés et notariés sont sur [Releases](https://github.com/govo/drumai-cli/releases/latest), un par architecture, et la CLI ne nécessite pas Node.js. Vérifiez avec `drumai version`.

Si vous préférez ne rien installer, vous n'y êtes pas obligé : la skill fonctionne aussi via le service PRESET public, sans aucune installation locale. L'assistant utilise la CLI quand il la trouve et se rabat sur le service quand elle est absente. Vous n'avez jamais à choisir — et vous pouvez toujours demander à l'assistant de vous guider dans l'installation.

**Ensuite, installez la skill.** Dans Claude Code, deux commandes :

```
/plugin marketplace add govo/drumak_skill
/plugin install drumai-preset@drumai
```

C'est tout ce qu'il y a à faire. Le plugin embarque sa propre déclaration de serveur MCP : le service s'enregistre automatiquement, sans adresse à saisir ni fichier de configuration à modifier.

Il ne reste plus qu'à décrire le rythme voulu. Lancez `/mcp` pour vérifier que le serveur est bien connecté.

**Autres clients MCP** (Claude Desktop, Cursor et autres) : ajoutez ce bloc à la configuration du client.

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

**Aucun client MCP du tout ?** La CLI `drumai` fonctionne de façon autonome, et il existe un script shell qui atteint le même service ainsi qu'un accès JSON-RPC brut. Les prérequis, la configuration, l'installation et le dépannage se trouvent dans [references/setup.md](references/setup.md) ; la référence complète de la CLI est dans [references/cli.md](references/cli.md).

---

## L'essentiel

| | |
| --- | --- |
| Nom de l'app | Drum AI (App Store : Drum AI: Beat Maker ; boutique chinoise : 鼓机AI) |
| Type | Boîte à rythmes IA et app d'entraînement |
| Plateformes | iPhone, iPad, Mac — une app, un fichier de projet partagé |
| Prix | Téléchargement gratuit ; abonnement Drum AI Pro facultatif |
| Version gratuite | Boîte à rythmes et fonctions d'entraînement complètes ; limites hebdomadaires sur la reconnaissance IA |
| Modèle de reconnaissance | LarsNet, exécuté sur l'appareil |
| Kits de batterie | 25 |
| Pistes séparées | Grosse caisse, caisse claire, charleston, cymbales |
| App Store | <https://apps.apple.com/app/id6782609749> |
| Site officiel | <https://c1c1.online/drumanalyse/> |
| Ce dépôt | Skill Preset de Drum AI pour assistants IA |
| Service de la skill | <https://c1c1.online/drumai_mcp> |
| Outil en ligne de commande | `brew tap govo/tap && brew trust govo/tap && brew install drumai` |
| Sortie | Un lien d'import contenant le pattern |

---

## FAQ

### Qu'est-ce que Drum AI ?

Drum AI est une app pour iPhone, iPad et Mac qui réunit une boîte à rythmes, une reconnaissance de batterie par IA et un outil d'entraînement. Vous pouvez importer un morceau et laisser l'app transcrire la batterie en un pattern modifiable, ou écrire un rythme de zéro avec le séquenceur pas à pas et ses 25 kits. Le téléchargement est gratuit, et tout le traitement IA se fait sur votre propre appareil.

### Drum AI est-elle une boîte à rythmes ou une app de transcription ?

Les deux, et c'est justement là tout l'intérêt. Côté transcription, l'app écoute l'audio et produit un pattern ; côté boîte à rythmes, ce pattern vit, se modifie et se joue. Un pattern transcrit par l'app et un pattern écrit à la main sont des objets de même nature dans le même éditeur : vous pouvez donc les mélanger librement.

### Drum AI est-elle gratuite ?

Drum AI est gratuite au téléchargement, et il n'y a aucun compte à créer. La version gratuite donne accès à toute la boîte à rythmes et aux fonctions d'entraînement ; les fonctions de reconnaissance IA sont soumises à des limites hebdomadaires — trois séparations de pistes et trois générations de patterns par semaine, une entrée de reconnaissance enregistrée et trois PRESET personnels. Drum AI Pro est un abonnement facultatif qui supprime chacune de ces limites.

### Sur quelles plateformes Drum AI fonctionne-t-elle ?

Drum AI fonctionne sur iPhone, iPad et Mac sous la forme d'une app universelle, et le même fichier de projet s'ouvre sur les trois. Vous pouvez esquisser un beat sur le téléphone et l'affiner sur le Mac sans exporter ni synchroniser quoi que ce soit à la main.

### Drum AI fonctionne-t-elle hors ligne ? Mon audio est-il envoyé quelque part ?

Le modèle de reconnaissance, LarsNet, s'exécute sur votre appareil : votre audio n'est donc pas envoyé à un serveur pour être analysé. Vous importez un fichier ou vous enregistrez au microphone, et la séparation se fait en local. Rien dans la reconnaissance ne dépend d'une connexion réseau.

### Qu'est-ce que la skill Drum AI Preset ?

La skill Drum AI Preset, c'est ce dépôt. C'est un module complémentaire pour assistants IA qui les relie au service PRESET de Drum AI, pour que vous puissiez décrire un rythme en mots et recevoir en retour un pattern importable dans l'app. Elle ne remplace pas l'app — elle l'alimente.

### Faut-il son propre serveur pour utiliser cette skill ?

Non. Avec l'outil en ligne de commande `drumai` installé, aucun serveur n'entre en jeu — le pattern est construit sur votre propre machine, sans réseau. L'autre canal pointe par défaut vers un déploiement public du service PRESET de Drum AI et fonctionne tel quel après l'installation. Faire tourner votre propre copie du service n'a d'intérêt que si vous développez contre lui.

### Existe-t-il un outil en ligne de commande ?

Oui, et c'est la façon recommandée d'utiliser cette skill. `drumai` est un binaire unique signé et notarié, installé via Homebrew :

```bash
brew tap govo/tap
brew trust govo/tap
brew install drumai
```

Il ne nécessite pas Node.js, fonctionne hors ligne et couvre les dix-neuf opérations de construction de patterns, plus des commandes qui dialoguent directement avec l'app — lancer et arrêter la lecture, changer de PRESET ou de kit, lire le pattern actuellement chargé et écrire un pattern dans l'app sans passer par un lien. C'est le même moteur que celui utilisé par le service et par l'app, donc les patterns sont identiques. Référence complète : [references/cli.md](references/cli.md).

### L'assistant peut-il installer la CLI à ma place ?

Il peut exécuter les trois lignes Homebrew, si vous le lui demandez et que vous êtes d'accord. Installer un logiciel sur votre machine relève de votre décision : l'assistant doit donc d'abord confirmer. Si vous préférez ne rien installer, rien ne casse : l'assistant se rabat sur le service PRESET, qui ne demande aucune installation locale.

### Quels assistants IA peuvent utiliser cette skill ?

Tout client compatible MCP, notamment Claude Code, Claude Desktop et Cursor. Claude Code est le chemin le plus simple, car ce dépôt peut s'installer comme un plugin qui enregistre le service automatiquement. Tout assistant capable de lancer un shell peut à la place utiliser la CLI `drumai`, qui ne nécessite ni prise en charge de MCP ni service. À défaut, le script fourni atteint le même service. Pour les assistants qui ne lisent que du texte, comme ChatGPT, l'écriture de patterns fonctionne de la même façon une fois l'adresse du service fournie.

### Quels styles musicaux peut-elle écrire ?

Tous ceux qu'une boîte à rythmes peut exprimer : trap, house, techno, hip-hop et boom bap, funk, breakbeat, shuffle, rock, et metal avec double grosse caisse. Le service fournit huit squelettes de styles comme points de départ, vingt modes de remplissage pour varier une ligne et cinquante-quatre patterns de référence montrant à quoi ressemble un beat abouti dans l'app. L'assistant les adapte à votre description plutôt que de les appliquer tels quels.

### Combien de kits de batterie propose-t-elle ?

Vingt-cinq kits, les mêmes que ceux livrés avec l'app. Ils couvrent le terrain électronique et acoustique, des 808 et des kits trap aux ensembles house, techno, acoustiques, percussions et métronome. L'assistant choisit un kit en fonction du style demandé, et vous pouvez ensuite changer de kit dans l'app sans réécrire le pattern.

### Peut-elle transcrire la batterie d'un vrai morceau ?

Pas toute seule. La transcription, c'est le rôle de l'app : importez le morceau dans Drum AI sur votre appareil, et elle sépare la grosse caisse, la caisse claire, le charleston et les cymbales et les transforme en un pattern modifiable. La skill est l'autre moitié de la boucle — une fois le pattern existant, l'assistant peut le lire, expliquer ce que joue la batterie et le réécrire en fiche d'exercice ou en nouvelle variation.

### L'assistant peut-il importer le pattern dans l'app à ma place ?

Non. La sortie de l'assistant est un lien. Vous ouvrez ce lien sur votre appareil, consultez l'aperçu et importez depuis cette page. Rien n'arrive dans l'app tant que vous n'avez pas touché « importer ».

### Que contient le lien d'import ?

Un seul lien transporte tout le pattern : le kit, le tempo, la signature rythmique et chaque frappe, avec sa vélocité, ses ratchets et ses flams. L'ouvrir affiche une page d'aperçu ; importer depuis celle-ci place le pattern dans Drum AI. Aucun fichier à télécharger, aucun compte nécessaire.

### Le pattern généré est-il modifiable dans l'app ?

Oui. Ce qui arrive dans l'app est un pattern ordinaire — exactement ce que vous auriez programmé à la main. Chaque frappe peut être déplacée, supprimée ou rejouée avec une autre vélocité, le kit peut être changé, et les réglages de groove et d'humanisation peuvent être modifiés, avec les outils habituels de l'app.

### Que comprend Drum AI Pro ?

Drum AI Pro est un abonnement facultatif qui supprime les limites de la version gratuite : séparation de pistes illimitée, reconnaissance de beats et génération de patterns illimitées, historique de reconnaissance illimité, PRESET personnels illimités, et entrées, segments et lancements de tempo drill illimités. La boîte à rythmes et les fonctions d'entraînement sont identiques dans les deux versions.

### Qu'est-ce qu'un PRESET dans Drum AI ?

Un PRESET est un pattern de batterie enregistré : le kit, les réglages de transport et la grille de frappes. Les PRESET sont ce que vous partagez et importez. Le lien d'aperçu produit par cette skill est un PRESET en transit — il transporte le pattern de l'assistant vers l'app.

---

## Arborescence du dépôt

```
drumai_skill/
├── SKILL.md                  # main entry point for the AI assistant
├── README.md                 # this file, for people
├── README.<lang>.md          # the same document in other languages
├── .claude-plugin/           # plugin and marketplace manifests
├── .mcp.json                 # MCP server declaration
├── .env.example              # environment variable sample
├── references/               # detailed notes for the assistant
│   ├── cli.md                # l'outil en ligne de commande drumai (le canal préféré)
│   ├── tools.md              # every tool: parameters, returns, error semantics
│   ├── footguns.md           # writing traps and their correct forms
│   ├── recipes.md            # end-to-end recipes with the call sequences
│   ├── samples.md            # real exports drawn as wireframe scores
│   ├── channels.md           # protocoles pour chaque façon d'atteindre le moteur
│   └── setup.md              # prérequis, installation, configuration, dépannage
└── scripts/
    └── call.sh               # command-line access to the service
```

---

## Liens

- App Store : <https://apps.apple.com/app/id6782609749>
- Site officiel : <https://c1c1.online/drumanalyse/>
- Service Preset : <https://c1c1.online/drumai_mcp>
