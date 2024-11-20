import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:impeccablehome_helper/model/helper_model.dart';


class CloudFirestoreClass {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future uploadNameAndImageToDatabase(
      {required HelperModel helper}) async {
    await firebaseFirestore
        .collection("helpers")
        .doc(firebaseAuth.currentUser!.uid)
        .set(helper.toMap());
  }
  }