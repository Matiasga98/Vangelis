import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/config/colors_.dart';
import 'package:vangelis/helpers/custom_button.dart';
import 'package:vangelis/helpers/custom_text_field.dart';
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
        backgroundColor: themeConfig!.whiteBlackColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CustomTextField(
                keyValue: "title",
                fontSize: 26.h,
                hint: "titulo",
                label: "titulo",
                textEditingController: _ctrl.titleController,
              ),
              SizedBox(height: 30.h),
              CustomTextField(
                keyValue: "description",
                fontSize: 26.h,
                hint: "descripcion",
                label: "descripcion",
                textEditingController: _ctrl.descriptionController,
              ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 16, horizontal: size.width * 0.075),
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
                      height: 220.h,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 12,
                          runAlignment: WrapAlignment.start,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: List.generate(
                            _ctrl.instruments.value.length,
                                (index) => IntrinsicWidth(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_ctrl.selectedInstruments
                                        .contains(
                                        _ctrl.instruments.value[index])) {
                                      _ctrl.selectedInstruments.remove(
                                          _ctrl.instruments.value[index]);
                                    } else {
                                      _ctrl.selectedInstruments
                                          .add(_ctrl.instruments[index]);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                      color: _ctrl.selectedInstruments
                                          .contains(_ctrl
                                          .instruments[index])
                                          ? greenLight
                                          : greenTint1,
                                      borderRadius:
                                      BorderRadius.circular(15)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _ctrl.instruments.value[index],
                                    style: TextStyle(
                                        color: _ctrl.selectedInstruments
                                            .contains(_ctrl
                                            .instruments[index])
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500),
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
                        vertical: 16, horizontal: size.width * 0.075),
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
                      height: 220.h,
                      child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 12,
                            runAlignment: WrapAlignment.start,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: List.generate(
                              _ctrl.musicalGenres.value.length,
                                  (index) => IntrinsicWidth(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_ctrl.selectedGenres.contains(
                                          _ctrl.musicalGenres.value[index])) {
                                        _ctrl.selectedGenres.remove(
                                            _ctrl.musicalGenres.value[index]);
                                      } else {
                                        _ctrl.selectedGenres
                                            .add(_ctrl.musicalGenres[index]);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                        color: _ctrl.selectedGenres.contains(
                                            _ctrl.musicalGenres.value[index])
                                            ? greenLight
                                            : greenTint1,
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _ctrl.musicalGenres.value[index],
                                      style: TextStyle(
                                          color: _ctrl.selectedGenres
                                              .contains(_ctrl
                                              .musicalGenres[index])
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))),
                  const SizedBox(
                    height: 16,
                  ),
              GestureDetector(
                onTap: () {
                  _ctrl
                      .openVideos()
                      .then((value) => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text(
                                'Select a video to add to profile'),
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
                                              onTap: () =>
                                                  _ctrl.addVideoToSelected(index),
                                              child: Padding(
                                                  padding: const EdgeInsets.all(60.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      image: DecorationImage(
                                                        image: NetworkImage(_ctrl.userVideos[index].snippet!.thumbnails!.high!.url!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 100.0, right: 100.0, top: 1.0, bottom: 1.0),
                                                    ),
                                                  )));
                                        }))));
                      }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius:
                    BorderRadius.circular(20.0),
                  ),
                  child: Icon(Icons.add),
                ),
              ),


              _ctrl.videoSelected.value?Container(
                height: 200.h,
                width: 300.w,
                child: Image(
                  image: NetworkImage(_ctrl.selectedUserVideo.value.snippet!.thumbnails!.high!.url!),
                ),

              ):Container(),
              CustomButton(
                label: "Crear Collab",
                onTap: () {_ctrl.createCollab(); },
              )
            ],
              )

          ),
        ));
  }
}
