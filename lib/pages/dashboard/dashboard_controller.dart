import 'dart:isolate';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vangelis/pages/dashboard/profile/profile_page.dart';
import 'package:vangelis/pages/dashboard/search/search_page.dart';
import 'package:vangelis/pages/dashboard/collab/collab_page.dart';

import '../../entity/user.dart';
import '../../model/abnormal_operation_notification.dart';
import '../../routes/router_name.dart';
import '../../services/auth_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/theme_service.dart';
import '../../util/constants.dart';
import 'collab/collab_page.dart';

class DashboardController extends GetxController with GetSingleTickerProviderStateMixin {
  RxBool isSearched = false.obs;
  RxBool recommendationExist = false.obs;
  final ReceivePort _port = ReceivePort();
  final Rx<int> currentButtonIndex = 1.obs;
  RxList<Widget> bodies = <Widget>[].obs;


  ConnectivityService connectivityService = Get.find();

  final TextEditingController searchFilter = TextEditingController();
  final FocusNode searchFilterFocusNode = FocusNode();

  //final Rx<ActivityFilter> filters = ActivityFilter().obs;

  static const String noAssignedWeekHeader = "NO_ASSIGNED_WEEK";

  //List<Registration>? registrations;
  //List<StudentPersonalStudyPlan>? activePsps;
  //StudentPersonalStudyPlan? selectedPsp;

  //List<LearningActivity> allLearningActivities = <LearningActivity>[];

  final Rx<Widget> selectedView =
  Rx<Widget>(const Center(child: CircularProgressIndicator()));

  //final Rx<List<LearningActivity>?> filteredLearningActivities =
  //    Rx<List<LearningActivity>?>(null);
  //final Rx<List<StudyWeek>> sqeStudyWeeks = Rx<List<StudyWeek>>([]);
  bool isSQE = false;
  final Rx<Set<String>> layouts = Rx<Set<String>>(<String>{});
  final Rx<Set<String>> subjects = Rx<Set<String>>(<String>{});

  //late Rx<PspVariation> defPsp = PspVariation().obs;
  //List<PspVariation>? pspVariations = [];

  final Rx<Icon> searchIcon = const Icon(Icons.search).obs;
  TabController? tabController;

  final ThemeService themeService = Get.find();

  @override
  void onReady() {
    super.onReady();
    //FlutterDownloader.registerCallback(downloadCallback);
    if (Get.isDarkMode != User().isDark) {
      themeService.updateTheme();
    }
    addSearchFilterListener();
    _registerActionAndLoad();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(handleTabSelection);
    connectivityService.currentStatus.listen((p0) {
      if (p0 != ConnectivityResult.none) {
        reInitDownload();
      } else {
        /*for (var activity in allLearningActivities) {
          if (activity.progressVideo < 0) {
            activity.progressVideo.value = 0.01;
          }
          if (activity.progressAudio < 0) {
            activity.progressAudio.value = 0.01;
          }

          if (activity.progressDoc.value == -0.01) {
            activity.progressDoc.value = 0.01;
          }
        }*/
        //filterActivities();
      }
    });
  }

  static void handleTabSelection() {
    DashboardController controller = Get.find();
    if (controller.tabController!.index == 0) {
      //controller.updateRecommended(true);
    } else {
      //controller.updateRecommended(false);
    }
  }

  void _registerActionAndLoad() async {
    await _internalLoad();
  }

  Future<void> _internalLoad() async {
    final hasLoaded = await load();
    if (!hasLoaded) {
      final AuthService authService = Get.find();
      await authService.logOut();
      Get.offAndToNamed(RouterName.loginPageTag);
    }
  }

  @override
  void onClose() {
    super.onClose();
    currentButtonIndex.value = 0;
    _unbindBackgroundIsolate();
  }

  void addSearchFilterListener() {
    /*searchFilter.addListener(() {
      filterActivities();
    });*/
  }

