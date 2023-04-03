import 'package:flutter/material.dart';
import 'package:gretapp/data/user.dart';
import 'package:gretapp/data/datetime.dart';
import 'package:gretapp/survey/survey_questions.dart';

class Emissions {
  // All emissions are in grams of CO2
  final int transportation;
  final int food;
  final int energy;
  final int other;

  const Emissions(
      {this.transportation = 0,
      this.food = 0,
      this.energy = 0,
      this.other = 0});

  int get total => transportation + food + energy + other;

  toInt() => total;

  toDouble() => total.toDouble();

  @override
  toString() => total.toString();

  Emissions operator +(Emissions otherEmissions) {
    return Emissions(
        transportation: transportation + otherEmissions.transportation,
        food: food + otherEmissions.food,
        energy: energy + otherEmissions.energy,
        other: other + otherEmissions.other);
  }

  Emissions operator -(Emissions otherEmissions) {
    return Emissions(
        transportation: transportation - otherEmissions.transportation,
        food: food - otherEmissions.food,
        energy: energy - otherEmissions.energy,
        other: other - otherEmissions.other);
  }

  Emissions operator *(int factor) {
    return Emissions(
        transportation: transportation * factor,
        food: food * factor,
        energy: energy * factor,
        other: other * factor);
  }

  Emissions operator /(int factor) {
    return Emissions(
        transportation: transportation ~/ factor,
        food: food ~/ factor,
        energy: energy ~/ factor,
        other: other ~/ factor);
  }
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

Emissions calculateCommuteEmissions(
    UserRecord record, CommuteMethod method, double distance) {
  // switch on the commute method
  switch (method) {
    case CommuteMethod.car:
      switch (record.car) {
        case CarType.none:
          return const Emissions();
        case CarType.gas:
          return Emissions(transportation: (411 * distance).floor());
        case CarType.electric:
          return Emissions(transportation: (200 * distance).floor());
        case CarType.hybrid:
          return Emissions(transportation: (260 * distance).floor());
      }
    case CommuteMethod.motorbike:
      return Emissions(transportation: (162 * distance).floor());
    case CommuteMethod.bus:
      return Emissions(transportation: (290 * distance).floor());
    case CommuteMethod.train:
      return Emissions(transportation: (131 * distance).floor());
    case CommuteMethod.bike:
      return const Emissions();
    case CommuteMethod.walk:
      return const Emissions();
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

const int kwhEmissions = 390;

Emissions calculateYearlyHomeMaintenanceEmissions(UserRecord record) {
  switch (record.householdType) {
    case HouseholdType.familyDetached:
      switch (record.location) {
        case Location.south:
          return const Emissions(energy: 15500 * kwhEmissions);
        case Location.west:
        case Location.northeast:
        case Location.midwest:
          return const Emissions(energy: 10500 * kwhEmissions);
      }
    case HouseholdType.familyAttached:
      switch (record.location) {
        case Location.northeast:
          return const Emissions(energy: 7000 * kwhEmissions);
        case Location.midwest:
          return const Emissions(energy: 8000 * kwhEmissions);
        case Location.south:
          return const Emissions(energy: 11000 * kwhEmissions);
        case Location.west:
          return const Emissions(energy: 6500 * kwhEmissions);
      }
    case HouseholdType.appartments24:
      switch (record.location) {
        case Location.northeast:
          return const Emissions(energy: 6100 * kwhEmissions);
        case Location.midwest:
          return const Emissions(energy: 6000 * kwhEmissions);
        case Location.south:
          return const Emissions(energy: 9000 * kwhEmissions);
        case Location.west:
          return const Emissions(energy: 5000 * kwhEmissions);
      }
    case HouseholdType.appartments5p:
      switch (record.location) {
        case Location.northeast:
          return const Emissions(energy: 4000 * kwhEmissions);
        case Location.midwest:
          return const Emissions(energy: 5800 * kwhEmissions);
        case Location.south:
          return const Emissions(energy: 8500 * kwhEmissions);
        case Location.west:
          return const Emissions(energy: 4200 * kwhEmissions);
      }
    case HouseholdType.mobileHome:
      switch (record.location) {
        case Location.northeast:
          return const Emissions(energy: 10500 * kwhEmissions);
        case Location.midwest:
          return const Emissions(energy: 12800 * kwhEmissions);
        case Location.south:
          return const Emissions(energy: 14000 * kwhEmissions);
        case Location.west:
          return const Emissions(energy: 9000 * kwhEmissions);
      }
  }
}

const poundsToKg = 0.453592;

Emissions calculateDietEmissions(Diet diet) {
  return Emissions(
      food: (poundsToKg *
              1000 *
              (diet.beefMass * 100 +
                  diet.lambPorkChickenMass *
                      14 + // TODO Split this up into more precise components
                  diet.chocolateMass * 34 +
                  diet.cheeseMass * 24 +
                  diet.coffeeMass * 29))
          .floor());
}

/// Used to fill in missing days by copying the last given day. If a record for that day is present, it will be returned.
DailyRecord getOrGenerateDailyRecord(UserRecord record, int day) {
  DailyRecord? lastKnownRecord;
  for (DailyRecord dailyRecord in record.dailyRecords) {
    if (dailyRecord.dayNumber == day) {
      return dailyRecord;
    } else if (dailyRecord.dayNumber < day &&
        (lastKnownRecord == null ||
            dailyRecord.dayNumber > lastKnownRecord.dayNumber)) {
      lastKnownRecord = dailyRecord;
    }
  }

  if (lastKnownRecord == null) {
    return DailyRecord(day, 0, CommuteMethod.walk, Diet(0, 0, 0, 0, 0));
  } else {
    return DailyRecord(day, lastKnownRecord.commuteDistance,
        lastKnownRecord.commuteMethod, lastKnownRecord.diet);
  }
}

/// Return the emissions for a given dailyRecord
Emissions calculateDailyEmissions(UserRecord record, DailyRecord dailyRecord) {
  return calculateYearlyHomeMaintenanceEmissions(record) / 365 +
      calculateCommuteEmissions(
          record, dailyRecord.commuteMethod, dailyRecord.commuteDistance) +
      calculateDietEmissions(dailyRecord.diet);
}

Emissions calculateMonthlyEmissions(UserRecord record, int month) {
  Emissions emissions = const Emissions();

  List<int> daysInMonth = getDaysInMonth(month);

  for (DailyRecord dailyRecord in record.dailyRecords) {
    if (daysInMonth.contains(dailyRecord.dayNumber)) {
      daysInMonth.remove(dailyRecord.dayNumber);
      emissions += calculateDailyEmissions(record, dailyRecord);
    }
  }

  for (int missedDay in daysInMonth) {
    emissions += calculateDailyEmissions(
        record, getOrGenerateDailyRecord(record, missedDay));
  }

  return emissions;
}

Emissions calculate30DayEmissions(UserRecord record, int today) {
  Emissions emissions = const Emissions();

  List<int> last30days = getLast30Days(today);

  for (DailyRecord dailyRecord in record.dailyRecords) {
    if (last30days.contains(dailyRecord.dayNumber)) {
      last30days.remove(dailyRecord.dayNumber);
      emissions += calculateDailyEmissions(record, dailyRecord);
    }
  }

  for (int missedDay in last30days) {
    emissions += calculateDailyEmissions(
        record, getOrGenerateDailyRecord(record, missedDay));
  }

  return emissions;
}

/// Return the emissions for a given day. The difference with calculateDailyEmissions is that this function takes a number as a day and not a record, and is able to fill in missing days based on previous records
Emissions getDailyEmissions(UserRecord record, int day) {
  return calculateDailyEmissions(record, getOrGenerateDailyRecord(record, day));
}

class Comparison {
  final String name;
  final String value;
  final String emoji;
  final Color color;

  const Comparison(this.name, this.value, this.emoji, this.color);
}

// Returns gallons
int calcualteCO2Volume(int mass) {
  double molesOfCO2 = mass / 44;
  return (molesOfCO2 * 8.314 * 288 / 101325 * 264.172)
      .floor(); // 8.314 is the gas constant, 288 is the temperature in kelvin, 101325 is the pressure in pascals, 264.172 converts from m3 to gallons
}

List<Comparison> generateComparisons(
    Emissions periodEmissions, int periodLength) {
  // periodLength is the number of days in the period
  final int yearlyEmissions =
      (periodEmissions.total / periodLength * 365).floor();

  return [
    Comparison("Emissions of the average person",
        "${(yearlyEmissions / 4700000).toStringAsFixed(1)}x", '👨', Colors.red),
    Comparison("Trees required to offset your emissions",
        (yearlyEmissions ~/ 22000).toString(), '🌳', Colors.green),
    Comparison(
        "Volume of CO2 emitted",
        "${(calcualteCO2Volume(periodEmissions.total) / 1000).floor()}K gallons",
        "📦",
        Colors.orange),
    Comparison(
        "Maximum emissions per person for a sustainable future",
        "${(yearlyEmissions / 2500000).toStringAsFixed(1)}x",
        "🌍",
        Colors.blue),
  ];
}
