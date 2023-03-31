import 'package:gretapp/data/carbon.dart';
import 'package:gretapp/survey/survey_widgets.dart';

class SurveyQuestion<T> {
  final String prompt;
  final String identifier;
  final AnswerInputWidget<T> Function(Map<String, dynamic>? parameters)
      widgetGenerator;
  final Map<String, dynamic>? parameters;
  final Function<bool>(Map<String, dynamic> answers)? shouldSkip;

  const SurveyQuestion(this.prompt, this.identifier, this.widgetGenerator,
      {this.parameters, this.shouldSkip});

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
    "What type of household do you live in?",
    'householdType',
    newMultipleChoiceAnswerWidget,
    parameters: {
      'options': [
        MultipleChoiceOption(
            "Family attached 🏠", HouseholdType.familyAttached.name),
        MultipleChoiceOption(
            "Family detached 🏡", HouseholdType.familyDetached.name),
        MultipleChoiceOption(
            "Appartments 2-4 🏢", HouseholdType.appartments24.name),
        MultipleChoiceOption(
            "Appartments 5+ 🏢", HouseholdType.appartments5p.name),
        MultipleChoiceOption("Mobile home 🏠", HouseholdType.mobileHome.name)
      ]
    });

final carTypeQuestion = SurveyQuestion(
    "What type of car do you drive?", 'carType', newMultipleChoiceAnswerWidget,
    parameters: {
      'options': [
        MultipleChoiceOption("None 🙅‍♂️", CarType.none.name),
        MultipleChoiceOption("Gas 🚗", CarType.gas.name),
        MultipleChoiceOption("Electric 🚗", CarType.electric.name),
        MultipleChoiceOption("Hybrid 🚗", CarType.hybrid.name)
      ]
    });

// Daily survey questions

const commuteDistanceQuestion = SurveyQuestion(
    "How many miles do you commute to work each day?",
    'commuteDistance',
    newNumberAnswerWidget);

final commuteMethodQuestion = SurveyQuestion(
    "How do you commute to work?", 'commuteType', newMultipleChoiceAnswerWidget,
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

const beefMassQuestion = SurveyQuestion(
    "How many pounds of beef did you eat today?",
    'beefMass',
    newNumberAnswerWidget);

const lambPorkChickenMassQuestion = SurveyQuestion(
    "How many pounds of lamb, pork, and chicken did you eat today?",
    'lambPorkChickenMass',
    newNumberAnswerWidget);

const chocolateMassQuestion = SurveyQuestion(
    "How many pounds of chocolate did you eat today?",
    'chocolateMass',
    newNumberAnswerWidget);

const cheeseMassQuestion = SurveyQuestion(
    "How many pounds of cheese did you eat today?",
    'cheeseMass',
    newNumberAnswerWidget);

const coffeeMassQuestion = SurveyQuestion(
    "How many pounds of coffee did you drink today?",
    'coffeeMass',
    newNumberAnswerWidget);

final List<SurveyQuestion> registrationQuestions = [
  nameQuestion,
  locationQuestion,
  householdTypeQuestion,
  carTypeQuestion
];

final List<SurveyQuestion> dailySurveyQuestions = [
  commuteDistanceQuestion,
  commuteMethodQuestion,
  beefMassQuestion,
  lambPorkChickenMassQuestion,
  chocolateMassQuestion,
  cheeseMassQuestion,
  coffeeMassQuestion
];
