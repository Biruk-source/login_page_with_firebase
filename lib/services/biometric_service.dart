import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class BiometricService extends ChangeNotifier {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferences _prefs;
  static const String _prefKey = 'biometric_enabled';
  static const String _emailKey = 'saved_email';
  static const String FINGERPRINT_KEY = 'fingerprint_enabled';
  bool _isAvailable = false;
  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  BiometricService(this._prefs);

  Future<bool> canUseBiometrics() async {
    try {
      _isAvailable = await _localAuth.canCheckBiometrics &&
          await _localAuth.isDeviceSupported();
      return _isAvailable;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<bool> canUseBiometric() async {
    try {
      _isAvailable = await _localAuth.canCheckBiometrics &&
          await _localAuth.isDeviceSupported();
      return _isAvailable && _prefs.getBool(_prefKey) == true;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    if (!await canUseBiometric()) return false;

    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to sign in',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        await _prefs.setBool(_prefKey, true);
      }

      return didAuthenticate;
    } on PlatformException catch (_) {
      return false;
    }
  }

  void toggleBiometrics(bool value) {
    _isEnabled = value;
    notifyListeners();
  }

  Future<void> showBiometricSetupDialog(BuildContext context) async {
    if (await canUseBiometrics()) {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Check if user hasn't already set up biometrics
        final docSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!docSnapshot.exists || !docSnapshot.data()?['biometricEnabled']) {
          // Show dialog to set up biometrics
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Enable Fingerprint Login?'),
                content: Text(
                    'Would you like to enable fingerprint login for faster access next time?'),
                actions: [
                  TextButton(
                    child: Text('Not Now'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Enable'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final bool didAuthenticate = await authenticate();

                      if (didAuthenticate) {
                        // Save to Firebase
                        await _firestore
                            .collection('users')
                            .doc(user.uid)
                            .set({
                          'biometricEnabled': true,
                          'updatedAt': FieldValue.serverTimestamp(),
                        }, SetOptions(merge: true));

                        // Save to local storage
                        await _prefs.setBool(_prefKey, true);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Fingerprint login enabled successfully!'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  Future<bool> checkAndAuthenticate() async {
    final enabled = await isEnabledLocally();
    if (!enabled) {
      return false;
    }

    return await authenticate();
  }

  Future<bool> hasSavedFingerprint() async {
    return _prefs.getBool(FINGERPRINT_KEY) ?? false;
  }

  Future<void> saveFingerprint(bool enabled) async {
    await _prefs.setBool(FINGERPRINT_KEY, enabled);
  }

  Future<String?> getSavedEmail() async {
    return _prefs.getString(_emailKey);
  }

  Future<void> clearBiometricSettings() async {
    await _prefs.remove(_prefKey);
    await _prefs.remove(_emailKey);
    await _prefs.remove(FINGERPRINT_KEY);
    
    // Also clear from Firebase
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'biometricEnabled': false,
      });
    }
  }

  Future<bool> authenticateWithFingerprint() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  Future<bool> isEnabledLocally() async {
    try {
      // Check local storage first
      final localEnabled = _prefs.getBool(_prefKey) ?? false;
      
      // If not enabled locally, no need to check Firebase
      if (!localEnabled) {
        return false;
      }

      // Check Firebase
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        
        return doc.data()?['biometricEnabled'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking biometric status: $e');
      return false;
    }
  }

  Future<void> setEnabled(bool enabled) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Save to Firebase
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set({
              'biometricEnabled': enabled,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

        // Save to local storage
        await _prefs.setBool(_prefKey, enabled);
      }
    } catch (e) {
      print('Error setting biometric status: $e');
      throw e;
    }
  }
}
