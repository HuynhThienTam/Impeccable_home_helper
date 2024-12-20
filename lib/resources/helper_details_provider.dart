// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:impeccablehome_helper/model/helper_model.dart';

// class HelperDetailsProvider extends ChangeNotifier {
//   HelperModel? _helper;
//   HelperModel? get helper => _helper;
  
//   String? _profilePicUrl;
//   String? get profilePicUrl => _profilePicUrl;

//   Future<void> fetchHelperDetails(String helperUid) async {
//     try {
//       // Fetch helper details from Firestore
//       final doc = await FirebaseFirestore.instance
//           .collection('helpers')
//           .doc(helperUid)
//           .get();

//       if (!doc.exists) throw Exception('Helper not found!');
//       _helper = HelperModel.fromMap(doc.data()!);

//       // Fetch profile picture URL from Firebase Storage
//       _profilePicUrl = await FirebaseStorage.instance
//           .ref('helperProfilePic/$helperUid')
//           .getDownloadURL();

//       notifyListeners();
//     } catch (e) {
//       print('Error fetching helper details: $e');
//     }
//   }
// }
