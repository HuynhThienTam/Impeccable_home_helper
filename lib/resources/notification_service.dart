import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:impeccablehome_helper/model/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<NotificationModel>> getNotificationsStream(String helperUid) {
    return _firestore
        .collection('helpers') // Adjust to your Firestore structure
        .doc(helperUid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots() // Listen for real-time updates
        .map((snapshot) {
          // Map the fetched data into a list of NotificationModel objects
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            NotificationModel notification = NotificationModel.fromMap(data);
            notification.id = doc.id; // Add document ID to the model
            return notification;
          }).toList();
        });
  }
  /// Fetches a list of notifications for a specific user (helper or customer) based on their UID.
  Future<List<NotificationModel>> fetchNotifications(String uid) async {
    try {
      // Reference the notifications collection for the given user
      QuerySnapshot snapshot = await _firestore
          .collection('helpers') // Adjust to your Firestore structure
          .doc(uid)
          .collection('notifications')
          .orderBy('createdAt', descending: true) // Optional: Order by timestamp
          .get();

      List<NotificationModel> notifications = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add notificationId to the model
        NotificationModel notification = NotificationModel.fromMap(data);
        notification.id = doc.id; // Add document ID to the model

        return notification;
      }).toList();

      return notifications;
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      return [];
    }
  }

   Future<void> markNotificationAsRead(String uid, String notificationId) async {
    await FirebaseFirestore.instance
        .collection('helpers')
        .doc(uid)
        .collection('notifications')
        .doc(notificationId) // Use the notification document ID
        .update({'isRead': true});
  }
}
