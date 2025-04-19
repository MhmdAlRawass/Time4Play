import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time4play/models/booking.dart';
import 'package:time4play/services/sport_service.dart';

final companyProvider = StreamProvider<List<Company>>((ref) {
  return FirebaseFirestore.instance
      .collection('company')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((data) {
      return Company.fromFirestore(data.data(), data.id);
    }).toList();
  });
});

final companySportsMapProvider =
    FutureProvider<Map<String, List<Sport>>>((ref) async {
  final allSports = await FirestoreSportService.getAllSports();
  final map = <String, List<Sport>>{};

  for (final sport in allSports) {
    map.putIfAbsent(sport.companyId, () => []).add(sport);
  }

  return map;
});
