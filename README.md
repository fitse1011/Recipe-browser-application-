# Recipe Browser App — TheMealDB

> Unit 4 Assignment · Mobile Application Development · Addis Ababa University

## Student Information
- **Name:** FITSUM NGUSSE
- **ID:** ATE/4123/15
- **Track:** Track C — Food & Recipe Browser

---

## Detailed Description
The **Recipe Browser App** is a sophisticated, cross-platform Flutter application designed to provide a seamless cooking and culinary exploration experience. Built using the **Material 3** design system, the app connects to the public **TheMealDB API** to offer users access to a global database of recipes.

### Key Features
- **Dynamic Category Discovery**: Users can explore a rich grid of meal categories, complete with high-resolution imagery and descriptive summaries.
- **Intuitive Navigation**: A multi-layered navigation system that drills down from broad categories to specific meal lists and finally to comprehensive recipe details.
- **Detailed Recipe Cards**: Each meal detail screen presents a beautifully formatted ingredient list with precise measurements, structured instructions, and one-tap access to video tutorials on YouTube.
- **Resilient Networking**: Implements a robust API service layer with mandatory 10-second timeouts and comprehensive error handling for network failures, malformed data, and server-side exceptions.
- **Premium UI/UX**: Features a "Warm Orange" food-brand theme with smooth transitions, collapsible app bars, and platform-specific optimizations for Web, Windows, and Mobile.

---

## Limitations
- **No Local Persistence**: The app does not currently feature a local database (like SQLite), meaning favorite recipes or search history are not saved between sessions.
- **Internet Dependency**: Being an API-driven app, a stable internet connection is required for all core functionalities.
- **Limited Search**: In this version, exploration is driven by categories rather than a global text-based search.

---

## Setup Instructions

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Android — internet & URL launcher permissions

Open `android/app/src/main/AndroidManifest.xml` and add inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

For `url_launcher`, also add inside `<application>`:
```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
</queries>
```

### 3. iOS — URL launcher

Open `ios/Runner/Info.plist` and add:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
</array>
```

### 4. Run the app
```bash
flutter run
```

---

## Project Structure

```
lib/
├── main.dart                         # App entry point & MaterialApp theme
├── models/
│   ├── meal_category.dart            # MealCategory model (fromJson / toJson / copyWith)
│   └── meal.dart                     # Meal + Ingredient models
├── services/
│   ├── api_exception.dart            # Custom ApiException (non-200 responses)
│   └── meal_api_service.dart         # All HTTP logic — MealApiService
└── screens/
    ├── error_view.dart               # Reusable error widget + errorMessage()
    ├── home_screen.dart              # Grid of categories (FutureBuilder)
    ├── category_screen.dart          # List of meals in a category
    └── meal_detail_screen.dart       # Full recipe + YouTube launcher
```

---

## Requirements Checklist

| Requirement | Status |
|---|---|
| `http` package only (no Dio) | ✅ |
| `Uri.https()` / `Uri.parse()` — no string concat | ✅ |
| `response.statusCode == 200` check | ✅ |
| Custom `ApiException` for non-200 | ✅ |
| 10-second `.timeout()` on all requests | ✅ |
| `Content-Type` & `Accept` headers set | ✅ |
| `factory fromJson` on every model | ✅ |
| `toJson()` on every model | ✅ |
| `copyWith()` on every model | ✅ |
| All model fields `final` | ✅ |
| Explicit type casts (`as String`, etc.) | ✅ |
| Models in `lib/models/`, one per file | ✅ |
| `MealApiService` in `lib/services/` | ✅ |
| `_baseUrl`, `_timeout`, `_headers` fields | ✅ |
| `_checkResponse()` private method | ✅ |
| One method per endpoint | ✅ |
| Typed return types (`Future<List<Meal>>`) | ✅ |
| `async/await` throughout (no `.then()`) | ✅ |
| No `async` in `build()` | ✅ |
| `mounted` check after `await` | ✅ |
| `FutureBuilder<T>` with all 4 states | ✅ |
| `SocketException` → friendly message + Retry | ✅ |
| `TimeoutException` → friendly message + Retry | ✅ |
| `ApiException` → status code + message | ✅ |
| `FormatException` → format message | ✅ |
| Generic `Exception` catch-all | ✅ |
| Home screen: category grid (thumb + description) | ✅ |
| Category screen: meal list (thumb + name) | ✅ |
| Meal detail: ingredients, instructions, YouTube | ✅ |
| `url_launcher` for YouTube link | ✅ |

---

## API Endpoints Used

| Endpoint | Method | Purpose |
|---|---|---|
| `/categories.php` | `fetchAllCategories()` | All meal categories |
| `/filter.php?c={category}` | `fetchMealsByCategory(String)` | Meals in a category |
| `/lookup.php?i={mealId}` | `fetchMealById(String)` | Full meal detail |
