import 'package:flutter/material.dart';

class StarsWidget extends StatelessWidget {
  final int ratings;

  const StarsWidget({
    Key? key,
    required this.ratings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const totalStars = 5;
    const starSpacing = 4.0; // Space between stars

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        return Row(
          children: [
            Image.asset(
              index < ratings
                  ? 'assets/icons/yellow_star.png'
                  : 'assets/icons/gray_star.png',
              width: 16.0,
              height: 16.0,
            ),
            if (index < totalStars - 1) SizedBox(width: starSpacing), // Adds space between stars
          ],
        );
      }),
    );
  }
}
