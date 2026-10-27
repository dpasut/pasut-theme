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
