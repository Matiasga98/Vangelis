import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:faker/faker.dart';
import 'package:vangelis/util/constants.dart';

import '../../../../config/colors_.dart';
import '../../../../services/theme_service.dart';
import 'favorite_controller.dart';


class FavoriteScreen extends StatefulWidget {


  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _ctrl = Get.put(FavoriteController());
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
              Center(
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Text ("Tus musicos favoritos")
                ),
              ),
              ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _ctrl.musicianCards.length,
                      itemBuilder: (context, index) =>
                      GestureDetector(
                        onTap: () => _ctrl.navigateToProfileOfUserIndex(index),
                        child: _ctrl.musicianCards[index],
                      )
                    )
            ],
          ),
        )));
  }
}
