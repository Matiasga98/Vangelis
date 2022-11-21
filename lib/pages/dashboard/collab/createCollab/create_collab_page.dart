import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/config/colors_.dart';
import 'package:vangelis/helpers/custom_button.dart';
import 'package:vangelis/helpers/custom_text_field.dart';
import 'package:vangelis/helpers/secondary_button.dart';
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
import 'package:vangelis/util/enums.dart';

import 'create_collab_controller.dart';

class CreateCollabScreen extends StatefulWidget {
  const CreateCollabScreen({Key? key}) : super(key: key);

  @override
  State<CreateCollabScreen> createState() => _CreateCollabScreenState();
}

class _CreateCollabScreenState extends State<CreateCollabScreen> {
  final _ctrl = Get.put(CreateCollabController());
  Faker faker = Faker();

  @override
  Widget build(BuildContext context) {
    ThemeService().init(context);
    Size size = MediaQuery.of(context).size;
    _ctrl.openContext();

    return Obx(() => Scaffold(
        backgroundColor: themeConfig!.blueColor,
        body: SingleChildScrollView(
            child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Stack(children: [
                  Image.asset(
                    themeConfig!.bgBlueAsset,
                    fit: BoxFit.cover,
                    height: Get.height,
                    width: Get.width,
                  ),
                  Center(
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Container(
                            color: themeConfig!.whiteBlackColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 50.h, horizontal: 50.w),
                            margin: EdgeInsets.symmetric(horizontal: 30.w),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    keyValue: "title",
                                    fontSize: 26.h,
                                    hint: "titulo",
                                    label: "",
                                    textEditingController:
                                        _ctrl.titleController,
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomTextField(
                                    keyValue: "description",
                                    fontSize: 26.h,
                                    hint: "descripcion",
                                    label: "",
                                    textEditingController:
                                        _ctrl.descriptionController,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: size.width * 0.075),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Instrumentos",
                                      style: TextStyle(
                                          color: greenDark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 180.h,
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 12,
                                          runAlignment: WrapAlignment.start,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          children: List.generate(
                                            _ctrl.instruments.value.length,
                                            (index) => IntrinsicWidth(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (_ctrl
                                                        .selectedInstruments
                                                        .contains(_ctrl
                                                            .instruments
                                                            .value[index])) {
                                                      _ctrl.selectedInstruments
                                                          .remove(_ctrl
                                                              .instruments
                                                              .value[index]);
                                                    } else {
                                                      _ctrl.selectedInstruments
                                                          .add(
                                                              _ctrl.instruments[
                                                                  index]);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: 30,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16),
                                                  decoration: BoxDecoration(
                                                      color: _ctrl
                                                              .selectedInstruments
                                                              .contains(_ctrl
                                                                      .instruments[
                                                                  index])
                                                          ? greenLight
                                                          : greenTint1,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    _ctrl.instruments
                                                        .value[index],
                                                    style: TextStyle(
                                                        color: _ctrl
                                                                .selectedInstruments
                                                                .contains(_ctrl
                                                                        .instruments[
                                                                    index])
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: size.width * 0.075),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Genero Musical",
                                      style: TextStyle(
                                          color: greenDark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 160.h,
                                      child: SingleChildScrollView(
                                          child: Wrap(
                                        spacing: 6,
                                        runSpacing: 12,
                                        runAlignment: WrapAlignment.start,
                                        alignment: WrapAlignment.start,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        children: List.generate(
                                          _ctrl.musicalGenres.value.length,
                                          (index) => IntrinsicWidth(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (_ctrl.selectedGenres
                                                      .contains(_ctrl
                                                          .musicalGenres
                                                          .value[index])) {
                                                    _ctrl.selectedGenres.remove(
                                                        _ctrl.musicalGenres
                                                            .value[index]);
                                                  } else {
                                                    _ctrl.selectedGenres.add(
                                                        _ctrl.musicalGenres[
                                                            index]);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 30,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                decoration: BoxDecoration(
                                                    color: _ctrl.selectedGenres
                                                            .contains(_ctrl
                                                                .musicalGenres
                                                                .value[index])
                                                        ? greenLight
                                                        : greenTint1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _ctrl.musicalGenres
                                                      .value[index],
                                                  style: TextStyle(
                                                      color: _ctrl
                                                              .selectedGenres
                                                              .contains(_ctrl
                                                                      .musicalGenres[
                                                                  index])
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  SecondaryButton(
                                      onPress: () {
                                        _ctrl
                                            .openVideos()
                                            .then((value) => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text(
                                                          'Elegir video a utilizar'),
                                                      content: Obx(() =>
                                                          Container(
                                                              height: 500.h,
                                                              width: 500.w,
                                                              child: ListView
                                                                  .builder(
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemCount: _ctrl
                                                                          .userVideos
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return GestureDetector(
                                                                            onTap: () {
                                                                              _ctrl.addVideoToSelected(index);
                                                                              Get.back();
                                                                            },
                                                                            child: Container(
                                                                              padding: EdgeInsets.all(10.0),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  border: Border.all(color: Colors.black),
                                                                                ),
                                                                                child: Image.network(
                                                                                  _ctrl.userVideos[index].snippet!.thumbnails!.high!.url!,
                                                                                ),
                                                                              ),
                                                                            ));
                                                                      }))));
                                                }));
                                      },
                                      buttonText: "  Elegir video  "),
                                  _ctrl.videoSelected.value
                                      ? Container(
                                          height: 200.h,
                                          width: 300.w,
                                          child: Image(
                                            image: NetworkImage(_ctrl
                                                .selectedUserVideo
                                                .value
                                                .snippet!
                                                .thumbnails!
                                                .high!
                                                .url!),
                                          ),
                                        )
                                      : Container(
                                          height: 200.h,
                                          width: 300.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                          ),
                                        ),
                                  SizedBox(height: 10.h),
                                  _ctrl.videoSelected.value
                                      ? CustomButton(
                                          label: "Crear Collab",
                                          onTap: () {
                                            _ctrl.createCollab().then((value) {
                                              if (value) {
                                                Get.back();
                                                showMsg(
                                                    message:
                                                        "Collab creado exitosamente",
                                                    type: MessageType.success);
                                              } else {
                                                showMsg(
                                                    message:
                                                        "error creando collab",
                                                    type: MessageType.error);
                                              }
                                            });
                                          },
                                        )
                                      : Container()
                                ]))
                      ]))
                ])))));

  }
}
