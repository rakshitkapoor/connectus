# ConnectUs  
A Full Stack Chat Application built with Flutter, Firebase, and Riverpod 2.0!  

## Features  
- Phone Number Authentication  
- 1-1 Chatting with Contacts Only  
- Group Chatting  
- Text, Image, GIF, Audio (Recording), Video & Emoji Sharing    
- Online/Offline Status  
- Seen Message  
- Replying to Messages  
- Auto Scroll on New Messages  

## Installation  
After cloning this repository, migrate to the **ConnectUs** folder. Then, follow these steps:  

1. **Create a Firebase Project:**  
   - Go to [Firebase Console](https://console.firebase.google.com/) and create a new project.  

2. **Run the Commands:**  
   ```
   bash
   npm install -g firebase-tools  
   dart pub global activate flutterfire_cli  
   flutterfire configure
   ```

3. Enable Firebase Features:
    - Enable Phone Authentication in Firebase Authentication.
    - Add Firestore & Storage Rules in the Firebase Console.
  
4. Create Android & iOS Apps:
   - Register your app in the Firebase Console and download the google-services.json (for Android) or GoogleService-Info.plist (for iOS) files.

5. Run Your App:
   ```
   flutter pub get
   open -a simulator  # To get the iOS Simulator
   flutter run 
   ```
# Tech Used:
   - **Server**: Firebase Auth, Firebase Storage, Firebase Firestore
   - **Client**: Flutter, Riverpod
# Additional Notes
- Ensure your Firebase rules for Firestore and Storage are secure to protect your app data.
- This app is compatible with both Android and iOS devices.

# Feedback
- If you have any feedback or suggestions, feel free to reach out to me at Rakshitkapoor1305@gmail.com.
