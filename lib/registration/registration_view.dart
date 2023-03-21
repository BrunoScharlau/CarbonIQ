import 'package:flutter/material.dart';
import 'package:gretapp/quiz/quiz_view.dart';
import 'package:gretapp/quiz/quiz_widgets.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
                child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Welcome to APP_NAME!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                      textAlign: TextAlign.center),
                  const Text(
                      "Before you can start regaining control over your carbon footprint, we need to ask you a few short questions.",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizView(
                                    [
                                      QuizQuestion("What's your name?",
                                          const TextAnswerInputWidget())
                                    ],
                                    (answers) {
                                      // TODO handle answers
                                    },
                                  )),
                        );
                      },
                      child: const Text('Begin'))
                ],
              ),
            ));
          },
        ));
  }
}
