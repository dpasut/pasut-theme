# pasut-theme

Shared design system for the pasut.xyz sites (recipes, personal): CSS tokens
and app-shell styles, the Mantine theme (navy `#153f7a`, Instrument Sans /
Newsreader), the collapsible/resizable sidebar shell, icons, and Mantine
bindings for ReScript.

## Usage

```jsonc
// package.json
"dependencies": { "pasut-theme": "github:dpasut/pasut-theme#main" }
// rescript.json
"bs-dependencies": ["@rescript/react", "pasut-theme"]
```

```rescript
// modules are namespaced:
PasutTheme.Shell, PasutTheme.Icons, PasutTheme.Ui, PasutTheme.Mantine
```

```js
// styles + Mantine theme
import "pasut-theme/src/theme.css";
import { theme } from "pasut-theme/src/theme.js";
```

Consumers pin a commit with an explicit https URL so CI can fetch it
without SSH keys:

```jsonc
"pasut-theme": "git+https://github.com/dpasut/pasut-theme.git#<sha>"
```

**Bump `version` in package.json with every change** — npm will not
refresh a cached git dependency whose version is unchanged.
