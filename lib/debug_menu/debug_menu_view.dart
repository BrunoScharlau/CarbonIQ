import 'package:flutter/material.dart';
import 'package:gretapp/main_menu/main_menu_view.dart';
import 'package:gretapp/registration/registration_view.dart';
import 'package:gretapp/registration/user.dart';

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
              UserAccount('Greta', []), 'Environmental Activist'),
          SimulatedUserButton(UserAccount('Jeff', []), 'Businessman'),
          SimulatedUserButton(UserAccount('Josh', []), 'Student'),
          // TODO Actually populate the SurveySessions
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
