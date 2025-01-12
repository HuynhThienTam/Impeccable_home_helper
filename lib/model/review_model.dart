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
  final String userId;
  final String helperId;
  final double ratings;
  final String reviewContent;
  final List<String> reviewPics;

  ReviewModel({
    required this.userId,
    required this.helperId,
    required this.ratings,
    required this.reviewContent,
    required this.reviewPics,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      userId: map['userId'] ?? '',
      helperId: map['helperId'] ?? 'Unknown User',
      ratings: (map['ratings'] ?? 0.0).toDouble(),
      reviewContent: map['reviewContent'] ?? '',
      reviewPics: List<String>.from(map['reviewPics'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'helperId': helperId,
      'ratings': ratings,
      'reviewContent': reviewContent,
      'reviewPics': reviewPics,
    };
  }
}


