import 'dart:isolate';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vangelis/pages/dashboard/profile/profile_page.dart';
import 'package:vangelis/pages/dashboard/search/search_page.dart';


import '../../entity/user.dart';
import '../../model/abnormal_operation_notification.dart';
import '../../routes/router_name.dart';
import '../../services/auth_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/theme_service.dart';
import '../../util/constants.dart';
import 'collab/profile_page.dart';

class DashboardController extends GetxController with GetSingleTickerProviderStateMixin {
  RxBool isSearched = false.obs;
  RxBool recommendationExist = false.obs;
  final ReceivePort _port = ReceivePort();
  final Rx<int> currentButtonIndex = 0.obs;
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

  /*void downloadProgress(LearningActivity taskIndex, String? id, double? progress) {
    if (progress! > 0 && progress < 1.0) {
      taskIndex.isDownloadingLectureHandout.value = false;
    }

    if (id == taskIndex.videoDownloadId.value) {
      taskIndex.progressVideo.value = progress.toDouble();
    } else if (id == taskIndex.audioDownloadId.value) {
      taskIndex.progressAudio.value = progress.toDouble();
    } else if (id == taskIndex.pdfDownloadId.value) {
      taskIndex.progressDoc.value = progress.toDouble();
    }

    if ((progress) == 1) {
      if (id == taskIndex.videoDownloadId.value) {
        taskIndex.videoDownloadId.value = '';
        if (taskIndex.type == ActivityType.lecture) {
          showMsg(type: MessageType.success, message: successDownloadFile);
        }
      } else if (id == taskIndex.audioDownloadId.value) {
        taskIndex.audioDownloadId.value = '';
      } else if (id == taskIndex.pdfDownloadId.value) {
        taskIndex.pdfDownloadId.value = '';
        if (taskIndex.progressDoc.value < 0 && taskIndex.progressDoc.value != -0.01) {
          taskIndex.progressDoc.value = 1.5;
          if (taskIndex.type != ActivityType.lecture) {
            showMsg(type: MessageType.success, message: successDownloadFile);
          }
        }
      }
      filterActivities();
    }

    if (id == taskIndex.pdfDownloadId.value) {
      if (taskIndex.progressDoc.value < 0 && taskIndex.progressDoc.value != -0.01) {
        taskIndex.progressDoc.value = 1.5;
        taskIndex.isDownloadingLectureHandout.value = false;
        if (taskIndex.type != ActivityType.lecture) {
          showMsg(type: MessageType.success, message: successDownloadFile);
          taskIndex.pdfDownloadId.value = '';
          taskIndex.isDownloadingLectureHandout.value = false;
        }

        filterActivities();
      }
    }
  }*/

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

    /*void setDownloadId({required DownloadTask value, required String taskId}) {
    for (int i = 0; i < allLearningActivities.length; i++) {
      if (value.filename!
              .contains(allLearningActivities[i].learningActivityId.toString()) &&
          value.filename!.contains(videoContent)) {
        allLearningActivities[i].localFilename = value.filename;
        allLearningActivities[i].videoDownloadId.value = taskId;
        allLearningActivities[i].isDownloadingLectureHandout.value = true;
      } else if (value.filename!
              .contains(allLearningActivities[i].learningActivityId.toString()) &&
          value.filename!.contains(audioContent)) {
        allLearningActivities[i].localAudioName = value.filename;
        allLearningActivities[i].audioDownloadId.value = taskId;
        allLearningActivities[i].isDownloadingLectureHandout.value = true;
      } else if (value.filename!
              .contains(allLearningActivities[i].learningActivityId.toString()) &&
          value.filename!.contains(handoutContent)) {
        allLearningActivities[i].localFilename = value.filename;
        allLearningActivities[i].pdfDownloadId.value = taskId;
        allLearningActivities[i].isDownloadingLectureHandout.value = true;
      }
    }

    for (int i = 0; i < filteredLearningActivities.value!.length; i++) {
      if (value.filename!.contains(
              filteredLearningActivities.value![i].learningActivityId.toString()) &&
          value.filename!.contains(videoContent)) {
        filteredLearningActivities.value![i].localFilename = value.filename;
        filteredLearningActivities.value![i].videoDownloadId.value = taskId;
        filteredLearningActivities.value![i].isDownloadingLectureHandout.value = true;
      } else if (value.filename!.contains(
              filteredLearningActivities.value![i].learningActivityId.toString()) &&
          value.filename!.contains(audioContent)) {
        filteredLearningActivities.value![i].localAudioName = value.filename;
        filteredLearningActivities.value![i].audioDownloadId.value = taskId;
        filteredLearningActivities.value![i].isDownloadingLectureHandout.value = true;
      } else if (value.filename!.contains(
              filteredLearningActivities.value![i].learningActivityId.toString()) &&
          value.filename!.contains(handoutContent)) {
        filteredLearningActivities.value![i].localFilename = value.filename;
        filteredLearningActivities.value![i].pdfDownloadId.value = taskId;
        filteredLearningActivities.value![i].isDownloadingLectureHandout.value = true;
      }
    }
    filterActivities();

  }*/

