import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class PhotoSelectorDialog extends StatelessWidget {
  final Function(ImageSource) onPickImage;

  const PhotoSelectorDialog({required this.onPickImage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        height: 200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select an option',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Select a photo"),
                      onTap: () {
                        onPickImage(ImageSource.gallery);
                        Navigator.pop(context, "gallery");
                      },
                    ),
                    ListTile(
                      title: Text("Take a photo"),
                      onTap: () {
                        onPickImage(ImageSource.camera);
                        Navigator.pop(context, "camera");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
