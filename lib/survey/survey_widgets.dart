
import 'package:flutter/material.dart';

/// This widget is only the input part. It doesn't include the prompt, the background, the progress bar etc
abstract class AnswerInputWidget<T> extends StatefulWidget {
  const AnswerInputWidget({super.key});
}

abstract class _AnswerInputWidgetState<T> extends State<AnswerInputWidget<T>> {
  T getInput();
}

class TextAnswerInputWidget extends AnswerInputWidget<String> {
  const TextAnswerInputWidget({super.key});

  @override
  State<StatefulWidget> createState() => _TextAnswerInputWidgetState();
}

class _TextAnswerInputWidgetState extends _AnswerInputWidgetState<String> {
  final TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: editingController, autofocus: true);
  }

  @override
  String getInput() {
    return editingController.text;
  }
}
