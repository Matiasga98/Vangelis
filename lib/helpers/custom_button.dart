import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vangelis/util/constants.dart';


import '../services/theme_service.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? label;
  final String? keyValue;
  final double? width;
  final double? height;
  final Color? textColor;
  final String? fontFamily;
  final double? fontSize;

  const CustomButton({
    Key? key,
    this.onTap,
    this.backgroundColor,
    this.label,
    this.keyValue = "",
    this.width,
    this.height,
    this.textColor,
    this.fontSize,
    this.fontFamily,
    this.borderColor,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key(keyValue!),
      onTap: () {
        onTap!();
      },
      child: Container(
        width: width ?? Get.width,
        height: height ?? 65.h,
        decoration: BoxDecoration(
          color: borderColor == null
              ? backgroundColor ?? ThemeService().orangeColor
              : Colors.transparent,
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: 1),
        ),
        child: Center(
          child: CustomText(
            label!,
            fontSize: fontSize ?? 22.h,
            textAlign: TextAlign.center,
            textColor: textColor ?? themeConfig!.whiteBlackColor,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
