import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/util/constants.dart';

import '../../../entity/user.dart';
import '../../../model/Genre.dart';
import '../../../model/Instrument.dart';
import '../../../model/musician.dart';
import '../../../services/theme_service.dart';

class ProfileController extends GetxController {

  late Musician musician;

  RxString description = "texto".obs;
  final descriptionController = TextEditingController();
  RxList<Instrument> instruments = <Instrument>[].obs;
  RxList<Genre> genres = <Genre>[].obs;
  Rx<Image> profilePicture = Image(image: AssetImage("images/Indio Diego.png")).obs;
  RxString username = "".obs;
  RxBool isLoading = true.obs;
  RxBool isCurrentUser = true.obs;

  @override
  void onReady() {

    getProfileInfo();
    super.onReady();
  }

  Future<void> getProfileInfo() async {
    if(musician.id != User().id){
      isCurrentUser.value = false;
    }
    else{
      isCurrentUser.value = true;
    }
    instruments.value = musician.instruments;
    genres.value = musician.favoriteGenres;
    profilePicture.value = musician.imageFromUserBase64String();
    username.value = musician.userName;
    description.value = musician.bio;
    await Future.delayed(Duration(milliseconds: 1000), () async {
      isLoading.value = false;
    });

  }


  void updateDescription() {
    description.value = descriptionController.text;
    musician.bio = description.value;
    //todo: llamar al back para editarla
  }

  void onCancel(){
    descriptionController.text = description.value;
  }


}
