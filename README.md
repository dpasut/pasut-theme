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

`account` puts the signed-in account at the very bottom: `<avatar> <name>`, which opens (upwards) to its items,
a theme row (`<icon> Theme: Light / Dark / System`, a click moves to the next) and its `endItems`, e.g.
`Shell.account(~name="admin", ~items=[logs, manage, settings, changes], ~endItems=[signOut], ())`. It replaces
the separate theme switcher and `footerItem`; whether it's open is remembered. Collapsed, it's the avatar and
icon rows with tooltips.

`Shell.item(..., ~disabled=true, ())` shows an item greyed out and not clickable (e.g. a page that's coming
soon).

`sections` / `bottomSections` replace `nav` / `bottom` when given; sites using
the flat lists are unaffected. The phone menu shows the same sections.

Keyboard and screen readers: the page content is a `<main id="main">` landmark with a "Skip to content" link
before everything else; moving to another page puts focus on it. The current page's link has
`aria-current="page"`, collapsed links are named by their labels, and the account button is named by its visible
name (it comes before its menu, so Tab goes into the menu). The phone menu is a dialog: focus goes into it,
Escape closes it, and focus goes back to the menu button. Shell controls get a focus ring when reached by keyboard.
`Ui.Link` takes `~ariaLabel` and `~ariaCurrent`.

Readable text: in light mode, Mantine's description/hint grey uses the theme's `--dimmed`, and red text (subtle
and light buttons) a darker red, so both pass WCAG AA (4.5:1). Modal and drawer close buttons are named "Close".

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

### Accent colour

`src/accent.js` lets a site use any accent colour instead of the navy:

```js
import { applyAccent, themeWithAccent, accentPalette, contrastOnWhite, DEFAULT_ACCENT } from "pasut-theme/src/accent.js";

applyAccent("#2f9e44");                       // the CSS tokens (--p-*), light and dark; null = back to navy
<MantineProvider theme={themeWithAccent(theme, "#2f9e44")}>  // Mantine's primary palette, auto contrast
```

The 10 shades keep the colour's hue and saturation and step the lightness like the designed navy palette, so
the default comes out the same. `contrastOnWhite(hex)` is the WCAG ratio for text in that colour on white.

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
