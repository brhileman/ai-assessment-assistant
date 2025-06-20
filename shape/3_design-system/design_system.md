# AI Assessment Assistant - Design System

A comprehensive visual guide for the AI Assessment Assistant application, built with LaunchPad Lab's established branding and featuring modern futuristic design patterns optimized for voice-based interactions.

## Brand Identity

**Logo Usage:**
- Primary: `Blue-Horizontal-LPL-Logo.svg` - Use on white/light backgrounds
- Alternative: `White-Horizontal-LPL-Logo.svg` - Use on dark/colored backgrounds  
- Monochrome: `Black-Horizontal-LPL-Logo.svg` - Use for print or single-color applications

**Logo Guidelines:**
- Minimum size: 120px width for digital applications
- Clear space: Equal to the height of the "L" in the logo on all sides
- Never stretch, rotate, or modify the logo proportions

## Color Palette

### Primary Brand Colors
- **Primary Blue**: `#1E60BD` - Main brand color, primary buttons, gradients, focus states
- **Cyan**: `#00ADEF` - Accent color, gradient partner, highlights, AI elements
- **Blue Dark**: `#0B4E95` - Darker gradient stops, hover states, depth

### Modern Dark Theme
- **Dark Background**: `#0F172A` (Slate 900) - Primary background for dark interfaces
- **Dark Card**: `#1E293B` (Slate 800) - Card backgrounds, elevated surfaces
- **Dark Border**: `#334155` (Slate 600) - Borders, dividers on dark backgrounds
- **Dark Text**: `#E2E8F0` (Slate 200) - Primary text on dark backgrounds
- **Dark Text Muted**: `#94A3B8` (Slate 400) - Secondary text, metadata
- **Dark Transcript**: `#1E293B` (Slate 800) - Conversation background areas

### Light Theme (Legacy/Admin)
- **Pure White**: `#FFFFFF` - Page backgrounds, light cards, button text
- **Dark Charcoal**: `#2C2C35` - Primary text, headings, navigation
- **Light Blue**: `#BFD7F0` - Backgrounds, disabled states, subtle highlights
- **Medium Gray**: `#393942` - Secondary text, icons
- **Light Gray**: `#D9D9D9` - Input borders, card borders
- **Off White**: `#EEEEEE` - Section backgrounds, alternating rows

### Semantic Colors
- **Success**: `#22C55E` - Successful assessments, confirmations
- **Warning**: `#F59E0B` - Warnings, incomplete assessments
- **Error**: `#EF4444` - Errors, failed validations
- **Info**: `#1E60BD` - Information messages (uses primary blue)

### Modern Gradients
- **Primary Brand Gradient**: `linear-gradient(135deg, #1E60BD 0%, #00ADEF 100%)`
- **Background Gradient**: `linear-gradient(135deg, #0F172A 0%, #1E293B 25%, #1E3A8A 75%, #1E60BD 100%)`
- **Wave Gradient**: `linear-gradient(180deg, #00ADEF 0%, #1E60BD 50%, #0B4E95 100%)`
- **Logo Gradient**: `linear-gradient(90deg, #1E60BD 0%, #00ADEF 100%)`

### Usage Guidelines
- **Voice Interfaces**: Use dark theme with glassmorphism effects
- **Admin Dashboards**: Use light theme for data-heavy interfaces
- **Gradients**: Apply to backgrounds, buttons, and brand elements
- **Contrast**: Ensure 4.5:1 minimum contrast for all text combinations

## Typography

**Font Family:** Proxima Nova (Primary) with Inter fallback and system fonts: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif

### Text Hierarchy
- **H1**: 32px (2rem), Bold (700) - Page titles, main headings (admin)
- **H2**: 24px (1.5rem), Bold (700) - Card titles, assessment headers
- **H3**: 20px (1.25rem), Semibold (600) - Section headings, component titles
- **H4**: 18px (1.125rem), Semibold (600) - Form labels, secondary headers
- **Body Large**: 18px (1.125rem), Regular (400) - Important content, conversation text
- **Body**: 16px (1rem), Regular (400) - Standard text, form inputs, buttons
- **Body Small**: 14px (0.875rem), Regular (400) - Secondary text, company context
- **Caption**: 12px (0.75rem), Regular (400) - Timestamps, metadata, helper text

