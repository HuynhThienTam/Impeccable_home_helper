import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final Color color;

  const SmallText({
    Key? key,
    required this.text,
    this.color = Colors.black, // Default color set to black
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: color,
      ),
    );
  }
}
