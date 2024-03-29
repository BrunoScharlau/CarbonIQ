import 'package:flutter/material.dart';
import 'package:gretapp/survey/survey_questions.dart';
import 'package:gretapp/survey/survey_widgets.dart';
import 'package:gretapp/colors/color_provider.dart';

class SurveyView extends StatefulWidget {
  final List<SurveyQuestion> questions;
  final Function(Map<SurveyQuestion, dynamic>) onComplete;
  final Map<SurveyQuestion, dynamic> answers = {};

  SurveyView(this.questions, this.onComplete, {super.key});

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  late int questionIndex;
  late ColorProvider colorProvider;

  @override
  void initState() {
    questionIndex = findNextAnswerNeedingQuestion(0);
    colorProvider = ColorProvider.random();
    super.initState();
  }

  int findNextAnswerNeedingQuestion(int startIndex) {
    for (int i = startIndex; i < widget.questions.length; i++) {
      if (widget.questions[i].autoAnswer == null) return i;
      
      dynamic answer = widget.questions[i].autoAnswer!(widget.answers);
      if (answer != null) {
        widget.answers[widget.questions[i]] = answer;
      } else {
        return i;
      }
    }

    return widget.questions.length;
  }

  @override
  Widget build(BuildContext context) {
    final answerInputWidget = widget.questions[questionIndex].generateWidget();

    return WillPopScope(
      onWillPop: () {
        // If we're on the first question, allow the user to exit the quiz, otherwise go back to the previous question
        if (questionIndex == 0) {
          return Future.value(true);
        } else {
          setState(() {
            questionIndex--;
            colorProvider.changePaletteWithOffset(-1);
          });
          return Future.value(false);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
                color: colorProvider.getColor(ColorType.secondary)),
          ),
          backgroundColor: colorProvider.getColor(ColorType.background),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ListView(
              children: [
                Text("Question ${questionIndex + 1}/${widget.questions.length}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorProvider.getColor(ColorType.secondary)),
                    textAlign: TextAlign.center),
                Text(widget.questions[questionIndex].prompt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        color: colorProvider.getColor(ColorType.secondary))),
                answerInputWidget,
                EnableableButton(colorProvider,
                    enabled: answerInputWidget.hasInput, onPressed: () {
                  widget.answers[widget.questions[questionIndex]] =
                      answerInputWidget.getInput();
                  if (questionIndex < widget.questions.length - 1) {
                    setState(() {
                      questionIndex = findNextAnswerNeedingQuestion(questionIndex + 1);
                      colorProvider.changePaletteWithOffset(1);
                    });
                  } else {
                    widget.onComplete(widget.answers);
                  }
                },
                    child: Text(questionIndex < widget.questions.length - 1
                        ? "Next"
                        : "Finish"))
              ],
            ),
          )),
    );
  }
}
