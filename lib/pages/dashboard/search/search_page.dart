import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:faker/faker.dart';
import 'package:vangelis/util/constants.dart';

import '../../../config/colors_.dart';
import 'card_widget.dart';
import '../../../services/theme_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = Get.put(SearchController());
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
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SvgPicture.asset(
                            "images/search.svg",
                            color: greenDark,
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
                                /*GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.white,
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        builder: (_) => StatefulBuilder(
                                              builder: (context, setState) =>
                                                  SingleChildScrollView(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        "Filtros",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: greenDark,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 15),
                                                      child: Divider(
                                                        color:
                                                            Color(0xffE1E7E7),
                                                        indent: 10,
                                                        endIndent: 10,
                                                        height: 1,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Edad",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: greenDark,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        const SizedBox(
                                                          width: 50,
                                                        ),
                                                        Container(
                                                          width: size.width / 2,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              color: greenTint1,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xffABC7C7))),
                                                          child: Row(
                                                            children: [
                                                              Material(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .transparent,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _ctrl
                                                                          .age--;
                                                                    });
                                                                  },
                                                                  splashColor:
                                                                      greenTint2,
                                                                  child: Ink(
                                                                    width: 30,
                                                                    height: 30,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        border: Border.all(
                                                                            color:
                                                                                const Color(0xffABC7C7))),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Color(
                                                                          0xff6B9696),
                                                                      size: 10,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: Align(
                                                                      child:
                                                                          FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                    "$_ctrl.age años"),
                                                              ))),
                                                              Material(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .transparent,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _ctrl
                                                                          .age++;
                                                                    });
                                                                  },
                                                                  splashColor:
                                                                      greenTint2,
                                                                  child: Ink(
                                                                    width: 30,
                                                                    height: 30,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        border: Border.all(
                                                                            color:
                                                                                const Color(0xffABC7C7))),
                                                                    child:
                                                                        const Icon(
                                                                      Icons.add,
                                                                      color: Color(
                                                                          0xff6B9696),
                                                                      size: 10,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 16),
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
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 15),
                                                      child: Divider(
                                                        color:
                                                            Color(0xffE1E7E7),
                                                        indent: 10,
                                                        endIndent: 10,
                                                        height: 1,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Sexo",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: greenDark,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 16),
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
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 7),
                                                      child: ElevatedButton(
                                                        onPressed: () {},
                                                        child: const Text(
                                                          "Aplicar Filtros",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 17),
                                                        ),
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                                        greenLight),
                                                            shape: MaterialStateProperty
                                                                .all(
                                                                    RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ))),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 7),
                                                      child: ElevatedButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          "Quitar Filtros",
                                                          style: TextStyle(
                                                              color: greenLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 17),
                                                        ),
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    Colors
                                                                        .white),
                                                            overlayColor:
                                                                MaterialStateProperty.all(
                                                                    greenLight
                                                                        .withOpacity(
                                                                            0.2)),
                                                            shape: MaterialStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                    side: BorderSide(
                                                                        color: greenLight)))),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Image.asset(
                                    "images/search.png",
                                  ),
                                ),*/
                              ]),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(maxHeight: 17, maxWidth: 50),
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
                      itemCount: _ctrl.filteredMusicians.length,
                      itemBuilder: (context, index) =>
                          _ctrl.filteredMusicians[index],
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

/*class SearchPage extends StatelessWidget {

  final _ctrl = Get.put(SearchController());
    @override
    Widget build(BuildContext context) {
      ThemeService().init(context);
      return Scaffold(
        appBar: AppBar(
          title: const Text("Buscar"),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                );
              },
              icon: const Icon(Icons.search)
            )
          ],
        ),
        body: Container(), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
}

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = [
    "Brazil",
    "China",
    "India",
    "Russia",
    "USA"
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back)
  );

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      onPressed: () {
        close(context, null);
        query = "";
      },
      icon: const Icon(Icons.clear)
    )
  ];

  @override
  Widget buildResults(BuildContext context) => Center(
    child: Text(
      query,
      style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)
    )
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}*/
