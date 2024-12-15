import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';
import 'package:country_picker/country_picker.dart';

class CustomTextInput extends StatefulWidget {
  final String hintText;
  final Image? prefixImage; // Accepts an Image widget directly
  final String title;
  final TextEditingController controller;
  final bool isPassword;
  final bool isPhoneNumber;
  final ValueNotifier<Country>? paraSelectedCountry; // Optional parameter

  const CustomTextInput({
    Key? key,
    required this.hintText,
    this.prefixImage = null,
    required this.title,
    required this.controller,
    this.isPassword = false,
    this.isPhoneNumber = false,
    this.paraSelectedCountry,
  }) : super(key: key);

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  late bool isHidden;
  late ValueNotifier<Country> localCountryNotifier; // Local notifier

  @override
  void initState() {
    super.initState();
    isHidden = widget.isPassword;
    // Initialize local notifier only if paraSelectedCountry is null
    localCountryNotifier = widget.paraSelectedCountry ??
        ValueNotifier(
          Country(
            phoneCode: "84",
            countryCode: "VN",
            e164Sc: 0,
            geographic: true,
            level: 1,
            name: "Vietnam",
            example: "Vietnam",
            displayName: "Vietnam",
            displayNameNoCountryCode: "VN",
            e164Key: "",
          ),
        );
  }

  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 15),
        TextField(
          keyboardType:
              widget.isPhoneNumber ? TextInputType.number : TextInputType.text,
          controller: widget.controller,
          obscureText: widget.isPassword && isHidden,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: silverGrayColor,
              fontSize: 16,
            ),
            prefixIcon: widget.isPhoneNumber
                ? ValueListenableBuilder<Country>(
                    valueListenable:
                        widget.paraSelectedCountry ?? localCountryNotifier,
                    builder: (context, selectedCountry, child) => Container(
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: widget.prefixImage,
                          ),
                          InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 600,
                                ),
                                onSelect: (value) {
                                  (widget.paraSelectedCountry ??
                                          localCountryNotifier)
                                      .value = value;
                                },
                              );
                            },
                            child: Text(
                              "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : (widget.prefixImage == null)
                    ? null
                    : Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: widget.prefixImage,
                      ),
            prefixIconConstraints: widget.isPhoneNumber
                ? BoxConstraints(maxHeight: 18, maxWidth: 85)
                : BoxConstraints(maxHeight: 17, maxWidth: 28),
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: toggleVisibility,
                    child: Container(
                      margin: const EdgeInsets.only(left: 9),
                      child: isHidden
                          ? Image.asset(
                              "assets/icons/text_invisible_icon.png",
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              "assets/icons/text_visible_icon.png",
                              fit: BoxFit.contain,
                            ),
                    ),
                  )
                : null,
            suffixIconConstraints: widget.isPassword
                ? const BoxConstraints(maxHeight: 17, maxWidth: 32)
                : const BoxConstraints(maxHeight: 0, minWidth: 0),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: silverGrayColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: skyBlueColor, width: 2),
            ),
            isDense: true,
            contentPadding: EdgeInsets.only(top: 5, bottom: 3),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.paraSelectedCountry == null) {
      localCountryNotifier.dispose();
    }
    super.dispose();
  }
}
