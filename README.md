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
   - Copy `.firebase_config.example.js` to `firebase_config.js` and fill in your Firebase credentials


4. **Run the app**
```bash
   flutter run -d chromes
```