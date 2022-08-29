import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/search/search_page.dart';

import '../../../services/theme_service.dart';

class SearchController extends GetxController {
  var textFilterController = TextEditingController();
  RxBool searchState = false.obs;

  void closeContext() {

    textFilterController.clear();

    searchState.value = false;

  }

  void openContext() {

    searchState.value = true;

  }

}
