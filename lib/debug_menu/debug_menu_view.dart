import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gretapp/data/carbon.dart';
import 'package:gretapp/main_menu/main_menu_view.dart';
import 'package:gretapp/registration/registration_view.dart';
import 'package:gretapp/data/user.dart';
import 'package:gretapp/survey/survey_questions.dart';

class DebugMenuView extends StatelessWidget {
  const DebugMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Menu'),
      ),
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          const SimulatedUserButton.newAccount(),
          SimulatedUserButton(
              UserAccount(
                  'Greta',
                  SurveySession(DateTime.utc(2023, 04, 01, 22, 53), {
                    nameQuestion: 'Greta',
                    locationQuestion: Location.midwest.name,
                    householdInhabitantCountQuestion: 5,
                    householdTypeQuestion: HouseholdType.familyAttached.name,
                    carTypeQuestion: CarType.none.name
                  }),
                  generateFakeSessions(
                      123, 0.5, 60, ['walk', 'bike', 'bus', 'train'], 0.05)),
              'Environmental Activist'),
          SimulatedUserButton(
              UserAccount(
                  'Jeff',
                  SurveySession(DateTime.utc(2023, 03, 01, 22, 53), {
                    nameQuestion: 'Jeff',
                    locationQuestion: Location.northeast.name,
                    householdInhabitantCountQuestion: 2,
                    householdTypeQuestion: HouseholdType.appartments24.name,
                    carTypeQuestion: CarType.gas.name
                  }),
                  generateFakeSessions(123, 1.5, 30, ['car', 'train'], 0.4)),
              'Businessman'),
          SimulatedUserButton(
              UserAccount(
                  'Josh',
                  SurveySession(DateTime.utc(2023, 03, 01, 22, 53), {
                    nameQuestion: 'Josh',
                    locationQuestion: Location.west.name,
                    householdInhabitantCountQuestion: 1,
                    householdTypeQuestion: HouseholdType.appartments24.name,
                    carTypeQuestion: CarType.gas.name
                  }),
                  generateFakeSessions(
                      123, 1.5, 30, ['bike', 'train', 'bus', 'walk'], 0.1)),
              'Student')
        ],
      ),
    );
  }
}

class SimulatedUserButton extends StatelessWidget {
  final UserAccount? userAccount;
  final String accountTypeDescriptor;
  const SimulatedUserButton(this.userAccount, this.accountTypeDescriptor,
      {super.key});

  const SimulatedUserButton.newAccount({super.key})
      : userAccount = null,
        accountTypeDescriptor = 'New Account';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          if (userAccount == null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrationView()),
                (r) => false // Clear everything
                );
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainMenuView(userAccount!)),
                (r) => false // Clear everything
                );
          }
        },
        child: Text((userAccount != null)
            ? 'Start as ${userAccount!.name} ($accountTypeDescriptor)'
            : 'Start as new user'),
      ),
    );
  }
}

List<SurveySession> generateFakeSessions(int seed, double multiplier, int count,
    List<String> commuteMethods, double skipProbability) {
  final rng = Random(seed);
  final List<SurveySession> sessions = [];
  final now = DateTime.now();

  for (int i = 0; i < count; i++) {
    if (rng.nextDouble() < skipProbability) {
      continue;
    }

    sessions.add(SurveySession(
        DateTime.utc(now.year, now.month, now.day - i - 1, 20 + rng.nextInt(4),
            rng.nextInt(60)),
        {
          commuteDistanceQuestion: rng.nextDouble() * 5 * multiplier,
          commuteMethodQuestion:
              commuteMethods[rng.nextInt(commuteMethods.length)],
          beefMassQuestion: rng.nextDouble() * 0.01 * multiplier,
          lambPorkChickenMassQuestion: rng.nextDouble() * 0.05 * multiplier,
          chocolateMassQuestion: rng.nextDouble() * 0.025 * multiplier,
          cheeseMassQuestion: rng.nextDouble() * 0.01 * multiplier,
          coffeeMassQuestion: 0.18 * rng.nextDouble() * multiplier
        }));
  }
  return sessions;
}
