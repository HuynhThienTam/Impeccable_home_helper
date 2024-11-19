import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class IdCardSelector extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;
  const IdCardSelector({
    super.key,
    required this.onTap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    // Screen size for calculating the width and height
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Stack(
          children: [
            Container(
              width: screenWidth * 6 / 13,
              height: screenWidth * 3 /11,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.fromBorderSide(
                  BorderSide(
                    color: silverGrayColor,
                    width: 1, // Border width
                    style: BorderStyle
                        .solid, // Will change this using custom dash painter
                  ),
                ),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
              ),
            ),
            Container(
              width: screenWidth * 6 / 13,
              height: screenWidth * 3 /11,
              child: image == null
                  ? Center(
                      child: Image.asset(
                        "assets/icons/plus_icon.png",
                        height: screenWidth * (1 / 15),
                        width: screenWidth * (1 / 15),
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.file(
                      image!,
                      height: screenWidth * (1 / 15),
                      width: screenWidth * (1 / 15),
                      fit: BoxFit.contain,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = silverGrayColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final dashWidth = 5.0;
    final dashSpace = 3.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