### Voice Interface Typography
- **Page Title**: 24px (1.5rem), Bold (700), White - "AI Assessment"
- **Company Context**: 14px (0.875rem), Regular (400), Slate-300 - Company names
- **AI Messages**: 14px (0.875rem), Regular (400), Slate-200 - AI conversation text
- **AI Labels**: 12px (0.75rem), Medium (500), Cyan - "Assistant" labels
- **User Messages**: 14px (0.875rem), Regular (400), Slate-200 - User conversation text
- **User Labels**: 12px (0.75rem), Medium (500), Slate-300 - "You" labels
- **Timestamps**: 12px (0.75rem), Regular (400), Slate-500 - Message timing
- **Duration**: 14px (0.875rem), Regular/Medium (400/500) - Status information
- **Helper Text**: 12px (0.75rem), Regular (400), Slate-400 - Instructions

### Font Loading Strategy
```css
/* Preferred: Adobe Fonts or Google Fonts */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

/* Font stack with fallbacks */
.font-proxima {
  font-family: 'proxima-nova', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}
```

## Spacing Scale

- **xs**: 4px (0.25rem) - Icon spacing, tight elements
- **sm**: 8px (0.5rem) - Form element spacing
- **md**: 16px (1rem) - Standard component spacing
- **lg**: 24px (1.5rem) - Card padding, section spacing
- **xl**: 32px (2rem) - Page margins, large component spacing
- **2xl**: 48px (3rem) - Section separations
- **3xl**: 64px (4rem) - Major layout sections

## Component Library

### Modern Buttons

**Primary Gradient Button:**
- Background: Primary Brand Gradient (`linear-gradient(135deg, #1E60BD 0%, #00ADEF 100%)`)
- Text: White, 16px, Medium (500)
- Padding: 12px 24px
- Border radius: 8px
- Hover: Darker gradient with lift effect
- Shadow: `0 2px 4px rgba(30, 96, 189, 0.2)`

**Secondary Button (Light Theme):**
- Background: White
- Text: Primary Blue, 16px, Medium (500)
- Border: 2px solid Primary Blue
- Padding: 10px 22px
- Border radius: 8px
- Hover: Light Blue background (`#BFD7F0`)

**Voice Control Interface:**
- **Central Microphone**: 64px gradient button with white border glow, lift hover effect
- **Settings Button**: 48px transparent with slate background, subtle hover lift
- **End Assessment**: 48px red accent with X icon, warning hover state
- **Hover Effects**: `transform: translateY(-2px)` with brand-colored shadows

### Modern Card System

**Glassmorphism Main Card:**
- Background: `rgba(30, 41, 59, 0.85)` with `backdrop-filter: blur(20px)`
- Border: `1px solid rgba(255, 255, 255, 0.1)`
- Border radius: 24px (rounded-3xl)
- Padding: 32px
- Shadow: Large shadow-2xl for floating effect
- Max-width: 28rem (448px) for mobile-optimized experience

**Standard Card (Admin):**
- Background: White
- Border: 1px solid Light Gray (`#D9D9D9`)
- Border radius: 12px
- Padding: 24px
- Shadow: `0 2px 8px rgba(0, 0, 0, 0.1)`

**Transcript Display Card:**
- Background: `bg-slate-800/30` (30% opacity)
- Border: 1px solid Dark Border (`#334155`)
- Border radius: 16px
- Padding: 16px
- Max height: 16rem (256px) with custom scrollbars

### Form Elements

