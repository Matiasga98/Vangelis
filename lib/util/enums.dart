
import 'constants.dart';

enum ActivityTypeFilter {
  essayPractice,
  gradedAssignments,
  knowledgeChecks,
  lectures,
  multipleChoicePractice,
  performanceTestPractice,
  reading,
  review,
  simulatedExams,
  skills,
  tips
}

extension ActivityTypeFilterExtension on ActivityTypeFilter {
  String get name {
    switch (this) {
      case ActivityTypeFilter.essayPractice:
        return 'Essay Practice';
      case ActivityTypeFilter.gradedAssignments:
        return 'Graded Assignments';
      case ActivityTypeFilter.knowledgeChecks:
        return 'Knowledge Checks';
      case ActivityTypeFilter.lectures:
        return 'Lectures';
      case ActivityTypeFilter.multipleChoicePractice:
        return 'Multiple Choice Practice';
      case ActivityTypeFilter.performanceTestPractice:
        return 'Performance Test Practice';
      case ActivityTypeFilter.reading:
        return 'Reading';
      case ActivityTypeFilter.review:
        return 'Review';
      case ActivityTypeFilter.simulatedExams:
        return 'Simulated Exams';
      case ActivityTypeFilter.skills:
        return 'Skills';
      case ActivityTypeFilter.tips:
        return 'Tips';
      default:
        return '';
    }
  }
}

ActivityTypeFilter activityTypeFilterFromString(String type) {
  switch (type) {
    case 'Essay Practice':
      return ActivityTypeFilter.essayPractice;
    case 'Graded Assignments':
      return ActivityTypeFilter.gradedAssignments;
    case 'Knowledge Checks':
      return ActivityTypeFilter.knowledgeChecks;
    case 'Lectures':
      return ActivityTypeFilter.lectures;
    case 'Multiple Choice Practice':
      return ActivityTypeFilter.multipleChoicePractice;
    case 'Performance Test Practice':
      return ActivityTypeFilter.performanceTestPractice;
    case 'Reading':
      return ActivityTypeFilter.reading;
    case 'Review':
      return ActivityTypeFilter.review;
    case 'Simulated Exams':
      return ActivityTypeFilter.simulatedExams;
    case 'Skills':
      return ActivityTypeFilter.skills;
    case 'Tips':
      return ActivityTypeFilter.tips;
    default:
      return ActivityTypeFilter.essayPractice;
  }
}

enum ActivityDurationFilter {
  lessThanOneHour,
  oneToTwoHours,
  twoToThreeHours,
  threeToFourHours,
  moreThanFourHours
}

ActivityDurationFilter activityDurationFilterFromDouble(double duration) {
  if (duration < 1) {
    return ActivityDurationFilter.lessThanOneHour;
  } else if (duration >= 1 && duration < 2) {
    return ActivityDurationFilter.oneToTwoHours;
  } else if (duration >= 2 && duration < 3) {
    return ActivityDurationFilter.twoToThreeHours;
  } else if (duration >= 3 && duration < 4) {
    return ActivityDurationFilter.threeToFourHours;
  } else {
    return ActivityDurationFilter.moreThanFourHours;
  }
}

enum MessageType {
  error,
  success,
  warning
}

enum MediaFileType {
  video,
  audio,
  lectureHandout
}

enum ActivityType {
  none,
  lecture,
  essay,
  gradedEssay,
  questions,
  ampQuestions,
  note,
  simulatedMBE,
  essayArchitect,
  readingOutline,
  assessment,
  other
}

ActivityType activityTypeFromString(String name){
  switch(name){
    case("Lecture"):
      return ActivityType.lecture;
    case("Essay Architect"):
      return ActivityType.essayArchitect;
    case("Simulated MBE"):
      return ActivityType.simulatedMBE;
    case("Graded Essay"):
      return ActivityType.gradedEssay;
    case("Essay"):
      return ActivityType.essay;
    case("Assessment"):
      return ActivityType.assessment;
    case("Questions"):
      return ActivityType.questions;
    case("AMP Questions"):
      return ActivityType.ampQuestions;
    case("Reading/Outline"):
      return ActivityType.readingOutline;
    case("note"):
      return ActivityType.note;
    case("none"):
      return ActivityType.none;
    default:
      return ActivityType.other;
  }
}

extension ActivityTypeExtension on ActivityType {
  String get displayName{
    switch (this) {
      case(ActivityType.lecture):
        return "Lecture";
      case(ActivityType.essayArchitect):
        return "Essay Architect";
      case(ActivityType.simulatedMBE):
        return "Simulated MBE";
      case(ActivityType.gradedEssay):
        return "Graded Essay";
      case(ActivityType.essay):
        return "Essay";
      case(ActivityType.assessment):
        return "Assessment";
      case(ActivityType.questions):
        return "Questions";
      case(ActivityType.ampQuestions):
        return "AMP Questions";
      case(ActivityType.readingOutline):
        return "Reading/Outline";
      case(ActivityType.note):
        return "note";
      case(ActivityType.none):
        return "none";
      default:
        return "other";
    }
  }
}


enum ActivityStatus {
  notStarted,
  inProgress,
  completed,
  discarded,
  snooze,
  ignored
}
extension ActivityStatusExtension on ActivityStatus {
  String get name {
    switch (this) {
      case ActivityStatus.ignored:
        return 'IGNORED';
      case ActivityStatus.completed:
        return 'COMPLETED';
      case ActivityStatus.inProgress:
        return "IN_PROGRESS";
      case ActivityStatus.discarded:
        return "DISCARDED";
      case ActivityStatus.notStarted:
        return "NOT_STARTED";
      case ActivityStatus.snooze:
        return "SNOOZE";
      default:
        return "NOT_STARTED";
    }
  }
  String get uiName {
    switch (this) {
      case ActivityStatus.ignored:
        return statusIgnored;
      case ActivityStatus.completed:
        return statusCompleted;
      case ActivityStatus.inProgress:
        return statusInProgress;
      case ActivityStatus.discarded:
        return statusDiscarded;
      case ActivityStatus.notStarted:
        return statusNotStarted;
      case ActivityStatus.snooze:
        return statusSnooze;
      default:
        return statusNotStarted;
    }
  }
}

ActivityStatus activityStatusFromString(String name){
  switch(name){
    case("IN_PROGRESS"):
      return ActivityStatus.inProgress;
    case("COMPLETED"):
      return ActivityStatus.completed;
    case("DISCARDED"):
      return ActivityStatus.discarded;
    case("NOT_STARTED"):
      return ActivityStatus.notStarted;
    case("SNOOZE"):
      return ActivityStatus.snooze;
    case("IGNORED"):
      return ActivityStatus.ignored;
    default:
      return ActivityStatus.notStarted;
  }
}

