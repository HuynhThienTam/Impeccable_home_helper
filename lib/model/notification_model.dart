import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class NotificationModel {
  final String title; // Title of the notification
  final String image; // Optional image URL for the notification
  final DateTime createdAt; // When the notification was created
  final String content; // Main content of the notification
  final String type; // Type of notification (e.g., "Booking", "Reminder")
  final bool isRead; // Indicates whether the notification has been read
   String? id; // Added for notificationId

  NotificationModel({
    required this.title,
    required this.image, // Optional field
    required this.createdAt,
    required this.content,
    required this.type,
    required this.isRead,
  });

  // Convert NotificationModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image , // Handle nullability for optional fields
      'createdAt': createdAt.toIso8601String(),
      'content': content,
      'type': type,
      'isRead': isRead, // Boolean value for read status
    };
  }

  // Create NotificationModel from Firestore Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'],
      image: map['image'] ?? '', // Handle missing image gracefully
      //createdAt: DateTime.parse(map['createdAt']),
      createdAt: map['createdAt'] is Timestamp // Check if it's a Firestore Timestamp
          ? (map['createdAt'] as Timestamp).toDate() // Convert to DateTime
          : DateTime.parse(map['createdAt']),
      content: map['content'],
      type: map['type'],
      isRead: map['isRead'] ?? false, // Default to false if not present
    );
  }
}

// // Enum to define notification types
// enum NotificationType {
//   inform,
//   warning,
//   serviceUpdate,
// }

// // Enum to define notification status
// enum NotificationStatus {
//   opened,
//   notYetOpened,
// }