import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/model/notification_model.dart';
import 'package:impeccablehome_helper/screens/notification_detail_screen.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  const NotificationWidget({Key? key, required this.notification, required this.onTap})
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: notification.isRead==true
            ? BoxDecoration(
                border: Border.all(
                  color: lightGrayColor, // Silver gray border color
                  width: 1, // Border width
                ),
              )
            : BoxDecoration(
                color: lightBlueColor,
              ),
        child: Row(
          children: [
            // Left side: Rounded image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                notification.image,
                width: 80.0,
                height: 80.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 28.0), // Space between image and text

            // Right side: Column with title and content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Title
                  Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  // Time text (content)
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    _getTimeText(notification.createdAt),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                   SizedBox(
                    height: 25,
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
