import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/profile/profile_controller.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';

import '../../../services/theme_service.dart';

class ProfilePage extends StatelessWidget {

  final _ctrl = Get.put(ProfileController());
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
              'this is the profile page',
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
