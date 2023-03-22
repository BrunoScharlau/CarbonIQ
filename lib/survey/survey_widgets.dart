import 'package:flutter/material.dart';

/// This widget is only the input part. It doesn't include the prompt, the background, the progress bar etc
abstract class AnswerInputWidget<T> extends StatelessWidget {
  const AnswerInputWidget({super.key});
}

class TextAnswerInputWidget extends AnswerInputWidget<String> {
  final ValueNotifier valueNotifier;
  final TextEditingController editingController = TextEditingController();

  TextAnswerInputWidget(this.valueNotifier, {super.key}) {
    editingController.addListener(() {
      valueNotifier.value = editingController.text;
    });
  }

  destructor() {
    editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: editingController, autofocus: true);
  }
}
