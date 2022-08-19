import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';

import '../../../services/theme_service.dart';

class SearchPage extends StatelessWidget {

  final _ctrl = Get.put(SearchController());
    @override
    Widget build(BuildContext context) {
      ThemeService().init(context);
      return Scaffold(
          backgroundColor: themeConfig!.blueColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'this is the search page',
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
