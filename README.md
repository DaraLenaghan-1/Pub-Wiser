# Pub-Wiser

## Overview
Pub-Wiser is a pint price comparison application designed to streamline the discovery and exploration of pubs tailored to user preferences. Its main target audience includes tourists and students, but it's also useful for locals to keep track of price changes across various pubs and bars. Built with the Flutter framework and Dart programming language, Pub-Wiser leverages Google Cloud Firestore for real-time data storage, Google Places API for detailed pub information.

## Features
- **Pub Discovery**: Users can search and filter pubs based on location, ambiance, and available services.
- **Detailed Information**: Access detailed information about each pub, including user reviews, ratings, and photos.
- **Real-Time Data**: Utilizes Google Cloud Firestore for dynamic data updates and synchronisation.
- **Interactive Maps**: Features integration with Google Maps for navigation and location-based services.
- **User Profiles**: Allows users to create their profiles and save favorite pubs.

## Prerequisites
- Flutter (Version 2.x or newer)
- Android Studio or Visual Studio Code with the Flutter plugin installed
- A Firebase account for accessing Firestore, Auth, and other services
- Google Cloud project with Maps and Places API enabled

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/DaraLenaghan-1/Pub-Wiser.git
cd Pub-Wiser
```

### 2. Install dependencies
Ensure you are in the project root and run:
```bash
flutter pub get
```

### 3. API Keys Configuration
Replace the API keys in the respective configuration files:
- Firebase configuration in `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`
- Google API key in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`

### 4. Build the project
To compile the project, select your target platform and build:
```bash
flutter build apk # For Android
flutter build ios # For iOS, requires a macOS device
```

### 5. Run the application
To run the application on a connected device or an emulator, execute:
```bash
flutter run
```

## Deployment
Follow the standard Flutter deployment guidelines to publish the app on Google Play Store or Apple App Store:
- [Deploy to Android](https://flutter.dev/docs/deployment/android)
- [Deploy to iOS](https://flutter.dev/docs/deployment/ios)

## Additional Resources
For more information on Flutter development, visit the [official Flutter documentation](https://flutter.dev/docs).

## Demo video
https://atlantictu-my.sharepoint.com/:v:/g/personal/g00385153_atu_ie/Ees7iZZLHmtIrfOMtqpz1awBS3YnH-cJ5wk9jL8sW0GQow?e=vgln3W

<iframe src="https://atlantictu-my.sharepoint.com/personal/g00385153_atu_ie/_layouts/15/embed.aspx?UniqueId=32e6f9ab-aa47-4e2f-b42e-87386ea2d5ca&embed=%7B%22hvm%22%3Atrue%2C%22ust%22%3Atrue%7D&referrer=StreamWebApp&referrerScenario=EmbedDialog.Create" width="640" height="360" frameborder="0" scrolling="no" allowfullscreen title="24-08-31-14-41-34.mp4"></iframe>