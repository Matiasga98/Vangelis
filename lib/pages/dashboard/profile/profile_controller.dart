import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../services/theme_service.dart';

class ProfileController extends GetxController {
  var listGenres = 5;
  var listInstruments = 2;
  RxString description = "texto".obs;
  final descriptionController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
  }

  void updateDescription() {
    description.value = descriptionController.text;
  }

  void onCancel(){
    descriptionController.text = description.value;
  }


}
