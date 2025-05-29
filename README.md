# EatFit

EatFit is a native iOS app that helps users analyze food by taking a photo and instantly getting fitness-related nutritional information. The app is built with Swift, SwiftUI, and follows best practices including MVVM, SOLID principles, and modular feature organization.

---

## Features

- **Splash Screen:** Animated logo and app name on launch.
- **Home Screen:**  
  - Prominent "Click Food" button to capture or select a food photo.
  - Green-themed, modern UI with custom navigation bar and logo.
- **Camera & Photo Library:**  
  - Choose between camera or photo library for food images.
  - Crop images before analysis.
- **Food Analysis:**  
  - Analyze food photos using free Gemini api.
  - Extracts: Ingredients, Calories, Carbohydrates, Protein, Fat, and Dish Name.
- **History:**  
  - View a scrollable, swipe-to-delete list of all analyzed foods.
  - Each card shows the photo, dish name, and nutritional data.
  - History is in-memory (not persisted after app restart).
- **Modern Architecture:**  
  - MVVM, SOLID, modular folder structure.
  - Debug logs and code documentation throughout.

---

## Project Structure

```
EatFit/
├── Features/
│   ├── Splash/
│   │   ├── Views/
│   │   └── ViewModels/
│   ├── Home/
│   │   ├── Views/
│   │   └── ViewModels/
│   └── History/
│       ├── Views/
│       └── ViewModels/
├── Networking/
│   ├── FoodAnalyzerService.swift
│   └── FoodAnalysisResult.swift
├── Assets.xcassets/
│   └── AppIcon.appiconset/
└── ...
```

---

## Setup & Running

1. **Clone the repository.**
2. **Open `EatFit.xcodeproj` in Xcode.**
3. **Install dependencies:**  
   - No external dependencies required for in-memory version.
   - If you want to use Realm or other libraries, add via Swift Package Manager.
4. **Add your OpenAI API key:**  
   - In `Networking/FoodAnalyzerService.swift`, replace the placeholder with your API key and endpoint.
5. **Build and run on iOS Simulator or device.**

---

## Customization

- **App Icon:**  
  - Uses a green leaf theme matching the splash and navigation bar.
  - To change, replace images in `Assets.xcassets/AppIcon.appiconset`.
- **Theme:**  
  - All main actions use a green color scheme for consistency.
- **History:**  
  - In-memory only. For persistence, integrate Realm or Core Data.

---

## Code Quality

- MVVM architecture, SOLID principles.
- Modular folder structure by feature.
- Debug logs for important operations.
- Public interfaces and methods are documented.
- SwiftUI best practices: Previews, view extraction, view modifier order.

---
