import 'package:flutter/material.dart';

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
          ElevatedButton(
            onPressed: () {},
            child: const Text('Start as new user'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Start as Greta (Environmental Activist)'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Start as Rick (Businessman)'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Start as Mike (Student)'),
          )
        ],
      ),
    );
  }
}
