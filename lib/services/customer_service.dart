import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time4play/models/booking.dart';

class CustomerService {
  static Future<Customer> getCustomerById(String customerId) async {
    final doc = await FirebaseFirestore.instance
        .collection('customer')
        .doc(customerId)
        .get();

    final data = doc.data();
    return Customer.fromFirestore(data!, doc.id);
  }

  static Future<void> updateCustomer(Customer customer) async {
    final doc =
        FirebaseFirestore.instance.collection('customer').doc(customer.id);

    await doc.update({
      'id': customer.id,
      'firstName': customer.firstName,
      'lastName': customer.lastName,
      'displayName': customer.displayName,
      'email': customer.email,
      'phoneNumber': customer.phoneNumber,
      'country': customer.country,
      'city': customer.city,
      'dateOfBirth': customer.dateOfBirth,
      'gender': customer.gender,
      'postalCode': customer.postalCode,
    });
  }
}
