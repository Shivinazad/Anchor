# Anchor ⚓️

<div align="center">

**A multi-sensory iOS reading environment designed to turn nervous energy into deep cognitive focus.**

*Winner / Submission for the Apple Swift Student Challenge 2026.*

</div>

---

## 🎥 See Anchor in Action

*(Demo Video: Turn on sound for ambient audio)*

<div align="center">

https://github.com/user-attachments/assets/51d0e447-f797-4a18-ab7a-1e96c036d0d2

</div>

---

## The Problem

For students navigating ADHD or digital fatigue, reading dense academic PDFs (like Data Structures or OS documentation) is a constant battle for attention. The static nature of digital text leads to u[...]

## The Solution

Anchor is a "Trojan Horse" of empathy. It hijacks the highly effective psychological layout of short-form video (the 60/40 split-screen) and applies it to academic reading. Instead of fighting the urg[...]

## Core Features

- 📖 **The 60/40 Split Layout:** The top 60% of the screen houses a robust, frictionless PDF reader. The bottom 40% houses a "Kinetic Anchor" to intercept distraction before it leads to an app swi[...]
- ✍️ **Kinetic Anchors (Doodle & Trace):** Tactile tools including a Doodle Canvas and an Infinity Trace path. These require zero fine-motor precision, allowing the thumb to wander mindlessly wh[...]
- 🎧 **Audio Grounding:** Localized, high-quality ambient soundscapes (Soft Rain, Brown noise) that mask external chaos and create a sensory bubble.
- 🏆 **Empathic Session Analytics:** A bottom-aligned dashboard that tracks "Active Time" and "Best Streaks," but proudly highlights "Anchors Used" on a central podium—celebrating the redirectio[...]
- 🧠 **Cognitive Accessibility:** Built with ruthless minimalism. Utilizing native iOS detents, high-contrast system colors, and SF Symbols to minimize cognitive load and visual clutter.

## Technical Architecture

Anchor was built purely with native Apple technologies to ensure frictionless performance and strict HIG compliance:

- **SwiftUI:** For a fluid, reactive, and accessible user interface.
- **PDFKit:** Integrated as the core renderer for seamless, native document pagination.
- **AVFoundation:** Utilized for thread-safe audio routing via `NSDataAsset`, ensuring ambient tracks respect the iOS physical silent switch.
- **Swift 6 Concurrency:** Engineered a custom Snapshot State Machine utilizing strict `@MainActor` isolation. This ensures every kinetic interaction is instantly logged to permanent `@AppStorage` w[...]

## Requirements

- iOS 18.0+
- Xcode 16.0+
- Swift 6.0

## Getting Started

1. Clone the repository: `git clone https://github.com/yourusername/anchor.git`
2. Open `Bubble Read.swiftpm` (or `Anchor.xcodeproj`) in Xcode.
3. Select an iOS Simulator (iPhone 15 Pro or later recommended) or a physical device.
4. Hit `Cmd + R` to build and run.

---

<div align="center">

*Designed and engineered by Shivin Azad.*

</div>
