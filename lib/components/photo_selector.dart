import 'dart:io';

import 'package:flutter/material.dart';

class PhotoSelector extends StatefulWidget {
  final File? image;
  final VoidCallback onTap;
  const PhotoSelector({
    super.key,
    required this.onTap,
    this.image,
  });

  @override
  State<PhotoSelector> createState() => _PhotoSelectorState();
}

class _PhotoSelectorState extends State<PhotoSelector> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * (3 / 8),
        height: MediaQuery.of(context).size.width * (3 / 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey), // Grey border
          borderRadius: BorderRadius.circular(8.0), // Optional rounded corners
        ),
        child:  widget.image == null
          ? Center(
              child: Image.asset(
                "assets/icons/camera_icon.png",
                height: MediaQuery.of(context).size.width * (1 / 6),
                width: MediaQuery.of(context).size.width * (1 / 6),
                fit: BoxFit.contain,
              ),
            )
          : Image.file(
              widget.image!,
              height: 200,
              width: double.infinity, // Ensures the image takes the full width
              fit: BoxFit.cover,
            ),
      ),
    );
  }
}