**Input Fields:**
- Background: White
- Border: 2px solid Light Gray (`#D9D9D9`)
- Border radius: 8px
- Padding: 12px 16px
- Text: 16px, Dark Charcoal
- Focus: Primary Blue border, blue shadow
- Placeholder: Gray (`#525253`)

**Text Areas:**
- Same as input fields
- Minimum height: 120px
- Resize: Vertical only

### Voice Interface Components

**Futuristic Wave Visualizer:**
- **10 Animated Bars**: Enhanced gradient with glow effects
- **Background**: `bg-slate-800/30` in rounded-2xl container
- **Gradient**: Cyan → Blue → Dark Blue vertical gradient
- **Glow Effects**: Pulsing box-shadow with dual-color glow
- **Shimmer**: White light sweep across bars every 2 seconds  
- **Dynamic Heights**: JavaScript randomization every 1.5 seconds
- **Animation**: 1.8s wave cycle with staggered delays

**Transcript Message Bubbles:**
- **AI Messages**: Gradient avatars (Blue to Cyan) with cyan text labels
- **User Messages**: Simple slate avatars with muted text labels
- **Spacing**: 16px between messages, 12px internal padding
- **Timestamps**: 12px text in Slate-500
- **Typing Indicator**: Three bouncing dots in brand blue

**Avatar System:**
- **AI Avatar**: 32px circle with brand gradient background
- **AI Text**: "AI" in white, 12px font-weight 600
- **User Avatar**: 32px circle with slate-600 background  
- **User Text**: "You" in slate-300, 12px font-weight 600

**Status Indicators:**
- **Recording**: Pulsing red dot with scale animation
- **Connected**: Green dot with "Connected" text
- **Processing**: Animated blue dots in sequence

### Navigation

**Admin Navigation:**
- Background: White
- Border bottom: 1px solid Light Gray
- Logo: Blue horizontal logo (left aligned)
- Links: 16px, Dark Charcoal
- Active: Primary Blue with underline
- Mobile: Hamburger → slide-out drawer

**Breadcrumbs:**
- Text: 14px, Gray
- Separator: `/` in Gray
- Current page: Dark Charcoal, no link

## Layout Patterns

### Modern Voice Interface (Primary)
- **Mobile-First Card Design**: Centered glassmorphism card optimized for all devices
- **Fixed Header**: LaunchPad Lab logo positioned at top of viewport
- **Gradient Background**: Full-viewport gradient from dark slate to brand blue
- **Card Dimensions**: Max-width 28rem (448px) for optimal mobile experience
- **Vertical Flow**: Header → Card (Company info → Visualizer → Transcript → Controls)

### Admin Dashboard (Secondary)
- **Sidebar**: 280px width, white background
- **Main Content**: Flexible width, Off White background
- **Cards Grid**: 24px gaps, responsive columns
- **Light Theme**: Traditional business application styling

### Responsive Strategy
- **Breakpoints**: 640px (sm), 768px (md), 1024px (lg), 1280px (xl)
- **Voice Interface**: Card design scales perfectly across all screen sizes
- **Touch Targets**: All buttons meet 44px minimum for mobile interaction
- **Typography**: Scales appropriately while maintaining readability

## Modern Design Elements

### Glassmorphism Effects
- **Card Backgrounds**: Semi-transparent with backdrop blur
- **Implementation**: `background: rgba(30, 41, 59, 0.85); backdrop-filter: blur(20px);`
- **Borders**: Subtle white borders with low opacity
- **Usage**: Primary cards, modals, floating elements

### Animation System
- **Wave Bars**: CSS transform and height animations with hardware acceleration
- **Glow Effects**: Box-shadow animations with ease-in-out timing
- **Shimmer**: CSS pseudo-elements with translate transforms
- **Button Interactions**: Subtle lift effects with cubic-bezier timing
- **Performance**: All animations use transform and opacity for 60fps performance

### Gradient Applications
- **Backgrounds**: Full-viewport gradients for immersive experience
- **Buttons**: Brand gradients for primary actions
- **Avatars**: AI elements use brand gradient for distinction
- **Wave Bars**: Vertical gradients create depth and dimensionality

