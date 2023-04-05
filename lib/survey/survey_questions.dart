import 'dart:convert';

import 'package:gretapp/data/user.dart';
import 'package:gretapp/survey/survey_widgets.dart';

class SurveyQuestion<T> {
  final String prompt;
  final String identifier;
  final AnswerInputWidget<T> Function(Map<String, dynamic>? parameters)
      widgetGenerator;
  final Map<String, dynamic>? parameters;
  final Function(Map<SurveyQuestion, dynamic> previousAnswers)?
      autoAnswer; // If this function returns a non null value, its results will be used as the answer to this question and the user will not be prompted to answer it

  const SurveyQuestion(this.prompt, this.identifier, this.widgetGenerator,
      {this.parameters, this.autoAnswer});

  AnswerInputWidget<T> generateWidget() {
    return widgetGenerator(parameters);
  }

  @override
  bool operator ==(Object other) =>
      other is SurveyQuestion && other.identifier == identifier;

  @override
  int get hashCode => identifier.hashCode;
}

class SurveySession {
  final DateTime time;
  final Map<SurveyQuestion, dynamic> answers;

  SurveySession(this.time, this.answers);

  String toJSON() {
    return jsonEncode({
      "time": time.millisecondsSinceEpoch,
      "answers": answers.map((key, value) => MapEntry(key.identifier, value))
    });
  }

  static SurveySession fromJSON(String jsonStr) {
    final json = jsonDecode(jsonStr);
    return SurveySession(
        DateTime.fromMillisecondsSinceEpoch(json["time"]),
        json["answers"]
            .map(
                (key, value) => MapEntry(getQuestionFromIdentifier(key), value))
            .cast<SurveyQuestion, dynamic>());
  }
}

SurveyQuestion getQuestionFromIdentifier(String identifier) {
  return registrationQuestions
      .followedBy(dailySurveyQuestions)
      .firstWhere((element) => element.identifier == identifier);
}

// Registration questions

const nameQuestion =
    SurveyQuestion("What's your name?", 'username', newTextAnswerWidget);

final locationQuestion = SurveyQuestion(
    "Where do you live?", 'location', newMultipleChoiceAnswerWidget,
    parameters: {
      'options': [
        MultipleChoiceOption("West 🌄", Location.west.name),
        MultipleChoiceOption("South 🌅", Location.south.name),
        MultipleChoiceOption("Northeast 🌇", Location.northeast.name),
        MultipleChoiceOption("Midwest 🌆", Location.midwest.name)
      ]
    });

final householdTypeQuestion = SurveyQuestion(
    "What type of building do you live in?",
    'householdType',
    newMultipleChoiceAnswerWidget,
    parameters: {
      'options': [
        MultipleChoiceOption(
            "Family attached 🏠", HouseholdType.familyAttached.name),
        MultipleChoiceOption(
            "Family detached 🏡", HouseholdType.familyDetached.name),
        MultipleChoiceOption(
            "Appartments 2-4 units 🏢", HouseholdType.appartments24.name),
        MultipleChoiceOption(
            "Appartments 5+ units 🏢", HouseholdType.appartments5p.name),
        MultipleChoiceOption("Mobile home 🏠", HouseholdType.mobileHome.name)
      ]
    });

const householdInhabitantCountQuestion = SurveyQuestion(
    "How many people live in your household?",
    'householdInhabitantCount',
    newIntegerAnswerWidget,
    parameters: {'min': 1});

final carTypeQuestion = SurveyQuestion(
    "What type of car do you drive?", 'carType', newMultipleChoiceAnswerWidget,
    parameters: {
      'options': [
        MultipleChoiceOption("None 🙅‍♂️", CarType.none.name),
        MultipleChoiceOption("Gas ⛽", CarType.gas.name),
        MultipleChoiceOption("Electric 🔌", CarType.electric.name),
        MultipleChoiceOption("Hybrid 🚗", CarType.hybrid.name)
      ]
    });

// Daily survey questions

const commuteDistanceQuestion = SurveyQuestion(
    "How many miles did you commute today?",
    'commuteDistance',
    newDoubleAnswerWidget,
    parameters: {'default': 0});

final commuteMethodQuestion = SurveyQuestion(
    "How do you commute?", 'commuteType', newMultipleChoiceAnswerWidget,
    parameters: {
      'options': [
        MultipleChoiceOption("Car 🚗", CommuteMethod.car.name),
        MultipleChoiceOption("Motorbike 🛵", CommuteMethod.motorbike.name),
        MultipleChoiceOption("Bus 🚌", CommuteMethod.bus.name),
        MultipleChoiceOption("Train 🚄", CommuteMethod.train.name),
        MultipleChoiceOption("Bike 🚲", CommuteMethod.bike.name),
        MultipleChoiceOption("Walk 🚶‍♀️", CommuteMethod.walk.name)
      ]
    });

final dietTypeQuestion = SurveyQuestion("What type of food did you eat today?",
    'dietType', newMultipleChoiceAnswerWidget,
    parameters: {
      'options': [
        MultipleChoiceOption("Vegan 🌱", DietType.vegan.name),
        MultipleChoiceOption("Vegetarian 🥦", DietType.vegetarian.name),
        MultipleChoiceOption("Pescatarian 🐟", DietType.pescatarian.name),
        MultipleChoiceOption("Omnivore 🍖", DietType.omnivore.name)
      ]
    });

double? meatAutoAnswer(Map<SurveyQuestion, dynamic> previousAnswers) {
  if (previousAnswers[dietTypeQuestion] == DietType.vegan.name ||
      previousAnswers[dietTypeQuestion] == DietType.vegetarian.name ||
      previousAnswers[dietTypeQuestion] == DietType.pescatarian.name) {
    return 0.0;
  } else {
    return null;
  }
}

const beefMassQuestion = SurveyQuestion(
    "How many pounds of beef did you eat today?",
    'beefMass',
    newDoubleAnswerWidget,
    autoAnswer: meatAutoAnswer,
    parameters: {'default': 0});

const lambPorkChickenMassQuestion = SurveyQuestion(
    "How many pounds of lamb, pork, and chicken did you eat today?",
    'lambPorkChickenMass',
    newDoubleAnswerWidget,
    autoAnswer: meatAutoAnswer,
    parameters: {'default': 0});

const chocolateMassQuestion = SurveyQuestion(
    "How many pounds of chocolate did you eat today?",
    'chocolateMass',
    newDoubleAnswerWidget,
    parameters: {'default': 0});

final cheeseMassQuestion = SurveyQuestion(
    "How many pounds of cheese did you eat today?",
    'cheeseMass',
    newDoubleAnswerWidget,
    autoAnswer: ((previousAnswers) =>
        previousAnswers[dietTypeQuestion] == DietType.vegan.name ? 0.0 : null),
    parameters: {'default': 0});

const coffeeCupsQuestion = SurveyQuestion(
    "How many cups of coffee did you drink today?",
    'coffeeCups',
    newIntegerAnswerWidget,
    parameters: {'default': 0});

final List<SurveyQuestion> registrationQuestions = [
  nameQuestion,
  locationQuestion,
  householdInhabitantCountQuestion,
  householdTypeQuestion,
  carTypeQuestion
];

final List<SurveyQuestion> dailySurveyQuestions = [
  commuteDistanceQuestion,
  commuteMethodQuestion,
  dietTypeQuestion,
  beefMassQuestion,
  lambPorkChickenMassQuestion,
  cheeseMassQuestion,
  coffeeCupsQuestion,
  chocolateMassQuestion
];
