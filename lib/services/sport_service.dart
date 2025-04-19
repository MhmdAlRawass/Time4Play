import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time4play/models/booking.dart';

class FirestoreSportService {
  // Fetch sports by company ID
  static Future<List<Sport>> getSportsForCompany(String companyId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('sport')
        .where('companyId', isEqualTo: companyId)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Sport(
        id: doc.id,
        name: data['name'],
        description: data['description'],
        pricePerHour: (data['pricePerHour'] as num).toDouble(),
        companyId: data['companyId'],
      );
    }).toList();
  }

  // get all sports
  static Future<List<Sport>> getAllSports() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(
          'sport',
        )
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Sport.fromFirestore(data, doc.id);
    }).toList();
  }

  static Future<Sport?> getSportById(String sportId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('sport').doc(sportId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      return Sport(
        id: docSnapshot.id,
        name: data?['name'],
        description: data?['description'],
        pricePerHour: (data?['pricePerHour'] as num).toDouble(),
        companyId: data?['companyId'],
      );
    }
    return null;
  }
}
