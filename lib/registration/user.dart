import 'package:gretapp/survey/survey_questions.dart';

class UserAccount {
  final String name;
  final SurveySession signupSurvey;
  final List<SurveySession> completedSurveys;

  UserAccount(this.name, this.signupSurvey, this.completedSurveys);
}
