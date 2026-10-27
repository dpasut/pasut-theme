import { createTheme } from "@mantine/core";

// Navy primary anchored on #153f7a (shade 7 is the exact brand color).
export const theme = createTheme({
  fontFamily:
    '"Instrument Sans", ui-sans-serif, system-ui, -apple-system, sans-serif',
  headings: {
    fontFamily: '"Newsreader", ui-serif, Georgia, serif',
    fontWeight: "500",
  },
  primaryColor: "navy",
  primaryShade: 7,
  colors: {
    // Mantine's default dark scale is a warm gray that reads brown next to
    // the site's cool surfaces; use a cool ramp aligned with the CSS tokens
    // (inputs pick up index 6 = the sidebar surface color).
    dark: [
      "#e7e9ec",
      "#c9cdd2",
      "#9aa1a9",
      "#6a7178",
      "#434a52",
      "#32383f",
      "#1d2126",
      "#1d2126",
      "#15181b",
      "#0d1013",
    ],
    navy: [
      "#e9eef9",
      "#d1ddf1",
      "#a8c0e4",
      "#7fa2d7",
      "#5c87ca",
      "#3a6bb9",
      "#25529a",
      "#153f7a",
      "#103460",
      "#0c294c",
    ],
  },
  defaultRadius: "md",
});
