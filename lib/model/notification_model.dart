import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String image;
  final DateTime createdAt;
  final String content;
  final String type;
  final String? bookingNumber; // Optional field for certain notifications
  final String status; // New field for status

  NotificationModel({
    required this.title,
    required this.image,
    required this.createdAt,
    required this.content,
    required this.type,
    this.bookingNumber,
    required this.status// Default status is notYetOpened
  });

  // Convert NotificationModel to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'content': content,
      'type': type,
      'bookingNumber': bookingNumber,
      'status': status, // Convert status to string
    };
  }

  // Create NotificationModel from Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'],
      image: map['image'],
      createdAt: DateTime.parse(map['createdAt']),
      content: map['content'],
      type: map['type'],
      bookingNumber: map['bookingNumber'],
      status:  map['status'],
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