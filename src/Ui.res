// Small shared UI pieces.

@val @scope("window") external windowScrollTo: (int, int) => unit = "scrollTo"

let scrollTop = () => windowScrollTo(0, 0)

module Link = {
  @react.component
  let make = (
    ~to_: string,
    ~className: string="",
    // the link's name when it shows no text (an icon only), and "page" on the link to the current page
    ~ariaLabel: option<string>=?,
    ~ariaCurrent: option<[#date | #"false" | #location | #page | #step | #time | #"true"]>=?,
    ~children,
  ) => {
    let onClick = e => {
      // allow cmd/ctrl-click to open in a new tab
      if (
        !ReactEvent.Mouse.metaKey(e) &&
        !ReactEvent.Mouse.ctrlKey(e) &&
        !ReactEvent.Mouse.shiftKey(e)
      ) {
        ReactEvent.Mouse.preventDefault(e)
        RescriptReactRouter.push(to_)
        scrollTop()
      }
    }
    <a href=to_ className onClick ?ariaLabel ?ariaCurrent> {children} </a>
  }
}

module TagChip = {
  @react.component
  let make = (~tag: string) =>
    <Link to_={"/tags/" ++ Js.Global.encodeURIComponent(tag)} className="chip">
      {React.string(tag)}
    </Link>
}

module NoPhoto = {
  @react.component
  let make = (~hero: bool=false) =>
    <div className={hero ? "recipe-hero no-photo" : "no-photo"}>
      <div className="np-icon"> <Icons.Icon d=Icons.photo /> </div>
      {React.string("No photo")}
    </div>
}

let initials = (name: string) => {
  let parts =
    name
    ->Js.String2.trim
    ->Js.String2.splitByRe(%re("/\s+/"))
    ->Js.Array2.map(p => p->Belt.Option.getWithDefault(""))
    ->Js.Array2.filter(p => p !== "")
  switch parts {
  | [] => "?"
  | [one] => one->Js.String2.slice(~from=0, ~to_=2)->Js.String2.toUpperCase
  | many => {
      let first = many[0]->Js.String2.slice(~from=0, ~to_=1)
      let last =
        many[Js.Array2.length(many) - 1]->Js.String2.slice(~from=0, ~to_=1)
      (first ++ last)->Js.String2.toUpperCase
    }
  }
}
