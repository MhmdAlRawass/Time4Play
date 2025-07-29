import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String?> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      return 'No user signed in';
    }

    // Check if user signed in with Email/Password
    final isEmailPasswordUser = user.providerData.any(
      (info) => info.providerId == 'password',
    );

    final checking = await checkCurrentPassword(currentPassword);

    print(checking);

    if (!isEmailPasswordUser) {
      return 'Password change is only available for Email/Password sign-in users';
    }

    try {
      // Re-authenticate
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);

      // Update password
      await user.updatePassword(newPassword);
      return null; // success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          return 'Current password is incorrect';
        case 'weak-password':
          return 'New password is too weak';
        case 'requires-recent-login':
          return 'Please re-login and try again';
        default:
          return 'Error: ${e.message}';
      }
    } catch (e) {
      return 'Unknown error: $e';
    }
  }

  Future<String?> checkCurrentPassword(String currentPassword) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      return 'No user signed in';
    }

    try {
      // Re-authenticate to check if the current password is correct
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      return null; // Password is correct
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'Current password is incorrect';
      }
      return 'Error: ${e.message}';
    } catch (e) {
      return 'Unknown error: $e';
    }
  }
}
