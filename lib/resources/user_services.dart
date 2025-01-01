import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:impeccablehome_helper/model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch user details by `userUid`
  Future<UserModel?> fetchUserDetails(String userUid) async {
    try {
      final doc = await _firestore.collection('users').doc(userUid).get();

      if (doc.exists) {
        final data = doc.data()!;
        return UserModel(
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          bio: data['bio'] ?? '',
          profilePic: data['profilePic'] ?? '',
          createdAt: data['createdAt'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          uid: data['uid'] ?? '',
          passWord: '', // Password is intentionally omitted
          lastLogOutAt: data['lastLogOutAt'] ?? '',
          status: data['status'] ?? '',
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      return null;
    }
  }

  /// Fetch a list of users by `status`
  
}
