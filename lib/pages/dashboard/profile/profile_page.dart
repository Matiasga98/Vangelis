import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vangelis/helpers/custom_text.dart';
import 'package:vangelis/pages/dashboard/profile/profile_controller.dart';
import 'package:vangelis/util/constants.dart';

import '../../../helpers/dialog_buttons.dart';
import '../../../model/Genre.dart';
import '../../../model/Instrument.dart';
import '../../../model/musician.dart';
import '../../../services/theme_service.dart';

class ProfilePage extends StatefulWidget {
  Musician musician;

  ProfilePage(this.musician);

  @override
  _ProfilePageState createState() => _ProfilePageState(musician);
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  var listImage = [
    "https://i.pinimg.com/originals/aa/eb/7f/aaeb7f3e5120d0a68f1b814a1af69539.png",
    "https://cdn.fnmnl.tv/wp-content/uploads/2020/09/04145716/Stussy-FA20-Lookbook-D1-Mens-12.jpg",
    "https://www.propermag.com/wp-content/uploads/2020/03/0x0-19.9.20_18908-683x1024.jpg",
    "https://www.thefashionisto.com/wp-content/uploads/2013/07/w012-800x1200.jpg",
    "https://manofmany.com/wp-content/uploads/2016/09/14374499_338627393149784_1311139926468722688_n.jpg",
    "https://image-cdn.hypb.st/https%3A%2F%2Fhypebeast.com%2Fimage%2F2020%2F04%2Faries-fall-winter-2020-lookbook-first-look-14.jpg?q=75&w=800&cbr=1&fit=max",
    "https://i.pinimg.com/originals/95/0f/4d/950f4df946e0a373e47df37fb07ea1f9.jpg",
    "https://i.pinimg.com/736x/c4/03/c6/c403c63b8e1882b6f10c82f601180e2d.jpg",
  ];

