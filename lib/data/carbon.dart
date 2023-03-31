// All emissions are in grams of CO2

import 'package:gretapp/registration/user.dart';
import 'package:gretapp/survey/survey_questions.dart';

enum CommuteMethod { car, motorbike, bus, train, bike, walk }

enum CarType { none, gas, electric, hybrid }

enum Location { west, south, northeast, midwest }

enum HouseholdType {
  familyAttached,
  familyDetached,
  appartments24,
  appartments5p,
  mobileHome
}

class Diet {
  final double beefMass;
  final double lambPorkChickenMass;
  final double chocolateMass;
  final double cheeseMass;
  final double coffeeMass;

  Diet(this.beefMass, this.lambPorkChickenMass, this.chocolateMass,
      this.cheeseMass, this.coffeeMass);
}

class DailyRecord {
  final int dayNumber;
  final int commuteDistance;
  final CommuteMethod commuteMethod;
  final Diet diet;

  DailyRecord(
      this.dayNumber, this.commuteDistance, this.commuteMethod, this.diet);
}

/// A class containing all relevant data used to calcualte a person's carbon footprint
class UserRecord {
  final CarType car;
  final Location location;
  final HouseholdType householdType; // in square meters

  final List<DailyRecord> dailyRecords;

  UserRecord(this.car, this.location, this.householdType,
      this.dailyRecords);
}

int getDayNumber(DateTime time) {
  // Return a unique number identifying this day starting January 1st, 1970
  return time.millisecondsSinceEpoch ~/ 86400000;
}

int getMonthNumber(DateTime time) {
  return time.month + time.year * 12;
}

int getMonthNumberFromDay(int dayNumber) {
  return getMonthNumber(DateTime.fromMillisecondsSinceEpoch(dayNumber * 86400000));
}

List<int> getDaysInMonth(int monthNumber) {
  int firstDayInMonth = getDayNumber(DateTime(monthNumber ~/ 12, monthNumber % 12, 1));
  int firstDayInNextMonth = getDayNumber(DateTime(monthNumber ~/ 12 + 1, monthNumber % 12, 1));

  List<int> days = [];
  for (int i = firstDayInMonth; i < firstDayInNextMonth; i++) {
    days.add(i);
  }

  return days;
}

dynamic getLatestAnswer(List<SurveySession> surveys, SurveyQuestion question) {
  surveys.sort((a, b) =>
      b.time.millisecondsSinceEpoch.compareTo(a.time.millisecondsSinceEpoch));

  for (SurveySession survey in surveys) {
    if (survey.answers.containsKey(question)) {
      return survey.answers[question];
    }
  }

  return null;
}

int calculateCommuteEmissions(
    UserRecord record, CommuteMethod method, int distance) {
  // switch on the commute method
  switch (method) {
    case CommuteMethod.car:
      switch (record.car) {
        case CarType.none:
          return 0;
        case CarType.gas:
          return 411 * distance;
        case CarType.electric:
          return 200 * distance;
        case CarType.hybrid:
          return 260 * distance;
      }
    case CommuteMethod.motorbike:
      return 162 * distance;
    case CommuteMethod.bus:
      return 290 * distance;
    case CommuteMethod.train:
      return 131 * distance;
    case CommuteMethod.bike:
      return 0;
    case CommuteMethod.walk:
      return 0;
  }
}

Diet getLatestDiet(UserAccount user) {
  return Diet(
      getLatestAnswer(user.completedSurveys, beefMassQuestion) ?? 0,
      getLatestAnswer(user.completedSurveys, lambPorkChickenMassQuestion) ?? 0,
      getLatestAnswer(user.completedSurveys, chocolateMassQuestion) ?? 0,
      getLatestAnswer(user.completedSurveys, cheeseMassQuestion) ?? 0,
      getLatestAnswer(user.completedSurveys, coffeeMassQuestion) ?? 0);
}

