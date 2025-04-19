// lib/services/firestore_company_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time4play/models/booking.dart';

class FirestoreCompanyService {
  // Fetch company details by ID
  static Future<Company> getCompanyById(String companyId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('company')
        .doc(companyId)
        .get();

    final data = docSnapshot.data();
    return Company(
      id: docSnapshot.id,
      name: data?['name'],
      adminId: data?['adminId'],
      address: data?['address'],
      city: data?['city'],
      latitude: data?['latitude'],
      longitude: data?['longitude'],
    );
  }

  static Future<List<Company>> getCompanies() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(
          'company',
        )
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Company.fromFirestore(data, doc.id);
    }).toList();
  }

  static Future<List<Company>> getCompaniesBySportId(String sportId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('company')
        .where('sportId', isEqualTo: sportId)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Company.fromFirestore(data, doc.id);
    }).toList();
  }
}
