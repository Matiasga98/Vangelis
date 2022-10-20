import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/collab/createCollab/create_collab_page.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/collab/collab_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:faker/faker.dart';
import 'package:vangelis/util/constants.dart';

import '../../../config/colors_.dart';
import 'card_widget.dart';
import '../../../services/theme_service.dart';
import '../../../services/theme_service.dart';
import 'collab_controller.dart';

class CollabScreen extends StatefulWidget {
  const CollabScreen({Key? key}) : super(key: key);

  @override
  State<CollabScreen> createState() => _CollabScreenState();
}

class _CollabScreenState extends State<CollabScreen> {
  final _ctrl = Get.put(CollabController());
  Faker faker = Faker();

  @override
  Widget build(BuildContext context) {
    ThemeService().init(context);
    Size size = MediaQuery.of(context).size;
    _ctrl.openContext();

    return Obx(() => Scaffold(
        backgroundColor: themeConfig!.whiteBlackColor,
        body: SizedBox(
          height: 1000.h,
          child: Column(
            children: [
              SizedBox(
                height: 100.h,
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.manage_search),
                      label: "Buscar collabs",
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.contacts),
                      label: "Feed",
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.account_circle_outlined),
                      label: "Mis collabs",
                    ),
                  ],
                  selectedLabelStyle: const TextStyle(fontFamily: regularFont),
                  unselectedLabelStyle:
                      const TextStyle(fontFamily: regularFont),
                  selectedItemColor: themeConfig!.blueColor,
                  backgroundColor: themeConfig!.whiteBlackColor,
                  currentIndex: _ctrl.currentButtonIndex.value,
                  onTap: (value) {
                    _ctrl.currentButtonIndex.value = value;
                  },
                ),
              ),
              SizedBox(
                height: 900.h,
                child: _ctrl.bodies.isNotEmpty
                    ? _ctrl.bodies[_ctrl.currentButtonIndex.value]
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              )
            ],
          ),
        )));
  }
}
