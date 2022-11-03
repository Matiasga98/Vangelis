import 'package:flutter/material.dart';
import 'package:vangelis/helpers/primary_button.dart';
import 'package:vangelis/helpers/secondary_button.dart';


import '../util/constants.dart';
import '../services/theme_service.dart';
import 'custom_text.dart';


class DialogButtons extends StatelessWidget {
  DialogButtons({
    Key? key,
    required this.onOk,
    required this.onCancel,
    required this.okButtonText,
    required this.cancelButtonText,
    this.alignment = MainAxisAlignment.end,
  }) : super(key: key);


  final void Function() onOk;
  final void Function() onCancel;
  final String okButtonText;
  final String cancelButtonText;
  MainAxisAlignment alignment;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: alignment,
      children: [
        SecondaryButton(onPress: onCancel, buttonText: cancelButtonText),

        const SizedBox(
          width: 18,
        ),
        PrimaryButton(key: const Key(dialogButtonOkButtonKey), onPress: onOk, buttonText: okButtonText),

      ],
    );
  }
}
