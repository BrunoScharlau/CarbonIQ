import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gretapp/data/carbon.dart';
import 'package:gretapp/data/user.dart';
import 'package:gretapp/survey/survey_questions.dart';
import 'package:gretapp/survey/survey_view.dart';
import 'package:gretapp/data/datetime.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_menu_widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gretapp/epicos/color_provider.dart';

class MainMenuView extends StatelessWidget {
  final UserAccount user;

  const MainMenuView(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    log("Building main menu view for user ${user.name}");

    var now = DateTime.now();

    final UserRecord record = generateUserRecord(user);
    final int dayNumber = getDayNumber(now);
    final Emissions last30dayEmissions =
        calculate30DayEmissions(record, dayNumber); // Divide by 1000 to get kg

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                ))
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.center.add(Alignment(0, .6)),
                    end: Alignment.bottomCenter.add(Alignment(0, -.25)),
                    colors: [Colors.white, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: ListView(
                  children: [
                    Text("Hi ${user.name},",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                        textAlign: TextAlign.center),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                          "This is what your impact over the past 30 days looks like",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20)),
                    ),
                    EmissionsGraph(record, dayNumber, last30dayEmissions),
                    EmissionsPieChart(record, last30dayEmissions),
                    EmissionsComparisons(record, last30dayEmissions),
                    DataBox(
                        "Tips & Tricks",
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 500),
                            child: Text(generateTip(user, last30dayEmissions))),
                        ColorProvider.white()),

                    // padding
                    const SizedBox(
                      height: 120,
                    )
                  ],
                )),
            Positioned(
                bottom: 25,
                left: 50,
                right: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 37, 109),
                  ),
                  onPressed: () {
                    startDailySurvey(context, user);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      'Start daily survey',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ))
          ],
        ));
  }
}

void startDailySurvey(BuildContext context, UserAccount userAccount) {
  List<SurveyQuestion> questions = dailySurveyQuestions;

  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => SurveyView(
              questions,
              (answers) {
                SurveySession session = SurveySession(DateTime.now(), answers);

                userAccount.completedSurveys.add(session);

                if (!userAccount.dontSave) {
                  log('Saving account...');
                  SharedPreferences.getInstance()
                      .then((prefs) => saveAccount(userAccount, prefs)
                          .then((value) => log('Saved account.')))
                      .catchError((e) => log(
                          'Error saving account: ${e.toString()}',
                          error: e));
                }

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainMenuView(userAccount)),
                  (r) => false, // Clear everything
                );
              },
            )),
  );
}

String generateTip(UserAccount account, Emissions last30dayEmissions) {
  if (account.completedSurveys.isEmpty) {
    return "You haven't completed any surveys yet. Complete one to get started!";
  } else {
    final int yearlyEmissions = (last30dayEmissions.total / 30 * 365).floor();

    math.Random rng = math.Random();

    if (yearlyEmissions < 2500000) {
      return "Congratulations! Your lifestyle is sustainable! You should be the one giving advice to others.";
    } else if (yearlyEmissions < 4700000 && rng.nextDouble() < 0.5) {
      return "Nice, your yearly emissions are less than average! Keep it up!";
    }

    if (rng.nextDouble() < 0.8) {
      if (last30dayEmissions.maxCategory == last30dayEmissions.energy) {
        return "Your biggest impact is from household energy consumption. Heating and AC are very energy intensive. Consider turning them down a bit.";
      } else if (last30dayEmissions.maxCategory == last30dayEmissions.food &&
          getLatestDiet(account).totalMeatMass > 0) {
        return "Your biggest impact is from food. Consider reducing your meat consumption.";
      } else if (last30dayEmissions.maxCategory ==
          last30dayEmissions.transportation) {
        return "Your biggest impact is from transport. Try to reduce your transport emissions by walking or cycling more often, or taking advantage of public transport.";
      }
    }

    return "Remember that every little step towards reducing your impact counts! Why don't you set yourself a goal of ${(last30dayEmissions / 10150).total * 10} KG of CO2 emitted for next month?";
  }
}
