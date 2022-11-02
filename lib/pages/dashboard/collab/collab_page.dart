import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/helpers/custom_text.dart';
import 'package:vangelis/pages/dashboard/collab/collabFeed/collabFeed_page.dart';
import 'package:vangelis/pages/dashboard/collab/collabSearch/collabSearch_page.dart';
import 'package:vangelis/pages/dashboard/collab/collabUser/collabUser_page.dart';
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

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: themeConfig!.whiteBlackColor,
          appBar: AppBar(
            backgroundColor: greenLight,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'Bucar Collabs',
                    ),
                    Tab(
                      text: 'Feed',
                    ),
                    Tab(
                      text: 'Mis Collabs',
                    ),
                  ],
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CollabSearchScreen(),
              CollabFeedScreen(),
              CollabUserScreen(),
            ],
          ),
        ));
  }
}
