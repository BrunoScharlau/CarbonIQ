import 'dart:math' as math;

import 'package:gretapp/survey/survey_questions.dart';
import 'package:gretapp/data/datetime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount {
  final String name;
  final SurveySession signupSurvey;
  final List<SurveySession> completedSurveys;
  final bool dontSave; // Used to prevent saving demo/debug accounts

  DateTime? lastDailySurveyTime;

  UserAccount(this.name, this.signupSurvey, this.completedSurveys,
      {this.dontSave = false, this.lastDailySurveyTime});
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

enum DietType { vegetarian, vegan, pescatarian, omnivore }

class Diet {
  final double beefMass;
  final double lambPorkChickenMass;
  final double chocolateMass;
  final double cheeseMass;
  final int coffeeCups;

  double get totalMeatMass => beefMass + lambPorkChickenMass;

  Diet(this.beefMass, this.lambPorkChickenMass, this.chocolateMass,
      this.cheeseMass, this.coffeeCups);
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
            survey.answers[coffeeCupsQuestion] ?? 0)));
  }

  return UserRecord(
      car,
      Location.values
          .byName(user.signupSurvey.answers[locationQuestion]!.toString()),
      math.max(1, user.signupSurvey.answers[householdInhabitantCountQuestion]!),
      HouseholdType.values
          .byName(user.signupSurvey.answers[householdTypeQuestion]!.toString()),
      dailyRecords);
}

saveAccount(UserAccount account, SharedPreferences prefs) async {
  await prefs.setString('save_version', '1.0.0');
  await prefs.setString('user.name', account.name);

  if (account.lastDailySurveyTime != null) {
    await prefs.setInt('user.last_daily_survey_time',
        account.lastDailySurveyTime!.millisecondsSinceEpoch);
  }

  await prefs.setString('user.signup_survey', account.signupSurvey.toJSON());
  await prefs.setStringList('user.completed_surveys',
      account.completedSurveys.map((survey) => survey.toJSON()).toList());
}

Future<UserAccount?> loadAccount(SharedPreferences prefs) async {
  if (prefs.containsKey('user.name')) {
    String name = prefs.getString('user.name')!;

    DateTime? lastDailySurveyTime;
    if (prefs.containsKey('user.last_daily_survey_time')) {
      lastDailySurveyTime = DateTime.fromMillisecondsSinceEpoch(
          prefs.getInt('user.last_daily_survey_time')!);
    }

    SurveySession signupSurvey =
        SurveySession.fromJSON(prefs.getString('user.signup_survey')!);
    List<SurveySession> completedSurveys = prefs
        .getStringList('user.completed_surveys')!
        .map((json) => SurveySession.fromJSON(json))
        .toList();

    return UserAccount(name, signupSurvey, completedSurveys,
        lastDailySurveyTime: lastDailySurveyTime);
  } else {
    return null;
  }
}
