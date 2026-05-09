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
- Mark tasks as completed/pending
- Real-time Firestore sync (stream-based)
- Task filtering: All / Completed / Pending
- Swipe-to-delete with confirmation
- Pull-to-refresh

### 💬 Motivational Quotes
- Random quotes from Quotable API
- Fallback to ZenQuotes API
- Hardcoded fallback for offline mode
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

## Architecture

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── app_strings.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── theme_provider.dart
│   ├── utils/
│   │   ├── date_helper.dart
│   │   ├── firebase_error_handler.dart
│   │   ├── snackbar_helper.dart
│   │   └── validators.dart
│   └── widgets/
│       ├── custom_text_field.dart
│       ├── empty_state.dart
│       ├── primary_button.dart
│       └── shimmer_loading.dart
│
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   ├── services/
│   │   │   └── auth_service.dart
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       └── signup_screen.dart
│   │
│   ├── tasks/
│   │   ├── models/
│   │   │   └── task_model.dart
│   │   ├── services/
│   │   │   └── task_service.dart
│   │   ├── providers/
│   │   │   └── task_provider.dart
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   │       ├── quote_card.dart
│   │       ├── task_card.dart
│   │       ├── task_filter_bar.dart
│   │       ├── task_form_sheet.dart
│   │       └── task_stats_bar.dart
│   │
│   └── quotes/
│       ├── models/
│       │   └── quote_model.dart
│       ├── services/
│       │   └── quote_service.dart
│       └── providers/
│           └── quote_provider.dart
│
└── main.dart
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
- Update `android/app/build.gradle.kts` with the google-services plugin

### Step 5: Update main.dart
After running `flutterfire configure`, update the Firebase initialization in `main.dart`:

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

### Step 6: Firestore Security Rules (Production)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Running the App

```bash
# Get dependencies
flutter pub get

# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device_id>
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

### Split APKs (smaller size)
```bash
flutter build apk --split-per-abi
```

APK output location: `build/app/outputs/flutter-apk/`

## Firestore Data Structure

```
users/
  └── {userId}/
       └── tasks/
            └── {taskId}/
                 ├── title: String
                 ├── description: String
                 ├── date: Timestamp
                 ├── status: String ("pending" | "completed")
                 └── createdAt: Timestamp
```

## State Management

Uses **Provider** with `ChangeNotifier`:

| Provider | Responsibility |
|---|---|
| `AuthProvider` | Login, signup, logout, session persistence |
| `TaskProvider` | CRUD operations, filtering, real-time sync |
| `QuoteProvider` | Fetch/refresh motivational quotes |
| `ThemeProvider` | Dark/light mode toggling |

## API Integration

- **Primary**: `https://api.quotable.io/random`
- **Fallback**: `https://zenquotes.io/api/random`
- **Safety net**: Hardcoded fallback quote

## Demo Video Script

1. **Splash Screen** → App launches with TaskFlow branding
2. **Signup** → Create new account with name, email, password
3. **Home Dashboard** → Quote card, stats bar, empty state
4. **Add Task** → Tap FAB → Fill form → Save
5. **Task List** → Multiple tasks with dates and status
6. **Complete Task** → Tap checkbox → Status updates
7. **Edit Task** → Tap card → Edit form → Save
8. **Delete Task** → Swipe left → Confirm delete
9. **Filter Tasks** → All / Pending / Completed tabs
10. **Pull to Refresh** → Refresh tasks and quote
11. **Dark Mode** → Toggle theme from app bar
12. **Logout** → Confirm dialog → Redirect to login
13. **Login** → Re-login with existing credentials
14. **Persistent Session** → Close/reopen app → Still logged in

## License

This project is built for educational/internship purposes.
