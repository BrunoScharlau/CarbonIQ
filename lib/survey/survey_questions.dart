import 'package:gretapp/survey/survey_widgets.dart';

class SurveyQuestion<T> {
  final String prompt;
  final String identifier;
  final AnswerInputWidget<T> Function(Map<String, dynamic>? parameters)
      widgetGenerator;
  final Map<String, dynamic>? parameters;

  const SurveyQuestion(this.prompt, this.identifier, this.widgetGenerator,
      {this.parameters});

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

const nameQuestion =
    SurveyQuestion("What's your name?", 'username', newTextAnswerWidget);

const householdSizeQuestion = SurveyQuestion(
    "How many people live in your household?",
    'houseSize',
    newNumberAnswerWidget);

const livingSpaceQuestion = SurveyQuestion(
    "How many square feet is your living space?",
    'livingSpace',
    newNumberAnswerWidget);

const commuteDistanceQuestion = SurveyQuestion(
    "How many miles do you commute to work each day?",
    'commute',
    newNumberAnswerWidget);

const commuteTypeQuestion = SurveyQuestion(
    "How do you commute to work?", 'commuteType', newMultipleChoiceAnswerWidget,
    parameters: {
      'options': [
        MultipleChoiceOption("Car 🚗", 'car'),
        MultipleChoiceOption("Bus 🚌", 'bus'),
        MultipleChoiceOption("Train 🚄", 'train'),
        MultipleChoiceOption("Bike 🚲", 'bike'),
        MultipleChoiceOption("Walk 🚶‍♀️", 'walk')
      ]
    });

const dietQuestion = SurveyQuestion(
    "What is your diet like?", 'diet', newMultipleChoiceAnswerWidget,
    parameters: {
      'options': [
        MultipleChoiceOption("Vegetarian 🥦", 'vegetarian'),
        MultipleChoiceOption("Vegan 🥬", 'vegan'),
        MultipleChoiceOption("Pescatarian 🐟", 'pescatarian'),
        MultipleChoiceOption("Meat 🥩", 'meat'),
        MultipleChoiceOption("Mixed 🍴", 'mixed')
      ]
    });

List<SurveyQuestion> generateDailySurveyQuestions() {
  return [
    householdSizeQuestion,
    livingSpaceQuestion,
    commuteDistanceQuestion,
    commuteTypeQuestion,
    dietQuestion
  ];
}
