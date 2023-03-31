import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gretapp/data/carbon.dart';
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
    log("Building main menu view for user ${user.name}");

    var now = DateTime.now();
    var formatter = DateFormat('MMMM');
    final String monthName = formatter.format(now);

    final UserRecord record = generateUserRecord(user);
    final int monthNumber = getMonthNumber(now);
    final int dayNumber = getDayNumber(now);
    final int monthlyEmissionsKg =
        calculateMonthlyEmissions(record, monthNumber) ~/ 1000;

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
                Text("here's what your impact for $monthName looks like",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20)),
                DataBox(
                    "How your emissions evolved this month",
                    Column(children: [
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: LineChart(generateChartData(
                              record, monthNumber, dayNumber))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "In total, you've emitted $monthlyEmissionsKg KG of CO2 this month")),
                    ])),
                DataBox(
                    "What makes up most of your carbon footprint",
                    ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: PieChart(generatePieChartData()))),
                DataBox(
                    "What your impact compares to",
                    ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 500),
                        child: ComparisonLister(generateComparisons())))
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
  List<SurveyQuestion> questions = dailySurveyQuestions;

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

LineChartData generateChartData(
    UserRecord record, int monthNumber, int dayNumber) {
  log("Generating chart data for month $monthNumber, day $dayNumber");

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
        spots: record.dailyRecords
            .map((e) => FlSpot(e.dayNumber.toDouble(),
                calculateDailyEmissions(record, e).toDouble()))
            .toList(),
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

PieChartData generatePieChartData() {
  return PieChartData(
    sectionsSpace: 0,
    centerSpaceRadius: double.infinity,
    sections: [
      PieChartSectionData(
        color: Colors.red,
        value: 25,
        title: "25% Transport 🚗",
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 15,
        title: "15% Energy ⚡",
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: 10,
        title: "10% Waste 🗑",
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.yellow,
        value: 40,
        title: "40% Food 🍔",
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ],
  );
}

List<Comparison> generateComparisons() {
  return [
    const Comparison("trees", '500', '🌳', Colors.green),
    const Comparison(
        "of average emissions per person", '5.2x', '👨', Colors.red),
    const Comparison("earths required if everyone lived like you", '1.2x', '🌍',
        Colors.blue),
  ];
}
