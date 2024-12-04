import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registerUser({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return 'Registration failed';
      }

      // Send email verification
      await user.sendEmailVerification();

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        ...userData,
        'email': email,
        'emailVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Check email verification status
  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  // Wait for email verification
  Future<bool> waitForEmailVerification({
    required String email,
    required String password,
    int timeoutSeconds = 300, // 5 minutes timeout
  }) async {
    final stopTime = DateTime.now().add(Duration(seconds: timeoutSeconds));
    
    while (DateTime.now().isBefore(stopTime)) {
      try {
        // Try to sign in
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Check if email is verified
        await userCredential.user?.reload();
        if (userCredential.user?.emailVerified == true) {
          // Update verification status in Firestore
          await _firestore.collection('users').doc(userCredential.user?.uid).update({
            'emailVerified': true,
            'lastLogin': FieldValue.serverTimestamp(),
          });
          return true;
        }

        // Wait before next attempt
        await Future.delayed(const Duration(seconds: 3));
      } catch (e) {
        // Ignore errors and continue checking
        await Future.delayed(const Duration(seconds: 3));
      }
    }
    return false;
  }

  // Login with email verification check
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return {
          'success': false,
          'message': 'Login failed',
        };
      }

      // Update last login timestamp in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Login successful',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': e.message ?? 'An error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
