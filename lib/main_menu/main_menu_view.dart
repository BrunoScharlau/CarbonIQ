import 'package:flutter/material.dart';
import 'package:gretapp/registration/user.dart';
import 'package:gretapp/survey/survey_questions.dart';
import 'package:gretapp/survey/survey_view.dart';
import 'main_menu_widgets.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class MainMenuView extends StatelessWidget {
  final UserAccount user;

  const MainMenuView(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('MMMM');
    String formatted = formatter.format(now);
    final String month = formatted;

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
            ListView(
              children: [
                Text("Hi ${user.name},",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 32),
                    textAlign: TextAlign.center),
                Text("here's what your impact for $month looks like",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20)),
                DataBox(
                    "Some graph",
                    ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: LineChart(generateChartData()))),
              ],
            ),
            Positioned(
                bottom: 25,
                left: 50,
                right: 50,
                child: ElevatedButton(
                  onPressed: () {
                    startDailySurvey(context, user);
                  },
                  child: const Text('Take your daily survey'),
                ))
          ],
        ));
  }
}

void startDailySurvey(BuildContext context, UserAccount userAccount) {
  List<SurveyQuestion> questions = generateDailySurveyQuestions();

  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => SurveyView(
              questions,
              (answers) {
                SurveySession session = SurveySession(DateTime.now(), answers);

                userAccount.completedSurveys.add(session);

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

LineChartData generateChartData() {
  return LineChartData(
    titlesData: FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true, interval: 1),
      ),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: const [
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 3),
          FlSpot(11, 4),
        ],
        isCurved: true,
        color: Colors.red,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData:
            BarAreaData(show: true, color: const Color.fromARGB(50, 255, 0, 0)),
      ),
    ],
  );
}
