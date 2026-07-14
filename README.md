# Pocket Machinist

**The only thing you need for the shop.**

A machinist's pocket reference and calculator suite for iOS - speeds & feeds,
shop math, layout tools, and illustrated reference charts, all in one
dark-themed app that works entirely offline.

Built with SwiftUI. **Zero third-party dependencies.**

> 🚧 **App Store release in progress**

<img width="501" height="910" alt="Pocket Machinist home screen" src="https://github.com/user-attachments/assets/df92f095-b8b4-4a03-ba3c-c24c20be84d1" />

## What's inside

**Cutting calculators** - Turning, Drilling, Milling, Tapping, Threading,
Boring, Reaming, and Band Saw: RPM, feed rates, metal removal, spindle power,
tap drill sizes, thread specs, and more, with material/tool/coating presets.

**Calculate & Measure** - Shop Math (right triangles, bolt circles, tapers,
sine bars, dividing heads, change gears…), a unit Converter, Layout tools,
and Scale calculators.

**Reference** - Thread charts and a 14-section reference library: insert
codes & tool choosing, tool grinding diagrams, drill sharpening, reading
micrometers & verniers, files, GD&T / print symbols, Loctite, silver solder,
hardness, heat treat, tapers & collets, and more - with interactive,
hand-drawn vector diagrams.

**Rose Engine** - an illustrated guide to ornamental turning, including an
interactive Pattern Lab for previewing guilloché rosette patterns.

Every screen supports Imperial ⇄ Metric switching from the toolbar.

## Tech

- **SwiftUI, iOS 17+, Swift 6** - no packages, no analytics, no network
- All diagrams are drawn in code with `Canvas` (no bundled images)
- Calculation engine is a Foundation-only core, covered by **460+ unit tests**
  ported and verified against the original web app's math

## Project layout

```
MachinistsBench/
├── App.swift              # entry point
├── Home/                  # home screen + section catalog
├── Sections/              # one folder per tool section
├── Components/            # shared UI (panels, tables, diagram canvas…)
├── Core/
│   ├── Calc/              # pure calculation logic (Foundation-only)
│   └── Data/              # reference tables & presets
└── Theme/                 # Catppuccin colors + typography
Tests/MachinistsCoreTests/ # unit tests for the core
```
Pocket Machinist started as a single-file web PWA called Machinist's Bench
(`app.html`, still in the repo). The iOS app is a full native port - same
math, same data, redrawn natively.
