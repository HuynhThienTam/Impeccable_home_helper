import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:impeccablehome_helper/components/custom_button.dart';
import 'package:impeccablehome_helper/components/id_card_selector.dart';
import 'package:impeccablehome_helper/components/photo_selector.dart';
import 'package:impeccablehome_helper/components/photo_selector_dialog.dart';
import 'package:impeccablehome_helper/components/small_text.dart';
import 'package:impeccablehome_helper/components/text_input_field.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class IdProvidingScreen extends StatefulWidget {
  const IdProvidingScreen({super.key});

  @override
  State<IdProvidingScreen> createState() => _IdProvidingScreenState();
}

class _IdProvidingScreenState extends State<IdProvidingScreen> {
  File? _image;
  File? _frontIdCardImage;
  File? _backIdCardImage;
  String? selectedOption;
  final ImagePicker _picker =
      ImagePicker(); // Create an instance of ImagePicker

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600, // Resize the image if needed
        imageQuality: 80, // Reduce quality for optimization
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Store the selected image
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _pickFrontImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600, // Resize the image if needed
        imageQuality: 80, // Reduce quality for optimization
      );

      if (pickedFile != null) {
        setState(() {
          _frontIdCardImage = File(pickedFile.path); // Store the selected image
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _pickBackImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600, // Resize the image if needed
        imageQuality: 80, // Reduce quality for optimization
      );

      if (pickedFile != null) {
        setState(() {
          _backIdCardImage = File(pickedFile.path); // Store the selected image
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController idCardNumberController =TextEditingController();
    final TextEditingController addressController =TextEditingController();
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
                "Identification",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: oceanBlueColor,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Photo of you",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(height: 20),
              PhotoSelector(
                image: _image,
                onTap: () async {
                  final selectedValue = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return PhotoSelectorDialog(
                        onPickImage: (source) async {
                          // Handle image picking here, e.g., call your _pickImage method
                          await _pickImage(source);
                        },
                      );
                    },
                  );

                  if (selectedValue != null) {
                    setState(() {});
                  }
                },
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    SmallText(
                        text:
                            "Make sure in the photo you are not wearing the following items:\n- Hat\n- Cap\n- Sunglasses"),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "ID Card",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SmallText(text: "Front side"),
                        Expanded(
                          child: Container(),
                        ),
                        IdCardSelector(
                          image: _frontIdCardImage,
                          onTap: () async {
                            final selectedValue = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return PhotoSelectorDialog(
                                  onPickImage: (source) async {
                                    // Handle image picking here, e.g., call your _pickImage method
                                    await _pickFrontImage(source);
                                  },
                                );
                              },
                            );

                            if (selectedValue != null) {
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        SmallText(text: "Back side"),
                        Expanded(
                          child: Container(),
                        ),
                        IdCardSelector(
                          image: _backIdCardImage,
                          onTap: () async {
                            final selectedValue = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return PhotoSelectorDialog(
                                  onPickImage: (source) async {
                                    // Handle image picking here, e.g., call your _pickImage method
                                    await _pickBackImage(source);
                                  },
                                );
                              },
                            );

                            if (selectedValue != null) {
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextInputField(
                        controller: idCardNumberController,
                        hintText: "Id card number"),
                    SizedBox(
                      height: 25,
                    ),
                    TextInputField(
                        controller: addressController,
                        hintText: "Home address"),
                    SizedBox(
                      height: 40,
                    ),
                    CustomButton(title: "Next", onTap: () {}),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
