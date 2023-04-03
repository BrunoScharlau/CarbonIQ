import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gretapp/main_menu/main_menu_view.dart';
import 'package:gretapp/data/user.dart';
import 'package:gretapp/survey/survey_view.dart';
import 'package:gretapp/survey/survey_questions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationView extends StatelessWidget {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Welcome to CarbonIQ!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              textAlign: TextAlign.center),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
                "Before you can start regaining control over your carbon footprint, we need to ask you a few short questions.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SurveyView(
                                registrationQuestions,
                                (answers) {
                                  final account = UserAccount(
                                      answers[nameQuestion],
                                      SurveySession(DateTime.now(), answers),
                                      []);
                                  log('Saving new account...');
                                  SharedPreferences.getInstance()
                                      .then((prefs) =>
                                          saveAccount(account, prefs).then(
                                              (value) => log('Saved account.')))
                                      .catchError((e) => log(
                                          'Error saving account: ${e.toString()}',
                                          error: e));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MainMenuView(account)),
                                    (r) => false, // Clear everything
                                  );
                                },
                              )),
                    );
                  },
                  child: const Text('Begin')),
            ),
          )
        ],
      ),
    );
  }
}
