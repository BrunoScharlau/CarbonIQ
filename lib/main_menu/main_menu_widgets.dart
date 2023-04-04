import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:gretapp/data/datetime.dart';
import 'package:gretapp/main_menu/main_menu_view.dart';
import 'package:gretapp/survey/survey_questions.dart';
import 'package:gretapp/survey/survey_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gretapp/data/user.dart';
import 'package:gretapp/colors/color_provider.dart';
import 'package:gretapp/data/carbon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBox extends StatelessWidget {
  final String title;
  final Widget child;
  final ColorProvider _colorProvider;
  const DataBox(this.title, this.child, this._colorProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: _colorProvider.getColor(ColorType.background),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6.0)]),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _colorProvider.getColor(ColorType.action)),
              textAlign: TextAlign.center),
          const Padding(padding: EdgeInsets.all(10)),
          child
        ],
      ),
    );
  }
}

class ComparisonLister extends StatelessWidget {
  final List<Comparison> comparisons;

  const ComparisonLister(this.comparisons, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: comparisons
            .map((comparison) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: null,
                          shape: BoxShape.circle,
                          color: comparison.color,
                        ),
                        child: Center(
                          child: Stack(children: [
                            Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(12),
                                child: Text(comparison.emoji,
                                    style: const TextStyle(fontSize: 52))),
                            const Padding(padding: EdgeInsets.all(10)),
                            Text(comparison.value,
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 10), // padding
                      Text(
                        comparison.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ))
            .toList());
  }
}

class DailySurveyButton extends StatefulWidget {
  final UserAccount user;
  final DateTime now;

  const DailySurveyButton(this.user, this.now, {super.key});

  @override
  State<DailySurveyButton> createState() => _DailySurveyButtonState();
}

class _DailySurveyButtonState extends State<DailySurveyButton> {
  bool enabled = false;

  @override
  void initState() {
    enabled = widget.user.lastDailySurveyTime == null ||
        getDayNumber(widget.now) >
            getDayNumber(widget.user.lastDailySurveyTime!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled
            ? const Color.fromARGB(255, 255, 37, 109)
            : const Color.fromARGB(255, 133, 107, 115),
      ),
      onPressed: () {
        if (!enabled) return;

        startDailySurvey(context, widget.user);
      },
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text(
          enabled ? 'Take daily survey' : 'Come back tomorrow!',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}

class EmissionsGraph extends StatelessWidget {
  final UserRecord record;
  final int dayNumber;
  final Emissions last30dayEmissions;

  const EmissionsGraph(this.record, this.dayNumber, this.last30dayEmissions,
      {super.key});

  @override
  Widget build(BuildContext context) {
    if (record.dailyRecords.isEmpty) {
      return DataBox(
          "How your emissions evolved during this period",
          const Center(
              child: Text(
                  "No data. Take your first daily survey to see a graph of your emissions!")),
          ColorProvider(0));
    }

    return DataBox(
        "How your emissions evolved during this period",
        Column(children: [
          ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: LineChart(generateChartData(record, dayNumber))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "In total, you've emitted ${(last30dayEmissions / 1000).toString()} KG of CO2 in the last 30 days")),
        ]),
        ColorProvider(0));
  }
}

class EmissionsPieChart extends StatelessWidget {
  final UserRecord record;
  final Emissions last30dayEmissions;

  const EmissionsPieChart(this.record, this.last30dayEmissions, {super.key});

  @override
  Widget build(BuildContext context) {
    if (record.dailyRecords.isEmpty) {
      return DataBox(
          "What makes up most of your carbon footprint",
          const Center(
              child: Text(
                  "No data. Take your first daily survey to see a pie chart of your emissions!")),
          ColorProvider(1));
    }

    return DataBox(
        "What makes up most of your carbon footprint",
        ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: PieChart(generatePieChartData(last30dayEmissions))),
        ColorProvider(1));
  }
}

class EmissionsComparisons extends StatelessWidget {
  final UserRecord record;
  final Emissions last30dayEmissions;

  const EmissionsComparisons(this.record, this.last30dayEmissions, {super.key});

  @override
  Widget build(BuildContext context) {
    if (record.dailyRecords.isEmpty) {
      return DataBox(
          "What your impact compares to",
          const Center(
              child: Text(
                  "No data. Take your first daily survey to see a list of comparisons!")),
          ColorProvider(2));
    }

    return DataBox(
        "What your impact compares to",
        ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500),
            child:
                ComparisonLister(generateComparisons(last30dayEmissions, 30))),
        ColorProvider(2));
  }
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
                userAccount.lastDailySurveyTime = DateTime.now();

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
