// Shared app shell: resizable, collapsible sidebar on desktop; top bar +
// full-screen menu on phones. Each site supplies its brand and nav items,
// either as flat lists (`nav`, `bottom`) or grouped into sections
// (`sections`, `bottomSections`).

type navItem = {
  key: string,
  to_: string,
  icon: string,
  label: string,
  isExternal: bool,
  newTab: bool,
  trailing: option<React.element>,
}

let item = (~key, ~to_, ~icon, ~label, ~isExternal=false, ~newTab=false, ~trailing=?, ()) => {
  key,
  to_,
  icon,
  label,
  isExternal,
  newTab,
  trailing,
}

// A group of nav items. Every section after the first in its list starts with
// a thin divider and, if it has one, a small uppercase label ("LIVE TV").
// When the sidebar is collapsed the divider stays and the label is hidden.
type section = {key: string, label: option<string>, items: array<navItem>}

let section = (~key, ~label=?, ~items, ()) => {key, label, items}

@val @scope(("window", "localStorage"))
external storageGet: string => Js.Nullable.t<string> = "getItem"
@val @scope(("window", "localStorage"))
external storageSet: (string, string) => unit = "setItem"

// localStorage can throw (privacy modes); treat failures as absent/no-op.
let lsGet = k =>
  try storageGet(k) catch {
  | _ => Js.Nullable.null
  }
let lsSet = (k, v) =>
  try storageSet(k, v) catch {
  | _ => ()
  }

@get external clientX: Dom.event => float = "clientX"

@val @scope("window")
external addWinListener: (string, Dom.event => unit) => unit = "addEventListener"
@val @scope("window")
external removeWinListener: (string, Dom.event => unit) => unit =
  "removeEventListener"

let minWidth = 180.
let maxWidth = 400.
let clamp = w => w < minWidth ? minWidth : w > maxWidth ? maxWidth : w

module SideLink = {
  @react.component
  let make = (~item: navItem, ~active: bool, ~collapsed: bool) => {
    let inner =
      <>
        <Icons.Icon d=item.icon className="side-icon" />
        {collapsed
          ? React.null
          : <span className="side-label"> {React.string(item.label)} </span>}
        {collapsed
          ? React.null
          : switch item.trailing {
            | Some(t) => t
            | None => React.null
            }}
      </>
    let className = active ? "side-link active" : "side-link"
    let link = item.isExternal
      ? item.newTab
          ? <a href=item.to_ className target="_blank" rel="noopener noreferrer">
              {inner}
            </a>
          : <a href=item.to_ className> {inner} </a>
      : <Ui.Link to_=item.to_ className> {inner} </Ui.Link>
    // Tooltip needs a ref-forwarding child; a plain div qualifies.
    <Mantine.Tooltip
      label=item.label position="right" withArrow=true disabled={!collapsed}>
      <div className="tip-wrap"> {link} </div>
    </Mantine.Tooltip>
  }
}

module MenuItem = {
  @react.component
  let make = (~item: navItem, ~active: bool, ~onNavigate: unit => unit) => {
    let className = active ? "mm-item active" : "mm-item"
    let inner =
      <>
        <Icons.Icon d=item.icon className="side-icon" />
        <span className="side-label"> {React.string(item.label)} </span>
        {switch item.trailing {
        | Some(t) => t
        | None => React.null
        }}
      </>
    item.isExternal
      ? <a
          href=item.to_
          className
          target={item.newTab ? "_blank" : "_self"}
          rel={item.newTab ? "noopener noreferrer" : ""}
          onClick={_ => onNavigate()}>
          {inner}
        </a>
      : <a
          href=item.to_
          className
          onClick={e => {
            ReactEvent.Mouse.preventDefault(e)
            RescriptReactRouter.push(item.to_)
            Ui.scrollTop()
            onNavigate()
          }}>
          {inner}
        </a>
  }
}

