
import 'package:flutter/material.dart'; 

class DataBox extends StatelessWidget {
  const DataBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.blueGrey[300]
      ),
      child: const Text("Justin Trudeaun hates children."),
    );
  }
}
