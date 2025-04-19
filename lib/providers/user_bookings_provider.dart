import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time4play/models/booking.dart';

final userBookingsProvider = StreamProvider<List<Booking>>((ref) {
  return FirebaseFirestore.instance
      .collection('booking')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((data) {
      return Booking.fromFirestore(data.data());
    }).toList();
  });
});

/// Streams only the bookings for a given sportId.
final bookingsFilteredWithSportProvider = StreamProvider.family<List<Booking>, String>(
  (ref, String sportId) {
    return FirebaseFirestore.instance
      .collection('booking')
      .where('sportId', isEqualTo: sportId)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => Booking.fromFirestore(doc.data()))
        .toList(),
      );
  },
);