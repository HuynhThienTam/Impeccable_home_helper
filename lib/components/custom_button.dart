import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class CustomButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String title;
  final VoidCallback onTap;
  final String? preIcon;

  const CustomButton({
    Key? key,
    this.backgroundColor,
    required this.title,
    required this.onTap,
    this.textColor,
    this.preIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 14.0,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? oceanBlueColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Centers the row content horizontally
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (preIcon != null) ...[
              SizedBox(
                width: MediaQuery.of(context).size.width * (1 / 5),
              ),
              Image.asset(
                preIcon!,
                width: 24, // Set the size of the image
                height: 24,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * (1 / 18),
              ),
              // Add space between the image and text
              Text(
                title,
                style: TextStyle(
                  color: textColor ?? Colors.white, // Button text color
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor ?? Colors.white, // Button text color
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
