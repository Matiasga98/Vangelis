import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/config/colors_.dart';
import 'package:vangelis/pages/dashboard/collab/collabSearch/collabSearch_controller.dart';
import 'package:vangelis/pages/dashboard/collab/collabUser/collabUser_controller.dart';
import 'package:vangelis/pages/dashboard/collab/createCollab/create_collab_page.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';
import 'package:vangelis/pages/dashboard/collab/collab_controller.dart';
import 'package:faker/faker.dart';
import 'package:vangelis/pages/dashboard/video/video_page.dart';
import 'package:vangelis/services/theme_service.dart';
import 'package:vangelis/util/constants.dart';

import 'collabUserResponse_controller.dart';

class CollabUserResponseScreen extends StatefulWidget {
  const CollabUserResponseScreen({Key? key}) : super(key: key);

  @override
  State<CollabUserResponseScreen> createState() => _CollabUserResponseScreenState();
}

class _CollabUserResponseScreenState extends State<CollabUserResponseScreen> {
  final _ctrl = Get.put(CollabUserResponseController());
  Faker faker = Faker();

  @override
  Widget build(BuildContext context) {
    ThemeService().init(context);
    Size size = MediaQuery.of(context).size;

    return Obx(() => Scaffold(
        backgroundColor: themeConfig!.whiteBlackColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              _ctrl.loading.value? Center(
                child: Image.asset(
                  themeConfig!.loadingGif,
                  height: 100,
                  fit: BoxFit.cover,
                  semanticLabel: barbriLogo,
                ),
              ):
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _ctrl.collabsRespondedCards.length,
                  itemBuilder: (context, index) =>
                      GestureDetector(
                        onTap: () {
                          int index2 = _ctrl.getResponseIndexOfUser(index);
                          Get.to(VideoScreen(_ctrl.collabsResponded[index].videoId,
                              _ctrl.collabsResponded[index].responses[index2].videoId,_ctrl.collabsResponded[index].id,false,
                              _ctrl.collabsResponded[index].responses[index2].id, _ctrl.collabsResponded[index].responses[index2].startTime
                              ,true
                          ));
                        },
                        child: _ctrl.collabsRespondedCards[index],
                      )
              ),
            ],
          ),
        )));
  }
}
