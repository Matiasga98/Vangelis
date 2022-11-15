import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/config/colors_.dart';
import 'package:vangelis/pages/dashboard/collab/createCollab/create_collab_page.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/collab/collab_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:faker/faker.dart';
import 'package:vangelis/services/theme_service.dart';
import 'package:vangelis/util/constants.dart';
import 'collabFeed_controller.dart';

class CollabFeedScreen extends StatefulWidget {
  const CollabFeedScreen({Key? key}) : super(key: key);

  @override
  State<CollabFeedScreen> createState() => _CollabFeedScreenState();
}

class _CollabFeedScreenState extends State<CollabFeedScreen> {
  final _ctrl = Get.put(CollabFeedController());
  Faker faker = Faker();

  @override
  Widget build(BuildContext context) {
    ThemeService().init(context);
    Size size = MediaQuery.of(context).size;


    return Obx(() => Scaffold(
        backgroundColor: themeConfig!.whiteBlackColor,
        body:
        SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child:
            SizedBox(
              child: Column(children: [
                _ctrl.loading.value? Container():
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _ctrl.filteredCollabCards.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => {
                        _ctrl
                            .loadVideo(index)
                            .then((value) => showDialog(
                            context: context,
                            builder: (context) {
                              return _ctrl.openVideo(index);
                            }))
                            .then((value) => _ctrl.unloadVideo())
                      },
                      child: _ctrl.filteredCollabCards[index],
                    ))
              ]),
            )
            )


    ));
  }
}
