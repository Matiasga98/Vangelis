import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../helpers/custom_text.dart';
import '../services/theme_service.dart';
import 'enums.dart';

export 'screen_size.dart';

///texts
const appNameText = "Barbri";

const barbriLogo = "Barbri Logo";
const cancel = "cancel";
const ok = "ok";
const selectStudyPlan = "selectStudyPlan";
const selectLanguage = "selectLanguage";
const menuItemFAQ = "menuItemFAQ";
const menuItemInformation = "menuItemInformation";
const menuItemContactUs = "menuItemContactUs";
const bottomNavBarSearch = 'bottomNavBarSearch';
const bottomNavBarProfile =  'bottomNavBarProfile';
const bottomNavBarCollab = 'bottomNavBarCollab';

const menuItemFeedback = "menuItemFeedback";
const menuItemLanguage = "menuItemLanguage";
const menuItemLogOut = "menuItemLogOut";
const searchPlaceholder = "searchPlaceholder";
const bottomNavBarHome = "bottomNavBarHome";
const bottomNavBarAccount = "bottomNavBarAccount";
const bottomNavBarDownload = "bottomNavBarDownload";
const warningNoAvailablePersonalStudyPlan = "warningNoAvailablePersonalStudyPlan";
const errorLoadingRegistrations = "errorLoadingRegistrations";
const errorLoadingLearningPlan = "errorLoadingLearningPlan";
const errorChangingStudyPlanPlan = "errorChangingStudyPlanPlan";
const errorLoadingPracticeTest = "errorLoadingPracticeTest";
const errorMessageTitle = "errorMessageTitle";
const successMessageTitle = "successMessageTitle";
const warningMessageTitle = "warningMessageTitle";
const filterEssayPractice = "filterEssayPractice";
const filterGradedAssignments = "filterGradedAssignments";
const filterKnowledgeChecks = "filterKnowledgeChecks";
const filterLectures = "filterLectures";
const filterMultipleChoicePractice = "filterMultipleChoicePractice";
const filterPerformanceTestPractice = "filterPerformanceTestPractice";
const filterReading = "filterReading";
const filterReview = "filterReview";
const filterSimulatedExams = "filterSimulatedExams";
const filterSkills = "filterSkills";
const filterTips = "filterTips";
const type = "type";
const progress = "progress";
const duration = "duration";
const lessThen1Hour = "lessThen1Hour";
const oneTo2Hours = "oneTo2Hours";
const twoTo3Hours = "twoTo3Hours";
const threeTo4Hours = "threeTo4Hours";
const moreThen4Hours = "moreThen4Hours";
const errorDownloadingVideo = "errorDownloadingVideo";
const errorMediaUrl = "errorMediaUrl";
const errorDownloadPlayPosit = "errorDownloadPlayposit";
const errorDownloadMissingInformation = "errorDownloadMissingInformation";
const errorDownloadPdf = "errorDownloadPdf";
const errorOpenPdf = "errorOpenPdf";
const errorGettingPdfData = "errorGettingPdfData";
const errorDownloadPdfUnable = "errorDownloadPdfUnable";
const errorDownloadGeneric = "errorDownloadGeneric";
const errorLoadingTimeout = "errorLoadingTimeout";
const successDownloadFile = "successDownloadFile";
const successDeleteFile = "successDeleteFile";
const buttonDelete = "buttonDelete";
const buttonDownload = "buttonDownload";
const loginIn = "loginIn";
const usernameLabel = "usernamePlaceholder";
const usernameHint = "usernameHint";
const passwordLabel = "passwordPlaceholder";
const passwordHint = "passwordHint";
const newPasswordLabel = "newPasswordLabel";
const newPasswordHint = "newPasswordHint";
const cNewPasswordLabel = "cNewPasswordLabel";
const cNewPasswordHint = "cNewPasswordHint";
const emailLabel = "emailLabel";
const emailHint = "emailHint";
const errorCredentials = "errorCredentials";
const buttonLogin = "buttonLogin";
const buttonRegister = "buttonRegister";
const filterSubject = "filterSubject";
const filterLayout = "filterLayout";
const register = "register";
const forgotPassword1 = "forgotPassword1";
const forgotPasswordGestureDetector = "forgotPasswordGD";
const learningActivitiesContainerKey = "learning-activities-container";
const rememberMe = "rememberMe";
const alert = "alert";
const enterUserEmailDetail = "enterUserEmailDetail";
const enterUserDetail = "enterUserDetail";
const submit = "submit";
const answerQuestion = "answerQuestion";
const showPassword = "showPassword";
const hidePassword = "hidePassword";
const validEmail = "validEmail";
const enterAllField = "enterAllField";
const passwordNotMatch = "passwordNotMatch";
const answerNotMatch = "answerNotMatch";
const userNotFound = "userNotFound";
const unauthorized = "unauthorized";
const selectEnvironment = "selectEnvironment";
const noDataFound = "noDataFound";
const search = "search";
const filter = "filter";
const logOutDesc = "logOutDesc";
const assesmentStatusAlert = "assesmentStatusAlert";
const dismiss = "dismiss";
const assesmentStatusDes = "assesmentStatusDes";
const yes = "yes";
const no = "no";
const open = "open";
const audio = "Audio";
const handout = "Handout";
const markAsComplete = "markAsComplete";
const markAsInProgress = "markAsInProgress";
const accountSettings = "Account Settings";
const accountUpdateTime = "accountUpdateTime";
const updateTimesSet = {"15", "30", "60", "90", "120", "240", "480"};
const darkThemeSelection = "darkThemeSelection";
const switchCourse = "Switch Course";
const noConnection = "noConnection";
const backOnline = "backOnline";
const errorSwitchingPlan = "errorSwitchingPlan";
const successSwitchingPlan = "successSwitchingPlan";
const errorUpdatingStatus = "errorUpdatingStatus";
const updateStatusSuccessful = "updateStatusSuccessful";
const offlineStatusChangeCreated = "offlineStatusChangeCreated";
const offlineChangesDone = "offlineChangesDone";
const contentNotSupported = "contentNotSupported";
const changeStatusTo = 'changeStatusTo';
const statusCompleted = 'statusCompleted';
const statusInProgress = 'statusInProgress';
const statusDiscarded = 'statusDiscarded';
const statusNotStarted = 'statusNotStarted';
const recommendation = 'recommendation';
const allRecommendation = 'allRecommendation';
const statusSnooze = 'statusSnooze';
const statusIgnored = 'statusIgnored';
const downloadContentAvailable = 'downloadContentAvailable';
const resetAll = 'resetAll';
const of = 'of';
const download = 'download';
const print = 'print';
const moveToLastPagePdf = 'moveToLastPagePdf';
const moveToFirstPagePdf = 'moveToFirstPagePdf';
const documentProperties = 'documentProperties';
const fileNamePdf = 'fileNamePdf';
const titlePdf = 'titlePdf';
const author = 'author';
const subject = 'subject';
const creationDatePdf = 'creationDatePdf';
const modificationDatePdf = 'modificationDatePdf';
const creator = 'creator';
const doubleTapTopreview = 'doubleTapTopreview';
const zoomOut = "zoomOut";
const zoomIn = "zoomIn";
const doubleTapToBackward = 'doubleTapToBackward';
const doubleTapToForward = 'doubleTapToForward';
const doubleTapToPlayPause = 'doubleTapToPlayPause';
const doubleTapToPause = 'doubleTapToPause';
const doubleTapToPlay = 'doubleTapToPlay';
const subtitle = 'subtitle';
const activateSubtitle = 'activateSubtitle';
const deactivateSubtitle = 'deactivateSubtitle';
const exitFullScreen = 'exitFullScreen';
const fullScreen = 'fullScreen';
const playPauseButton = 'playPauseButton';
const doubleTapToClose = 'doubleTapToClose';
const doubleTapToToggleCaption = 'doubleTapToToggleCaption';

