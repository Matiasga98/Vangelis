import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:faker/faker.dart';
import 'package:vangelis/util/constants.dart';

import '../../../config/colors_.dart';
import '../../../services/theme_service.dart';
import 'collab_controller.dart';

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
