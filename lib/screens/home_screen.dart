import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impeccablehome_helper/components/avatar_widget.dart';
import 'package:impeccablehome_helper/components/custom_text_input.dart';
import 'package:impeccablehome_helper/components/dropdown_field.dart';
import 'package:impeccablehome_helper/components/photo_selector_dialog.dart';
import 'package:impeccablehome_helper/components/review_widget.dart';
import 'package:impeccablehome_helper/components/small_button.dart';
import 'package:impeccablehome_helper/components/weekly_working_time_widget.dart';
import 'package:impeccablehome_helper/model/helper_model.dart';
import 'package:impeccablehome_helper/resources/helper_details_provider.dart';
import 'package:impeccablehome_helper/resources/helper_services.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';
import 'package:impeccablehome_helper/utils/mock.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _calculateAge(String dob) {
    final birthDate = DateFormat('yyyy-MM-dd').parse(dob);
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
  String? getColorfulImagePath(String serviceType) {
  try {
    return services.firstWhere((service) => service.serviceName == serviceType).colorfulImagePath;
  } catch (e) {
    // If no matching serviceId is found, return null or handle accordingly
    print('Service with ID $serviceType not found');
    return null;
  }
}

  //final TextEditingController provinceController = TextEditingController();
  // final ImagePicker _imagePicker = ImagePicker();

  // String? profilePicUrl;
  // final String helperUid = "currentUserId"; // Replace with dynamic user ID
  final TextEditingController provinceController = TextEditingController();
  final HelperService helperService = HelperService();
  HelperModel? helper;
  String? profilePicUrl;
  final ImagePicker _picker =
      ImagePicker(); // Create an instance of I
  final List<String> vietnamProvinces = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Hải Phòng',
    'Cần Thơ',
    'Bà Rịa - Vũng Tàu',
    'Quảng Ninh',
    'Thanh Hóa',
    'Nghệ An',
    'Bình Dương',
    'Đồng Nai',
    'Thừa Thiên Huế',
    'Quảng Nam',
    'Bình Định',
    'Khánh Hòa',
    'Lâm Đồng',
    'Gia Lai',
    'Đắk Lắk',
    'Sóc Trăng',
    'Kiên Giang',
    'Bạc Liêu',
    'Cà Mau',
    'An Giang',
    'Hậu Giang',
    'Vĩnh Long',
    'Đồng Tháp',
    'Tiền Giang',
    'Bến Tre',
    'Trà Vinh',
    'Long An',
    'Tây Ninh',
    'Quảng Trị',
    'Quảng Bình',
    'Hà Tĩnh',
    'Ninh Bình',
    'Nam Định',
    'Hòa Bình',
    'Sơn La',
    'Điện Biên',
    'Lào Cai',
    'Yên Bái',
    'Thái Nguyên',
    'Bắc Kạn',
    'Bắc Giang',
    'Bắc Ninh',
    'Hải Dương',
    'Hưng Yên',
    'Phú Thọ',
    'Lạng Sơn',
    'Cao Bằng',
    'Hà Giang',
    'Tuyên Quang',
  ];
   @override
  void initState() {
    super.initState();
    _fetchHelper();
  }

  @override
  void dispose() {
    provinceController.dispose();
    super.dispose();
  }
  final currentuser = FirebaseAuth.instance.currentUser;
  Future<void> _fetchHelper() async {
    final fetchedHelper = await helperService.fetchHelperDetails(currentuser!.uid);

    if (fetchedHelper != null) {
      setState(() {
        helper = fetchedHelper;
        profilePicUrl = fetchedHelper.profilePic;

        //fetchedHelper.profilePic;
        provinceController.text = fetchedHelper.province ?? '';
      });
    }
  }
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600, // Resize the image if needed
        imageQuality: 80, // Reduce quality for optimization
      );

      if (pickedFile != null) {
        await helperService.uploadPhoto(currentuser!.uid, pickedFile.path);
      _fetchHelper(); // Refresh the UI after upload
        
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }


  Future<void> _updateProvince(String newProvince) async {
    if (provinceController.text.isNotEmpty) {
      await helperService.updateProvince(currentuser!.uid, newProvince);
      _fetchHelper(); // Refresh the UI after update
    }
  }
  // Future<HelperModel?> fetchHelperDetails(String helperUid) async {
  //   try {
  //     // Fetch helper details from Firestore
  //     final doc = await FirebaseFirestore.instance
  //         .collection('helpers')
  //         .doc(helperUid)
  //         .get();

  //     if (doc.exists)
  //       return HelperModel.fromMap(doc.data()!);

  //     // Fetch profile picture URL from Firebase Storage
  //     else {
  //       debugPrint('User not found in Firestore');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching helper details: $e');
  //   }
  // }


  // Future<String> getProfilePicUrl(String helperUid) async {
  //   try {
  //     // Get the download URL of the profile picture from Firebase Storage
  //     final ref = FirebaseStorage.instance.ref('helperProfilePic/$helperUid');
  //     return await ref.getDownloadURL();
  //   } catch (e) {
  //     // Return a placeholder or default image URL in case of error
  //     return 'https://via.placeholder.com/150'; // Replace with your placeholder image URL
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final helperProvider = Provider.of<HelperDetailsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenWidth * (1 / 6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your profile",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  AvatarWidget(
                    imageUrl: profilePicUrl!=null?profilePicUrl!:"https://picsum.photos/205",
                    size: screenWidth * 2 / 5,
                    onPressed: ()  async {
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
                    height: 25,
                  ),
                  Text(
                    '${helper!.firstName } ${helper!.lastName}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        helper!.gender.toLowerCase() == 'male'
                            ? 'assets/icons/male_icon.png'
                            : 'assets/icons/female_icon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${_calculateAge(helper!.dateOfBirth)} years old',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: silverGrayColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .end, // Aligns children to the bottom of the Row
                          children: [
                            // CustomTextInput takes remaining space
                            Expanded(
                              child: AbsorbPointer(
                                child: CustomTextInput(
                                  prefixImage: Image.asset(
                                    "assets/icons/small_location_icon.png",
                                    fit: BoxFit.contain,
                                  ),
                                  hintText: "",
                                  title: "Working area",
                                  controller: provinceController,
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 32), // Space between input and button
                            // SmallButton at the bottom of the Row
                            Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .end, // Aligns SmallButton to the bottom
                              children: [
                                SmallButton(
                                  title: "Edit",
                                  textColor: Colors.white,
                                  backgroundColor: crimsonRedColor,
                                  onTap: () {
                                    _showProvinceDialog(context);
                                    // Handle button press
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Text(
                          "Specialized in",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: screenWidth * (1 / 7),
                                  child: Image.asset(
                                    getColorfulImagePath(helper!.serviceType)!,
                                    fit: BoxFit
                                        .cover, // Ensures the image fills the container
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  helper!.serviceType,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Working time",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        WeeklyWorkingTimeWidget(
                            helperModel: helper!,),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 12),
                    child: Row(
                      children: [
                        Text(
                          "Average ${helpers[0].ratings}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Image.asset(height: 13, "assets/icons/yellow_star.png"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: mockReviews
                        .map((review) => Padding(
                              padding: EdgeInsets.only(
                                top: screenWidth / 36,
                                left: screenWidth / 13,
                                right: screenWidth / 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReviewWidget(review: review),
                                  SizedBox(
                                    height: screenWidth / 36,
                                  ),
                                  Divider(
                                    // Divider between each widget
                                    color:
                                        orangeColor, // Customize divider color
                                    thickness:
                                        1.0, // Customize divider thickness
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
      // backgroundColor: Colors.white,
      // body: FutureBuilder(
      //   // future: fetchHelperDetails(currentuser!.uid),
      //   future: Future.wait([
      //     fetchHelperDetails(currentuser!.uid), // Fetch helper details
      //     getProfilePicUrl(currentuser!.uid), // Fetch profile picture URL
      //   ]),

      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }

      //     if (snapshot.hasError) {
      //       return Center(
      //         child: Text(
      //           'Error: ${snapshot.error}',
      //           style: const TextStyle(fontSize: 18, color: Colors.red),
      //         ),
      //       );
      //     }

      //     if (!snapshot.hasData || snapshot.data == null) {
      //       return const Center(
      //         child: Text(
      //           'User not found.',
      //           style: TextStyle(fontSize: 18, color: Colors.grey),
      //         ),
      //       );
      //     }
      //     // final helper = snapshot.data!;
      //     // provinceController.text=helper.province;
      //     final results = snapshot.data as List;
      //     final helper = results[0]; // First future result (helper details)
      //     final profilePicUrl =
      //         results[1]; // Second future result (profile pic URL)

      //     // Update the controller's text
      //     provinceController.text = helper.province;
      //     return SafeArea(
      //       child: SingleChildScrollView(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Padding(
      //               padding: EdgeInsets.only(
      //                 top: screenWidth * (1 / 6),
      //               ),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Text(
      //                     "Your profile",
      //                     style: TextStyle(
      //                         fontSize: 18,
      //                         fontWeight: FontWeight.w600,
      //                         color: Colors.black),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 25,
      //             ),
      //             AvatarWidget(
      //               imageUrl: profilePicUrl,
      //               size: screenWidth * 2 / 5,
      //               onPressed: () {
      //                 print('Camera icon pressed!');
      //               },
      //             ),
      //             SizedBox(
      //               height: 25,
      //             ),
      //             Text(
      //               '${helper.firstName} ${helper.lastName}',
      //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      //             ),
      //             Row(
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Image.asset(
      //                   helpers[0].gender.toLowerCase() == 'male'
      //                       ? 'assets/icons/male_icon.png'
      //                       : 'assets/icons/female_icon.png',
      //                   height: 16,
      //                   width: 16,
      //                 ),
      //                 SizedBox(width: 8),
      //                 Text(
      //                   '${_calculateAge(helpers[0].dateOfBirth)} years old',
      //                   style: TextStyle(
      //                       fontSize: 16,
      //                       fontWeight: FontWeight.w400,
      //                       color: silverGrayColor),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ],
      //             ),
      //             SizedBox(
      //               height: 25,
      //             ),
      //             Padding(
      //               padding: EdgeInsets.symmetric(horizontal: screenWidth / 12),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment
      //                         .end, // Aligns children to the bottom of the Row
      //                     children: [
      //                       // CustomTextInput takes remaining space
      //                       Expanded(
      //                         child: AbsorbPointer(
      //                           child: CustomTextInput(
      //                             prefixImage: Image.asset(
      //                               "assets/icons/small_location_icon.png",
      //                               fit: BoxFit.contain,
      //                             ),
      //                             hintText: "",
      //                             title: "Working area",
      //                             controller: provinceController,
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(
      //                           width: 32), // Space between input and button
      //                       // SmallButton at the bottom of the Row
      //                       Column(
      //                         mainAxisAlignment: MainAxisAlignment
      //                             .end, // Aligns SmallButton to the bottom
      //                         children: [
      //                           SmallButton(
      //                             title: "Edit",
      //                             textColor: Colors.white,
      //                             backgroundColor: crimsonRedColor,
      //                             onTap: () {
      //                               _showProvinceDialog(context);
      //                               // Handle button press
      //                             },
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(
      //                     height: 35,
      //                   ),
      //                   Text(
      //                     "Specialized in",
      //                     style: TextStyle(
      //                         fontSize: 16, fontWeight: FontWeight.w600),
      //                   ),
      //                   SizedBox(
      //                     height: 25,
      //                   ),
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Column(
      //                         crossAxisAlignment: CrossAxisAlignment.center,
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Container(
      //                             width: screenWidth * (1 / 7),
      //                             child: Image.asset(
      //                               "assets/images/colorful_cleanup_image.png",
      //                               fit: BoxFit
      //                                   .cover, // Ensures the image fills the container
      //                             ),
      //                           ),
      //                           SizedBox(
      //                             height: 10,
      //                           ),
      //                           Text(
      //                             helpers[0].serviceType,
      //                             style: TextStyle(
      //                               color: Colors.black,
      //                               fontSize: 14,
      //                               fontWeight: FontWeight.w600,
      //                             ),
      //                             maxLines: 2,
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(
      //                     height: 25,
      //                   ),
      //                   Text(
      //                     "Working time",
      //                     style: TextStyle(
      //                         fontSize: 16,
      //                         fontWeight: FontWeight.w600,
      //                         color: Colors.black),
      //                   ),
      //                   SizedBox(
      //                     height: 10,
      //                   ),
      //                   WeeklyWorkingTimeWidget(
      //                       workingTime: helper1WorkingTimes),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 25,
      //             ),
      //             Padding(
      //               padding: EdgeInsets.symmetric(horizontal: screenWidth / 12),
      //               child: Row(
      //                 children: [
      //                   Text(
      //                     "Average ${helpers[0].ratings}",
      //                     style: TextStyle(
      //                         fontSize: 16, fontWeight: FontWeight.w600),
      //                   ),
      //                   SizedBox(
      //                     width: 4,
      //                   ),
      //                   Image.asset(height: 13, "assets/icons/yellow_star.png"),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 25,
      //             ),
      //             Column(
      //               children: mockReviews
      //                   .map((review) => Padding(
      //                         padding: EdgeInsets.only(
      //                           top: screenWidth / 36,
      //                           left: screenWidth / 13,
      //                           right: screenWidth / 10,
      //                         ),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             ReviewWidget(review: review),
      //                             SizedBox(
      //                               height: screenWidth / 36,
      //                             ),
      //                             Divider(
      //                               // Divider between each widget
      //                               color:
      //                                   orangeColor, // Customize divider color
      //                               thickness:
      //                                   1.0, // Customize divider thickness
      //                             ),
      //                           ],
      //                         ),
      //                       ))
      //                   .toList(),
      //             ),
      //             SizedBox(
      //               height: 50,
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  void _showProvinceDialog(BuildContext context) {
    String? selectedProvince = provinceController
        .text; // Ensure the initial value matches an existing province

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Province"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: silverGrayColor, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius:
                    BorderRadius.circular(8.0), // Optional: Rounded corners
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0), // Add padding inside the border
              child: DropdownButton<String>(
                value: vietnamProvinces.contains(selectedProvince)
                    ? selectedProvince
                    : null,
                items: vietnamProvinces.map((province) {
                  return DropdownMenuItem<String>(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                onChanged: (newValue){
                  setState(() {
                    selectedProvince = newValue;
                  });
                  
                },
                underline: SizedBox(), // Removes the default underline
                isExpanded: true, // Makes the dropdown take the full width
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog without changes
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (selectedProvince != null) {
                setState(() {
                  provinceController.text = selectedProvince!;
                });
                _updateProvince(selectedProvince!);
              }
              Navigator.of(context).pop(); // Save selection and close dialog
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
