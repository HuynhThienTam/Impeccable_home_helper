import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/model/helper_model.dart';
import 'package:impeccablehome_helper/model/user_model.dart';
import 'package:impeccablehome_helper/resources/user_services.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class ContactCard extends StatefulWidget {
  final String userId;
  final String lastMessage;
  final int unreadCount;
  final VoidCallback onTap;

  ContactCard({
    required this.userId,
    required this.lastMessage,
    required this.unreadCount,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  UserModel? user;

  String formatLastActive(String? lastLogOutAt) {
    if (lastLogOutAt == null || lastLogOutAt.isEmpty) {
      return "Unavailable"; // Fallback for null or empty value
    }

    try {
      // Parse the String into a DateTime object
      final lastActive = DateTime.parse(lastLogOutAt);

      // Calculate the difference between now and the parsed DateTime
      final duration = DateTime.now().difference(lastActive);

      // Format based on the duration
      if (duration.inMinutes < 60) {
        return '${duration.inMinutes} min';
      } else if (duration.inHours < 24) {
        return '${duration.inHours} hours';
      } else if (duration.inDays < 7) {
        return '${duration.inDays} days';
      } else {
        // Return formatted date as DD-MM-YYYY
        return '${lastActive.day.toString().padLeft(2, '0')}-'
            '${lastActive.month.toString().padLeft(2, '0')}-'
            '${lastActive.year}';
      }
    } catch (e) {
      print("Invalid date format: $lastLogOutAt");
      return ""; // Fallback for invalid format
    }
  }

  final currentuser = FirebaseAuth.instance.currentUser;
  final UserService userService = UserService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final fetchedUser =
          await userService.fetchUserDetails(widget.userId);

      if (fetchedUser != null) {
        setState(() {
          user = fetchedUser;
        });
      }
    } catch (e) {
      // Handle errors (optional)
      print('Error fetching helper: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading once data is fetched
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: screenWidth * 2 / 9,
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          children: [
            isLoading
                ? CircularProgressIndicator()
                : Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip
                                .none, // To allow the dot to appear outside the bounds
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  user!
                                      .profilePic, // Replace with HelperModel().profilePic
                                ),
                                radius: screenWidth / 11,
                              ),
                              Positioned(
                                top:
                                    2, // Adjust this to fine-tune the position of the dot
                                left: 2, // Adjust this as well
                                child: Container(
                                  width: 14, // Diameter of the dot
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: user!.status == 'onl'
                                        ? oceanBlueColor
                                        : silverGrayColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors
                                          .white, // Optional border for better visibility
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(user!.name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(widget.lastMessage,
                                style: TextStyle(color: silverGrayColor)),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              user!.lastLogOutAt == ""
                                  ? "Online"
                                  : formatLastActive(user!.lastLogOutAt),
                              style: TextStyle(
                                  fontSize: 12, color: charcoalGrayColor)),
                          SizedBox(height: 4),
                          if (widget.unreadCount > 0)
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Text(
                                widget.unreadCount.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
            Expanded(child: Container()),
            Divider(
              color: silverGrayColor, // Line color
              thickness: 1, // Line thickness
              height: 1, // Space the divider takes vertically
            )
          ],
        ),
      ),
    );
  }
}