## Accessibility

### Color Contrast
- All text combinations meet WCAG AA standards (4.5:1 minimum)
- Primary Blue on White: 5.8:1 ✓
- Dark Charcoal on White: 12.6:1 ✓
- White on Primary Blue: 5.8:1 ✓

### Focus States
- All interactive elements have visible focus indicators
- Focus ring: 2px Primary Blue with 2px offset
- Keyboard navigation support throughout

### Voice Interface Accessibility
- Clear visual indicators for recording state
- Text alternatives for audio-only information
- Support for screen reader announcements

## Technical Implementation

**CSS Framework:** Tailwind CSS 3.x with custom configuration
**Component Approach:** Custom components with Tailwind utility classes
**Icons:** Heroicons SVG icons (outline style preferred)
**Animations:** Pure CSS animations with hardware acceleration
**Font Loading:** Google Fonts with Inter as primary fallback

### Tailwind Configuration
```javascript
// tailwind.config.js - Custom configuration for modern design
tailwind.config = {
  theme: {
    extend: {
      colors: {
        'lpl-blue': '#1E60BD',
        'lpl-blue-dark': '#0B4E95',
        'lpl-blue-light': '#3B82F6',
        'lpl-cyan': '#00ADEF'
      },
      fontFamily: {
        'proxima': ['Inter', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif']
      },
      backdropBlur: {
        xs: '2px',
      },
      boxShadow: {
        'glow': '0 0 20px rgba(0, 173, 239, 0.8)',
        'glow-blue': '0 0 30px rgba(30, 96, 189, 0.6)',
      }
    }
  }
}
```

### Critical CSS Animations
```css
/* Glassmorphism card effect */
.glass-card {
  background: rgba(30, 41, 59, 0.85);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

/* Modern gradient background */
.gradient-bg {
  background: linear-gradient(135deg, #0F172A 0%, #1E293B 25%, #1E3A8A 75%, #1E60BD 100%);
  min-height: 100vh;
}

/* Wave animation with glow */
@keyframes wave-animation {
  0%, 100% { height: 6px; }
  25% { height: 24px; }
  50% { height: 40px; }
  75% { height: 18px; }
}

@keyframes wave-glow {
  0%, 100% { box-shadow: 0 0 10px rgba(30, 96, 189, 0.5); }
  50% { box-shadow: 0 0 20px rgba(0, 173, 239, 0.8), 0 0 30px rgba(30, 96, 189, 0.6); }
}

.wave-bar {
  animation: wave-animation 1.8s infinite ease-in-out, wave-glow 2s infinite ease-in-out;
  background: linear-gradient(180deg, #00ADEF 0%, #1E60BD 50%, #0B4E95 100%);
}
```

### Performance Considerations
- **Hardware Acceleration**: All animations use transform and opacity
- **Reduced Motion**: Respect user preferences with media queries
- **Font Loading**: Preconnect to Google Fonts for faster loading
- **Critical CSS**: Inline critical styles for first paint

## Voice Interface Specific Guidelines

### Visual Feedback
- Always provide visual confirmation of audio state
- Use animation to indicate active listening
- Clear visual separation between AI and user text

### Error States
- Microphone access denied: Clear instructions with retry button
- Poor audio quality: Gentle notification with improvement tips
- Connection issues: Obvious status with reconnection options

### Loading States
- Skeleton screens for content loading
- Smooth transitions between states
- Progress indicators for longer operations

## Brand Voice & Tone

**Professional yet Approachable:** Maintain LaunchPad Lab's expert positioning while being welcoming

**Clear and Direct:** Especially important for voice interface instructions

**Supportive:** Guide users through the assessment process without intimidation

This modern design system ensures consistent, accessible, and futuristic experiences across all touchpoints of the AI Assessment Assistant, balancing LaunchPad Lab's professional brand with cutting-edge voice interface design patterns. 