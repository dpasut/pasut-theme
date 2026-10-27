// Shared app shell: resizable, collapsible sidebar on desktop; top bar +
// bottom nav on phones. Each site supplies its brand and nav items.

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

let lsGet: string => Js.Nullable.t<string> = %raw(`k => {
  try { return window.localStorage.getItem(k); } catch (e) { return null; }
}`)
let lsSet: (string, string) => unit = %raw(`(k, v) => {
  try { window.localStorage.setItem(k, v); } catch (e) {}
}`)

let clientX: Dom.event => float = %raw(`e => e.clientX`)
let addWinListener: (string, Dom.event => unit) => unit = %raw(`(t, f) =>
  window.addEventListener(t, f)`)
let removeWinListener: (string, Dom.event => unit) => unit = %raw(`(t, f) =>
  window.removeEventListener(t, f)`)

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

module BottomItem = {
  @react.component
  let make = (~item: navItem, ~active: bool) => {
    let className = active ? "bn-item active" : "bn-item"
    let inner =
      <>
        <span className="bn-icon"> <Icons.Icon d=item.icon /> </span>
        {React.string(item.label)}
      </>
    item.isExternal
      ? <a href=item.to_ className> {inner} </a>
      : <Ui.Link to_=item.to_ className> {inner} </Ui.Link>
  }
}

@react.component
let make = (
  ~brand: string,
  ~brandInitial: string="C",
  ~brandIcon: option<string>=?,
  ~active: string,
  ~nav: array<navItem>,
  ~bottom: array<navItem>=[],
  ~mobileNav: array<navItem>=[],
  ~children,
) => {
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

  let sidebarStyle = collapsed
    ? ReactDOM.Style.make(~width="64px", ())
    : ReactDOM.Style.make(~width=Belt.Float.toString(width) ++ "px", ())

  let mobile = mobileNav->Js.Array2.length > 0 ? mobileNav : nav

  <div className="shell">
    <aside
      className={collapsed ? "sidebar collapsed" : "sidebar"} style=sidebarStyle>
      <Ui.Link to_="/" className="brand">
        <>
          <span className="brand-mark">
            {switch brandIcon {
            | Some(d) => <Icons.Icon d />
            | None => React.string(brandInitial)
            }}
          </span>
          {collapsed ? React.null : React.string(brand)}
        </>
      </Ui.Link>
      <nav className="side-nav">
        {nav
        ->Js.Array2.map(i =>
          <SideLink key=i.key item=i active={active == i.key} collapsed />
        )
        ->React.array}
      </nav>
      <div className="side-bottom">
        {bottom
        ->Js.Array2.map(i =>
          <SideLink key=i.key item=i active={active == i.key} collapsed />
        )
        ->React.array}
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
            <span className="brand-mark">
            {switch brandIcon {
            | Some(d) => <Icons.Icon d />
            | None => React.string(brandInitial)
            }}
          </span>
            {React.string(brand)}
          </>
        </Ui.Link>
      </header>
      <Mantine.Container size="xl" px="md">
        <div className="page"> {children} </div>
      </Mantine.Container>
    </div>
    <nav className="bottom-nav">
      {mobile
      ->Js.Array2.map(i =>
        <BottomItem key=i.key item=i active={active == i.key} />
      )
      ->React.array}
    </nav>
  </div>
}
