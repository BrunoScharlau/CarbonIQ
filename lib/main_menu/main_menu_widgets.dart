import 'package:flutter/material.dart';

class DataBox extends StatelessWidget {
  final String title;
  final Widget child;

  const DataBox(this.title, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Colors.blueGrey[300]),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center),
          const Padding(padding: EdgeInsets.all(10)),
          child
        ],
      ),
    );
  }
}