const changeStudyPlanDropdownKey = 'changeStudyPlanDropdown';
const ratingBar = 'ratingBar';

///Search widget
const searchTextFieldKey = "searchTextField";

///Video player page
const audioContainerKey = "audioOnlyContainer";
const videoContainerKey = "videoPlayerContainer";

///DialogButton Custom Widget
const dialogButtonOkButtonKey = "dBOkOption";

///Layout - Subject sub dropdown
const filterSubDropdown = "subDropdown";

const errorLoadingLecture = 'errorLoadingLecture';
const warningLectureUnavailable = 'warningLectureUnavailable';
const warningLectureAudioUnavailable = 'warningLectureAudioUnavailable';
const defaultQuote = 'defaultQuote';

const supportTechnicalAssistance = 'supportTechnicalAssistance';
const supportOtherInformation = 'supportOtherInformation';
const supportUkContactInfo = 'supportUkContactInfo';
const supportPhone = 'supportPhone';
const supportEmail = 'supportEmail';
const supportTechnicalPhoneHours = 'supportTechnicalPhoneHours';
const supportOtherPhoneHours = 'supportOtherPhoneHours';

const feedbackQuestion1 = 'feedbackQuestion1';
const feedbackQuestion2 = 'feedbackQuestion2';
const feedbackQuestion3 = 'feedbackQuestion3';
const feedbackEmailGreeting = "feedbackEmailGreeting";
const star = "star";
const blackOnWhite = "blackOnWhite";
const greyOnLightGrey = "greyOnLightGrey";
const purpleOnLightGreen = "purpleOnLightGreen";
const blackOnViolet = "blackOnViolet";
const yellowOnNavy = "yellowOnNavy";
const whiteOnBlack = "whiteOnBlack";
const smallFont = "smallFont";
const normalFont = "normalFont";
const largeFont = "largeFont";
const extraLargeFont = "extraLargeFont";
const hugeFont = "hugeFont";
const accessibilityOption = "accessibilityOption";
const colorScheme = "colorScheme";
const fontSizeText = "fontSizeText";
const changeBGFGColor = "changeBGFGColor";
const adjustFontSize = "adjustFontSize";
const submitActivity = "submitActivity";
const questionUnattempted = "questionUnattempted";
const submitActivitySure = "submitActivitySure";
const saveExit = "saveExit";
const next = "next";
const answerDiscussion = "answerDiscussion";
const finish = "finish";
const exit = "exit";
const review = "review";
const accessibility = "accessibility";
const flagItem = "flagItem";
const unFlagItem = "unFlagItem";
const flagged = "flagged";
const score = "score";
const correct = "correct";
const averageTimePerQuestion = "averageTimePerQuestion";
const date = "date";
const activity = "activity";
const allSessionsandQuestionsReview = "allSessionsandQuestionsReview";
const resume = "resume";
const activitypaused = "activitypaused";
const doubleTapToMute = "doubleTapToMute";
const doubleTapToUnMute = "doubleTapToUnMute";
const openPlaybackspeedMenu = "openPlaybackspeedMenu";
const unattempted = "unattempted";
const partiallyAttempted = "partiallyAttempted";
const weekOf = "weekOf";
const noScheduleWeek = "noScheduleWeek";
const warningNoAvailableHandout = "warningNoAvailableHandout";
const selectHandout = "selectHandout";
const cantUpdateWhileDownloading = "cantUpdateWhileDownloading";
const back = "back";
const details = "details";
const comingSoon = "comingSoon";
const iosVersion = 'iosVersion';
const androidVersion = 'androidVersion';

