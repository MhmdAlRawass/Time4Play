import 'package:firebase_auth/firebase_auth.dart';

class LogoutService {
  final auth = FirebaseAuth.instance;
  void logout() {
    auth.signOut().then((_) {
      print("User logged out");
    }).catchError((error) {
      print("Error logging out: $error");
    });

  }
}
