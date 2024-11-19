import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/components/custom_button.dart';
import 'package:impeccablehome_helper/components/dropdown_field.dart';
import 'package:impeccablehome_helper/components/text_input_field.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class ECProvidingScreen extends StatefulWidget {
  const ECProvidingScreen({super.key});

  @override
  State<ECProvidingScreen> createState() => _ECProvidingScreenState();
}

class _ECProvidingScreenState extends State<ECProvidingScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController ecNameController = TextEditingController();
    final TextEditingController ecRelationshipController =
        TextEditingController();
    final TextEditingController ecPhoneNumberController =
        TextEditingController();
    final TextEditingController ecAddressController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Emergency\ncontact",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: oceanBlueColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                   Image.asset(
                    "assets/icons/family_icon.png",
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextInputField(
                              controller: ecNameController,
                              hintText: "Name of emergency contact"),
                          SizedBox(
                            height: 25,
                          ),
                          DropdownField(
                              options: relationshipTypes,
                              hintText: "Relationship to emergency contact",
                              controller: ecRelationshipController),
                          SizedBox(
                            height: 25,
                          ),
                          TextInputField(
                              controller: ecPhoneNumberController,
                              hintText: "Phone number of emergency contact"),
                          SizedBox(
                            height: 25,
                          ),
                          TextInputField(
                              controller: ecAddressController,
                              hintText: "Address of emergency contact"),
                          SizedBox(
                            height: 40,
                          ),
                          CustomButton(title: "Next", onTap: () {}),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

final List<String> relationshipTypes = [
  'Parent',
  'Sibling',
  'Spouse',
  'Relative',
];
