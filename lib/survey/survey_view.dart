import 'package:flutter/material.dart';
import 'package:gretapp/survey/survey_questions.dart';
import 'package:gretapp/survey/survey_widgets.dart';

class SurveyView extends StatefulWidget {
  final List<SurveyQuestion> questions;
  final Function(Map) onComplete;
  final Map<String, dynamic> answers = {};

  SurveyView(this.questions, this.onComplete, {super.key});

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  int questionIndex = 0;

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
          });
          return Future.value(false);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Text("Question ${questionIndex + 1}/${widget.questions.length}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center),
                Text(widget.questions[questionIndex].prompt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32)),
                answerInputWidget,
                EnableableButton(
                    enabled: answerInputWidget.hasInput,
                    onPressed: () {
                      widget.answers[widget.questions[questionIndex]
                          .identifier] = answerInputWidget.getInput();
                      if (questionIndex < widget.questions.length - 1) {
                        setState(() {
                          questionIndex++;
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
