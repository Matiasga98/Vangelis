import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/config/colors_.dart';
import 'package:vangelis/pages/dashboard/collab/collabSearch/collabSearch_controller.dart';
import 'package:vangelis/pages/dashboard/collab/collabUser/collabUser_controller.dart';
import 'package:vangelis/pages/dashboard/collab/createCollab/create_collab_page.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/collab/collab_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:faker/faker.dart';
import 'package:vangelis/pages/dashboard/video/video_page.dart';
import 'package:vangelis/services/theme_service.dart';
import 'package:vangelis/util/constants.dart';

class CollabUserScreen extends StatefulWidget {
  const CollabUserScreen({Key? key}) : super(key: key);

  @override
  State<CollabUserScreen> createState() => _CollabUserScreenState();
}

class _CollabUserScreenState extends State<CollabUserScreen> {
  final _ctrl = Get.put(CollabUserController());
  Faker faker = Faker();

  @override
  Widget build(BuildContext context) {
    ThemeService().init(context);
    Size size = MediaQuery.of(context).size;

    return Obx(() => Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () => {
            Get.to(() => CreateCollabScreen())
        },
      ),
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
                itemCount: _ctrl.filteredCollabCards.length,
                itemBuilder: (context, index) =>
                GestureDetector(
                  onTap: () => {
                    _ctrl.loadVideo(index).then((value) =>
                    showDialog(context: context, builder: (context){
                      return _ctrl.openVideo(index);
                    })).then((value) => _ctrl.unloadVideo())
                  },
                  child: _ctrl.filteredCollabCards[index],
                )
              ),
            ],
          ),
        )));
  }
}
