import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time4play/models/booking.dart';
import 'package:time4play/services/customer_service.dart';

final customerIdProvider = Provider<String?>((ref) {
  // Replace this with your actual logic to get the user ID
  return FirebaseAuth.instance.currentUser?.uid;
});


final customerProvider = FutureProvider.autoDispose<Customer>((ref) async {
  final customerId = ref.watch(customerIdProvider);

  if (customerId == null) {
    throw Exception('Customer ID is null');
  }

  return await CustomerService.getCustomerById(customerId);
});
