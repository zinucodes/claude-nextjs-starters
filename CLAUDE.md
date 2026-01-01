# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Next.js 16 starter project using the App Router, TypeScript, and Tailwind CSS v4. The project is pre-configured with shadcn/ui components and uses the "new-york" style variant.

## Development Commands

```bash
# Development
npm run dev          # Start dev server at http://localhost:3000

# Build & Production
npm run build        # Create production build
npm start            # Start production server

# Linting
npm run lint         # Run ESLint (using flat config)
```

## Architecture

### Next.js App Router Structure

- **`/app`**: App Router directory with file-based routing
  - `layout.tsx`: Root layout with Geist font configuration
  - `page.tsx`: Home page component
  - `globals.css`: Global styles with Tailwind CSS v4 and theme variables

### Styling System

- **Tailwind CSS v4**: Uses `@import "tailwindcss"` in globals.css (not tailwind.config)
- **tw-animate-css**: Animation utilities included
- **CSS Variables**: Extensive theming system via CSS custom properties in `globals.css`
- **Dark Mode**: Class-based dark mode with custom variant `@custom-variant dark (&:is(.dark *))`
- **Theme Tokens**: Uses OKLCH color space for all color values

### shadcn/ui Integration

Configuration in `components.json`:
- Style: "new-york"
- RSC: Enabled (React Server Components)
- Icon Library: lucide
- Path Aliases:
  - `@/components` → `/components`
  - `@/lib` → `/lib`
  - `@/hooks` → `/hooks`
  - `@/ui` → `/components/ui`

When adding shadcn components, they will be placed in `/components/ui/`.

### Utilities

- **`lib/utils.ts`**: Contains `cn()` helper for merging Tailwind classes with clsx and tailwind-merge

### TypeScript Configuration

- Import alias: `@/*` maps to project root
- Strict mode enabled
- React JSX transform (react-jsx)

### Fonts

Uses Next.js font optimization with Geist fonts:
- `--font-geist-sans`: Primary sans-serif font
- `--font-geist-mono`: Monospace font

## Key Dependencies

- **next**: 16.1.1
- **react**: 19.2.3
- **tailwindcss**: v4 (uses new PostCSS plugin)
- **lucide-react**: Icon library
- **class-variance-authority**: For component variants
- **tw-animate-css**: Animation utilities

## Important Notes

- This uses Tailwind CSS v4, which has a different configuration approach (no `tailwind.config.js`)
- All theme customization is done via CSS variables in `globals.css`
- ESLint uses the new flat config format (`eslint.config.mjs`)
- The project uses React 19 and React Server Components by default
