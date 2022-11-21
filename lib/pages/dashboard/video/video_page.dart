import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:faker/faker.dart';
import 'package:objectbox/internal.dart';
import 'package:vangelis/helpers/custom_button.dart';
import 'package:vangelis/helpers/custom_text.dart';
import 'package:vangelis/helpers/dialog_buttons.dart';
import 'package:vangelis/helpers/secondary_button.dart';
import 'package:vangelis/model/collab_response.dart';
import 'package:vangelis/services/theme_service.dart';
import 'package:vangelis/util/constants.dart';
import 'package:vangelis/util/enums.dart';
import 'package:video_player/video_player.dart';
import 'package:vangelis/services/collab_service.dart';
import '../../../entity/user.dart';
import 'video_controller.dart';

class VideoScreen extends StatefulWidget {
  int originalCollabId;
  String requestVideoId;
  String responseVideoId;
  bool createView;
  bool checkMyResponseView;
  int? responseId;
  double startTime;

  VideoScreen(this.requestVideoId, this.responseVideoId, this.originalCollabId,
      this.createView,
      [this.responseId,
      this.startTime = 0.0,
      this.checkMyResponseView = false]);

  @override
  State<VideoScreen> createState() => _VideoScreenState(
      requestVideoId,
      responseVideoId,
      originalCollabId,
      createView,
      responseId,
      startTime,
      checkMyResponseView);
}

class _VideoScreenState extends State<VideoScreen> {
  int originalCollabId;
  String requestVideoId;
  String responseVideoId;
  bool createView;
  bool checkMyResponseView;
  int? responseId;
  double startTime;
  _VideoScreenState(this.requestVideoId, this.responseVideoId,
      this.originalCollabId, this.createView,
      [this.responseId,
      this.startTime = 0.0,
      this.checkMyResponseView = false]);

  CollabService collabService = Get.find();
  final _ctrl = Get.put(VideoController());
  Faker faker = Faker();

  late VideoPlayerController _controller;
  late VideoPlayerController _controller2;

  RxBool loading = true.obs;
  RxBool isPlaying = false.obs;

  String? youTube_link = "https://www.youtube.com/watch?v=";
  String? youTube_link2 = "https://www.youtube.com/watch?v=";
  String? _extractedLink = 'Loading...';
  String? _extractedLink2 = 'Loading...';

  @override
  void initState() {
    youTube_link = (youTube_link! + requestVideoId);
    youTube_link2 = (youTube_link2! + responseVideoId);
    super.initState();
    extractYoutubeLink();
    var a = "fsadfa";
  }

