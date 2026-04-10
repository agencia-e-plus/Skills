---
name: vtex-io-styling
description: Generates and validates styling for VTEX IO components using CSS Handles and Tachyons. Enforces the whitelist of allowed CSS selectors and prevents usage of deprecated HTML-structure selectors.
version: 1.0.1
---

# VTEX IO Styling and CSS Handles

## When to use this skill
Use this skill when the user asks to:
1. Style a React component in VTEX IO.
2. Fix layout issues caused by HTML structure changes (broken selectors).
3. Implement vtex.css-handles or custom classes.
4. Apply CSS to a Store Framework block.

## Critical Rules: Selector Whitelist
VTEX IO explicitly deprecates selectors based on HTML structure because the rendered DOM is volatile. You must strictly follow this whitelist found in the documentation.

### Forbidden Selectors (Strictly Deprecated)
Do NOT generate or suggest CSS containing:
*   Tag/Type selectors: div, span, h1, button (e.g., .container > div).
*   IDs: #header, #menu.
*   Combinators dependent on tags: > (direct child), + (adjacent sibling), ~ (general sibling).
*   Fixed nth-child: :nth-child(2), :nth-child(3).
*   Attribute selectors (except data attributes): [alt="logo"], [type="text"].

### Allowed Selectors (Whitelist)
*   Class selectors: .container, .menuItem.
*   Data Attributes: [data-id="123"], [data-selected].
*   Pseudo-classes: :hover, :visited, :active, :disabled, :focus, :local, :empty, :target.
*   Structural pseudo-classes (Limited): :first-child, :last-child, :nth-child(even), :nth-child(odd).
*   Pseudo-elements: ::before, ::after, ::placeholder.
*   Space combinator between classes: .foo .bar (descendant selector).
*   Global App Selectors: :global(.vtex-app-name-1-x-handle).

## Implementation Guide

### 1. Manifest Dependency
Ensure the app has the required dependency in manifest.json:
{
  "dependencies": {
    "vtex.css-handles": "0.x"
  }
}

### 2. Functional Components (Standard Pattern)
Use the useCssHandles hook. Do not use standard CSS classes directly; always map them through handles.

Pattern:
import React from 'react'
import { useCssHandles, applyModifiers } from 'vtex.css-handles'

// 1. Define the handles list using 'as const' for TypeScript inference
const CSS_HANDLES = ['container', 'title', 'button'] as const

const MyComponent = ({ isActive }) => {
  // 2. Initialize the hook
  const handles = useCssHandles(CSS_HANDLES)

  return (
    // 3. Use Tachyons for layout (flex, padding) and Handles for specific styling
    <div className={`${handles.container} flex flex-column pa4`}>
      <h2 className={`${handles.title} t-heading-2 mb3`}>Hello VTEX</h2>
      
      {/* 4. Use applyModifiers for conditional states. NEVER concatenate strings manually. */}
      <button 
        className={`${applyModifiers(handles.button, isActive ? 'active' : '')} ph3 pv2`}
      >
        Click me
      </button>
    </div>
  )
}

export default MyComponent

### 3. Class Components (Legacy Support)
Use the withCssHandles Higher-Order Component.

Pattern:
import React, { Component } from 'react'
import { withCssHandles } from 'vtex.css-handles'

const CSS_HANDLES = ['container', 'text'] as const

class MyComponent extends Component {
  render() {
    const { cssHandles } = this.props
    return (
      <div className={cssHandles.container}>
        <span className={cssHandles.text}>Hello</span>
      </div>
    )
  }
}

export default withCssHandles(CSS_HANDLES)(MyComponent)

## Modifiers vs. Conditional Classes
When a component has a state (e.g., active, loading, selected), do not manually concatenate strings like `handles.item + ' ' + 'active'`.
Instead, use the `applyModifiers` utility. This ensures the generated class follows the BEM-like structure VTEX expects (e.g., vtex-app-1-x-button--active).

## Tachyons Usage
VTEX IO recommends Tachyons for structural styling to reduce CSS file size.
*   Margins/Padding: ma, pa, mt, pb, ph, pv (scale 0-9).
*   Flexbox: flex, flex-column, items-center, justify-between.
*   Typography: f1-f7 (size), b (bold), tc (text-center).
*   Colors: c-on-base, bg-action-primary (using theme tokens).

Use CSS Handles only for:
*   Specific custom colors (hex/rgb).
*   Specific pixel-perfect dimensions.
*   Complex animations.
*   Pseudo-elements (::before/::after).