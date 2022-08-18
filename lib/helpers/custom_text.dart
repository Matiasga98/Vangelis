import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../services/theme_service.dart';
import '../util/constants.dart';

class CustomText extends StatelessWidget {
  final String data;
  final String? keyValue;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final Color? textColor;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final List<Shadow>? shadows;
  final TextDecoration? textDecoration;
  final String? fontFamily;

  const CustomText(
    this.data, {
    Key? key,
    this.keyValue = "",
    this.textAlign,
    this.textOverflow,
    this.maxLines,
    this.textColor,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.shadows,
    this.textDecoration,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data.tr,
      key: Key(keyValue!),
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLines,
      style: TextStyle(
        color: textColor ?? themeConfig!.blackWhiteColor,
        backgroundColor: backgroundColor,
        fontSize: fontSize ?? 20.h,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        shadows: shadows,
        decoration: textDecoration,
        fontFamily: fontFamily ?? regularFont,
      ),
    );
  }
}
