import 'package:gretapp/survey/survey_questions.dart';

class UserAccount {
  final String name;
  final List<SurveySession> completedSurveys;

  UserAccount(this.name, this.completedSurveys);
}
