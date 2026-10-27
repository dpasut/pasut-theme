// Minimal hand-rolled bindings for the Mantine components this app uses.

type responsiveCols = {base: int, sm: int, lg: int}

module Provider = {
  @module("@mantine/core") @react.component
  external make: (
    ~theme: 'theme=?,
    ~defaultColorScheme: string=?,
    ~children: React.element,
  ) => React.element = "MantineProvider"
}

type colorSchemeCtl = {
  colorScheme: string,
  setColorScheme: string => unit,
}

@module("@mantine/core")
external useMantineColorScheme: unit => colorSchemeCtl = "useMantineColorScheme"

module Container = {
  @module("@mantine/core") @react.component
  external make: (
    ~size: string=?,
    ~px: string=?,
    ~children: React.element,
  ) => React.element = "Container"
}

module SimpleGrid = {
  @module("@mantine/core") @react.component
  external make: (
    ~cols: responsiveCols=?,
    ~spacing: string=?,
    ~children: React.element,
  ) => React.element = "SimpleGrid"
}

module TextInput = {
  @module("@mantine/core") @react.component
  external make: (
    ~value: string=?,
    ~onChange: ReactEvent.Form.t => unit=?,
    ~placeholder: string=?,
    ~size: string=?,
    ~radius: string=?,
    ~leftSection: React.element=?,
    ~rightSection: React.element=?,
    ~ariaLabel: string=?,
  ) => React.element = "TextInput"
}

module Group = {
  @module("@mantine/core") @react.component
  external make: (
    ~gap: string=?,
    ~justify: string=?,
    ~align: string=?,
    ~wrap: string=?,
    ~children: React.element,
  ) => React.element = "Group"
}

module Stack = {
  @module("@mantine/core") @react.component
  external make: (~gap: string=?, ~children: React.element) => React.element =
    "Stack"
}

module Text = {
  @module("@mantine/core") @react.component
  external make: (
    ~size: string=?,
    ~c: string=?,
    ~fw: int=?,
    ~span: bool=?,
    ~children: React.element,
  ) => React.element = "Text"
}

module Button = {
  @module("@mantine/core") @react.component
  external make: (
    ~variant: string=?,
    ~size: string=?,
    ~onClick: ReactEvent.Mouse.t => unit=?,
    ~leftSection: React.element=?,
    ~children: React.element,
  ) => React.element = "Button"
}

module CloseButton = {
  @module("@mantine/core") @react.component
  external make: (
    ~onClick: ReactEvent.Mouse.t => unit=?,
    ~ariaLabel: string=?,
  ) => React.element = "CloseButton"
}

type selectItem = {value: string, label: string}

module Select = {
  @module("@mantine/core") @react.component
  external make: (
    ~data: array<selectItem>=?,
    ~value: Js.Nullable.t<string>=?,
    ~onChange: Js.Nullable.t<string> => unit=?,
    ~placeholder: string=?,
    ~clearable: bool=?,
    ~searchable: bool=?,
    ~size: string=?,
    ~radius: string=?,
    ~w: int=?,
  ) => React.element = "Select"
}

module MultiSelect = {
  @module("@mantine/core") @react.component
  external make: (
    ~data: array<string>=?,
    ~value: array<string>=?,
    ~onChange: array<string> => unit=?,
    ~placeholder: string=?,
    ~clearable: bool=?,
    ~searchable: bool=?,
    ~size: string=?,
    ~radius: string=?,
    ~w: int=?,
  ) => React.element = "MultiSelect"
}

module Tooltip = {
  @module("@mantine/core") @react.component
  external make: (
    ~label: string,
    ~position: string=?,
    ~disabled: bool=?,
    ~withArrow: bool=?,
    ~children: React.element,
  ) => React.element = "Tooltip"
}

module Badge = {
  @module("@mantine/core") @react.component
  external make: (
    ~variant: string=?,
    ~size: string=?,
    ~radius: string=?,
    ~children: React.element,
  ) => React.element = "Badge"
}
