# Design Tokens: Complete Learning Guide

## Table of Contents
1. [Introduction](#introduction)
2. [What Are Design Tokens?](#what-are-design-tokens)
3. [Token Structure and Types](#token-structure-and-types)
4. [Aliasing and References](#aliasing-and-references)
5. [Implementation in Figma](#implementation-in-figma)
6. [Dark Mode and Theming](#dark-mode-and-theming)
7. [Naming Conventions](#naming-conventions)
8. [Best Practices](#best-practices)

## Introduction

Design tokens represent the evolution of design systems, addressing scalability challenges that teams face as their products grow. They provide a systematic approach to managing design properties and values across an entire design system.

### The Problem

Teams often struggle with:
- Inconsistent spacing and border radius values
- Unpredictable user experiences
- Difficulty tracking design standards
- Inefficient change management processes
- Accuracy issues during design-to-development handoffs

### The Solution

Design tokens offer:
- **Single source of truth** that maintains consistency between design and code
- **Improved management** of scaling design systems
- **Elimination of guesswork** when building products
- **Enhanced efficiency** in the development process

## What Are Design Tokens?

Design tokens are a method for managing design properties and values across a design system. Each token stores a piece of information such as:

- Colors
- Sizing
- Spacing
- Typography
- Animations
- Border radius
- Shadows

Each token receives a name to make it easier to reference and becomes reusable across designs, creating a shared language between design and code.

### Example Scenario

**Problem**: A designer hands off a file with 25-point spacing values, but the codebase uses an 8-point spatial system. The developer assumes this is intentional and implements the incorrect spacing.

**Solution with Tokens**: The design file would include information about which spacing token to use, pointing to a pre-validated value and preventing errors and ambiguity.

## Token Structure and Types

The most common design token structure starts with three foundational layers, each communicating different aspects of the token's purpose.

### 1. Primitive Tokens (Global Tokens)

**Definition**: Foundation tokens that define every value in a property system.

**Characteristics**:
- Reference-only (never applied directly in designs)
- Serve as the foundation for other tokens
- Include every possible value for a property

**Examples**:
```
// Color primitives
color-red-100: #FEF2F2
color-red-200: #FECACA
color-red-300: #FCA5A5
color-red-400: #F87171
color-red-500: #EF4444

// Spacing primitives
spacing-4: 4px
spacing-8: 8px
spacing-12: 12px
spacing-16: 16px
spacing-24: 24px
```

### 2. Semantic Tokens

**Definition**: Tokens that provide context on how the token should be used.

**Characteristics**:
- Can be applied directly to designs
- Convey meaning, purpose, and usage context
- Reference primitive tokens

**Naming Structure**: `[surface/purpose]-[brand/category]-[intensity/variant]`

**Examples**:
```
// Semantic color tokens
surface-brand-contrast → references color-red-400
surface-neutral-subtle → references color-gray-100
text-primary-default → references color-gray-900
text-danger-emphasis → references color-red-500

// Semantic spacing tokens
spacing-component-small → references spacing-8
spacing-component-medium → references spacing-16
spacing-layout-large → references spacing-24
```

### 3. Component-Specific Tokens

**Definition**: Tokens that provide maximum specificity by indicating exactly where a token is used.

**Characteristics**:
- Applied directly in designs
- Most detailed level of token organization
- Commonly used by larger, enterprise-level systems

**Naming Structure**: `[component]-[element]-[property]-[state]`

**Examples**:
```
// Button tokens
button-primary-background-default → references surface-brand-contrast
button-primary-background-hover → references surface-brand-emphasis
button-primary-background-disabled → references surface-neutral-muted
button-secondary-border-default → references border-neutral-default

// Input tokens
input-field-background-default → references surface-neutral-subtle
input-field-border-focus → references border-brand-emphasis
input-field-text-placeholder → references text-neutral-muted
```

## Aliasing and References

### Definition
Aliasing allows any token to reference or take on the value of another token. When a referenced token changes, all tokens referencing it update automatically.

### Benefits

1. **Organized Structure**: Neatly organize tokens into categories and subcategories
2. **Efficient Updates**: Quickly update any category with downstream propagation
3. **Controlled Changes**: Avoid unintentionally affecting other design areas
4. **Scalable Architecture**: No limit to reference depth or frequency

### Reference Chain Example
```
// Primitive level
color-blue-400: #3B82F6

// Semantic level
surface-brand-primary → color-blue-400

// Component level
button-primary-background → surface-brand-primary
```

### Complex Aliasing Structure
```
Primitive Tokens
├── Semantic Tokens (reference primitives)
│   ├── Surface tokens
│   ├── Text tokens
│   └── Border tokens
└── Component Tokens (reference semantics or primitives)
    ├── Button tokens
    ├── Input tokens
    └── Card tokens
```

## Implementation in Figma

### Styles vs Variables

#### When to Use Variables
- Complex token structures (variables can define other variables)
- Multiple modes for theming support
- Scoping for specific usage contexts
- Code syntax for better handoff experience

#### When to Use Styles
- Color gradients (variables cannot capture gradients)
- Composite values (multiple fills, shadow effects)

#### Hybrid Approach
Most teams implement design tokens using a combination of styles and variables to leverage the strengths of both features.

### Implementation Process

#### Step 1: Create Variable Collections

```
Collection: "Primitives"
├── Purpose: Store all primitive tokens
├── Scoping: Hide from all supported properties
├── Publishing: Hide from publishing
└── Organization: Group by color families, spacing scales

Collection: "Tokens" 
├── Purpose: Store semantic and component tokens
├── Scoping: Available in supported properties
├── Publishing: Published to team libraries
└── Organization: Group by usage categories
```

#### Step 2: Organize Primitive Tokens

```
Color Organization:
├── red-100 (lightest - most white)
├── red-200
├── red-300  
├── red-400
└── red-500 (darkest - most black)

Spacing Organization:
├── spacing-4: 4px
├── spacing-8: 8px
├── spacing-12: 12px
├── spacing-16: 16px
└── spacing-24: 24px
```

#### Step 3: Create Semantic Token Groups

```
Surface Group:
├── surface-primary
├── surface-secondary
├── surface-brand
└── surface-danger

Button Group:
├── button-primary-background
├── button-primary-text
├── button-secondary-background
└── button-secondary-text

Text Group:
├── text-primary
├── text-secondary
├── text-muted
└── text-inverse
```

#### Step 4: Audit and Apply

1. **Conduct Design Audit**: Document every color/spacing value used in the product
2. **Identify Usage Areas**: Categorize by surface, button, text, border, icon
3. **Create Token Names**: Establish names that communicate usage
4. **Apply to Designs**: Replace hard-coded values with token references

## Dark Mode and Theming

### Variable Modes Approach

Design tokens enable efficient theming through Figma's variable modes feature without requiring token name changes.

#### Implementation Steps

1. **Maintain Token Structure**: Keep existing semantic and component token names
2. **Create New Mode**: Add "Dark" mode in the tokens collection
3. **Update References**: Point to different primitive tokens as needed
4. **Test Switching**: Use right sidebar to toggle between modes

#### Example: Light to Dark Mode

```
Light Mode References:
├── surface-primary → gray-50
├── surface-secondary → gray-100
├── text-primary → gray-900
└── text-secondary → gray-600

Dark Mode References:
├── surface-primary → gray-900
├── surface-secondary → gray-800
├── text-primary → gray-50
└── text-secondary → gray-300
```

#### Benefits of Mode-Based Theming

- **Token Names Remain Consistent**: No need to rename tokens
- **Quick Theme Switching**: Toggle modes from the interface
- **Scalable Approach**: Add multiple themes (high contrast, seasonal, etc.)
- **Maintenance Efficiency**: Update references rather than recreating tokens

## Naming Conventions

### Core Principles

#### 1. Clarity and Understanding
- Use language-neutral names for cross-team accessibility
- Consider international team members
- Make tokens approachable across different disciplines

#### 2. Full Words Over Abbreviations
- **Good**: `background-primary`, `text-secondary`
- **Bad**: `bg-1`, `txt-2nd`
- Abbreviations can be unclear and open to interpretation

#### 3. Consistent Prefixes
- Background colors always start with `background`
- Text colors always start with `text`
- Spacing always starts with `spacing`
- Maintain consistency across all token categories

#### 4. Contextual Singular/Plural Usage
- Use singular or plural based on the context of usage
- **Single item**: `button-primary`
- **Multiple items**: `colors-brand-palette`

#### 5. Avoid Brand-Specific Names
- Use generic names for broader context usage
- **Good**: `surface-brand-primary`
- **Bad**: `surface-company-name-primary`
- Enables token reuse across multiple products or brands

### Token Naming Patterns

#### Surface Tokens
```
surface-primary          // Main background
surface-secondary        // Secondary backgrounds  
surface-brand            // Brand-related surfaces
surface-neutral          // Neutral backgrounds
surface-success          // Success state backgrounds
surface-warning          // Warning state backgrounds
surface-danger           // Error state backgrounds
```

#### Text Tokens
```
text-primary             // Primary text color
text-secondary           // Secondary text color
text-muted               // Subdued text
text-inverse             // Text on dark backgrounds
text-brand               // Brand-colored text
text-success             // Success message text
text-warning             // Warning message text
text-danger              // Error message text
```

#### Component Tokens
```
button-primary-background-default
button-primary-background-hover
button-primary-background-active
button-primary-background-disabled
button-primary-text-default
button-primary-border-default
```

### Future-Proofing Token Names

#### Anticipate Growth
- Choose names that can accommodate new additions
- Avoid overly specific names that limit expansion
- Plan for potential system modifications

#### Scalability Examples
```
// Scalable approach
spacing-small → Can add spacing-xsmall, spacing-medium
color-brand-primary → Can add color-brand-secondary, tertiary

// Limited approach  
spacing-8 → Hard to insert between existing values
color-blue → Doesn't accommodate multiple blue variants
```

## Best Practices

### Token Structure Planning

#### Start with Foundation
1. **Begin with Primitives**: Establish all raw values first
2. **Add Semantic Layer**: Build contextual meaning on top
3. **Consider Component Level**: Add if needed for large-scale systems
4. **Plan for Growth**: Anticipate future system expansion

#### Organizational Strategies
- **Category-Based**: Group by usage (surface, text, border)
- **Property-Based**: Group by CSS property (color, spacing, typography)
- **Component-Based**: Group by UI component (button, input, card)
- **Hybrid Approach**: Combine strategies based on team needs

### Migration Strategy

#### Gradual Implementation
1. **Start with Color**: Usually the most straightforward migration
2. **Add Spacing**: Implement spatial system tokens
3. **Expand to Typography**: Include font, size, line-height tokens
4. **Include Shadows/Effects**: Add visual effect tokens
5. **Complete with Motion**: Implement animation/transition tokens

#### Change Management
- **Communicate Changes**: Keep team informed throughout migration
- **Document Decisions**: Record why certain approaches were chosen
- **Train Team Members**: Ensure everyone understands new system
- **Monitor Usage**: Track adoption and identify issues

### Team Collaboration

#### Design-Development Handoff
```
// Design token reference in handoff
Token: button-primary-background-default
Value: #3B82F6 (references color-blue-400)
Usage: Primary action buttons in default state
Context: High emphasis actions, CTAs
```

#### Documentation Standards
- **Token Purpose**: Clearly explain when to use each token
- **Usage Examples**: Provide visual and code examples  
- **Do's and Don'ts**: Specify correct and incorrect usage
- **Update History**: Track changes and version history

### Quality Assurance

#### Token Validation
1. **Accessibility Check**: Ensure color contrast ratios meet standards
2. **Consistency Audit**: Verify similar use cases use same tokens
3. **Performance Review**: Monitor impact on file size and performance
4. **Cross-Platform Testing**: Validate tokens work across all platforms

#### Maintenance Procedures
- **Regular Audits**: Periodically review token usage and effectiveness
- **Cleanup Processes**: Remove unused or redundant tokens
- **Version Control**: Track changes and maintain backwards compatibility
- **Stakeholder Reviews**: Get feedback from design and development teams

## Conclusion

Design tokens represent a fundamental shift in how teams manage design systems at scale. By implementing a thoughtful token architecture, teams can:

- **Improve Consistency**: Maintain unified design language across products
- **Increase Efficiency**: Reduce time spent on design decisions and implementation
- **Enable Scalability**: Support growing design systems and team expansion  
- **Enhance Collaboration**: Create shared vocabulary between design and development
- **Facilitate Theming**: Enable dark modes and brand variations efficiently


---

Written by [seunghwanly](https://github.com/seunghwanly)