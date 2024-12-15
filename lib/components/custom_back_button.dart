import 'package:flutter/material.dart';

class CustomBackButton extends StatefulWidget {
  final Color color;
  
  const CustomBackButton({Key? key, required this.color}) : super(key: key);

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconWidth = screenWidth * 1 / 13;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: iconWidth,
        width: iconWidth,
        child: (widget.color != Colors.white)
            ? Image.asset("assets/icons/blue_back_button.png")
            : Image.asset("assets/icons/white_back_button.png"),
      ),
    );
  }
}