module SectionHead = {
  @react.component
  let make = (~label: option<string>, ~collapsed: bool) =>
    <div className="nav-section" role="presentation">
      <div className="nav-divider" />
      {switch (label, collapsed) {
      | (Some(l), false) =>
        <div className="nav-section-label"> {React.string(l)} </div>
      | _ => React.null
      }}
    </div>
}

module SideSections = {
  @react.component
  let make = (~sections: array<section>, ~active: string, ~collapsed: bool) =>
    sections
    ->Js.Array2.mapi((s, i) =>
      <React.Fragment key=s.key>
        {i > 0 ? <SectionHead label=s.label collapsed /> : React.null}
        {s.items
        ->Js.Array2.map(it =>
          <SideLink key=it.key item=it active={active == it.key} collapsed />
        )
        ->React.array}
      </React.Fragment>
    )
    ->React.array
}

module MenuSections = {
  @react.component
  let make = (
    ~sections: array<section>,
    ~active: string,
    ~onNavigate: unit => unit,
  ) =>
    sections
    ->Js.Array2.mapi((s, i) =>
      <React.Fragment key=s.key>
        {i > 0 ? <SectionHead label=s.label collapsed=false /> : React.null}
        {s.items
        ->Js.Array2.map(it =>
          <MenuItem key=it.key item=it active={active == it.key} onNavigate />
        )
        ->React.array}
      </React.Fragment>
    )
    ->React.array
}

// The flat lists as a single unlabelled section, unless sections were given.
let sectionsOr = (sections: option<array<section>>, items: array<navItem>, key) =>
  switch sections {
  | Some(s) => s
  | None => [{key, label: None, items}]
  }

module ThemeToggle = {
  let next = s => s == "light" ? "dark" : s == "dark" ? "auto" : "light"
  let iconFor = s => s == "light" ? Icons.sun : s == "dark" ? Icons.moon : Icons.monitor
  let labelFor = s => s == "light" ? "Light" : s == "dark" ? "Dark" : "System"

  @react.component
  let make = (~collapsed: bool=false) => {
    let ctl = Mantine.useMantineColorScheme()
    let scheme = ctl.colorScheme
    collapsed
      ? <Mantine.Tooltip
          label={"Theme: " ++ labelFor(scheme)} position="right" withArrow=true>
          <div className="tip-wrap theme-toggle">
            <button
              className="theme-btn"
              onClick={_ => ctl.setColorScheme(next(scheme))}
              ariaLabel="Cycle color scheme">
              <Icons.Icon d={iconFor(scheme)} />
            </button>
          </div>
        </Mantine.Tooltip>
      : <div className="theme-toggle" role="group" ariaLabel="Color scheme">
          {["light", "dark", "auto"]
          ->Js.Array2.map(s =>
            <button
              key=s
              className={scheme == s ? "theme-btn active" : "theme-btn"}
              title={labelFor(s)}
              ariaLabel={labelFor(s)}
              onClick={_ => ctl.setColorScheme(s)}>
              <Icons.Icon d={iconFor(s)} />
            </button>
          )
          ->React.array}
        </div>
  }
}

