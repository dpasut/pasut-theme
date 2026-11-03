// A site's accent colour, from one colour.
//
// The theme's accent appears in two places: the CSS tokens (--p-0 … --p-8, with their own dark-mode values)
// and Mantine's 10-shade primary palette ("navy"). accentPalette() builds the 10 shades from one colour
// (shade 7 is the colour itself, as #153f7a is for navy); applyAccent() sets the CSS tokens for light and dark
// mode; themeWithAccent() gives a Mantine theme using the palette. Pass null to go back to the default navy.

const STYLE_ID = "pasut-accent";

export const DEFAULT_ACCENT = "#153f7a";

const parse = (hex) => {
  const m = /^#?([0-9a-f]{6})$/i.exec(String(hex || "").trim());
  if (!m) return null;
  const n = parseInt(m[1], 16);
  return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
};

const toHex = (rgb) =>
  "#" + rgb.map((v) => Math.round(Math.max(0, Math.min(255, v))).toString(16).padStart(2, "0")).join("");

const toHsl = ([r, g, b]) => {
  const [rr, gg, bb] = [r / 255, g / 255, b / 255];
  const max = Math.max(rr, gg, bb), min = Math.min(rr, gg, bb), l = (max + min) / 2;
  if (max === min) return [0, 0, l];
  const d = max - min;
  const s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
  const h = max === rr ? (gg - bb) / d + (gg < bb ? 6 : 0) : max === gg ? (bb - rr) / d + 2 : (rr - gg) / d + 4;
  return [h * 60, s, l];
};

const fromHsl = ([h, s, l]) => {
  const k = (n) => (n + h / 30) % 12;
  const a = s * Math.min(l, 1 - l);
  const f = (n) => l - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)));
  return [f(0) * 255, f(8) * 255, f(4) * 255];
};

export const isAccent = (hex) => parse(hex) !== null;

// Lightness steps measured from the theme's designed navy palette: shades 0-6 sit this far from the colour's
// lightness towards white, shades 8-9 keep this share of it. Hue and saturation stay the colour's own, so the
// tints don't wash out (as mixing with white would).
const LIGHTER = [0.924, 0.839, 0.689, 0.543, 0.411, 0.272, 0.132];
const LIGHTER_SAT = [0.88, 0.8, 0.78, 0.74, 0.72, 0.73, 0.86]; // the designed tints ease off the saturation
const DARKER = [0.786, 0.618];

const shade = ([h, s, l], lightness, sat = 1) => toHex(fromHsl([h, s * sat, Math.max(0, Math.min(1, lightness))]));

export const accentPalette = (hex) => {
  const c = parse(hex) || parse(DEFAULT_ACCENT);
  const hsl = toHsl(c);
  const l = hsl[2];
  return [
    ...LIGHTER.map((t, i) => shade(hsl, l + (1 - l) * t, LIGHTER_SAT[i])),
    toHex(c),
    ...DARKER.map((t) => shade(hsl, l * t)),
  ];
};

// the CSS tokens, for light and dark mode (dark mode's are lighter, so text in them reads on the dark
// background; the steps again follow the designed navy)
export const accentTokens = (hex) => {
  const p = accentPalette(hex);
  const hsl = toHsl(parse(hex) || parse(DEFAULT_ACCENT));
  const l = hsl[2];
  return {
    light: { "--p-0": p[0], "--p-1": p[1], "--p-6": p[6], "--p-7": p[7], "--p-8": p[9] },
    dark: {
      "--p-0": shade(hsl, 0.22, 0.6),
      "--p-1": shade(hsl, 0.29, 0.6),
      "--p-6": p[5],
      "--p-7": shade(hsl, l + (1 - l) * 0.625, 0.87),
      "--p-8": shade(hsl, l + (1 - l) * 0.76, 0.9),
    },
  };
};

const block = (selector, vars) =>
  `${selector} {\n${Object.entries(vars).map(([k, v]) => `  ${k}: ${v};`).join("\n")}\n}`;

// Set the CSS tokens for this accent (null: back to the theme's own). Safe to call often.
export const applyAccent = (hex) => {
  if (typeof document === "undefined") return;
  let el = document.getElementById(STYLE_ID);
  if (!isAccent(hex) || hex.toLowerCase() === DEFAULT_ACCENT) {
    if (el) el.remove();
    return;
  }
  const t = accentTokens(hex);
  // same selectors as theme.css (Mantine marks the resolved scheme on <html>); print stays light
  const css = [
    block(":root", t.light),
    block('[data-mantine-color-scheme="dark"]', t.dark),
    `@media print {\n${block(':root, [data-mantine-color-scheme="dark"]', t.light)}\n}`,
  ].join("\n");
  if (!el) {
    el = document.createElement("style");
    el.id = STYLE_ID;
    document.head.appendChild(el);
  }
  el.textContent = css;
};

// The Mantine theme with this accent as its primary palette (null: the theme unchanged).
export const themeWithAccent = (theme, hex) =>
  !isAccent(hex) || hex.toLowerCase() === DEFAULT_ACCENT
    ? theme
    : { ...theme, autoContrast: true, colors: { ...theme.colors, navy: accentPalette(hex) } };

// WCAG contrast of the colour against white (text in the accent on white needs about 4.5)
const lum = (rgb) => {
  const [r, g, b] = rgb.map((v) => {
    const s = v / 255;
    return s <= 0.03928 ? s / 12.92 : ((s + 0.055) / 1.055) ** 2.4;
  });
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
};

export const contrastOnWhite = (hex) => {
  const c = parse(hex);
  return c ? 1.05 / (lum(c) + 0.05) : 21;
};
