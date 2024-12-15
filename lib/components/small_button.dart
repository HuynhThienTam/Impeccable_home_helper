import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const SmallButton({
    Key? key,
    required this.title,
    required this.textColor,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 22.0, // Fixed height
        padding: EdgeInsets.symmetric(horizontal: 6.0), // Some padding for text
        decoration: BoxDecoration(
          color: backgroundColor, // Background color
          borderRadius: BorderRadius.zero, // No circular border
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor, // Text color
              fontSize: 13.0, // Small font size
              fontWeight: FontWeight.w600, // Optional styling
            ),
          ),
        ),
      ),
    );
  }
}
