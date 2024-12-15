import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String imageUrl;
  final double size;
  final VoidCallback onPressed;

  const AvatarWidget({
    Key? key,
    required this.imageUrl,
    this.size = 160.0, // 40 * 4 for consistency
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: [
            // Background Image
            Image.network(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
            // Black-transparent layer at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size,
                height: size / 4, // 1/4 of the avatar's height
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: size / 7, // Adjust icon size
                    ),
                    onPressed: onPressed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
