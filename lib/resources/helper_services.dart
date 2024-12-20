import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/model/helper_model.dart';

class HelperService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Future<HelperModel?> fetchHelperDetails(String helperUid) async {
    try {
      // Fetch helper details from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('helpers')
          .doc(helperUid)
          .get();

      if (doc.exists) {
        // Retrieve profile picture URL from Firebase Storage
        final profilePicUrl = await FirebaseStorage.instance
            .ref('helperProfilePic/$helperUid')
            .getDownloadURL();

        final data = doc.data()!;
        data['profilePicUrl'] = profilePicUrl; // Add profile pic to data
        return HelperModel.fromMap(data);
      } else {
        debugPrint('Helper not found in Firestore');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching helper details: $e');
      return null;
    }
  }

  // Future<void> uploadPhoto(String helperUid, String filePath) async {
  //   String profilePic="";
  //   try {
  //     await storeFileToStorage(
  //             "helperProfilePic/${helperUid}", File(filePath))
  //         .then((value) {
  //       profilePic = value;
  //     });}catch(e){

  //     }

  // }
  Future<void> uploadPhoto(String helperUid, String filePath) async {
    String profilePicUrl = "";

    try {
      // Upload file to Firebase Storage and get the download URL
      profilePicUrl = await storeFileToStorage(
          "helperProfilePic/$helperUid", File(filePath));

      // Update the `profilePicUrl` in Firestore
      await FirebaseFirestore.instance
          .collection('helpers')
          .doc(helperUid)
          .update({
        'profilePic': profilePicUrl,
      });

      debugPrint("Photo updated successfully in Firestore");
    } catch (e) {
      debugPrint("Error uploading photo: $e");
    }
  }

  Future<void> updateProvince(String helperUid, String province) async {
    try {
      await FirebaseFirestore.instance
          .collection('helpers')
          .doc(helperUid)
          .update({'province': province});
      debugPrint('Province updated successfully.');
    } catch (e) {
      debugPrint('Error updating province: $e');
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
