import 'package:flutter/material.dart';
import 'package:gretapp/registration/user.dart';
import 'package:gretapp/survey/survey_questions.dart';
import 'package:gretapp/survey/survey_view.dart';
import 'main_menu_widgets.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gretapp/epicos/color_provider.dart';

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
            
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text("Hi ${user.name},",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                            textAlign: TextAlign.center),
                            Text("here's what your impact for $month looks like",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  
                  DataBox(
                      "How your emissions evolved this month",
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: LineChart(generateChartData())),
                      ColorProvider(0)),
                  DataBox(
                      "What makes up most of your carbon footprint",
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: PieChart(generatePieChartData())),
                      ColorProvider(1)),
                  DataBox(
                      "What your impact compares to",
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 500),
                          child: ComparisonLister(generateComparisons())),
                          
                      ColorProvider(2))
                ],
              ),
            ),
            Positioned(
                bottom: 25,
                left: 50,
                right: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 37, 109), ),
                  onPressed: () {
                    startDailySurvey(context, user);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text('Start daily survey', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
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

PieChartData generatePieChartData() {
  return PieChartData(
    sectionsSpace: 0,
    centerSpaceRadius: double.infinity,
    sections: [
      PieChartSectionData(
        color: Colors.red.shade400,
        value: 25,
        title: "25% 🚗",
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black.withAlpha(128)),
      ),
      PieChartSectionData(
        color: Colors.green.shade400,
        value: 15,
        title: "15% ⚡",
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black.withAlpha(128)),
      ),
      PieChartSectionData(
        color: Colors.blue.shade400,
        value: 10,
        title: "10% 🗑",
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black.withAlpha(128)),
      ),
      PieChartSectionData(
        color: Colors.yellow.shade400,
        value: 40,
        title: "40% 🍔",
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black.withAlpha(128)),
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
