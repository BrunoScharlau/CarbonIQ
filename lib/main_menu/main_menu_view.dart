import 'package:flutter/material.dart';
import 'main_menu_widgets.dart';


class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {

  String month = 'MONTH';

  @override
  void initState() {
    super.initState();
    month = "Febuary";
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [ IconButton(onPressed: (){}, icon: const Icon(Icons.settings, color: Colors.grey,))],
        elevation: 0,
        backgroundColor: Colors.transparent,  
      ),
      body:ListView(
        children: [ 
          const Text("Hello Greta,", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32), textAlign: TextAlign.center),
          Text("here's what your impact for $month looks like", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
          DataBox(DataBoxType.Comparison),
          DataBox(DataBoxType.Graph)
        ],
      )
    );
  }
}