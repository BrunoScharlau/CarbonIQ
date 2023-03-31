import 'package:flutter/material.dart';
import 'package:gretapp/epicos/color_provider.dart';

class DataBox extends StatelessWidget {
  final String title;
  final Widget child;
  final ColorProvider _colorProvider;
  const DataBox(this.title, this.child, this._colorProvider, {super.key});

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: _colorProvider.getColor(ColorType.background),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6.0)]),

      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center),
          const Padding(padding: EdgeInsets.all(10)),
          child
        ],
      ),
    );
  }
}

class Comparison {
  final String name;
  final String value;
  final String emoji;
  final Color color;

  const Comparison(this.name, this.value, this.emoji, this.color);
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
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: null,
                          shape: BoxShape.circle,
                          color: comparison.color,
                        ),
                        child: Center(
                          child: Stack(children: [
                            Container(
                                alignment: Alignment.center,
                                padding:const EdgeInsets.all(12),
                                child: Text(comparison.emoji,
                                style: const TextStyle(fontSize: 52))),
                            const Padding(padding: EdgeInsets.all(10)),
                            Text(comparison.value,
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                          ]),
                        ),
                      ),
                      Text(comparison.name, textAlign: TextAlign.center,),
                    ],
                  ),
                ))
            .toList());
  }
}