    /*List<StudyWeek> getStudyWeeksForSQE() {
    List<StudyWeek> studyWeeks = [];
    List<LearningActivity> scheduledActivities = filteredLearningActivities.value!
        .where((element) =>
            element.scheduledWeek != null && element.scheduledWeek!.isNotEmpty)
        .toList();
    List<LearningActivity> noScheduleActivities = filteredLearningActivities.value!
        .where(
            (element) => element.scheduledWeek == null || element.scheduledWeek!.isEmpty)
        .toList();

    Set<String> weeks = scheduledActivities.map((e) => e.scheduledWeek!).toSet();
    for (var week in weeks) {
      final parsedWeek = DateTime.parse(week);
      String formattedWeek = DateFormat("d MMM yyyy").format(parsedWeek.toLocal());
      studyWeeks.add(
          StudyWeek(week: parsedWeek, weekHeader: formattedWeek, learningActivities: []));
    }
    for (var activity in scheduledActivities) {
      studyWeeks
          .firstWhere((week) => week.week == DateTime.parse(activity.scheduledWeek!))
          .learningActivities
          .add(activity);
    }
    studyWeeks.sort((a, b) => a.week!.compareTo(b.week!));
    Duration durationOfWeek = const Duration(days: 6);
    studyWeeks = studyWeeks
            .where(
                (element) => !element.week!.add(durationOfWeek).isBefore(DateTime.now()))
            .toList() +
        (studyWeeks
            .where(
                (element) => element.week!.add(durationOfWeek).isBefore(DateTime.now()))
            .toList());

    if (noScheduleActivities.isNotEmpty) {
      StudyWeek noScheduledActivities = StudyWeek(
          weekHeader: noAssignedWeekHeader,
          week: null,
          learningActivities: noScheduleActivities);
      studyWeeks.add(noScheduledActivities);
    }
    return studyWeeks;
    return [];
  }*/

    /*Future<AbnormalOperationNotification?> getLearningActivities(
      PspVariation pspVariation, bool forceApi) async {
    AbnormalOperationNotification? error;
    activePsps = await studyPlanRepository.getPsp(registrations!, pspVariation,
        forceApi: forceApi);
    selectedPsp = activePsps!
        .where((element) =>
            element.personalStudyPlan.target!.personalStudyPlanId == pspVariation.pspId)
        .first;
    final learningPlan = await studyPlanRepository.getEntireCourse(
        selectedPsp!.personalStudyPlan.target!,
        forceApi: forceApi,
        pspStudentId: selectedPsp!.pspStudentId);
    if (learningPlan != null) {
      allLearningActivities = learningPlan.learningActivities;
      filteredLearningActivities.value = allLearningActivities;

      if (filteredLearningActivities.value?.any(
              (element) => (element.filterTypes?.contains("RECOMMENDED")) ?? false) ??
          false) {
        if (tabController!.index == 1) {
          filters.value.recommendations.value = false;
        } else {
          filters.value.recommendations.value = true;
        }
        recommendationExist.value = true;
        filterActivities();
      } else {
        filters.value.recommendations.value = false;
        recommendationExist.value = false;
        filterActivities();
      }
      if (pspVariation.description == "SQE") {
        List<StudyWeek> studyWeeks = getStudyWeeksForSQE();
        sqeStudyWeeks.value = studyWeeks;
        isSQE = true;
      } else {
        isSQE = false;
      }

      _setSubjectAndLayoutFilters(allLearningActivities);
    } else {
      error = AbnormalOperationNotification(
          type: MessageType.error, message: errorLoadingLearningPlan.tr);
    }
    addBodies();
    return error;
  }*/

    Future<void> addBodies() async {

      bodies.add(SearchScreen());
      bodies.add(CollabPage());
      bodies.add(ProfilePage());
    }

    /*void _setSubjectAndLayoutFilters(List<LearningActivity> activities) {
    layouts.value = ActivityFilterUtil.filterableLayouts(activities);
    subjects.value = ActivityFilterUtil.filterableSubjects(activities);
  }*/

    /*void filterActivities() {
    filteredLearningActivities.value = ActivityFilterUtil.filterActivities(
        allLearningActivities, filters.value, searchFilter.text.toString());
    if (isSQE) sqeStudyWeeks.value = getStudyWeeksForSQE();
  }*/

