import 'dart:developer';

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
                    DataBox(
                        "How your emissions evolved during this period",
                        Column(children: [
                          ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 150),
                              child: LineChart(
                                  generateChartData(record, dayNumber))),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "In total, you've emitted ${last30dayEmissions / 1000} KG of CO2 in the last 30 days")),
                        ]),
                        ColorProvider(0)),
                    DataBox(
                        "What makes up most of your carbon footprint",
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: PieChart(
                                generatePieChartData(last30dayEmissions))),
                        ColorProvider(1)),
                    DataBox(
                        "What your impact compares to",
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 500),
                            child: ComparisonLister(
                                generateComparisons(last30dayEmissions, 30))),
                        ColorProvider(2)),

                    DataBox(
                        "Tips & Tricks",
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 500),
                            child: Text("lorem ipsum")),
                        ColorProvider.white()),

                    // padding
                    Container(
                      height: 100,
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

LineChartData generateChartData(UserRecord record, int dayNumber) {
  log("Generating chart data for day $dayNumber");

  final int firstDayInPeriod = dayNumber - 29;
  final spots = generateLineChartSpots(record, dayNumber, firstDayInPeriod);

  late final double? minY;
  late final double? maxY;

  if (spots.length == 1) {
    // Center the spot vertically on the cahrt
    minY = spots[0].y / 2;
    maxY = spots[0].y * 1.5;
  } else {
    minY = null;
    maxY = null;
  }

  var fakeSpotAdded = false;
  if (spots.length == 1 && spots[0].x > firstDayInPeriod.toDouble()) {
    spots.add(FlSpot(firstDayInPeriod.toDouble(), spots[0].y));
    fakeSpotAdded = true;
  }

  spots.sort((a, b) => a.x.compareTo(b.x));

  return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          interval: 7,
          getTitlesWidget: (value, meta) => value == meta.max
              ? const SizedBox.shrink()
              : Text(DateFormat("MM/dd").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      value.toInt() * 86400000))),
        )),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
            spots: spots,
            isCurved: false,
            color: Colors.red,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) =>
                    !fakeSpotAdded || spot.x.floor() != firstDayInPeriod,
                getDotPainter: (p0, p1, p2, p3) => FlDotCirclePainter(
                      radius: 4,
                      color: Colors.red,
                      strokeWidth: 0,
                      strokeColor: null,
                    )),
            belowBarData: BarAreaData(
                show: true, color: const Color.fromARGB(50, 255, 0, 0))),
      ],
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) => touchedSpots
                  .map((e) =>
                      LineTooltipItem("${e.y ~/ 1000} kg", const TextStyle()))
                  .toList())));
}

List<FlSpot> generateLineChartSpots(
    UserRecord record, int dayNumber, int firstDayInPeriod) {
  List<FlSpot> spots = [];

  for (DailyRecord dailyRecord in record.dailyRecords) {
    if (dailyRecord.dayNumber >= firstDayInPeriod) {
      spots.add(FlSpot(dailyRecord.dayNumber.toDouble(),
          calculateDailyEmissions(record, dailyRecord).toDouble()));
    }
  }

  return spots;
}

PieChartData generatePieChartData(Emissions periodEmissions) {
  return PieChartData(
    sectionsSpace: 0,
    centerSpaceRadius: double.infinity,
    sections: [
      PieChartSectionData(
        color: Colors.red,
        value: periodEmissions.transportation.toDouble(),
        title: "Transport 🚗",
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black.withAlpha(128)),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: periodEmissions.energy.toDouble(),
        title: "Energy ⚡",
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black.withAlpha(128)),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: periodEmissions.other.toDouble(),
        title: "Other 🛠",
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black.withAlpha(128)),
      ),
      PieChartSectionData(
        color: Colors.yellow,
        value: periodEmissions.food.toDouble(),
        title: "Food 🍔",
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black.withAlpha(128)),
      ),
    ],
  );
}
