import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/components/onboarding_header.dart';
import 'package:impeccablehome_helper/components/process_widget.dart';
import 'package:impeccablehome_helper/components/small_text.dart';

class ApprovalWaitingScreen extends StatefulWidget {
  const ApprovalWaitingScreen({super.key});

  @override
  State<ApprovalWaitingScreen> createState() => _ApprovalWaitingScreenState();
}

class _ApprovalWaitingScreenState extends State<ApprovalWaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
              height: 20,
            ),
            OnBoardingHeader(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SmallText(text: "Waiting for approval. Come back soon!")
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ProcessWidget(processes: processesList, doneProcesses: doneProcessesList, currentProcesses: currentProcessesList,currentProcess: 1))
            ],),
        )),
    );
  }
}
final List<String> processesList = [
  'Submit',
  'Approve',
  'Complete',
];
final List<String> doneProcessesList = [
  'Submitted',
  'Approved',
  'Completed',
];
final List<String> currentProcessesList = [
  'Submitting',
  'Approving',
  'Completing',
];