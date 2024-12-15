import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/components/custom_back_button.dart';
import 'package:impeccablehome_helper/model/notification_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({Key? key, required this.notification})
      : super(key: key);
  String _getTimeText(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 60) {
      // Show "x mins ago"
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      // Show "x hours ago"
      return '${difference.inHours} hours ago';
    } else {
      // Show date in dd-mm-yyyy format
      return '${createdAt.day.toString().padLeft(2, '0')}-${(createdAt.month).toString().padLeft(2, '0')}-${createdAt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: screenWidth * (1 / 6),
                  left: screenWidth * (1 / 13),
                ),
                child: Row(
                  children: [
                    CustomBackButton(color: Colors.blue),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (19 / 80),
                    ),
                    Text(
                      "Notification",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Image.network(
                notification.image,
                width: screenWidth * (2 / 5),
                height: screenWidth * (2 / 5),
                fit: BoxFit.cover,
              ),
              SizedBox(height: 28.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 13),
                child: Column(
                  children: [
                    Text(
                      notification.title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _getTimeText(notification.createdAt),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Text(
                      notification.content,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
