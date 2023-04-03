import 'package:flutter/material.dart';
import 'package:gretapp/data/carbon.dart';

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

class ComparisonLister extends StatelessWidget {
  final List<Comparison> comparisons;

  const ComparisonLister(this.comparisons, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        children: comparisons
            .map((comparison) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: null,
                      shape: BoxShape.circle,
                      color: comparison.color,
                    ),
                    child: Center(
                      child: Column(children: [
                        Text(comparison.emoji,
                            style: const TextStyle(fontSize: 32)),
                        const Padding(padding: EdgeInsets.all(10)),
                        Text(comparison.value,
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold)),
                        const Padding(padding: EdgeInsets.all(10)),
                        Text(comparison.name),
                      ]),
                    ),
                  ),
                ))
            .toList());
  }
}
