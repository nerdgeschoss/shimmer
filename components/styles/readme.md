Stack Component
===============

The Stack Component is a powerful, reusable SCSS tool built upon the robust CSS Grid framework. It's designed to manage both layout and spacing, thus promoting uniformity, readability, and maintainability within your CSS code.

Key Features
------------

*   **Streamlined Grid Layouts**: Create responsive grid layouts that adapt across devices.
*   **Uniform Spacing**: Achieve consistent spacing between items within a container with minimal effort.
*   **Customizable to Your Needs**: Fine-tune the Stack Component to meet your project's unique design requirements.

Usage
-----

To use the Stack Component, you need to import it into your SCSS file:

scss

scss

```scss
@import "shimmer/components/stack";
```

SCSS Variables and Breakpoints
------------------------------

The Stack Component relies on a set of predefined SCSS variables. These variables are located in the `variables.scss` file within the `components/styles` directory of the gem.

Here is a sample of the variables defined:

scss

```scss
$size-breakpoint-tablet: 640px;
$size-breakpoint-desktop: 890px;
$size-breakpoint-widescreen: 1280px;
```

These variables represent the breakpoints for tablet, desktop, and widescreen devices respectively. To include these variables in your SCSS, you need to import the `variables.scss` file:

scss

```scss
@import "shimmer/components/styles/variables";
```

You can use these variables with the `@include` directive to apply styles at specific viewport sizes. For instance:

scss

```scss
@include breakpoint($size-breakpoint-tablet) {
  // Styles for tablet viewport size...
}
```

### Spacing

The Stack Component offers a variety of spacing options. You define the spacing using the format `stack--spacing-{value}`, where `{value}` is one of the following: 0, 2, 4, 8, 12, 16, 20, 22, 24, 32, 40, 48, 56, 64.

### Alignment, Justification, and Equal Sizing

The Stack Component provides several classes for controlling alignment, justification, and sizing of stack items:

*   For alignment, use: `-start`, `-center`, `-end`, `-stretch`
*   For justification, use: `-start`, `-center`, `-end`, `-space-between`, `-space-around`
*   For equal sizing, use: `-equal-size`

Key Modifiers
-------------

The `-equal-size` modifier applies the `flex: 1` rule to every direct child of the Stack Component, forcing them to have equal widths (for rows) or heights (for columns). If you don't apply `-equal-size`, the Stack items will take up only as much space as they need, based on their content.

The rule `min-width: 0` is applied to all direct children of the Stack Component to prevent them from growing larger than the stack itself, which would cause layout issues.

Mobile-First Approach
---------------------

The Stack Component adopts a mobile-first approach. This means that you should start with the basic Stack Component for mobile designs and progressively enhance or modify its behavior for larger screens (like tablets, desktops, or widescreens) as needed.

This approach ensures a scalable and maintainable design, with base styles for smaller screens and additional rules for larger ones.

---

Example: Building a Responsive Header
-------------------------------------

Let's create a basic structure first:

html

html

```html
<header class="stack">
    <div class="logo">Logo</div>
    <nav class="navigation">
        <ul class="stack">
            <li>Link 1</li>
            <li>Link 2</li>
            <li>Link 3</li>
        </ul>
    </nav>
</header>
```

### Mobile Layout (default)

The Stack Component applies a gap of `8px` by default:

scss

scss

```scss
.stack {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-8);
  > * {
    min-width: 0;
  }
}
```

This means, for mobile devices, the logo and the navigation will stack vertically with a gap of `8px` between them.

### Tablet Layout

On larger screens like tablets, we might want to change the layout to a row and align the items in the center. We also want to increase the gap to `16px`.

html

html

```html
<header class="stack stack--line-tablet stack--align-tablet-center stack--tablet-16">
    <div class="logo">Logo</div>
    <nav class="navigation">
        <ul class="stack stack--line-tablet stack--tablet-16">
            <li>Link 1</li>
            <li>Link 2</li>
            <li>Link 3</li>
        </ul>
    </nav>
</header>
```

### Desktop and Widescreen Layout

On even larger screens like desktops and widescreens, we might want to keep the same structure but increase the gap to `24px` and `32px` respectively.

html

html

```html
<header class="stack stack--line-tablet stack--align-tablet-center stack--tablet-16 stack--desktop-24 stack--widescreen-32">
    <div class="logo">Logo</div>
    <nav class="navigation">
        <ul class="stack stack--line-tablet stack--tablet-16 stack--desktop-24 stack--widescreen-32">
            <li>Link 1</li>
            <li>Link 2</li>
            <li>Link 3</li>
        </ul>
    </nav>
</header>
```

The Stack Component provides a simple, intuitive way to create layouts that are responsive and adaptable across different screen sizes. By adding or removing classes, you can easily modify your layout for various screen sizes.
