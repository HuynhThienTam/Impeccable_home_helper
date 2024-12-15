import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class CustomButtonMain extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String title;
  final VoidCallback onTap;
  final String? iconImage; // Optional parameter for an image (URL or asset path)

  const CustomButtonMain({
    Key? key,
    this.backgroundColor,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconImage, // Added optional parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? oceanBlueColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min, // Keep the content compact
            children: [
              if (iconImage != null) ...[
                Image.asset(
                  iconImage!,
                  height: 20, // Adjust image size
                  width: 20,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 8), // Add some space between the image and text
              ],
              Text(
                title,
                style: TextStyle(
                  color: textColor ?? Colors.white, // Button text color
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
