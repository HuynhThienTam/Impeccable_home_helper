import 'package:impeccablehome_helper/resources/cloud_firestore_methods.dart';

class HelperModel {
  String firstName;
  String lastName;
  String email;
  String province;
  String serviceType;
  String phoneNumber;
  String helperUid;
  String lastLogOutAt;
  String status; // online/offline
  String profilePic;
  String createdAt;
  String idCardFront;
  String idCardBack;
  String idCardNumber;
  String houseAddress;
  String emergencyContactName;
  String emergencyContactRelationship;
  String emergencyContactPhoneNumber;
  String emergencyContactAddress;
  String
      isApproved; // Has the profile been approved by admin? yes/no/notsubmitted
  double ratings; // Average rating score

  HelperModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.province,
    required this.serviceType,
    required this.phoneNumber,
    required this.helperUid,
    required this.lastLogOutAt,
    required this.status,
    required this.profilePic,
    required this.createdAt,
    required this.idCardFront,
    required this.idCardBack,
    required this.idCardNumber,
    required this.houseAddress,
    required this.emergencyContactName,
    required this.emergencyContactRelationship,
    required this.emergencyContactPhoneNumber,
    required this.emergencyContactAddress,
    required this.isApproved,
    required this.ratings,
  });

  factory HelperModel.fromMap(Map<String, dynamic> map) {
    return HelperModel(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      province: map['province'] ?? '',
      serviceType: map['serviceType'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      helperUid: map['helperUid'] ?? '',
      lastLogOutAt: map['lastLogOutAt'] ?? '',
      status: map['status'] ?? '',
      profilePic: map['profilePic'] ?? '',
      createdAt: map['createdAt'] ?? '',
      idCardFront: map['idCardFront'] ?? '',
      idCardBack: map['idCardBack'] ?? '',
      idCardNumber: map['idCardNumber'] ?? '',
      houseAddress: map['houseAddress'] ?? '',
      emergencyContactName: map['emergencyContactName'] ?? '',
      emergencyContactRelationship: map['emergencyContactRelationship'] ?? '',
      emergencyContactPhoneNumber: map['emergencyContactPhoneNumber'] ?? '',
      emergencyContactAddress: map['emergencyContactAddress'] ?? '',
      isApproved: map['isApproved'] ?? '',
      ratings: (map['ratings'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'province': province,
      'serviceType': serviceType,
      'phoneNumber': phoneNumber,
      'helperUid': helperUid,
      'lastLogOutAt': lastLogOutAt,
      'status': status,
      'profilePic': profilePic,
      'createdAt': createdAt,
      'idCardFront': idCardFront,
      'idCardBack': idCardBack,
      'idCardNumber': idCardNumber,
      'houseAddress': houseAddress,
      'emergencyContactName': emergencyContactName,
      'emergencyContactRelationship': emergencyContactRelationship,
      'emergencyContactPhoneNumber': emergencyContactPhoneNumber,
      'emergencyContactAddress': emergencyContactAddress,
      'isApproved': isApproved,
      'ratings': ratings,
    };
  }

  // Function to retrieve working time from Firestore
  Future<List<Map<String, String>>> getWorkingTime() async {
    final workingTimeCollection = CloudFirestoreClass()
        .firebaseFirestore
        .collection('helpers')
        .doc(helperUid)
        .collection('workingTime');

    final querySnapshot = await workingTimeCollection.get();
    return querySnapshot.docs
        .map((doc) => {'day': doc.id, ...doc.data() as Map<String, String>})
        .toList();
  }

  // Function to save working time into Firestore
  Future<void> setWorkingTime(List<Map<String, String>> workingTime) async {
    final workingTimeCollection = CloudFirestoreClass()
        .firebaseFirestore
        .collection('helpers')
        .doc(helperUid)
        .collection('workingTime');

    for (var time in workingTime) {
      final day = time['day']!;
      final startTime = time['startTime']!;
      final finishedTime = time['finishedTime']!;
      await workingTimeCollection.doc(day).set({
        'startTime': startTime,
        'finishedTime': finishedTime,
      });
    }
  }
}