  void _bindBackgroundIsolate() {
    bool isSuccess =
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String? id = data[0];
      double? progress = (data[2] / 100);
      try {
        /*final task = filteredLearningActivities.value!.firstWhere(
            (task) =>
                task.videoDownloadId.value == id ||
                task.audioDownloadId.value == id ||
                task.pdfDownloadId.value == id,
            orElse: () => LearningActivity());

        final taskIndex = allLearningActivities.firstWhere(
            (task) =>
                task.videoDownloadId.value == id ||
                task.audioDownloadId.value == id ||
                task.pdfDownloadId.value == id,
            orElse: () => LearningActivity());
        downloadProgress(taskIndex, id, progress);
        downloadProgress(task, id, progress);*/
      } catch (e) {
        debugPrint("ERROR PORT LISTEN: $e");
      }
    });
  }


  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  /*static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }*/

  Future<bool> load({bool forceApi = false}) async {
    AbnormalOperationNotification? loadingError;
    addBodies();
    /*try {
      if (User().defaultPspVariation.target != null) {
        defPsp.value = User().defaultPspVariation.target!;
      }
      registrations = await studyPlanRepository.getRegistrations(forceApi: forceApi);
      if (registrations != null) {
        pspVariations = registrations!.mapMany((e) => e.pspVariations).toList();
        if (registrations!.isNotEmpty && pspVariations!.isNotEmpty) {
          if (User().defaultPspVariation.target == null) {
            defPsp.value = pspVariations!.where((element) => element.defaultPSP).first;
          }
          loadingError = await getLearningActivities(defPsp.value, forceApi);
          if (!forceApi) {
            _bindBackgroundIsolate();
            reInitDownload();
          }
        } else {
          loadingError = AbnormalOperationNotification(
              type: MessageType.warning, message: warningNoAvailablePersonalStudyPlan.tr);
        }
      } else {
        loadingError = AbnormalOperationNotification(
            type: MessageType.error, message: errorLoadingRegistrations.tr);
      }
    } catch (ex) {
      loadingError = AbnormalOperationNotification(
          type: MessageType.error, message: errorLoadingLearningPlan.tr);
    }*/
    if (loadingError != null) {
      showMsg(message: loadingError.message, type: loadingError.type);
      return false;
    }
    return true;
  }

  void reInitDownload() {
    /*Future<List<DownloadTask>?> taskPending = FlutterDownloader.loadTasks();
    taskPending.then((value) async {
      disableDownloadProgress();

      if (value != null && value.isNotEmpty) {
        for (int j = 0; j < value.length; j++) {
          if (value[j].status == DownloadTaskStatus.complete) {
            FlutterDownloader.remove(taskId: value[j].taskId, shouldDeleteContent: false);
          } else {
            if (value[j].status == DownloadTaskStatus.failed ||
                value[j].status == DownloadTaskStatus.canceled ||
                value[j].status == DownloadTaskStatus.enqueued ||
                value[j].status == DownloadTaskStatus.paused ||
                value[j].status == DownloadTaskStatus.running) {
              setDownloadId(value: value[j], taskId: value[j].taskId);
            }
            if (value[j].status == DownloadTaskStatus.failed ||
                value[j].status == DownloadTaskStatus.canceled) {
              await FlutterDownloader.retry(
                taskId: value[j].taskId,
                requiresStorageNotLow: false,
              ).then((newTask) {
                if (newTask != null) {
                  setDownloadId(value: value[j], taskId: newTask);
                }
              }).onError((error, stackTrace) {});
            } else if (value[j].status == DownloadTaskStatus.paused) {
              await FlutterDownloader.resume(
                      taskId: value[j].taskId, requiresStorageNotLow: false)
                  .then((newTask) {
                if (newTask != null) {
                  setDownloadId(value: value[j], taskId: newTask);
                }
              });
            }
          }
        }
      }

      filterActivities();
    });*/
  }

    void disableDownloadProgress() {
      /*for (var activity in allLearningActivities) {
      if (activity.isDownloadingLectureHandout.value &&
          activity.progressAudio.value == 0 &&
          activity.progressVideo.value == 0 &&
          activity.progressDoc.value == 1.5) {
        activity.isDownloadingLectureHandout.value = false;
      }
    }*/
    }


    Future<void> addBodies() async {

      bodies.add(SearchScreen());
      bodies.add(CollabScreen());
      bodies.add(ProfilePage(User().musicianFromUser()));
      }

}
