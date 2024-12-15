// import 'package:cloud_firestore/cloud_firestore.dart';

// class ReviewModel {
//   final String uid;
//   final double ratings;
//   final String reviewContent;

//   ReviewModel({
//     required this.uid,
//     required this.ratings,
//     required this.reviewContent,
//   });

//   factory ReviewModel.fromMap(Map<String, dynamic> map) {
//     return ReviewModel(
//       uid: map['uid'] ?? '',
//       ratings: (map['ratings'] ?? 0.0).toDouble(),
//       reviewContent: map['reviewContent'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'ratings': ratings,
//       'reviewContent': reviewContent,
//     };
//   }
// }

// Future<Map<String, String>> getUserDetails(String uid) async {
//   try {
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

//     if (userDoc.exists) {
//       final data = userDoc.data();
//       return {
//         'name': data?['name'] ?? '',
//         'profilePic': data?['profilePic'] ?? '',
//       };
//     } else {
//       return {
//         'name': 'Unknown User',
//         'profilePic': '',
//       };
//     }
//   } catch (e) {
//     // Handle error
//     return {
//       'name': 'Error fetching user',
//       'profilePic': '',
//     };
//   }
// }


class ReviewModel {
  final String uid;
  final String userName;
  final String profilePic;
  final double ratings;
  final String reviewContent;
  final List<String> reviewPics;

  ReviewModel({
    required this.uid,
    required this.userName,
    required this.profilePic,
    required this.ratings,
    required this.reviewContent,
    required this.reviewPics,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? 'Unknown User',
      profilePic: map['profilePic'] ?? '',
      ratings: (map['ratings'] ?? 0.0).toDouble(),
      reviewContent: map['reviewContent'] ?? '',
      reviewPics: List<String>.from(map['reviewPics'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'profilePic': profilePic,
      'ratings': ratings,
      'reviewContent': reviewContent,
      'reviewPics': reviewPics,
    };
  }
}


