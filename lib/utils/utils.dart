import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';
void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: oceanBlueColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        content: SizedBox(
          width:  MediaQuery.of(context).size.width*(3/4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                
              ),
            ],
          ),
        ),
      ),
  );
}