///Download content
const videoContent = 'VideoContent';
const audioContent = 'AudioContent';
const handoutContent = 'HandoutContent';
const closedCaption = 'ClosedCaption';
const videoDocumentContent = 'VideoDocumentContent';

RxDouble noInternetHeight = 0.0.obs;

///Font Family
const regularFont = 'goldPlay';
const proximaNovaFont = 'proximaNova';

/// Support information
const technicalAssistancePhoneNumber = '1-877-385-6238';
const technicalAssistanceEmail = 'techsupport@barbri.com';
const otherInformationPhoneNumber = '1-888-3BARBRI';
const otherInformationEmail = 'service@barbri.com';
const ukContactPhone = '+44 (0) 2038550162';
const ukContactEmail = 'ukoperations@barbri.com';
const mailTo = "mailto";
const emailBoodySubject = "subject=";
const emailBoody = "&body=";

/// testing keys
const answerSelect = Key("answerSelect");
const selectedContainerColor = Key("selectedContainerColor");
const resultChartClick = Key('resultChartClick');
const flagCheckbox = Key('flagCheckbox');
const unAttemptedCheckbox = Key('unAttemptedCheckbox');
const partiallyAttemptedCheckbox = Key('partiallyAttemptedCheckbox');
const pageCountUpdate = Key("PageCountUpdate");
const playSpeedTwoBtn = Key("PlaySpeedTwoBtn");
const videoPlayerSpeed = Key("VideoPlayerSpeed");
const videoVolumeBtn = Key("VideoVolumeBtn");
const reviewQuestionListTap = Key("reviewQuestionListTap");
const accessibilityConfirm = Key("accessibilityConfirm");
const colorRadioList = Key("colorRadioList");
const drawerSaveExitKey = Key("saveExit");
const drawerReviewKey = Key("review");
const drawerFlagItemKey = Key("flagItem");
const drawerAccessibilityKey = Key("accessibility");
const updateIntervalKey = Key("updateIntervalKey");
const updateIntervalItem = Key("updateIntervalItem");
const filterItems = Key("filterItems");
const zoomOutKey = Key('zoomOut');
const zoomInKey = Key('zoomIn');
const thumbnailTap = Key("thumbnailTap");
const forgotPasswordButton = 'forgotPasswordButton';
const expansionTileSqeDownload = 'expansionTileSqeDownload';
const popUpIcon = 'popUpIcon';

