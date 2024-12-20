import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/model/helper_model.dart';
import 'package:impeccablehome_helper/resources/cloud_firestore_methods.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:impeccablehome_helper/screens/apprroval_waiting_screen.dart';
import 'package:impeccablehome_helper/screens/ec_providing_screen.dart';
import 'package:impeccablehome_helper/screens/id_providing_screen.dart';
import 'package:impeccablehome_helper/screens/onboarding_screen.dart';
import 'package:impeccablehome_helper/utils/utils.dart';

class AuthenticationMethods extends ChangeNotifier {
  HelperModel? _helperModel;
  HelperModel get helperModel => _helperModel!;
  File? _profilePic;
  File get profilePic => _profilePic!;
  File? _idCardFront;
  File get idCardFront => _idCardFront!;
  File? _idCardBack;
  File get idCardBack => _idCardBack!;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  //CloudFirestoreClass cloudFirestoreClass = CloudFirestoreClass();
  // signInWithGoogle()async{
  //   final GoogleSignInAccount? gUser=await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication gAuth=await gUser!.authentication;
  //   final credential=GoogleAuthProvider.credential(
  //     accessToken: gAuth.accessToken,
  //     idToken: gAuth.idToken,
  //   );
  //   return await FirebaseAuth.instance.signInWithCredential(credential);

  // }
  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Authenticate with Google
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in with Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the signed-in user's email
      User? user = userCredential.user;

      if (user != null) {
        final email = user.email;
        if (email == null) {
          showSnackBar(context, 'Error: Email is null for the signed-in user.');
          return;
        }

        // Check if the email already exists in Firestore
        final existingUser = await FirebaseFirestore.instance
            .collection('helpers') // Replace with your collection name
            .where('email', isEqualTo: email)
            .get();

        if (existingUser.docs.isNotEmpty) {
          await CloudFirestoreClass()
              .firebaseFirestore
              .collection('helpers')
              .doc(user.uid)
              .update({'status': 'onl'});
        } else {
          // Assign the email to _helperModel.email since it's not used
          _helperModel = HelperModel(
            firstName: '',
            lastName: '',
            email: email,
            province: '',
            serviceType: '',
            phoneNumber: '',
            helperUid: user.uid,
            lastLogOutAt: '',
            status: 'off',
            profilePic: '',
            createdAt: '',
            idCardFront: '',
            idCardBack: '',
            idCardNumber: '',
            houseAddress: '',
            emergencyContactName: '',
            emergencyContactRelationship: '',
            emergencyContactPhoneNumber: '',
            emergencyContactAddress: '',
            isApproved: 'notsubmitted',
            ratings: 5,
            dateOfBirth: '',
            gender: '',
          );
        }
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
    }
  }

  void providePersonalInfoForProfile({
    required BuildContext context,
    required String province,
    required String serviceType,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      if (_helperModel == null) {
        final email = firebaseAuth.currentUser!.email;
        final uid = firebaseAuth.currentUser!.uid;
        _helperModel = HelperModel(
          firstName: '',
          lastName: '',
          email: email!,
          province: '',
          serviceType: '',
          phoneNumber: '',
          helperUid: uid,
          lastLogOutAt: '',
          status: 'off',
          profilePic: '',
          createdAt: '',
          idCardFront: '',
          idCardBack: '',
          idCardNumber: '',
          houseAddress: '',
          emergencyContactName: '',
          emergencyContactRelationship: '',
          emergencyContactPhoneNumber: '',
          emergencyContactAddress: '',
          isApproved: 'notsubmitted',
          ratings: 5,
          dateOfBirth: '',
          gender: '',
        );
      }
      helperModel.province = province;
      helperModel.serviceType = serviceType;
      helperModel.firstName = firstName;
      helperModel.lastName = lastName;
      helperModel.phoneNumber = phoneNumber;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IdProvidingScreen()),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void provideIdentificationForProfile(
      {required BuildContext context,
      required File profilePic,
      required File idCardFront,
      required File idCardBack,
      required String idCardNumber,
      required String houseAddress}) async {
    helperModel.idCardNumber = idCardNumber;
    helperModel.houseAddress = houseAddress;
    _profilePic = profilePic;
    _idCardBack = idCardBack;
    _idCardFront = idCardFront;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ECProvidingScreen()),
    );
  }

  void provideEmergencyContactForProfile({
    required BuildContext context,
    required String emergencyContactName,
    required String emergencyContactRelationship,
    required String emergencyContactPhoneNumber,
    required String emergencyContactAddress,
  }) async {
    helperModel.emergencyContactName = emergencyContactName;
    helperModel.emergencyContactRelationship = emergencyContactRelationship;
    helperModel.emergencyContactPhoneNumber = emergencyContactPhoneNumber;
    helperModel.emergencyContactAddress = emergencyContactAddress;
    saveHelperDataToFirebase(context: context);
  }

  void saveHelperDataToFirebase({
    required BuildContext context,
  }) async {
    try {
      await storeFileToStorage(
              "helperProfilePic/${helperModel.helperUid}", profilePic)
          .then((value) {
        helperModel.profilePic = value;
      });

      await storeFileToStorage(
              "helperIdCardFront/${helperModel.helperUid}", idCardFront)
          .then((value) {
        helperModel.idCardFront = value;
      });

      await storeFileToStorage(
              "helperIdCardBack/${helperModel.helperUid}", idCardBack)
          .then((value) {
        helperModel.idCardBack = value;
      });
      helperModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      helperModel.isApproved = "no";
      await CloudFirestoreClass()
          .firebaseFirestore
          .collection("helpers")
          .doc(helperModel.helperUid)
          .set(helperModel.toMap());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ApprovalWaitingScreen()),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Upload id card back side unsuccessfully");
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future userSignOut() async {
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection('helpers')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'status': 'off',
      'lastLogOutAt': now,
    });
    await firebaseAuth.signOut();
  }
}
