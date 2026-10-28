// Inline SVG icons (Tabler-style strokes) so rendering is consistent
// across platforms — no emoji fonts involved.

let svg = (body: string) =>
  `<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${body}</svg>`

let search = svg(
  `<circle cx="10" cy="10" r="7"></circle><line x1="21" y1="21" x2="15" y2="15"></line>`,
)

let photo = svg(
  `<rect x="3" y="4" width="18" height="16" rx="2"></rect><circle cx="9" cy="10" r="1.5"></circle><path d="M5 19l5 -6l3 3l3 -4l3 4"></path>`,
)

let tag = svg(
  `<path d="M11 3h7a1 1 0 0 1 1 1v7l-9 9a1.5 1.5 0 0 1 -2 0l-6 -6a1.5 1.5 0 0 1 0 -2z"></path><circle cx="15" cy="9" r="1"></circle>`,
)

module Icon = {
  @react.component
  let make = (~d: string, ~className: string="") =>
    <span
      className
      style={ReactDOM.Style.make(~display="inline-flex", ~alignItems="center", ())}
      dangerouslySetInnerHTML={{"__html": d}}
    />
}

let printer = svg(
  `<path d="M17 17h2a2 2 0 0 0 2 -2v-4a2 2 0 0 0 -2 -2h-14a2 2 0 0 0 -2 2v4a2 2 0 0 0 2 2h2"></path><path d="M17 9v-4a2 2 0 0 0 -2 -2h-6a2 2 0 0 0 -2 2v4"></path><rect x="7" y="13" width="10" height="8" rx="2"></rect>`,
)

let share = svg(
  `<circle cx="6" cy="12" r="3"></circle><circle cx="18" cy="6" r="3"></circle><circle cx="18" cy="18" r="3"></circle><line x1="8.7" y1="10.7" x2="15.3" y2="7.3"></line><line x1="8.7" y1="13.3" x2="15.3" y2="16.7"></line>`,
)

let sparkles = svg(
  `<path d="M16 18a2 2 0 0 1 2 2a2 2 0 0 1 2 -2a2 2 0 0 1 -2 -2a2 2 0 0 1 -2 2"></path><path d="M16 6a2 2 0 0 1 2 2a2 2 0 0 1 2 -2a2 2 0 0 1 -2 -2a2 2 0 0 1 -2 2"></path><path d="M9 12a4 4 0 0 1 4 4a4 4 0 0 1 4 -4a4 4 0 0 1 -4 -4a4 4 0 0 1 -4 4"></path>`,
)

let chevronLeft = svg(`<polyline points="15 6 9 12 15 18"></polyline>`)

let chevronRight = svg(`<polyline points="9 6 15 12 9 18"></polyline>`)

let home = svg(
  `<path d="M5 12l-2 0l9 -9l9 9l-2 0"></path><path d="M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-7"></path><path d="M9 21v-6a2 2 0 0 1 2 -2h2a2 2 0 0 1 2 2v6"></path>`,
)

let briefcase = svg(
  `<rect x="3" y="7" width="18" height="13" rx="2"></rect><path d="M8 7v-2a2 2 0 0 1 2 -2h4a2 2 0 0 1 2 2v2"></path><line x1="12" y1="12" x2="12" y2="12.01"></line><path d="M3 13a20 20 0 0 0 18 0"></path>`,
)

let heart = svg(
  `<path d="M19.5 12.572l-7.5 7.428l-7.5 -7.428a5 5 0 1 1 7.5 -6.566a5 5 0 1 1 7.5 6.572"></path>`,
)

let chefhat = svg(
  `<path d="M12 3c1.918 0 3.52 1.35 3.91 3.151a4 4 0 0 1 2.09 7.723l0 7.126h-12v-7.126a4 4 0 1 1 2.092 -7.723a4 4 0 0 1 3.908 -3.151z"></path><line x1="6.161" y1="17.009" x2="17.839" y2="17.009"></line>`,
)

let linkedin = svg(
  `<path d="M8 11v5"></path><path d="M8 8v.01"></path><path d="M12 16v-5"></path><path d="M16 16v-3a2 2 0 1 0 -4 0"></path><path d="M3 7a4 4 0 0 1 4 -4h10a4 4 0 0 1 4 4v10a4 4 0 0 1 -4 4h-10a4 4 0 0 1 -4 -4z"></path>`,
)

let school = svg(
  `<path d="M22 9l-10 -4l-10 4l10 4l10 -4v6"></path><path d="M6 10.6v5.4a6 3 0 0 0 12 0v-5.4"></path>`,
)

// Filled utensils mark (from the original cookbook favicon)
let utensils = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 416 512" width="16" height="16" fill="currentColor"><path d="M207.9 15.2c.8 4.7 16.1 94.5 16.1 128.8 0 52.3-27.8 89.6-68.9 104.6L168 486.7c.7 13.7-10.2 25.3-24 25.3H80c-13.7 0-24.7-11.5-24-25.3l12.9-238.1C27.7 233.6 0 196.2 0 144 0 109.6 15.3 19.9 16.1 15.2 19.3-5.1 61.4-5.4 64 16.3v141.2c1.3 3.4 15.1 3.2 16 0 1.4-25.3 7.9-139.2 8-141.8 3.3-20.8 44.7-20.8 47.9 0 .2 2.7 6.6 116.5 8 141.8.9 3.2 14.8 3.4 16 0V16.3c2.6-21.6 44.8-21.4 48-1.1zm119.2 285.7l-15 185.1c-1.2 14 9.9 26 23.9 26h56c13.3 0 24-10.7 24-24V24c0-13.2-10.7-24-24-24-82.5 0-221.4 178.5-64.9 300.9z"/></svg>`

let sun = svg(
  `<circle cx="12" cy="12" r="4"></circle><path d="M3 12h1m8 -9v1m8 8h1m-9 8v1m-6.4 -15.4l.7 .7m12.1 -.7l-.7 .7m0 11.4l.7 .7m-12.1 -.7l-.7 .7"></path>`,
)

let moon = svg(
  `<path d="M12 3c.132 0 .263 0 .393 0a7.5 7.5 0 0 0 7.92 12.446a9 9 0 1 1 -8.313 -12.454z"></path>`,
)

let monitor = svg(
  `<rect x="3" y="4" width="18" height="12" rx="1"></rect><line x1="7" y1="20" x2="17" y2="20"></line><line x1="9" y1="16" x2="9" y2="20"></line><line x1="15" y1="16" x2="15" y2="20"></line>`,
)

let menu = svg(
  `<line x1="4" y1="6" x2="20" y2="6"></line><line x1="4" y1="12" x2="20" y2="12"></line><line x1="4" y1="18" x2="20" y2="18"></line>`,
)

let close = svg(
  `<line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line>`,
)