  File? tempProfilePicture;
  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemp = File(image.path);
      tempProfilePicture = imageTemp;
      //setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      //print('Failed to pick image: $e');
    }
  }
  //final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  TabController? tabController;
  int selectedIndex = 0;

  final _ctrl = Get.put(ProfileController());

  Musician musician;

  _ProfilePageState(this.musician);

  @override
  Widget build(BuildContext context) {
    _ctrl.musician = musician;
    ThemeService().init(context);
    return Obx(() => _ctrl.isLoading.value
        ? Center(
            child: Image.asset(
              themeConfig!.loadingGif,
              height: 100,
              fit: BoxFit.cover,
              semanticLabel: barbriLogo,
            ),
          )
        : Scaffold(
            backgroundColor: themeConfig!.whiteBlackColor,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 30.0,
                            ),
                          ),
                          Text(
                            _ctrl.username.value,
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          _ctrl.isCurrentUser.value
                              ? PopupMenuButton(
                                  onSelected: (value) {
                                    _ctrl.optionsButtonClicked(value);
                                  },
                                  itemBuilder: (BuildContext bc) {
                                    return const [
                                      PopupMenuItem(
                                        value: 'fav',
                                        child: Text("Ver Favoritos"),
                                      ),
                                    ];
                                  },
                                )
                              : _ctrl.isFavorited.value
                                  ? IconButton(
                                      onPressed: () {
                                        _ctrl.removeUserFromFavorites();
                                      },
                                      icon: const Icon(
                                        Icons.star,
                                        size: 30.0,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        _ctrl.addUserToFavorites();
                                      },
                                      icon: const Icon(
                                        Icons.star_border,
                                        size: 30.0,
                                      ),
                                    ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70.0),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: _ctrl.profilePicture.value.image,
                          radius: 70.0,
                        ),
                        _ctrl.isCurrentUser.value
                            ? GenerateEditProfilePictureIcon()
                            : const SizedBox()
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 150.h,
                          width: 500.w,
                          child: GenerateInstrumentsList(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 150.h,
                          width: 500.w,
                          child: GenerateGenresList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.transparent,
                              ),
                              primary: Colors.blue,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              fixedSize: const Size(50.0, 60.0)),
                          child: const Icon(
                            Icons.telegram_rounded,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.transparent,
                              ),
                              primary: Colors.green,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              fixedSize: const Size(50.0, 60.0)),
                          child: const Icon(Icons.whatsapp_rounded),
                        ),
                        SizedBox(width: 15.w),
                        OutlinedButton(
                          onPressed: () {
                            _ctrl.handleSignIn();
                          },
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.transparent,
                              ),
                              primary: Colors.red,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              fixedSize: const Size(50.0, 60.0)),
                          child: const Icon(Icons.youtube_searched_for),
                        )
                      ],
                    ),
                    Container(
                      height: 30.h,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              'Sobre ${_ctrl.username.value}',
                              fontSize: 30.h,
                            ), // <-- Text
                            !_ctrl.isCurrentUser.value
                                ? const SizedBox()
                                : OutlinedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Editar descripción'),
                                            content: TextFormField(
                                                controller:
                                                    _ctrl.descriptionController,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      270),
                                                ]),
                                            actions: [
                                              DialogButtons(
                                                  onCancel: () => {
                                                        Navigator.pop(
                                                            context, false),
                                                        _ctrl
                                                            .onCancelEditDescription()
                                                      },
                                                  onOk: () => {
                                                        //TODO: Cambiar esto para que se controle con algún validador y sino es valido que alerte
                                                        if (_ctrl
                                                                .descriptionController
                                                                .text !=
                                                            "")
                                                          {
                                                            _ctrl
                                                                .updateDescription(),
                                                            Navigator.pop(
                                                                context, true)
                                                          }
                                                      },
                                                  okButtonText: "Aceptar",
                                                  cancelButtonText: "Cancelar"),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size.zero, // Set this
                                      padding: EdgeInsets.zero, // and this
                                      side: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          // <-- Icon
                                          Icons.edit,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                        Container(
                          height: 30.h,
                        ),
                        SizedBox(
                          height: 200.h,
                          width: 600.w,
                          child: CustomText(
                            _ctrl.description.value,
                            fontSize: 25.h,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TabBar(
                            isScrollable: true,
                            controller: tabController,
                            indicator: const BoxDecoration(
                                borderRadius: BorderRadius.zero),
                            labelColor: Colors.black,
                            labelStyle: const TextStyle(
                                fontSize: 28.0, fontWeight: FontWeight.bold),
                            unselectedLabelColor: Colors.black26,
                            onTap: (tapIndex) {
                              setState(() {
                                selectedIndex = tapIndex;
                              });
                            },
                            tabs: const [
                              Tab(text: "Fotos"),
                              Tab(text: "Videos"),
                              Tab(text: "Audios"),
                              Tab(text: "Colaboraciones"),
                            ],
                          ),
                        ),
                        SizedBox(width: 50.w),
                        PopupMenuButton(
                          onSelected: (value) {
                            // your logic
                          },
                          itemBuilder: (BuildContext bc) {
                            return const [
                              PopupMenuItem(
                                value: '/hello',
                                child: Text("Hello"),
                              ),
                              PopupMenuItem(
                                value: '/about',
                                child: Text("About"),
                              ),
                              PopupMenuItem(
                                value: '/contact',
                                child: Text("Contact"),
                              )
                            ];
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 5000.w,
                      height: 500.h,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: tabController,
                        children: [
                          GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: 250.0, crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                      image: NetworkImage(listImage[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 37.0,
                                        right: 37.0,
                                        top: 185.0,
                                        bottom: 15.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: const Text("1.234k"),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: 8,
                          ),
                          Center(
                            child:
                          GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: 250.0, crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              if (index < _ctrl.selectedUserVideos.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _ctrl.loadVideo(index).then((value) =>
                                          showDialog(
                                            context: context,
                                            builder: (context) {

                                              return _ctrl.openVideo(index);
                                            },
                                          )
                                      );

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        image: DecorationImage(
                                          image: NetworkImage(_ctrl
                                              .selectedUserVideos[index]
                                              .snippet!
                                              .thumbnails!
                                              .high!
                                              .url!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else if (_ctrl.isCurrentUser.value) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
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
                                                                    })
                                                        )
                                                    )
                                                );
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
                                );
                              } else {
                                return Container();
                              }
                            },
                            itemCount: _ctrl.selectedUserVideos.length + 1,
                          )),
                            Center(
                              child: Text("You don't have any tagged"),
                            ),
                            Center(
                              child: Text("You don't have any tagged"),
                            ),
                          ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://free2music.com/images/singer/2019/02/10/troye-sivan_2.jpg"),
                      radius: 70.0,
                    ),
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://free2music.com/images/singer/2019/02/10/troye-sivan_2.jpg"),
                      radius: 70.0,
                    ),
                  ],
                ),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ));
  }

  Widget GenerateInstrumentsList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              width: 110.w,
              child: Column(
                children: [
                  index < _ctrl.instruments.length
                      ? _ctrl.instruments[index].imageFromBase64String()
                      : _ctrl.isCurrentUser.value &&
                              _ctrl.filteredPossibleInstruments.isNotEmpty
                          ? OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Agregar instrumento'),
                                      content: GenerateDropdownInstrument(),
                                      actions: [
                                        DialogButtons(
                                            onCancel: () => {
                                                  Navigator.pop(context, false),
                                                },
                                            onOk: () => {
                                                  _ctrl
                                                      .addInstrumentToFavorites(),
                                                  Navigator.pop(context, true)
                                                },
                                            okButtonText: "Aceptar",
                                            cancelButtonText: "Cancelar"),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  primary: Colors.green,
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  fixedSize: const Size(10.0, 20.0)),
                              child: const Icon(
                                Icons.add,
                              ),
                            )
                          : const SizedBox(),
                  index < _ctrl.instruments.length
                      ? CustomText(_ctrl.instruments.value[index].name)
                      : const SizedBox()
                ],
              ),
            ),
            _ctrl.isCurrentUser.value &&
                    index < _ctrl.instruments.length &&
                    _ctrl.instruments.length > 1
                ? Positioned(
                    top: -14,
                    right: -14,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Eliminar instrumento'),
                              content: CustomText(
                                  "¿Está seguro de que desea eliminar ${_ctrl.instruments.value[index].name} de su lista de instrumentos?"),
                              actions: [
                                DialogButtons(
                                    onCancel: () => {
                                          Navigator.pop(context, false),
                                        },
                                    onOk: () => {
                                          _ctrl.removeInstrument(index),
                                          Navigator.pop(context, true)
                                        },
                                    okButtonText: "Aceptar",
                                    cancelButtonText: "Cancelar"),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.red,
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        );
      },
      itemCount: _ctrl.instruments.value.length + 1,
    );
  }

  Widget GenerateDropdownInstrument() {
    //Instrument instrumentToAdd = _ctrl.instrumentToAdd;
    return DropdownButtonFormField<Instrument>(
      value: _ctrl.instrumentToAdd,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (Instrument? value) {
        // This is called when the user selects an item.
        setState(() {
          //instrumentToAdd = value!;
          _ctrl.instrumentToAdd = value!;
        });
      },
      onSaved: (Instrument? value) {
        // This is called when the user selects an item.
        setState(() {
          //instrumentToAdd = value!;
          _ctrl.instrumentToAdd = value!;
        });
      },
      items: _ctrl.filteredPossibleInstruments
          .map<DropdownMenuItem<Instrument>>((Instrument instrument) {
        return DropdownMenuItem<Instrument>(
          value: instrument,
          child: Text(instrument.name),
        );
      }).toList(),
    );
  }

  Widget GenerateGenresList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              width: 110.w,
              child: Column(
                children: [
                  index < _ctrl.genres.length
                      ? _ctrl.genres[index].imageFromBase64String()
                      : _ctrl.isCurrentUser.value &&
                              _ctrl.filteredPossibleGenres.isNotEmpty
                          ? OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Agregar genero'),
                                      content: GenerateDropdownGenre(),
                                      actions: [
                                        DialogButtons(
                                            onCancel: () => {
                                                  Navigator.pop(context, false),
                                                },
                                            onOk: () => {
                                                  _ctrl.addGenreToFavorites(),
                                                  Navigator.pop(context, true)
                                                },
                                            okButtonText: "Aceptar",
                                            cancelButtonText: "Cancelar"),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  primary: Colors.green,
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  fixedSize: const Size(10.0, 20.0)),
                              child: const Icon(
                                Icons.add,
                              ),
                            )
                          : const SizedBox(),
                  index < _ctrl.genres.length
                      ? CustomText(_ctrl.genres.value[index].name)
                      : const SizedBox()
                ],
              ),
            ),
            _ctrl.isCurrentUser.value &&
                    index < _ctrl.genres.length &&
                    _ctrl.genres.length > 1
                ? Positioned(
                    top: -14,
                    right: -14,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Eliminar genero'),
                              content: CustomText(
                                  "¿Está seguro de que desea eliminar ${_ctrl.genres.value[index].name} de su lista de generos?"),
                              actions: [
                                DialogButtons(
                                    onCancel: () => {
                                          Navigator.pop(context, false),
                                        },
                                    onOk: () => {
                                          _ctrl.removeGenre(index),
                                          Navigator.pop(context, true)
                                        },
                                    okButtonText: "Aceptar",
                                    cancelButtonText: "Cancelar"),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.red,
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        );
      },
      itemCount: _ctrl.genres.value.length + 1,
    );
  }

  Widget GenerateDropdownGenre() {
    //Genre genreToAdd = _ctrl.genreToAdd;
    return DropdownButtonFormField<Genre>(
      value: _ctrl.genreToAdd,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (Genre? value) {
        // This is called when the user selects an item.
        setState(() {
          //genreToAdd = value!;
          _ctrl.genreToAdd = value!;
        });
      },
      onSaved: (Genre? value) {
        // This is called when the user selects an item.
        setState(() {
          //genreToAdd = value!;
          _ctrl.genreToAdd = value!;
        });
      },
      items: _ctrl.filteredPossibleGenres
          .map<DropdownMenuItem<Genre>>((Genre genre) {
        return DropdownMenuItem<Genre>(
          value: genre,
          child: Text(genre.name),
        );
      }).toList(),
    );
  }

  Widget GenerateEditProfilePictureIcon() {
    //File? tempProfilePicture = _ctrl.tempProfilePicture;

    return Positioned(
      top: -0,
      right: -0,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Container(
                  width: 110.w,
                  height: 50.h,
                  child: AlertDialog(
                    title: const Text('Actualizar foto'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                pickImage(ImageSource.gallery);
                              },
                              icon: const Icon(
                                Icons.collections,
                                size: 30.0,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                //_ctrl.pickImage(ImageSource.camera);
                              },
                              icon: const Icon(
                                Icons.photo_camera,
                                size: 30.0,
                              ),
                            )
                          ],
                        ),
                        tempProfilePicture != null
                            ? CircleAvatar(
                                backgroundImage:
                                    Image.file(tempProfilePicture!).image,
                                radius: 70.0,
                              )
                            : const CircleAvatar(
                                radius: 70.0,
                              ),
                      ],
                    ),
                    actions: [
                      DialogButtons(
                          onCancel: () => {
                                Navigator.pop(context, false),
                              },
                          onOk: () => {
                                _ctrl.updateProfilePicture(),
                                Navigator.pop(context, true)
                              },
                          okButtonText: "Aceptar",
                          cancelButtonText: "Cancelar"),
                    ],
                  ));
            },
          );
        },
        style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Colors.black12,
            ),
            primary: Colors.blue,
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            fixedSize: const Size(10.0, 20.0)),
        child: const Icon(
          Icons.edit,
        ),
      ),
    );
  }
/*
  Future pickImage(File? imageTMP, ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imageTMP = imageTemp);
    } on PlatformException catch (e) {
      //print('Failed to pick image: $e');
    }
  }*/
}
