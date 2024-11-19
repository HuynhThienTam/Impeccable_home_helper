import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class OnBoardingHeader extends StatelessWidget {
  const OnBoardingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              Text(
                "Impeccable\nHome",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: oceanBlueColor,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "for partner",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'OldStandardTT',
                  fontStyle: FontStyle.italic,
                  color: oceanBlueColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Image.asset(
            "assets/icons/clean_home_icon.png",
            height: 90,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