const mockCaptionFilePath = 'test/Utils/90320ClosedCaption.txt';

String state = "";

///show message, pass isError true/false for success/error type dialog
void showMsg(
    {String? title,
    String message = "",
    MessageType type = MessageType.error}) {
  if (!Get.isSnackbarOpen) {
    Color? titleTextColor;
    Color? messageTextColor;
    Color? backgroundColor;
    Color? colorText;
    Color? borderColor;
    Widget? icon;
    switch (type) {
      case MessageType.error:
        title ??= errorMessageTitle;
        titleTextColor = themeConfig!.redTextColor;
        messageTextColor = themeConfig!.redTextColor;
        backgroundColor = themeConfig!.redColorLight;
        colorText = themeConfig!.redTextColor;
        borderColor = themeConfig!.redTextColor;
        icon = Image.asset(
          themeConfig!.errorAsset,
          height: 30,
          width: 30,
          color: themeConfig!.redTextColor,
        ).paddingAll(5);
        break;
      case MessageType.success:
        title ??= successMessageTitle;
        titleTextColor = themeConfig!.greenTextColor;
        messageTextColor = themeConfig!.greenTextColor;
        backgroundColor = themeConfig!.greenColorLight;
        colorText = themeConfig!.greenTextColor;
        borderColor = themeConfig!.greenTextColor;
        icon = Image.asset(
          themeConfig!.successAsset,
          height: 30,
          width: 30,
          color: themeConfig!.greenTextColor,
        ).paddingAll(5);
        break;
      case MessageType.warning:
        title ??= warningMessageTitle;
        titleTextColor = themeConfig!.yellowTextColor;
        messageTextColor = themeConfig!.yellowTextColor;
        backgroundColor = themeConfig!.yellowColorLight;
        colorText = themeConfig!.yellowTextColor;
        borderColor = themeConfig!.yellowTextColor;
        icon = Image.asset(
          themeConfig!.warningAsset,
          height: 30,
          width: 30,
          color: themeConfig!.yellowTextColor,
        ).paddingAll(5);
        break;
    }
    Get.snackbar(
      '',
      '',
      titleText: CustomText(title.tr, textColor: titleTextColor),
      messageText: CustomText(message.tr, textColor: messageTextColor),
      backgroundColor: backgroundColor,
      colorText: colorText,
      borderRadius: 0,
      borderColor: borderColor,
      icon: icon,
      borderWidth: 1,
    );
  }
}

const alphabetArray = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
];


String logoRock = "images/logo.png";