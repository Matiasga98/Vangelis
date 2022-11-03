import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/config/colors_.dart';
import 'package:vangelis/pages/dashboard/collab/collabSearch/collabSearch_controller.dart';
import 'package:vangelis/pages/dashboard/collab/createCollab/create_collab_page.dart';
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


class CollabSearchScreen extends StatefulWidget {
  const CollabSearchScreen({Key? key}) : super(key: key);

  @override
  State<CollabSearchScreen> createState() => _CollabSearchScreenState();
}

class _CollabSearchScreenState extends State<CollabSearchScreen> {
  final _ctrl = Get.put(CollabSearchController());
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
              _ctrl.searchState.isTrue
                  ?
              Column(children: [
                Container(alignment: Alignment.centerLeft,
                  child:  IconButton(
                      onPressed:() {_ctrl.returnToSearch();},
                      icon: Icon(Icons.arrow_back)),
                ),
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

                )
              ],)

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
