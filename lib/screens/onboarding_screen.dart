import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:impeccablehome_helper/components/custom_button.dart';
import 'package:impeccablehome_helper/components/onboarding_header.dart';
import 'package:impeccablehome_helper/resources/authenticatiom_method.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
              height: 60,
            ),
            OnBoardingHeader(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 70, bottom: 50),
              child: Image.asset(
                "assets/images/customer_boarding.png",
                height: 265,
                fit: BoxFit.contain,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    color: charcoalGrayColor, // Grey color for the line
                    thickness: 1, // Line thickness
                    indent: 20, // Space before the line starts
                    endIndent: 0, // Space after the line ends
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10), // Padding for the text
                  child: Text(
                    "Sign up or login with Google",
                    style: TextStyle(
                      color: charcoalGrayColor, // Text color
                      fontSize: 16, // Text size
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: charcoalGrayColor, // Grey color for the line
                    thickness: 1, // Line thickness
                    indent: 0, // Space before the line starts
                    endIndent: 20, // Space after the line ends
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * (2 / 15),
              ),
              child: CustomButton(
                  preIcon: "assets/images/google_logo.png",
                  title: "Google",
                  backgroundColor: skyBlueColor,
                  textColor: Colors.black,
                  onTap: () {
                    AuthenticationMethods().signInWithGoogle(context: context);
                  }),
            )
          ],
        ),
      )),
    );
  }
}
