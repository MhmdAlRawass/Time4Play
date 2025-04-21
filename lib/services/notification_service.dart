import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:time4play/models/booking.dart';

class NotificationService {
  static const _oneSignalAppId = '3447e44a-de0a-4dd8-a4bd-19b8bd74ebb0';
  static const _oneSignalRestKey =
      'os_v2_app_grd6isw6bjg5rjf5dg4l25hlwa5i4rueb3he275g7isnnqckh2xpq3hzhbofjlhgevzwhg55kgsdgy3rl3tkkaj6rafo5oatvlxazgq';

  final user = FirebaseAuth.instance.currentUser;

  /// Call this once during app startup
  void setupForegroundNotificationListener() {
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final notification = event.notification;

      final title = notification.title ?? 'No title';
      final body = notification.body ?? 'No body';

      addNotification(title: title, message: body);
    });
  }

  Future<void> addNotification({
    required String title,
    required String message,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('notifications').doc();
    await docRef.set({
      'id': docRef.id,
      'customerId': user?.uid ?? '',
      'title': title,
      'message': message,
      'createdAt': Timestamp.now(),
      'isRead': false,
    });
  }

  Future<bool> sendToSingleUser({
    required String title,
    required String message,
  }) async {
    final externalId = await OneSignal.User.getExternalId();
    if (externalId == null) {
      print('❌ No external ID is set.');
      return false;
    }

    final url = Uri.parse('https://onesignal.com/api/v1/notifications');
    final body = {
      'app_id': _oneSignalAppId,
      'include_external_user_ids': [externalId],
      'headings': {'en': title},
      'contents': {'en': message},
    };

    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic $_oneSignalRestKey',
      },
      body: jsonEncode(body),
    );

    if (resp.statusCode == 200) {
      // addNotification(title: title, message: message);
      print('✅ Notification sent to $externalId');
      return true;
    } else {
      print('❌ Failed to send. Code=${resp.statusCode}, Body=${resp.body}');
      return false;
    }
  }

  static Future<List<Notifications>> getNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('customerId', isEqualTo: user.uid)
        // .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Notifications(
        id: doc.id,
        customerId: data['customerId'] ?? '',
        title: data['title'] ?? '',
        body: data['message'] ?? '',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  static Future<void> deleteNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
}
