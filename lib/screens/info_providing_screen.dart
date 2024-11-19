import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:impeccablehome_helper/components/custom_button.dart';
import 'package:impeccablehome_helper/components/dropdown_field.dart';
import 'package:impeccablehome_helper/components/onboarding_header.dart';
import 'package:impeccablehome_helper/components/small_text.dart';
import 'package:impeccablehome_helper/components/text_input_field.dart';

class InfoProvidingScreen extends StatefulWidget {
  const InfoProvidingScreen({super.key});

  @override
  State<InfoProvidingScreen> createState() => _InfoProvidingScreenState();
}

class _InfoProvidingScreenState extends State<InfoProvidingScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController provinceController = TextEditingController();
    final TextEditingController serviceTypeController = TextEditingController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(
                      text:
                          "Sign up as a domestic worker partner by \nproviding us information below"),
                  SizedBox(
                    height: 25,
                  ),
                  DropdownField(
                      options: vietnamProvinces,
                      hintText: "Province/City",
                      controller: provinceController),
                  SizedBox(
                    height: 25,
                  ),
                  DropdownField(
                      options: serviceTypes,
                      hintText: "Service type",
                      controller: serviceTypeController),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextInputField(
                            controller: firstNameController,
                            hintText: "Enter your first name"),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextInputField(
                            controller: lastNameController,
                            hintText: "Enter your last name"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextInputField(
                      controller: phoneController,
                      hintText: "Enter your phone number"),
                  SizedBox(
                    height: 40,
                  ),
                  CustomButton(title: "Next", onTap: (){}),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

final List<String> serviceTypes = [
  'Clean-up & Laundry',
  'Plumbing',
  'Cooking',
  'Electricity',
  'Gardening',
  'Grocery Shopping',
];
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
