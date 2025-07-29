import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time4play/models/booking.dart';

class FirestoreBookingService {
  static final _bookingCollection =
      FirebaseFirestore.instance.collection('booking');

  /// Fetch bookings for a specific sport
  static Future<List<Booking>> getBookingsForSport(String sportId) async {
    final snapshot =
        await _bookingCollection.where('sportId', isEqualTo: sportId).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Booking(
        id: doc.id,
        customerId: data['customerId'] ?? '',
        sportId: data['sportId'] ?? '',
        courtId: data['courtId'] ?? '',
        startTime: (data['startTime'] as Timestamp).toDate(),
        duration: data['duration'] ?? 0,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  static Future<List<Booking>> getAllBookingsForUser(User user) async {
    final bookingSnapshot =
        await _bookingCollection.where('customerId', isEqualTo: user.uid).get();

    return bookingSnapshot.docs.map((doc) {
      final data = doc.data();
      return Booking(
        id: doc.id,
        customerId: data['customerId'] ?? '',
        sportId: data['sportId'] ?? '',
        courtId: data['courtId'] ?? '',
        startTime: (data['startTime'] as Timestamp).toDate(),
        duration: data['duration'] ?? 0,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  /// Create a new booking
  static Future<void> createBooking(Booking booking, String companyId) async {
    await FirebaseFirestore.instance.collection('booking').doc(booking.id).set({
      'id': booking.id,
      'customerId': booking.customerId,
      'sportId': booking.sportId,
      'courtId': booking.courtId,
      'startTime': Timestamp.fromDate(booking.startTime),
      'duration': booking.duration,
      'createdAt': FieldValue.serverTimestamp(),
      'companyId': companyId,
    });
  }

  /// Remove a booking
  static Future<void> removeBooking(String bookingId) async {
    await _bookingCollection.doc(bookingId).delete();
  }
}
