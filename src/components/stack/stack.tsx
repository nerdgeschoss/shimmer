import React from "react";
import classnames from "classnames";

type Justify =
  | "start"
  | "center"
  | "end"
  | "space-between"
  | "space-around"
  | "stretch"
  | "equal-size";
type Align = "start" | "center" | "end" | "stretch";

export interface Props {
  children: React.ReactNode;
  gap?: number;
  gapTablet?: number;
  gapDesktop?: number;
  gapWidescreen?: number;
  line?: boolean;
  lineTablet?: boolean;
  lineDesktop?: boolean;
  lineWidescreen?: boolean;
  align?: Align;
  alignTablet?: Align;
  alignDesktop?: Align;
  alignWidescreen?: Align;
  justify?: Justify;
  justifyTablet?: Justify;
  justifyDesktop?: Justify;
  justifyWidescreen?: Justify;
}

export function Stack({
  children,
  gap = 8,
  gapTablet,
  gapDesktop,
  gapWidescreen,
  line,
  lineTablet,
  lineDesktop,
  lineWidescreen,
  align,
  alignTablet,
  alignDesktop,
  alignWidescreen,
  justify,
  justifyTablet,
  justifyDesktop,
  justifyWidescreen,
}: Props): JSX.Element {
  return (
    <div
      className={classnames(
        "stack",
        gap && `stack--${gap}`,
        gapTablet && `stack--tablet-${gapTablet}`,
        gapDesktop && `stack--desktop-${gapDesktop}`,
        gapWidescreen && `stack--widescreen-${gapWidescreen}`,
        align && `stack--align-${align}`,
        alignTablet && `stack--align-tablet-${alignTablet}`,
        alignDesktop && `stack--align-desktop-${alignDesktop}`,
        alignWidescreen && `stack--align-widescreen-${alignWidescreen}`,
        justify && `stack--justify-${justify}`,
        justifyTablet && `stack--justify-tablet-${justifyTablet}`,
        justifyDesktop && `stack--justify-desktop-${justifyDesktop}`,
        justifyWidescreen && `stack--justify-widescreen-${justifyWidescreen}`,
        { "stack--line": line },
        { "stack--line-tablet": lineTablet },
        { "stack--line-desktop": lineDesktop },
        { "stack--line-widescreen": lineWidescreen }
      )}
    >
      {children}
    </div>
  );
}
