import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/entity/user.dart';
import 'package:vangelis/helpers/card_widget.dart';
import 'package:vangelis/model/Genre.dart';
import 'package:vangelis/model/Instrument.dart';
import 'package:vangelis/model/musician.dart';
import 'package:vangelis/pages/dashboard/profile/profile_controller.dart';
import 'package:vangelis/pages/dashboard/profile/profile_page.dart';
import 'package:vangelis/pages/dashboard/search/search_page.dart';
import 'package:vangelis/services/instrument_service.dart';
import 'package:vangelis/services/user_service.dart';



class FavoriteController extends GetxController {
  var textFilterController = TextEditingController();
  RxBool searchState = false.obs;


  RxList<MusicianCard> musicianCards = List<MusicianCard>.empty().obs;
  List<Musician> musicians = [];

  UserService userService = Get.find();

  @override
  Future<void> onReady() async {
    if(User().environment !="MOBILE"){
      musicians = await userService.getFavorites(User().id);

      for (Musician musician in musicians){
        musicianCards.add(MusicianCard(finalImage: musician.userAvatar??"", name: musician.userName,
            description: musician.instruments[0].name ?? "", address: musician.favoriteGenres[0].name ?? "",
            instruments: musician.instruments.map((a)=>a.name).toList(),
            genres: musician.favoriteGenres.map((a)=>a.name).toList()));
      }

    }
    super.onReady();
  }

  void navigateToProfileOfUserIndex(int index){
    Get.delete<ProfileController>();
    Get.to(() =>ProfilePage(musicians[index]));
  }

}