    /*void resetAllFilters() {
    filters.value.showEssayPractice.value = false;
    filters.value.showGradedAssignments.value = false;
    filters.value.showKnowledgeChecks.value = false;
    filters.value.showLectures.value = false;
    filters.value.showMultipleChoicePractice.value = false;
    filters.value.showPerformanceTestPractice.value = false;
    filters.value.showReading.value = false;
    filters.value.showReview.value = false;
    filters.value.showSimulatedExams.value = false;
    filters.value.showSkills.value = false;
    filters.value.showTips.value = false;
    filters.value.notStartedProgress.value = false;
    filters.value.inProgress.value = false;
    filters.value.completedProgress.value = false;
    filters.value.dismissedProgress.value = false;
    filters.value.lessThanOneHour.value = false;
    filters.value.oneToTwoHour.value = false;
    filters.value.twoToThreeHour.value = false;
    filters.value.moreThanFourHour.value = false;
    filters.value.threeToFourHour.value = false;
    searchFilter.clear();
    filters.value.layout.value = '';
    filters.value.subject.value = '';
    filterActivities();
    Get.back();
  }*/

    /*void updateEssayPractice(bool? value) {
    filters.value.showEssayPractice.value = value!;
    _filterAndUpdate();
  }*/

    /*void updateGradedAssignments(bool? value) {
    filters.value.showGradedAssignments.value = value!;
    _filterAndUpdate();
  }*/

    /*void updateKnowledgeChecks(bool? value) {
    filters.value.showKnowledgeChecks.value = value!;
    _filterAndUpdate();
  }

  void updateLectures(bool? value) {
    filters.value.showLectures.value = value!;
    _filterAndUpdate();
  }

  void updateMultipleChoicePractice(bool? value) {
    filters.value.showMultipleChoicePractice.value = value!;
    _filterAndUpdate();
  }

  void updatePerformanceTestPractice(bool? value) {
    filters.value.showPerformanceTestPractice.value = value!;
    _filterAndUpdate();
  }

  void updateReading(bool? value) {
    filters.value.showReading.value = value!;
    _filterAndUpdate();
  }

  void updateReview(bool? value) {
    filters.value.showReview.value = value!;
    _filterAndUpdate();
  }

  void updateSimulatedExams(bool? value) {
    filters.value.showSimulatedExams.value = value!;
    _filterAndUpdate();
  }

  void updateSkills(bool? value) {
    filters.value.showSkills.value = value!;
    _filterAndUpdate();
  }

  void updateTips(bool? value) {
    filters.value.showTips.value = value!;
    _filterAndUpdate();
  }

  void updateInProgress(bool? value) {
    filters.value.inProgress.value = value!;
    _filterAndUpdate();
  }

  void updateCompletedProgress(bool? value) {
    filters.value.completedProgress.value = value!;
    _filterAndUpdate();
  }

  void updateDismissedProgress(bool? value) {
    filters.value.dismissedProgress.value = value!;
    _filterAndUpdate();
  }

  void notStartedProgress(bool? value) {
    filters.value.notStartedProgress.value = value!;
    _filterAndUpdate();
  }

  void lessThanOneHour(bool? value) {
    filters.value.lessThanOneHour.value = value!;
    _filterAndUpdate();
  }

  void oneToTwoHour(bool? value) {
    filters.value.oneToTwoHour.value = value!;
    _filterAndUpdate();
  }

  void twoToThreeHour(bool? value) {
    filters.value.twoToThreeHour.value = value!;
    _filterAndUpdate();
  }

  void threeToFourHour(bool? value) {
    filters.value.threeToFourHour.value = value!;
    _filterAndUpdate();
  }

  void moreThanFourHour(bool? value) {
    filters.value.moreThanFourHour.value = value!;
    _filterAndUpdate();
  }

  void updateDownloaded(bool? value) {
    filters.value.onlyDownloaded.value = value!;
    _filterAndUpdate();
  }

  void updateSubject(String? subject) {
    filters.value.subject.value = subject!;
    _filterAndUpdate();
  }

  void updateLayout(String? layout) {
    filters.value.layout.value = layout!;
    _filterAndUpdate();
  }

  void updateRecommended(bool? value) {
    filters.value.recommendations.value = value!;
    _filterAndUpdate();
  }

  void _filterAndUpdate() {
    filterActivities();
  }

  bool isDownloading() {
    for (var activity in allLearningActivities) {
      if (activity.isBeingDownloaded()) {
        return true;
      }
    }
    return false;
  }*/
}
