import 'package:flutter/material.dart';
import 'package:gretapp/main_menu/main_menu_view.dart';
import 'package:gretapp/survey/survey_view.dart';
import 'package:gretapp/survey/survey_widgets.dart';

class RegistrationView extends StatelessWidget {
  final ValueNotifier<String> usernameNotifier = ValueNotifier<String>('');

  RegistrationView({super.key});

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
                                      QuizQuestion(
                                          "What's your name?",
                                          'username',
                                          TextAnswerInputWidget(
                                              usernameNotifier))
                                    ],
                                    () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainMenuView(
                                                usernameNotifier.value)),
                                        (r) => false, // Clear everything
                                      );
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
