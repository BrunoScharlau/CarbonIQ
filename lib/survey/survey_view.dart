import 'package:flutter/material.dart';
import 'package:gretapp/survey/survey_widgets.dart';

class QuizQuestion<T> {
  final String prompt;
  final String identifier;
  final AnswerInputWidget<T> widget;

  QuizQuestion(this.prompt, this.identifier, this.widget);
}

class QuizView extends StatefulWidget {
  final List<QuizQuestion> questions;
  final VoidCallback onComplete;

  const QuizView(this.questions, this.onComplete, {super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int questionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                alignment: Alignment.centerLeft,
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ))
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
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
              widget.questions[questionIndex].widget,
              ElevatedButton(
                  onPressed: () {
                    if (questionIndex < widget.questions.length - 1) {
                      questionIndex++;
                    } else {
                      widget.onComplete();
                    }
                  },
                  child: Text(questionIndex < widget.questions.length - 1
                      ? "Next"
                      : "Finish"))
            ],
          ),
        ));
  }
}
