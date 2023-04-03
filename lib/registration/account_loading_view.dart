import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gretapp/data/user.dart';
import 'package:gretapp/main_menu/main_menu_view.dart';
import 'package:gretapp/registration/registration_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountLoadingView extends StatefulWidget {
  const AccountLoadingView({super.key});

  @override
  State<AccountLoadingView> createState() => _AccountLoadingViewState();
}

class _AccountLoadingViewState extends State<AccountLoadingView> {
  Future<UserAccount?> account =
      SharedPreferences.getInstance().then((value) => loadAccount(value));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserAccount?>(
        future: account,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            log('Existing account found.');

            return MainMenuView(snapshot.data!);
          } else if (snapshot.hasError) {
            log('Error loading account: ${snapshot.error.toString()}',
                error: snapshot.error, stackTrace: snapshot.stackTrace);

            return const RegistrationView();
          } else if (snapshot.connectionState == ConnectionState.done) {
            log('No existing account found.');
            return const RegistrationView();
          } else {
            log('Loading account...');
            return const Scaffold(
                appBar: null, body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
