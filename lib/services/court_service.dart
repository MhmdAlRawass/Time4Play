import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time4play/models/booking.dart';

class FirestoreCourtService {
  // Fetch court by sport ID
  static Future<List<Court>> getCourtForSport(String sportId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('court')
        .where('sportId', isEqualTo: sportId)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Court(
        id: doc.id,
        name: data['name'],
        companyId: data['companyId'],
        sportId: data['sportId'],
        isIndoor: (data['isIndoor'] ?? false) as bool,
      );
    }).toList();
  }

  // get all courts
  static Future<List<Court>> getAllCourts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(
          'court',
        )
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Court.fromFirestore(data, doc.id);
    }).toList();
  }

  static Future<Court?> getCourtById(String courtId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('court').doc(courtId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      return Court(
        id: docSnapshot.id,
        name: data?['name'],
        companyId: data?['companyId'],
        sportId: data?['sportId'],
        isIndoor: (data?['isIndoor'] ?? false) as bool,
      );
    }
    return null;
  }
}
