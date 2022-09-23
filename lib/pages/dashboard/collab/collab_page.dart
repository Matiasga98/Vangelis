import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () => {

        },
      ),
        backgroundColor: themeConfig!.whiteBlackColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: size.width * 0.9,
                  child: TextFormField(
                    controller: _ctrl.textFilterController,
                    cursorColor: greenMed,
                    enableSuggestions: true,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "Buscar por Nombre",
                        filled: true,
                        alignLabelWithHint: true,
                        fillColor: const Color(0xffDCEBEA),
                        hintStyle: TextStyle(fontSize: 15, color: greenDark),
                        prefixIcon: SizedBox(
                          child: Row(
                            children: [IconButton(
                              onPressed: () {
                                _ctrl.closeContext();
                              },
                              icon: Icon(Icons.search_rounded, size: 25),
                              color: greenDark
                            )],
                          ),
                        ),
                        suffixIcon: SizedBox(
                          width: 165.w,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _ctrl.closeContext();
                                    },
                                    icon: const Icon(Icons.clear)),
                              ]),
                        ),
                        prefixIconConstraints:
                        const BoxConstraints(maxWidth: 50),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        prefixStyle: TextStyle(color: greenDark),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide.none)),
                  ),
                ),
              ),
              _ctrl.searchState.isTrue
                  ? ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: _ctrl.filteredCollabs.length,
                itemBuilder: (context, index) =>
                _ctrl.filteredCollabs[index],
              )
                  : Column(
                children: [
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
                            _ctrl.instruments.length,
                                (index) => IntrinsicWidth(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_ctrl.selectedInstruments
                                        .contains(
                                        _ctrl.instruments[index])) {
                                      _ctrl.selectedInstruments.remove(
                                          _ctrl.instruments[index]);
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
                                    _ctrl.instruments[index],
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
                              _ctrl.musicalGenres.length,
                                  (index) => IntrinsicWidth(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_ctrl.selectedGenres.contains(
                                          _ctrl.musicalGenres[index])) {
                                        _ctrl.selectedGenres.remove(
                                            _ctrl.musicalGenres[index]);
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
                                            _ctrl.musicalGenres[index])
                                            ? greenLight
                                            : greenTint1,
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _ctrl.musicalGenres[index],
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
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 16, horizontal: size.width * 0.075),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sexo",
                      style: TextStyle(
                          color: greenDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                      height: 50.h,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 12,
                          runAlignment:
                          WrapAlignment.start,
                          alignment:
                          WrapAlignment.start,
                          crossAxisAlignment:
                          WrapCrossAlignment
                              .start,
                          children: [
                            IntrinsicWidth(
                              child:
                              GestureDetector(
                                onTap: () {
                                  setState(
                                        () {
                                      _ctrl.selectedGender =
                                      "Masculino";
                                    },
                                  );
                                },
                                child: Container(
                                    height: 30,
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal:
                                        32),
                                    decoration: BoxDecoration(
                                        color: "Masculino" ==
                                            _ctrl
                                                .selectedGender
                                            ? greenLight
                                            : greenTint1,
                                        borderRadius:
                                        BorderRadius.circular(
                                            15)),
                                    alignment:
                                    Alignment
                                        .center,
                                    child: Text(
                                      "Masculino",
                                      style: TextStyle(
                                          color: "Masculino" == _ctrl.selectedGender
                                              ? Colors
                                              .white
                                              : Colors
                                              .black,
                                          fontWeight:
                                          FontWeight.w500),
                                    )),
                              ),
                            ),
                            IntrinsicWidth(
                              child:
                              GestureDetector(
                                onTap: () {
                                  setState(
                                        () {
                                      _ctrl.selectedGender =
                                      "Femenino";
                                    },
                                  );
                                },
                                child: Container(
                                    height: 30,
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal:
                                        32),
                                    decoration: BoxDecoration(
                                        color: "Femenino" ==
                                            _ctrl
                                                .selectedGender
                                            ? greenLight
                                            : greenTint1,
                                        borderRadius:
                                        BorderRadius.circular(
                                            15)),
                                    alignment:
                                    Alignment
                                        .center,
                                    child: Text(
                                      "Femenino",
                                      style: TextStyle(
                                          color: "Femenino" == _ctrl.selectedGender
                                              ? Colors
                                              .white
                                              : Colors
                                              .black,
                                          fontWeight:
                                          FontWeight.w500),
                                    )),
                              ),
                            ),
                          ],
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
                      "Edad",
                      style: TextStyle(
                          color: greenDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                      height: 200.h,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 12,
                          runAlignment:
                          WrapAlignment.start,
                          alignment:
                          WrapAlignment.start,
                          crossAxisAlignment:
                          WrapCrossAlignment
                              .start,
                          children: List.generate(
                              _ctrl.ageRange
                                  .length,
                                  (index) =>
                                  IntrinsicWidth(
                                    child:
                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                              () {
                                            _ctrl.selectedAge =
                                                index;
                                          },
                                        );
                                      },
                                      child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(color: index == _ctrl.selectedAge ? greenLight : greenTint1, borderRadius: BorderRadius.circular(15)),
                                          alignment: Alignment.center,
                                          child: Text(
                                            _ctrl.ageRange[
                                            index],
                                            style: TextStyle(
                                                color: index == _ctrl.selectedAge ? Colors.white : Colors.black,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ),
                                  )),
                        ),
                      )),
                  Container(
                    width: size.width * 0.9,
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _ctrl.openContext();
                        });
                      },
                      child: const Text(
                        "Buscar",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(greenLight),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                    ),
                  ),
                  Container(
                    width: size.width * 0.9,
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _ctrl.selectedInstruments.clear();
                          _ctrl.selectedAge = 0;
                          _ctrl.selectedGender = "Masculino";
                          _ctrl.selectedDistance = 0;
                          _ctrl.age = 0;
                          _ctrl.distance = 0;
                        });
                      },
                      child: Text(
                        "Quitar Filtros",
                        style: TextStyle(
                            color: greenLight,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.white),
                          overlayColor: MaterialStateProperty.all(
                              greenLight.withOpacity(0.2)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  side: BorderSide(color: greenLight)))),
                    ),
                  )
                ],
              )
            ],
          ),
        )));
  }
}