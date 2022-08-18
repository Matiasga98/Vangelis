import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vangelis/util/constants.dart';

import '../services/theme_service.dart';
import 'custom_text.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? keyValue;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final double? borderRadius;
  final bool? isPassword;
  final Color? hintColor;
  final Color? borderColor;
  final TextInputAction? action;
  final double? fontSize;
  final String? fontFamily;
  final Color? fontColor;
  final Color? fillColor;
  final int? maxLines;
  final bool? isDense;
  final bool? isLabel;
  final double? height;
  final double? width;
  final IconData? prefixIcon;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final TextAlign? textAlign;
  final Function? onEditingComplete;
  final EdgeInsets? contentPadding;
  final int? maxLength;

  const CustomTextField(
      {Key? key,
      this.label = "",
      this.hint = "",
      this.keyValue = "",
      this.textEditingController,
      this.keyboardType,
      this.height,
      this.width,
      this.isDense = false,
      this.isLabel = true,
      this.borderRadius,
      this.hintColor = Colors.grey,
      this.borderColor = Colors.black,
      this.action = TextInputAction.next,
      this.isPassword = false,
      this.fontSize,
      this.fontFamily,
      this.fontColor = Colors.black,
      this.fillColor = Colors.transparent,
      this.maxLines = 1,
      this.prefixIcon,
      this.validator,
      this.onSaved,
      this.onEditingComplete,
      this.contentPadding,
      this.maxLength,
      this.textAlign = TextAlign.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Rx<bool>? isPassword = this.isPassword!.obs;
    RxBool? isPassToggle = false.obs;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLabel!)
            CustomText(
              label!.tr,
              fontSize: 26.h,
              fontFamily: regularFont,
              fontWeight: FontWeight.w300,
            ),
          if (isLabel!) SizedBox(height: 5.h),
          TextFormField(
            textAlign: textAlign ?? TextAlign.start,
            maxLength: maxLength,
            key: Key(keyValue!),
            maxLines: maxLines,
            obscureText: isPassword.value ? !isPassToggle.value : false,
            controller: textEditingController,
            keyboardType: keyboardType,
            cursorColor: themeConfig!.blackWhiteColor,
            textInputAction: action,
            onEditingComplete: () {
              onEditingComplete == null
                  ? {
                      if (action == TextInputAction.done)
                        {Get.focusScope!.unfocus()}
                      else
                        {Get.focusScope!.nextFocus()}
                    }
                  : {onEditingComplete!(), Get.focusScope!.unfocus()};
            },
            style: TextStyle(
              color: fontColor ?? themeConfig!.blackWhiteColor,
              fontSize: fontSize ?? 24.h,
              fontFamily: fontFamily ?? regularFont,
            ),
            decoration: InputDecoration(
              filled: true,
              isDense: isDense,
              constraints: BoxConstraints(
                maxHeight: height ?? double.infinity,
                maxWidth: width ?? double.infinity,
              ),
              border: const OutlineInputBorder(),
              hintText: hint!.tr,
              hintStyle: TextStyle(
                color: themeConfig!.blackWhiteColor,
                fontSize: 26.h,
                fontFamily: fontFamily ?? regularFont,
                fontWeight: FontWeight.w300,
              ),
              contentPadding: contentPadding,
              fillColor: fillColor ?? themeConfig!.blackWhiteColor,
              suffixIcon: isPassword.value
                  ? IconButton(
                      icon: Semantics(
                        label: isPassToggle.value
                            ? hidePassword.tr
                            : showPassword.tr,
                        child: Icon(
                          isPassToggle.value
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          color: themeConfig!.blackWhiteColor,
                          size: getProportionateScreenHeight(30),
                        ),
                      ),
                      onPressed: () {
                        isPassToggle.value = !isPassToggle.value;
                      },
                    )
                  : null,
            ),
            validator: validator,
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }
}
