import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:impeccablehome_helper/components/custom_back_button.dart';
import 'dart:io';

import 'package:impeccablehome_helper/model/user_model.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

import '../resources/user_services.dart';

class ChatroomScreen extends StatefulWidget {
  final String userId;
  final String helperId;
  final String contactId;
  const ChatroomScreen({required this.userId, required this.helperId, required this.contactId, Key? key})
      : super(key: key);

  @override
  _ChatroomScreenState createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  UserModel? customer;
  final UserService userService = UserService();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final fetchedUser = await userService.fetchUserDetails(widget.userId);

      if (fetchedUser != null) {
        setState(() {
          customer = fetchedUser;
        });
      }
    } catch (e) {
      // Handle errors (optional)
      print('Error fetching customer: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading once data is fetched
      });
    }
  }

  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _sendMessage({String? imageUrl}) async {
    final message = _messageController.text.trim();
    if (message.isEmpty && imageUrl == null) return;

    final chatId = '${widget.userId}_${widget.helperId}';

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'userId': widget.userId,
      'helperId': widget.helperId,
      'sender': "helper",
      'message': message,
      'imageUrl': imageUrl ?? '',
      'createdAt': DateTime.now(),
    });
    await updateLastMessage(
        contactId: widget.contactId, newLastMessage: message);
    _messageController.clear();
  }

  Future<void> updateLastMessage({
    required String contactId,
    required String newLastMessage,
  }) async {
    try {
      // Reference to the specific contact document
      DocumentReference contactRef =
          FirebaseFirestore.instance.collection('contacts').doc(contactId);

      // Update the 'lastMessage' field
      await contactRef.update({
        'lastMessage': newLastMessage,
      });

      print('Last message updated successfully!');
    } catch (e) {
      print('Failed to update last message: $e');
      throw e; // Optionally rethrow the error
    }
  }

  Future<void> _pickAndSendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final chatId = '${widget.userId}_${widget.helperId}';
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chats')
        .child(chatId)
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    try {
      await storageRef.putFile(File(image.path));
      final imageUrl = await storageRef.getDownloadURL();
      await _sendMessage(imageUrl: imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatId = '${widget.userId}_${widget.helperId}';
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: screenWidth * (1 / 6),
              left: screenWidth * (1 / 13),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomBackButton(color: Colors.blue),
                SizedBox(
                  width: MediaQuery.of(context).size.width * (1 / 20),
                ),
                Container(
                  width: screenWidth * (11 / 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            50), // Makes the image circular
                        child: Image.network(
                          isLoading
                              ? "https://img.freepik.com/premium-vector/sexual-harassment-icon-vector-image-can-be-used-business-management_120816-263245.jpg?semt=ais_hybrid"
                              : customer!
                                  .profilePic, // Replace with your image URL
                          width: 35, // Adjust the size as needed
                          height: 35,
                          fit: BoxFit.cover, // Ensures the image fits nicely
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * (1 / 32),
                      ),
                      Text(
                        isLoading ? "" : customer!.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * (1 / 25),
                ),
                Icon(Icons.phone, size: 26, color: oceanBlueColor),
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      (1 / 25), // Phone icon
                ),
                Icon(Icons.more_vert,
                    size: 26, color: oceanBlueColor), // 3 vertical dots
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isHelper = message['sender'] == "helper";

                    // Format the time
                    final createdAt =
                        (message['createdAt'] as Timestamp).toDate();
                    final now = DateTime.now();
                    final difference = now.difference(createdAt);

                    String formattedTime;
                    if (difference.inMinutes < 1) {
                      formattedTime = "now";
                    } else if (difference.inMinutes < 60) {
                      formattedTime = "${difference.inMinutes} mins";
                    } else if (difference.inHours < 24) {
                      formattedTime = "${difference.inHours} hours";
                    } else {
                      formattedTime =
                          "${createdAt.day}/${createdAt.month}/${createdAt.year}";
                    }
                    return Align(
                      alignment: isHelper
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isHelper
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [

                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: 8, horizontal: screenWidth/20),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isHelper ? Colors.grey[100] : skyBlueColor,
                              borderRadius: BorderRadius.only(
                                topLeft:isHelper
                                    ? Radius.circular(18): Radius.zero,
                                topRight: isHelper
                                    ? Radius.zero
                                    : Radius.circular(18), // No rounded corner for helper's top-right
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message['imageUrl'] != null &&
                                    message['imageUrl'].isNotEmpty)
                                  Image.network(
                                    message['imageUrl'],
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                if (message['message'] != null &&
                                    message['message'].isNotEmpty)
                                  Text(
                                    message['message'],
                                    style: TextStyle(
                                        color:charcoalGrayColor, fontSize: 16,),
                                        textAlign:isHelper? TextAlign.right: TextAlign.left,
                                  ),
                              ],
                            ),
                          ),
                          // Time display
                          Padding(
                            padding: EdgeInsets.only(
                              left: isHelper ? 0 : 20,
                              right: isHelper ? 20 : 0,
                              top: 4,
                            ),
                            child: Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            height: screenWidth / 5,
            decoration: BoxDecoration(
              color: Colors.white, // You can change this to any color you need
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), // Top-left border radius
                topRight: Radius.circular(30), // Top-right border radius
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(66, 218, 217, 217)
                      .withOpacity(0.4), // Light shadow color
                  offset: Offset(0,
                      -2), // Shadow direction (negative Y-axis to go upwards)
                  blurRadius: 4, // Spread of the shadow
                  spreadRadius: 2, // How far the shadow spreads
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth / 18,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Your message here...',
                      hintStyle: TextStyle(color: silverGrayColor),
                      border: InputBorder.none, // Single underline only
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                silverGrayColor), // Customize underline color
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: oceanBlueColor), // Underline when focused
                      ),
                      suffixIcon: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Prevent row from expanding
                        children: [
                          Container(
                            height: 26,
                            width: 26,
                            child: GestureDetector(
                                onTap: _pickAndSendImage,
                                child: Image.asset(
                                    "assets/icons/blue_camera_icon.png")),
                          ),

                          SizedBox(width: 12), // Space between icons
                          Container(
                            height: 26,
                            width: 26,
                            child: GestureDetector(
                                onTap: () => _sendMessage(),
                                child:
                                    Image.asset("assets/icons/send_icon.png")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth / 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatroomScreen extends StatefulWidget {
//   final String userId;
//   final String helperId;

//   const ChatroomScreen({required this.userId, required this.helperId, Key? key}) : super(key: key);

//   @override
//   _ChatroomScreenState createState() => _ChatroomScreenState();
// }

// class _ChatroomScreenState extends State<ChatroomScreen> {
//   final TextEditingController _messageController = TextEditingController();

//   Future<void> _sendMessage() async {
//     final message = _messageController.text.trim();
//     if (message.isEmpty) return;

//     final chatId = widget.userId + '_' + widget.helperId;

//     await FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
//       'senderId': widget.userId,
//       'receiverId': widget.helperId,
//       'message': message,
//       'createdAt': DateTime.now(),
//     });

//     _messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatId = widget.userId + '_' + widget.helperId;

//     return Scaffold(
//       appBar: AppBar(title: Text('Chat with Helper')),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(chatId)
//                   .collection('messages')
//                   .orderBy('createdAt', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(child: Text('No messages yet.'));
//                 }

//                 final messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     final isMe = message['senderId'] == widget.userId;

//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blue : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           message['message'],
//                           style: TextStyle(color: isMe ? Colors.white : Colors.black),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.blue),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
