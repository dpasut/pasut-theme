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

### The sidebar

```rescript
module Shell = PasutTheme.Shell

// flat: one list at the top, one pinned to the bottom (above the theme switcher)
<Shell brand="Recipes" active nav=[Shell.item(~key="home", ~to_="/", ~icon, ~label="Home", ())]>
  ...
</Shell>

// sections: every section after the first starts with a thin divider and, if
// labelled, a small uppercase heading; collapsed, only the divider shows
let sections = [
  Shell.section(~key="home", ~items=[overview], ()),
  Shell.section(~key="live", ~label="Live TV", ~items=[channels, playlists], ()),
]
<Shell brand="IPTV Guide" active sections bottomSections=[Shell.section(~key="admin", ~items=[logs, manage], ())]>
  ...
</Shell>
```

`footerItem` puts one compact link (icon and label, plus its `trailing` element
if there's room) to the right of the theme switcher, e.g.
`footerItem=Shell.item(~key="updates", ~to_="/updates", ~icon=Icons.sparkles, ~label="Changes", ())`.
Collapsed, it's an icon under the switcher; the phone menu shows it beside the switcher.

`sections` / `bottomSections` replace `nav` / `bottom` when given; sites using
the flat lists are unaffected. The phone menu shows the same sections.

### Installed web apps

The shell keeps clear of the notch and home indicator when a site is drawn edge
to edge (`viewport-fit=cover` in its viewport meta, e.g. an installed PWA). The
safe-area insets are 0 everywhere else, so nothing changes for normal sites.

Consumers pin a commit with an explicit https URL so CI can fetch it
without SSH keys:

```jsonc
"pasut-theme": "git+https://github.com/dpasut/pasut-theme.git#<sha>"
```

**Bump `version` in package.json with every change** — npm will not
refresh a cached git dependency whose version is unchanged.

## Linting

This package follows the same three lint rules as its consumer sites.
There is no standalone build here; rule 1 is enforced whenever a consumer
compiles this package from source, and rules 2-3 are checked in the
consumers:

1. **All ReScript compiler warnings are errors** — `"warnings": {"error": "+a"}`
   in `rescript.json`. Unused values, incomplete matches, deprecated APIs,
   and shadowing all fail the build.
2. **Static analysis must be clean** — `rescript-tools reanalyze -config`
   (configured in `rescript.json`) runs dead-code and exception analysis
   and must report zero issues. Bindings and `node_modules` are suppressed;
   annotate intentional exceptions with `@raises(...)` or delete dead code.
3. **No type escape hatches** — `scripts/check-escape-hatches.sh` rejects
   `Obj.magic` and `%raw(` expressions in `src/` (checked manually or by consumers). Write typed `external`
   bindings instead; module-level `%%raw` imports (CSS etc.) are allowed.
