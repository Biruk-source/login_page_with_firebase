import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can create the configuration using the Firebase Console',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can create the configuration using the Firebase Console',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can create the configuration using the Firebase Console',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can create the configuration using the Firebase Console',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR-API-KEY',  // Replace with your API key
    appId: 'YOUR-APP-ID',    // Replace with your App ID
    messagingSenderId: 'YOUR-SENDER-ID', // Replace with your Sender ID
    projectId: 'YOUR-PROJECT-ID', // Replace with your Project ID
    storageBucket: 'YOUR-STORAGE-BUCKET', // Replace with your Storage Bucket
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR-API-KEY',  // Replace with your API key
    appId: 'YOUR-APP-ID',    // Replace with your App ID
    messagingSenderId: 'YOUR-SENDER-ID', // Replace with your Sender ID
    projectId: 'YOUR-PROJECT-ID', // Replace with your Project ID
    storageBucket: 'YOUR-STORAGE-BUCKET', // Replace with your Storage Bucket
    iosClientId: 'YOUR-IOS-CLIENT-ID', // Replace with your iOS Client ID
    iosBundleId: 'YOUR-IOS-BUNDLE-ID', // Replace with your iOS Bundle ID
  );
}
