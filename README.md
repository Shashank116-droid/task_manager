# TaskFlow - Flutter Task Manager App

A production-ready Flutter Task Manager application with Firebase Authentication, Cloud Firestore, REST API integration, and Material 3 design.

## Features

### 🔐 Authentication
- Email/password signup and login
- Persistent login session
- Form validation with real-time feedback
- Firebase error handling with user-friendly messages

### ✅ Task Management (CRUD)
- Add, edit, delete tasks
- Mark tasks as completed (permanent action)
- Real-time Firestore sync (stream-based)
- Task filtering: All / Completed / Pending
- Swipe-to-delete with confirmation
- Pull-to-refresh

### 💬 Motivational Quotes
- Random quotes from Quotable API
- Cache-busting logic for fresh quotes on reload
- Fallback to ZenQuotes API
- Randomized hardcoded fallback for offline mode
- Tap-to-refresh functionality

### 🎨 UI/UX
- Material 3 design system
- Dark mode support
- Shimmer loading animations
- Smooth entry animations (flutter_animate)
- Empty states with illustrations
- Gradient buttons and cards
- Responsive layouts
- Snackbar notifications

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform framework |
| Dart | Programming language |
| Firebase Auth | Authentication |
| Cloud Firestore | Database |
| Provider | State management |
| HTTP | REST API calls |
| Google Fonts | Typography (Outfit) |
| flutter_animate | Micro-animations |
| Shimmer | Loading placeholders |

## Architecture (Simplified Flat Structure)

The project follows a simplified, flat directory structure as per internship requirements:

```
lib/
├── constants/      # App strings and constants
├── models/         # Data models (Task, User, Quote)
├── providers/      # State management (ChangeNotifiers)
├── screens/        # UI Screens (Login, Signup, Home)
├── services/       # Backend & API logic
├── theme/          # Styling and Colors
├── utils/          # Helper classes and logic
├── widgets/        # Reusable UI components
└── main.dart       # App entry point
```

## Firebase Setup (Step-by-Step)

### Prerequisites
- Flutter SDK installed (stable channel)
- Firebase CLI installed (`npm install -g firebase-tools`)
- FlutterFire CLI installed (`dart pub global activate flutterfire_cli`)
- A Firebase project created at [console.firebase.google.com](https://console.firebase.google.com)

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"**
3. Name it (e.g., `taskflow-app`)
4. Enable/disable Google Analytics (optional)
5. Click **"Create project"**

### Step 2: Enable Authentication
1. In Firebase Console → **Authentication** → **Sign-in method**
2. Click **"Email/Password"**
3. Toggle **Enable** → **Save**

### Step 3: Create Firestore Database
1. In Firebase Console → **Firestore Database** → **Create database**
2. Choose **"Start in test mode"** (for development)
3. Select your preferred region → **Enable**

### Step 4: Configure Flutter App with FlutterFire CLI
```bash
# Login to Firebase
firebase login

# Run FlutterFire configuration (from project root)
flutterfire configure --project=YOUR_PROJECT_ID
```

This will:
- Register your app with Firebase
- Generate `lib/firebase_options.dart`
- Update `android/app/build.gradle` with the google-services plugin

### Step 5: Update main.dart
After running `flutterfire configure`, ensure your `main.dart` is correctly initializing Firebase:

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TaskManagerApp());
}
```

## Running the App

```bash
# Get dependencies
flutter pub get

# Run in debug mode
flutter run
```

## Building APK

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

APK output location: `build/app/outputs/flutter-apk/`

## State Management

Uses **Provider** with `ChangeNotifier`:

| Provider | Responsibility |
|---|---|
| `AuthProvider` | Login, signup, logout, session persistence |
| `TaskProvider` | CRUD operations, filtering, real-time sync |
| `QuoteProvider` | Fetch/refresh motivational quotes |
| `ThemeProvider` | Dark/light mode toggling |

## License

This project is built for educational/internship purposes.
