import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/layout/screen_layout.dart';
import 'package:impeccablehome_helper/resources/cloud_firestore_methods.dart';
import 'package:impeccablehome_helper/screens/apprroval_waiting_screen.dart';
import 'package:impeccablehome_helper/screens/home_screen.dart';
import 'package:impeccablehome_helper/screens/info_providing_screen.dart';
import 'package:impeccablehome_helper/screens/onboarding_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context,snapshot){
           if(snapshot.hasData){
            return CheckHelperDetailsGate();
          }
          else{
            return const OnboardingScreen();
          }
        }),
    );
  }
}

class CheckHelperDetailsGate extends StatelessWidget {
  const CheckHelperDetailsGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("helpers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("An error occurred: ${snapshot.error}"));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const InfoProvidingScreen();
        } else {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final isApproved = data['isApproved'] as String? ?? 'no';

          if (isApproved == 'yes') {
            return const ScreenLayout(initialIndex: 0,);
          } else {
            return const ApprovalWaitingScreen();
          }
        }
      },
    );
  }
}
