import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This widget is only the input part. It doesn't include the prompt, the background, the progress bar etc
abstract class AnswerInputWidget<T> extends StatelessWidget {
  const AnswerInputWidget({super.key});

  T getInput();
}

class TextAnswerInputWidget extends AnswerInputWidget<String> {
  final TextEditingController editingController = TextEditingController();

  TextAnswerInputWidget({super.key});

  destructor() {
    editingController.dispose();
  }

  @override
  String getInput() {
    return editingController.value.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: editingController, autofocus: true);
  }
}

class NumberAnswerInputWidget extends AnswerInputWidget<int> {
  final TextEditingController editingController = TextEditingController();

  NumberAnswerInputWidget({super.key});

  destructor() {
    editingController.dispose();
  }

  @override
  int getInput() {
    return int.parse(editingController.value.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: editingController,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly]);
  }
}

// Answer widget generators
TextAnswerInputWidget newTextAnswerWidget() => TextAnswerInputWidget();
NumberAnswerInputWidget newNumberAnswerWidget() => NumberAnswerInputWidget();
