import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vangelis/helpers/custom_text.dart';
import 'package:vangelis/pages/dashboard/profile/profile_controller.dart';
import 'package:vangelis/util/constants.dart';
import '../../../helpers/dialog_buttons.dart';
import '../../../model/Genre.dart';
import '../../../model/Instrument.dart';
import '../../../model/musician.dart';
import '../../../services/theme_service.dart';
import '../video/video_page.dart';

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
    "https://www.propermag.com/wp-content/uploads/2020/03/0x0-19.9.20_18908-683x1024.jpg",
    "https://manofmany.com/wp-content/uploads/2016/09/14374499_338627393149784_1311139926468722688_n.jpg",
    "https://image-cdn.hypb.st/https%3A%2F%2Fhypebeast.com%2Fimage%2F2020%2F04%2Faries-fall-winter-2020-lookbook-first-look-14.jpg?q=75&w=800&cbr=1&fit=max",
    "https://i.pinimg.com/originals/95/0f/4d/950f4df946e0a373e47df37fb07ea1f9.jpg",
    "https://i.pinimg.com/736x/c4/03/c6/c403c63b8e1882b6f10c82f601180e2d.jpg",
  ];

  File? previewPicture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  TabController? tabController;
  int selectedIndex = 0;

  final _ctrl = Get.put(ProfileController());

  Musician musician;

  _ProfilePageState(this.musician);

  String whatsappUrlBase = "whatsapp://send?phone=";
  String mailUrlBase = "mailto:";

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
                            : const SizedBox(),
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
                          onPressed: () {
                            !_ctrl.isCurrentUser.value
                                ? _launchUrl(whatsappUrlBase +
                                    _ctrl.musician.phoneNumber +
                                    "&text=" +
                                    _ctrl.greetingMessage!)
                                : EditPhoneNumberModal();
                          },
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
                            !_ctrl.isCurrentUser.value
                                ? _launchUrl(mailUrlBase +
                                    _ctrl.musician.email +
                                    "?subject=¡Busco músico!&body=" +
                                    _ctrl.greetingMessage!)
                                : EditEmailModal();
                          },
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
                            Icons.mail_rounded,
                          ),
                        ),
                        SizedBox(width: 15.w),

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
                              Tab(text: "Colaboraciones"),
                            ],
                          ),
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
                          ViewPhotos(),
                          ViewVideos(),
                          ViewCollabs(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ));
  }

  Widget ViewCollabs() {
    return Center(
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 250.0, crossAxisCount: 3),
          itemBuilder: (context, index) {
            return ShowCollabRectangle(index);
          },
          itemCount: _ctrl.collabs.length,
        ));
  }

  Widget ShowCollabRectangle(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Get.to(VideoScreen(_ctrl.collabs.values.elementAt(index).videoId,
            _ctrl.collabs.keys.elementAt(index).videoId,
            _ctrl.collabs.values.elementAt(index).id,
            false,
            _ctrl.collabs.keys.elementAt(index).id,
            _ctrl.collabs.keys.elementAt(index).startTime
            ,true)),
        child: Stack(children: [
          CollabThumbnail(index),
        ]),
      ),
    );
  }

  Widget ViewVideos() {
    return Center(
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 250.0, crossAxisCount: 3),
          itemBuilder: (context, index) {
            if (index < _ctrl.selectedUserVideos.length) {
              return ShowVideoRectangle(index);
            } else if (_ctrl.isCurrentUser.value) {
              return AddVideoOption();
            }
            return Container();
          },
          itemCount: _ctrl.selectedUserVideos.length + 1,
        ));
  }

  Widget ShowVideoRectangle(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _ctrl.loadVideo(index).then((value) => showDialog(
                context: context,
                builder: (context) {
                  return _ctrl.openVideo(index);
                },
              ));
        },
        child: Stack(children: [
          VideoThumbnail(index),
          RemoveVideoOption(index),
        ]),
      ),
    );
  }

  Widget RemoveVideoOption(int index) {
    return _ctrl.isCurrentUser.value
        ? Positioned(
            top: -14,
            right: -14,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Eliminar Video'),
                      content: CustomText(
                          "¿Está seguro de que desea eliminar este video?"),
                      actions: [
                        DialogButtons(
                            onCancel: () => {
                                  Navigator.pop(context, false),
                                },
                            onOk: () => {
                                  _ctrl.removeVideo(
                                      _ctrl.selectedUserVideos[index].id),
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
        : const SizedBox();
  }

  Widget CollabThumbnail(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: NetworkImage(
              'https://img.youtube.com/vi/${_ctrl.collabs.values.elementAt(index).videoId}/0.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget VideoThumbnail(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: NetworkImage(
              'https://img.youtube.com/vi/${_ctrl.selectedUserVideos[index].media}/0.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget AddVideoOption() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _ctrl.openVideos().then((value) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text('Elegir video para agregar a tu perfil'),
                    content: Obx(() => Container(
                        height: 500.h,
                        width: 500.w,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _ctrl.userVideos.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () => _ctrl.addVideoToSelected(index),
                                  child: Padding(
                                      padding: const EdgeInsets.all(60.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          image: DecorationImage(
                                            image: NetworkImage(_ctrl
                                                .userVideos[index]
                                                .snippet!
                                                .thumbnails!
                                                .high!
                                                .url!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 100.0,
                                              right: 100.0,
                                              top: 1.0,
                                              bottom: 1.0),
                                        ),
                                      )));
                            }))));
              }));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget ViewPhotos() {
    return Center(
      child: GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 250.0, crossAxisCount: 3),
      itemBuilder: (context, index) {
        if (index < _ctrl.userPhotos.length) {
          return ShowPhotoRectangle(index);
        } else if (_ctrl.isCurrentUser.value) {
          return AddPhotoOption(index);
        }
        return Container();
      },
      itemCount: _ctrl.userPhotos.length + 1,
    ));
  }

  Widget AddPhotoOption(index) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
    child:
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: OutlinedButton(
          onPressed: () {
            UploadPhotoDialog(false);
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
            Icons.add,
          ),
        )));
  }

  Widget ShowPhotoRectangle(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        fit: StackFit.expand,
          children: [
        PhotoThumbnail(index),
        RemovePhotoOption(index),
      ]),
    );
  }

  Widget RemovePhotoOption(int index) {
    return _ctrl.isCurrentUser.value
        ? Positioned(
            top: -14,
            right: -14,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Eliminar foto'),
                      content: CustomText(
                          "¿Está seguro de que desea eliminar esta foto?"),
                      actions: [
                        DialogButtons(
                            onCancel: () => {
                                  Navigator.pop(context, false),
                                },
                            onOk: () => {
                                  _ctrl.removePhoto(_ctrl.userPhotos[index].id),
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
        : const SizedBox();
  }

  Widget PhotoThumbnail(index) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            image: _ctrl.userPhotos[index].imageFromBase64String().image,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 37.0, right: 37.0, top: 185.0, bottom: 15.0),
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
            UploadPhotoDialog(true);
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
        ));
  }

  Future<dynamic> UploadPhotoDialog(bool isProfilePicture) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Subir foto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        try {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image == null) return;
                          final imageTemp = File(image.path);
                          setState(() => {
                                previewPicture = imageTemp,
                                _ctrl.tempPicture = imageTemp
                              });
                        } on PlatformException catch (e) {
                          //print('Failed to pick image: $e');
                        }
                      },
                      icon: const Icon(
                        Icons.collections,
                        size: 30.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (image == null) return;
                          final imageTemp = File(image.path);
                          setState(() => {
                                previewPicture = imageTemp,
                                _ctrl.tempPicture = imageTemp
                              });
                        } on PlatformException catch (e) {
                          //print('Failed to pick image: $e');
                        }
                      },
                      icon: const Icon(
                        Icons.photo_camera,
                        size: 30.0,
                      ),
                    )
                  ],
                ),
                previewPicture != null
                    ? CircleAvatar(
                        backgroundImage: Image.file(previewPicture!).image,
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
                        isProfilePicture
                            ? _ctrl.updateProfilePicture()
                            : _ctrl.uploadPhoto(),
                        Navigator.pop(context, true)
                      },
                  okButtonText: "Aceptar",
                  cancelButtonText: "Cancelar"),
            ],
          );
        });
      },
    );
  }

  Future<dynamic> EditPhoneNumberModal() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar número'),
          content: TextFormField(
              controller: _ctrl.phoneNumberController, inputFormatters: []),
          actions: [
            DialogButtons(
                onCancel: () => {
                      Navigator.pop(context, false),
                      _ctrl.onCancelEditPhoneNumber()
                    },
                onOk: () => {
                      if (_ctrl.phoneNumberController.text != "")
                        {
                          _ctrl.updatePhoneNumber(),
                          Navigator.pop(context, true)
                        }
                    },
                okButtonText: "Aceptar",
                cancelButtonText: "Cancelar"),
          ],
        );
      },
    );
  }

  Future<dynamic> EditEmailModal() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar email'),
          content: TextFormField(
              controller: _ctrl.emailController, inputFormatters: []),
          actions: [
            DialogButtons(
                onCancel: () =>
                    {Navigator.pop(context, false), _ctrl.onCancelEditEmail()},
                onOk: () => {
                      if (_ctrl.emailController.text != "")
                        {_ctrl.updateEmail(), Navigator.pop(context, true)}
                    },
                okButtonText: "Aceptar",
                cancelButtonText: "Cancelar"),
          ],
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri finalUrl = Uri.parse(url);
    if (!await launchUrl(finalUrl)) {
      throw 'Could not launch $finalUrl';
    }
  }
}