  Future<void> extractYoutubeLink() async {
    String? link;
    var alink;
    var alink2;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      alink =
          await FlutterYoutubeDownloader.extractYoutubeLink(youTube_link!, 18);
      alink2 =
          await FlutterYoutubeDownloader.extractYoutubeLink(youTube_link2!, 18);
    } on PlatformException {
      link = 'Failed to Extract YouTube Video Link.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _extractedLink = alink;
      _extractedLink2 = alink2;

      _controller2 = VideoPlayerController.network(_extractedLink2!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
        ..initialize();

      _controller = VideoPlayerController.network(_extractedLink!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
        ..initialize();
    });
    await Future.delayed(Duration(seconds: 10));
    loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    RxDouble _sliderValue = startTime.obs;
    return Obx(() => loading.value
        ? Stack(
            children: [
              Image.asset(
                themeConfig!.bgWhiteAsset,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Center(
                child: Image.asset(
                  themeConfig!.loadingGif,
                  height: 100,
                  fit: BoxFit.cover,
                  semanticLabel: barbriLogo,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: CustomText(
                    "Procesando la collab",
                    fontSize: 20,
                    fontFamily: regularFont,
                    textColor: themeConfig!.grayTextColor,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              loading.value ? Container() : Container(),
            ],
          )
        : MaterialApp(
            title: 'Video Demo',
            home: Scaffold(
              body: Center(
                  child: loading.value
                      ? Container()
                      : Column(
                          children: [
                            Container(
                              width: 600.w,
                              height: 400.h,
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                            Container(
                              width: 600.w,
                              height: 400.h,
                              child: AspectRatio(
                                aspectRatio: _controller2.value.aspectRatio,
                                child: VideoPlayer(_controller2),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (isPlaying.value) {
                                        _controller.pause();
                                        _controller2.pause();
                                        isPlaying.value = false;
                                      } else {
                                        _controller.play();
                                        _controller2.play();
                                        isPlaying.value = true;
                                      }
                                    },
                                    icon: Icon(isPlaying.value
                                        ? Icons.pause
                                        : Icons.play_arrow)),
                                IconButton(
                                    onPressed: () {
                                      var miliseconds =
                                          ((_sliderValue.value) * 1000)
                                              .truncate();
                                      _controller2.seekTo(
                                          Duration(milliseconds: miliseconds));
                                      _controller.seekTo(Duration(seconds: 0));
                                      isPlaying.value = true;
                                    },
                                    icon: Icon(Icons.refresh)),
                                createView
                                    ? IconButton(
                                        onPressed: () {
                                          if (_sliderValue.value < 20.0) {
                                            _sliderValue.value += 0.05;
                                            String stringValue = _sliderValue
                                                .value
                                                .toStringAsFixed(3);
                                            _sliderValue.value =
                                                double.parse(stringValue);
                                          }
                                        },
                                        icon: Icon(Icons.add))
                                    : Container(),
                                createView
                                    ? IconButton(
                                        onPressed: () {
                                          if (_sliderValue.value > 0) {
                                            _sliderValue.value -= 0.05;
                                            String stringValue = _sliderValue
                                                .value
                                                .toStringAsFixed(3);
                                            _sliderValue.value =
                                                double.parse(stringValue);
                                          }
                                        },
                                        icon: Icon(Icons.remove))
                                    : Container()
                              ],
                            ),
                            createView
                                ? Row(
                                    children: [
                                      Container(
                                        width: 20.w,
                                      ),
                                      Container(
                                        width: 80.w,
                                        child: Text(_sliderValue.toString()),
                                      ),
                                      Expanded(
                                          child: Slider(
                                        value: _sliderValue.value,
                                        min: 0.0,
                                        max: 20.0,
                                        divisions: 200,
                                        activeColor: Colors.green,
                                        inactiveColor: Colors.orange,
                                        label: 'Set start value',
                                        onChanged: (double newValue) {
                                          String stringValue =
                                              newValue.toStringAsFixed(2);
                                          _sliderValue.value =
                                              double.parse(stringValue);
                                        },
                                      )),
                                    ],
                                  )
                                : Container(),
                            createView
                                ? CustomButton(
                                    label: "Crear collab",
                                    onTap: () {
                                      var response = CollabResponse(
                                          0,
                                          responseVideoId,
                                          [], //todo: agregar generos e instrumentos
                                          [],
                                          _sliderValue.value,
                                          User().musicianFromUser(),
                                          false);
                                      collabService
                                          .createCollabResponse(
                                              response, originalCollabId)
                                          .then((value) {
                                        if (value) {
                                          Get.back();
                                          showMsg(
                                              message:
                                                  "Respuesta creada exitosamente",
                                              type: MessageType.success);
                                        } else {
                                          showMsg(
                                              message:
                                                  "error creando respuesta",
                                              type: MessageType.error);
                                        }
                                      });
                                    })
                                : checkMyResponseView
                                    ? SecondaryButton(
                                        onPress: () => {Get.back()},
                                        buttonText: "Volver atrás")
                                    : DialogButtons(
                                        alignment:
                                            MainAxisAlignment.spaceEvenly,
                                        onOk: () => {
                                              collabService
                                                  .chooseCollabResponseWinner(
                                                      originalCollabId,
                                                      responseId!)
                                                  .then((value) => {Get.back()})
                                            },
                                        onCancel: () => {Get.back()},
                                        okButtonText: "Elegir como ganadora",
                                        cancelButtonText: "Volver atrás"),
                          ],
                        )),
            ),
          ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _ctrl.dispose();
    super.dispose();
  }
}
