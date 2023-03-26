import 'package:flutter/material.dart';
import 'package:gretapp/registration/user.dart';
import 'main_menu_widgets.dart';
import 'package:intl/intl.dart';

class MainMenuView extends StatelessWidget {
  final UserAccount user;

  const MainMenuView(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('MMMM');
    String formatted = formatter.format(now);
    final String month = formatted;

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                ))
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          children: [
            Text("Hi ${user.name},",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                textAlign: TextAlign.center),
            Text("here's what your impact for $month looks like",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20)),
            const DataBox(DataBoxType.comparison),
            const DataBox(DataBoxType.graph)
          ],
        ));
  }
}