UserRecord generateUserRecord(UserAccount user) {
  CarType car = CarType.values
      .byName(user.signupSurvey.answers[carTypeQuestion]!.toString());

  List<DailyRecord> dailyRecords = [];
  for (SurveySession survey in user.completedSurveys) {
    // Add a new daily record
    dailyRecords.add(DailyRecord(
        getDayNumber(survey.time),
        survey.answers[commuteDistanceQuestion] ?? 0,
        CommuteMethod.values
            .byName(survey.answers[commuteMethodQuestion]!.toString()),
        Diet(
            survey.answers[beefMassQuestion] ?? 0,
            survey.answers[lambPorkChickenMassQuestion] ?? 0,
            survey.answers[chocolateMassQuestion] ?? 0,
            survey.answers[cheeseMassQuestion] ?? 0,
            survey.answers[coffeeMassQuestion] ?? 0)));
  }

  return UserRecord(
      car,
      Location.values
          .byName(user.signupSurvey.answers[locationQuestion]!.toString()),
      HouseholdType.values.byName(
          user.signupSurvey.answers[householdTypeQuestion]!.toString()), dailyRecords);
}

const kwhEmissions = 390;

int calculateYearlyHomeMaintenanceEmissions(UserRecord record) {
  switch (record.householdType) {
    case HouseholdType.familyDetached:
      switch (record.location) {
        case Location.south:
          return 15500 * kwhEmissions;
        case Location.west:
        case Location.northeast:
        case Location.midwest:
          return 10500 * kwhEmissions;
      }
    case HouseholdType.familyAttached:
      switch (record.location) {
        case Location.northeast:
          return 7000 * kwhEmissions;
        case Location.midwest:
          return 8000 * kwhEmissions;
        case Location.south:
          return 11000 * kwhEmissions;
        case Location.west:
          return 6500 * kwhEmissions;
      }
    case HouseholdType.appartments24:
      switch (record.location) {
        case Location.northeast:
          return 6100 * kwhEmissions;
        case Location.midwest:
          return 6000 * kwhEmissions;
        case Location.south:
          return 9000 * kwhEmissions;
        case Location.west:
          return 5000 * kwhEmissions;
      }
    case HouseholdType.appartments5p:
      switch (record.location) {
        case Location.northeast:
          return 4000 * kwhEmissions;
        case Location.midwest:
          return 5800 * kwhEmissions;
        case Location.south:
          return 8500 * kwhEmissions;
        case Location.west:
          return 4200 * kwhEmissions;
      }
    case HouseholdType.mobileHome:
      switch (record.location) {
        case Location.northeast:
          return 10500 * kwhEmissions;
        case Location.midwest:
          return 12800 * kwhEmissions;
        case Location.south:
          return 14000 * kwhEmissions;
        case Location.west:
          return 9000 * kwhEmissions;
      }
  }
}

const poundsToKg = 0.453592;

int calculateDietEmissions(Diet diet) {
  return (poundsToKg *
      1000 *
      (diet.beefMass * 100 +
          diet.lambPorkChickenMass *
              14 + // TODO Split this up into more precise components
          diet.chocolateMass * 34 +
          diet.cheeseMass * 24 +
          diet.coffeeMass * 29)).floor();
}

/// Used to fill in missing days by copying the last given day
DailyRecord generateMissingDailyRecord(UserRecord record, int day) {
  DailyRecord? lastKnownRecord;
  for (DailyRecord dailyRecord in record.dailyRecords) {
    if (dailyRecord.dayNumber <= day && (lastKnownRecord == null || dailyRecord.dayNumber > lastKnownRecord.dayNumber)) {
      lastKnownRecord = dailyRecord;
    }
  }

  if (lastKnownRecord == null) {
    return DailyRecord(day, 0, CommuteMethod.walk, Diet(0, 0, 0, 0, 0));
  } else {
    return DailyRecord(day, lastKnownRecord.commuteDistance, lastKnownRecord.commuteMethod, lastKnownRecord.diet);
  }
}

/// Return the emissions for a given day
int calculateDailyEmissions(UserRecord record, DailyRecord dailyRecord) {
  return (calculateYearlyHomeMaintenanceEmissions(record) / 365 +
      calculateCommuteEmissions(
          record, dailyRecord.commuteMethod, dailyRecord.commuteDistance) +
      calculateDietEmissions(dailyRecord.diet)).round();
}

int calculateMonthlyEmissions(UserRecord record, int month) {
  int emissions = 0;

  List<int> daysInMonth = getDaysInMonth(month);

  for (DailyRecord dailyRecord in record.dailyRecords) {
    if (daysInMonth.contains(dailyRecord.dayNumber)) {
      daysInMonth.remove(dailyRecord.dayNumber);
      emissions += calculateDailyEmissions(record, dailyRecord);
    }
  }

  for (int missedDay in daysInMonth) {
    emissions += calculateDailyEmissions(record, generateMissingDailyRecord(record, missedDay));
  }

  return emissions;
}
