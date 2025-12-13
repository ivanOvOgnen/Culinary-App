# Culinary App

A Flutter recipe application with Firebase integration for favorites, authentication, and notifications.

### Prerequisites
- Flutter SDK
- Firebase account
- Git

### Setup

1. **Clone the repository**
```bash
   git clone https://github.com/ivanOvOgnen/Culinary-App.git
   cd Culinary-App
```

2. **Install dependencies**
```bash
   flutter pub get
```

3. **Configure Firebase**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com/)
   - Enable Authentication, Firestore, and Cloud Messaging
   - Copy `.env.example` to `.env` and fill in your Firebase credentials
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

4. **Generate web config**
```bash
   dart run tool/generate_service_worker.dart
```

5. **Run the app**
```bash
   flutter run -d chrome
```