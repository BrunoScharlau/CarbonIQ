import 'package:flutter/material.dart';

/// This widget is only the input part. It doesn't include the prompt, the background, the progress bar etc
abstract class AnswerInputWidget<T> extends StatefulWidget {
  const AnswerInputWidget({super.key});
}

class TextAnswerInputWidget extends AnswerInputWidget<String> {
  final ValueNotifier valueNotifier;

  const TextAnswerInputWidget(this.valueNotifier, {super.key});

  @override
  State<StatefulWidget> createState() => _TextAnswerInputWidgetState();
}

class _TextAnswerInputWidgetState extends State<TextAnswerInputWidget> {
  final TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    editingController.addListener(() {
      widget.valueNotifier.value = editingController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: editingController, autofocus: true);
  }
}
