import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entity/user.dart';


ColorScheme? themeConfig;

class ThemeService {
  static final light = ThemeData.light().copyWith();
  static final dark = ThemeData.dark().copyWith();

  ThemeMode get theme => User().isDark ? ThemeMode.dark : ThemeMode.light;

  void updateTheme() {
    Get.changeThemeMode(User().isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void init(BuildContext context) {
    themeConfig = context.theme.colorScheme;
  }

  Color whiteColor = const Color(0xFFFFFFFF);
  Color blackColor = const Color(0xFF000000);
  Color blueColor = const Color(0xff235BA8);
  Color orangeColor = const Color(0xffF06000);
  Color redColor = const Color(0xffbb2323);
  Color redTextColor = const Color(0xff6C0F1C);
  Color redColorLight = const Color(0xffFADBDF);
  Color greenColor = const Color(0xff23bb2b);
  Color greenTextColor = const Color(0xff206600);
  Color greenColorLight = const Color(0xffE8F9DC);
  Color yellowTextColor = Colors.yellow[900]!;
  Color yellowColorLight = Colors.yellow[50]!;
  Color grayTextColor = const Color(0xff464F57);
  Color offWhiteColor = const Color(0xffCACAC8);
  Color black26 = Colors.black26;
  Color black38 = Colors.black38;
  Color white70 = Colors.white70;
  Color lightGray = Colors.grey[500]!;
  Color lightGray400 = Colors.grey[400]!;
  Color lightGray300 = Colors.grey[300]!;
  Color yellow = Colors.yellow[700]!;
  Color backgroundBlueColor = const Color(0xff3167b1);

  String logoLight = "images/logo.png";
  String logoDark = "images/logo.png";
  String bgWhiteLight = "images/bgWhite.png";
  String bgWhiteDark = "images/bgWhite.png";
  String bgBlueLight = "images/bgBlue.png";
  String bgBlueDark = "images/bgBlue.png";
  String noDataLight = "images/no_data.png";
  String noDataDark = "images/no_data.png";
  String errorIcon = "images/warning.png";
  String warningIcon = "images/warning.png";
  String successIcon = "images/check.png";
  String loadingGif = "gif/loading.gif";
  String emptyDataGif = "gif/empty_data.gif";
  String playbackIcon = "images/playback.png";
}

extension ThemeServiceX on ColorScheme {
  Color get whiteBlackColor => brightness == Brightness.light
      ? ThemeService().whiteColor
      : ThemeService().blackColor;

  Color get blackWhiteColor => brightness == Brightness.light
      ? ThemeService().blackColor
      : ThemeService().whiteColor;

  Color get blueColor => brightness == Brightness.light
      ? ThemeService().blueColor
      : ThemeService().blueColor;

  Color get redColor => brightness == Brightness.light
      ? ThemeService().redColor
      : ThemeService().redColor;

  Color get redTextColor => brightness == Brightness.light
      ? ThemeService().redTextColor
      : ThemeService().redTextColor;

  Color get redColorLight => brightness == Brightness.light
      ? ThemeService().redColorLight
      : ThemeService().redColorLight;

  Color get greenColor => brightness == Brightness.light
      ? ThemeService().greenColor
      : ThemeService().greenColor;

  Color get greenTextColor => brightness == Brightness.light
      ? ThemeService().greenTextColor
      : ThemeService().greenTextColor;

  Color get greenColorLight => brightness == Brightness.light
      ? ThemeService().greenColorLight
      : ThemeService().greenColorLight;

  Color get grayTextColor => brightness == Brightness.light
      ? ThemeService().grayTextColor
      : ThemeService().grayTextColor;

  Color get offWhiteColor => brightness == Brightness.light
      ? ThemeService().offWhiteColor
      : ThemeService().offWhiteColor;

  Color get lightBlackColor => brightness == Brightness.light
      ? ThemeService().black26
      : ThemeService().black26;

  Color get lightBlackColor38 => brightness == Brightness.light
      ? ThemeService().black38
      : ThemeService().black38;

  Color get lightWhiteColor70 => brightness == Brightness.light
      ? ThemeService().white70
      : ThemeService().white70;

  Color get lightGreyColor => brightness == Brightness.light
      ? ThemeService().lightGray
      : ThemeService().lightGray;

  Color get lightGreyColor400 => brightness == Brightness.light
      ? ThemeService().lightGray400
      : ThemeService().lightGray400;

  Color get lightGreyColor300 => brightness == Brightness.light
      ? ThemeService().lightGray300
      : ThemeService().lightGray300;

  Color get yellowColor => brightness == Brightness.light
      ? ThemeService().yellow
      : ThemeService().yellow;

  Color get yellowTextColor => brightness == Brightness.light
      ? ThemeService().yellowTextColor
      : ThemeService().yellowTextColor;

  Color get yellowColorLight => brightness == Brightness.light
      ? ThemeService().yellowColorLight
      : ThemeService().yellowColorLight;

  String get logoAsset => brightness == Brightness.light
      ? ThemeService().logoLight
      : ThemeService().logoDark;

  String get bgWhiteAsset => brightness == Brightness.light
      ? ThemeService().bgWhiteLight
      : ThemeService().bgWhiteDark;

  String get bgBlueAsset => brightness == Brightness.light
      ? ThemeService().bgBlueLight
      : ThemeService().bgBlueDark;

  String get noDataAsset => brightness == Brightness.light
      ? ThemeService().noDataLight
      : ThemeService().noDataDark;

  String get noDataGif => brightness == Brightness.light
      ? ThemeService().emptyDataGif
      : ThemeService().emptyDataGif;

  String get errorAsset => brightness == Brightness.light
      ? ThemeService().errorIcon
      : ThemeService().errorIcon;

  String get successAsset => brightness == Brightness.light
      ? ThemeService().successIcon
      : ThemeService().successIcon;

  String get warningAsset => brightness == Brightness.light
      ? ThemeService().warningIcon
      : ThemeService().warningIcon;

  String get loadingGif => brightness == Brightness.light
      ? ThemeService().loadingGif
      : ThemeService().loadingGif;

  String get playbackAsset => brightness == Brightness.light
      ? ThemeService().playbackIcon
      : ThemeService().playbackIcon;
}
