import 'package:flutter/material.dart';
import 'package:gretapp/data/user.dart';
import 'package:gretapp/main_menu/main_menu_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountLoadingView extends StatefulWidget {
  const AccountLoadingView({super.key});

  @override
  State<AccountLoadingView> createState() => _AccountLoadingViewState();
}

class _AccountLoadingViewState extends State<AccountLoadingView> {
  Future<UserAccount> account =
      SharedPreferences.getInstance().then((value) => loadAccount(value));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
          child: FutureBuilder<UserAccount>(
              future: account,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Load main menu view
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenuView(snapshot.data!)),
                    (r) => false, // Clear entire navigation stack
                  );

                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text("Error loading account");
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ));
  }
}
