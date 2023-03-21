import 'package:flutter/material.dart';

class DataBox extends StatelessWidget {
  final DataBoxType type;

  const DataBox(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Colors.blueGrey[300]),
      child: Text(
        "This is Data $type Box\nLorem ipsum foo bar",
        textAlign: TextAlign.center,
      ),
    );
  }
}

enum DataBoxType {
  graph,
  comparison,
}
