import 'package:flutter/material.dart';
import 'package:vangelis/util/constants.dart';

import '../services/theme_service.dart';
import 'custom_text.dart';


class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    required this.onPress,
    required this.buttonText,
    this.width = 0,
    this.height = 0,
  }) : super(key: key);

  final void Function() onPress;
  final String buttonText;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(
                EdgeInsets.fromLTRB(width.w, height.w, width.w, height.w)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(color: themeConfig!.blueColor)))),
        onPressed: onPress,
        child: CustomText(buttonText, textColor: themeConfig!.blueColor));
  }
}
