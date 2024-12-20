import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelpers {
  static Future<String?> uploadProfilePicture(String helperUid, File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref('helperProfilePic/$helperUid');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  static Future<void> updateProvince(String helperUid, String newProvince) async {
    try {
      await FirebaseFirestore.instance
          .collection('helpers')
          .doc(helperUid)
          .update({'province': newProvince});
    } catch (e) {
      print('Error updating province: $e');
      throw e; // Optionally rethrow to handle errors in the caller.
    }
  }

  static Future<Map<String, dynamic>?> fetchHelperData(String helperUid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('helpers')
          .doc(helperUid)
          .get();

      return snapshot.data();
    } catch (e) {
      print('Error fetching helper data: $e');
      return null;
    }
  }

  static Future<String?> fetchProfilePictureUrl(String helperUid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref('helperProfilePic/$helperUid');
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error fetching profile picture URL: $e');
      return null;
    }
  }
}
