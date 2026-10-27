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
