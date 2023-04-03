import 'package:gretapp/survey/survey_questions.dart';
import 'package:gretapp/data/datetime.dart';

class UserAccount {
  final String name;
  final SurveySession signupSurvey;
  final List<SurveySession> completedSurveys;

  UserAccount(this.name, this.signupSurvey, this.completedSurveys);
}

enum CommuteMethod { car, motorbike, bus, train, bike, walk }

enum CarType { none, gas, electric, hybrid }

enum Location { west, south, northeast, midwest }

// This describes the building the user lives in, not the appartment itself
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

/// A class containing all relevant data to calculate a person's carbon footprint for a single day
class DailyRecord {
  final int dayNumber;
  final double commuteDistance;
  final CommuteMethod commuteMethod;
  final Diet diet;

  DailyRecord(
      this.dayNumber, this.commuteDistance, this.commuteMethod, this.diet);
}

/// A class containing all relevant data used to calcualte a person's carbon footprint
class UserRecord {
  final CarType car;
  final Location location;
  final int householdInhabitantCount;
  final HouseholdType householdType; // in square meters

  final List<DailyRecord> dailyRecords;

  UserRecord(this.car, this.location, this.householdInhabitantCount,
      this.householdType, this.dailyRecords);
}

UserRecord generateUserRecord(UserAccount user) {
  CarType car = CarType.values
      .byName(user.signupSurvey.answers[carTypeQuestion]!.toString());

  List<DailyRecord> dailyRecords = [];
  for (SurveySession survey in user.completedSurveys) {
    // Add a new daily record
    dailyRecords.add(DailyRecord(
        getDayNumber(survey.time),
        survey.answers[commuteDistanceQuestion],
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
      user.signupSurvey.answers[householdInhabitantCountQuestion]!,
      HouseholdType.values
          .byName(user.signupSurvey.answers[householdTypeQuestion]!.toString()),
      dailyRecords);
}
