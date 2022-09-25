import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vangelis/helpers/custom_text.dart';
import 'package:vangelis/pages/dashboard/profile/profile_controller.dart';
import 'package:vangelis/pages/dashboard/search/search_controller.dart';
import 'package:vangelis/util/constants.dart';

import '../../../entity/user.dart';
import '../../../helpers/dialog_buttons.dart';
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

  final ProfileController profileController = Get.put(ProfileController());

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
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 30.0,
                            ),
                          ),
                          Text(
                            _ctrl.username.value,
                            style: TextStyle(
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
                                        child: Text("Ver Favoritos"),
                                        value: 'fav',
                                      ),
                                    ];
                                  },
                                )
                              : _ctrl.isFavorited.value
                                  ? IconButton(
                                      onPressed: () {
                                        _ctrl.removeUserFromFavorites();
                                      },
                                      icon: Icon(
                                        Icons.star,
                                        size: 30.0,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        _ctrl.addUserToFavorites();
                                      },
                                      icon: Icon(
                                        Icons.star_border,
                                        size: 30.0,
                                      ),
                                    ),
                        ],
                      ),
                    ),
                    SizedBox(height: 70.0),
                    CircleAvatar(
                      backgroundImage: _ctrl.profilePicture.value.image,
                      radius: 70.0,
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 150.h,
                          width: 500.w,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 110.w,
                                child: Column(
                                  children: [
                                    _ctrl.instruments[index]
                                        .imageFromBase64String(),
                                    CustomText(
                                        _ctrl.instruments.value[index].name),
                                  ],
                                ),
                              );
                            },
                            itemCount: _ctrl.instruments.value.length,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 150.h,
                          width: 500.w,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 110.w,
                                child: Column(
                                  children: [
                                    _ctrl.genres[index].imageFromBase64String(),
                                    CustomText(_ctrl.genres.value[index].name),
                                  ],
                                ),
                              );
                            },
                            itemCount: _ctrl.genres.length,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Icon(
                            Icons.telegram_rounded,
                          ),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.transparent,
                              ),
                              primary: Colors.blue,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              fixedSize: Size(50.0, 60.0)),
                        ),
                        SizedBox(width: 15.w),
                        OutlinedButton(
                          onPressed: () {},
                          child: Icon(Icons.whatsapp_rounded),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.transparent,
                              ),
                              primary: Colors.green,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              fixedSize: Size(50.0, 60.0)),
                        ),
                        SizedBox(width: 15.w),
                        OutlinedButton(
                          onPressed: () {
                            _ctrl.handleSignIn();
                          },
                          child: Icon(Icons.youtube_searched_for),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.transparent,
                              ),
                              primary: Colors.red,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              fixedSize: Size(50.0, 60.0)),
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
                              'Sobre ' + _ctrl.username.value,
                              fontSize: 30.h,
                            ), // <-- Text
                            !_ctrl.isCurrentUser.value
                                ? SizedBox()
                                : OutlinedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Editar descripción'),
                                            content: TextField(
                                              controller: profileController
                                                  .descriptionController,
                                            ),
                                            actions: [
                                              DialogButtons(
                                                  onCancel: () => {
                                                        Navigator.pop(
                                                            context, false),
                                                        profileController
                                                            .onCancel()
                                                      },
                                                  onOk: () => {
                                                        profileController
                                                            .updateDescription(),
                                                        Navigator.pop(
                                                            context, true)
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
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
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
                            profileController.description.value,
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
                            indicator:
                                BoxDecoration(borderRadius: BorderRadius.zero),
                            labelColor: Colors.black,
                            labelStyle: TextStyle(
                                fontSize: 28.0, fontWeight: FontWeight.bold),
                            unselectedLabelColor: Colors.black26,
                            onTap: (tapIndex) {
                              setState(() {
                                selectedIndex = tapIndex;
                              });
                            },
                            tabs: [
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
                                child: Text("Hello"),
                                value: '/hello',
                              ),
                              PopupMenuItem(
                                child: Text("About"),
                                value: '/about',
                              ),
                              PopupMenuItem(
                                child: Text("Contact"),
                                value: '/contact',
                              )
                            ];
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: 5000.w,
                      height: 500.h,
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: tabController,
                        children: [
                          GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                      child: Text("1.234k"),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: 8,
                          ),
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
                          ),
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
                    CircleAvatar(
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
}
