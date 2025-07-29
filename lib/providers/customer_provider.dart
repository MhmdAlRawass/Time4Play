import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time4play/models/booking.dart';
import 'package:time4play/services/customer_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

final customerIdProvider = Provider<String?>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  return user?.uid;
});


final customerProvider = FutureProvider.autoDispose<Customer>((ref) async {
  final customerId = ref.watch(customerIdProvider);

  if (customerId == null) {
    throw Exception('Customer ID is null');
  }

  return await CustomerService.getCustomerById(customerId);
});