@react.component
let make = (
  ~brand: string,
  ~brandInitial: string="C",
  ~brandIcon: option<string>=?,
  ~markVariant: string="box", // "box" (always shown) | "avatar" (circle, collapsed only)

  ~active: string,
  ~nav: array<navItem>=[],
  ~bottom: array<navItem>=[],
  // grouped alternatives to `nav` / `bottom`; when given, they replace them
  ~sections: option<array<section>>=?,
  ~bottomSections: option<array<section>>=?,
  ~children,
) => {
  let top = sectionsOr(sections, nav, "nav")
  let foot = sectionsOr(bottomSections, bottom, "bottom")
  let (collapsed, setCollapsed) = React.useState(() =>
    lsGet("sidebar-collapsed")->Js.Nullable.toOption == Some("1")
  )
  let (width, setWidth) = React.useState(() =>
    lsGet("sidebar-width")
    ->Js.Nullable.toOption
    ->Belt.Option.flatMap(Belt.Float.fromString)
    ->Belt.Option.mapWithDefault(248., clamp)
  )
  let dragging = React.useRef(false)
  let (menuOpen, setMenuOpen) = React.useState(() => false)
  let closeMenu = () => setMenuOpen(_ => false)

  React.useEffect0(() => {
    let onMove = e =>
      if dragging.current {
        setWidth(_ => clamp(clientX(e)))
      }
    let onUp = _ =>
      if dragging.current {
        dragging.current = false
        setWidth(w => {
          lsSet("sidebar-width", Belt.Float.toString(w))
          w
        })
      }
    addWinListener("mousemove", onMove)
    addWinListener("mouseup", onUp)
    Some(
      () => {
        removeWinListener("mousemove", onMove)
        removeWinListener("mouseup", onUp)
      },
    )
  })

  let toggle = _ =>
    setCollapsed(c => {
      lsSet("sidebar-collapsed", !c ? "1" : "0")
      !c
    })

  let sidebarStyle: JsxDOMStyle.t = collapsed
    ? {width: "64px"}
    : {width: Belt.Float.toString(width) ++ "px"}

  <div className="shell">
    <aside
      className={collapsed ? "sidebar collapsed" : "sidebar"} style=sidebarStyle>
      <Ui.Link to_="/" className="brand">
        <>
          {markVariant == "avatar" && !collapsed
            ? React.null
            : <span
                className={markVariant == "avatar"
                  ? "brand-mark avatar-mark"
                  : "brand-mark"}>
                {switch brandIcon {
                | Some(d) => <Icons.Icon d />
                | None => React.string(brandInitial)
                }}
              </span>}
          {collapsed ? React.null : React.string(brand)}
        </>
      </Ui.Link>
      <nav className="side-nav">
        <SideSections sections=top active collapsed />
      </nav>
      <div className="side-bottom">
        <SideSections sections=foot active collapsed />
        <ThemeToggle collapsed />
      </div>
      <button
        className="edge-toggle"
        onClick=toggle
        ariaLabel={collapsed ? "Expand sidebar" : "Collapse sidebar"}
        title={collapsed ? "Expand sidebar" : "Collapse sidebar"}>
        <Icons.Icon d={collapsed ? Icons.chevronRight : Icons.chevronLeft} />
      </button>
      {collapsed
        ? React.null
        : <div
            className="resize-handle"
            onMouseDown={e => {
              ReactEvent.Mouse.preventDefault(e)
              dragging.current = true
            }}
          />}
    </aside>
    <div className="main-col">
      <header className="mobile-header">
        <Ui.Link to_="/" className="brand">
          <>
            {markVariant == "avatar"
              ? React.null
              : <span className="brand-mark">
                  {switch brandIcon {
                  | Some(d) => <Icons.Icon d />
                  | None => React.string(brandInitial)
                  }}
                </span>}
            {React.string(brand)}
          </>
        </Ui.Link>
        <button
          className="mh-burger"
          onClick={_ => setMenuOpen(_ => true)}
          ariaLabel="Open menu">
          <Icons.Icon d=Icons.menu />
        </button>
      </header>
      <Mantine.Container size="xl" px="md">
        <div className="page"> {children} </div>
      </Mantine.Container>
    </div>
    <div className={menuOpen ? "mobile-menu open" : "mobile-menu"}>
      <div className="mm-head">
        <span className="brand"> {React.string(brand)} </span>
        <button
          className="mh-burger"
          onClick={_ => setMenuOpen(_ => false)}
          ariaLabel="Close menu">
          <Icons.Icon d=Icons.close />
        </button>
      </div>
      <nav className="mm-nav">
        <MenuSections sections=top active onNavigate=closeMenu />
      </nav>
      <div className="mm-bottom">
        <MenuSections sections=foot active onNavigate=closeMenu />
        <ThemeToggle />
      </div>
    </div>
  </div>
}
