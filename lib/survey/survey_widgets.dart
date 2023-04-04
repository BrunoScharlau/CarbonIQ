import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gretapp/colors/color_provider.dart';

/// A stateful button that enables and disables itself according to the specified ValueNotifier.
class EnableableButton extends StatefulWidget {
  final ValueNotifier<bool> enabled;
  final VoidCallback onPressed;
  final Widget child;
  final ColorProvider _colorProvider;

  const EnableableButton(this._colorProvider,
      {super.key,
      required this.enabled,
      required this.onPressed,
      required this.child});

  @override
  State<EnableableButton> createState() => _EnableableButtonState();
}

class _EnableableButtonState extends State<EnableableButton> {
  @override
  void initState() {
    super.initState();

    widget.enabled.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant EnableableButton oldWidget) {
    widget.enabled.addListener(() {
      setState(() {});
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: widget._colorProvider.getColor(ColorType.primary)),
        onPressed: widget.enabled.value ? widget.onPressed : null,
        child: widget.child);
  }
}

/// A anbstract superclass for AnswerInputWidgets. AnswerInputWidgets are only the input part of a question. They do not include the prompt, the background, the progress bar etc
abstract class AnswerInputWidget<T> extends Widget {
  final ValueNotifier<bool> hasInput = ValueNotifier<bool>(false);

  AnswerInputWidget({super.key});

  T getInput();
}

/// A widget that displays a text input field
class TextAnswerInputWidget extends StatelessWidget
    implements AnswerInputWidget<String> {
  @override
  final ValueNotifier<bool> hasInput = ValueNotifier<bool>(false);
  final TextEditingController editingController = TextEditingController();

  TextAnswerInputWidget({super.key}) {
    editingController.addListener(() {
      hasInput.value = editingController.value.text.isNotEmpty;
    });
  }

  destructor() {
    editingController.dispose();
  }

  @override
  String getInput() {
    return editingController.value.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }
}

/// A widget that displays a number input field accepting only integers
class IntegerAnswerInputWidget extends StatelessWidget
    implements AnswerInputWidget<int> {
  @override
  final ValueNotifier<bool> hasInput = ValueNotifier<bool>(false);
  final TextEditingController editingController = TextEditingController();

  IntegerAnswerInputWidget({super.key}) {
    editingController.addListener(() {
      hasInput.value = editingController.value.text.isNotEmpty;
    });
  }

  destructor() {
    editingController.dispose();
  }

  @override
  int getInput() {
    try {
      return int.parse(editingController.value.text);
    } catch (e) {
      log("Failed to parse input '${editingController.value.text}' as integer: ${e.toString()}",
          error: e);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: editingController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(border: InputBorder.none),
        keyboardType: const TextInputType.numberWithOptions(
            decimal: false, signed: false),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly]);
  }
}

/// A widget that displays a number input field accepting doubles
class DoubleAnswerInputWidget extends StatelessWidget
    implements AnswerInputWidget<double> {
  @override
  final ValueNotifier<bool> hasInput = ValueNotifier<bool>(false);
  final TextEditingController editingController = TextEditingController();

  DoubleAnswerInputWidget({super.key}) {
    editingController.addListener(() {
      hasInput.value = editingController.value.text.isNotEmpty &&
          editingController.value.text != "." &&
          '.'.allMatches(editingController.value.text).length <= 1;
    });
  }

  destructor() {
    editingController.dispose();
  }

  @override
  double getInput() {
    try {
      return double.parse(editingController.value.text);
    } catch (e) {
      log("Failed to parse input '${editingController.value.text}' as double: ${e.toString()}",
          error: e);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: editingController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(border: InputBorder.none),
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
        ]);
  }
}

/// A type that represents a multiple choice option. `text` is the text that is displayed to the user, identifier is used internally to identify the option.
/// This allows `text` to be changed and potentially translated without breaking the code.
class MultipleChoiceOption {
  final String text;
  final String identifier;

  const MultipleChoiceOption(this.text, this.identifier);

  @override
  bool operator ==(Object other) =>
      other is MultipleChoiceOption && other.identifier == identifier;

  @override
  int get hashCode => identifier.hashCode;

  @override
  String toString() {
    return identifier;
  }
}

/// A widget that displays a multiple choice question in the form of a list of radio buttons. It is stateful because it needs to keep track of which radio button is selected.
/// The value returned by getInput is the identifier of the selected option.
class MultipleChoiceAnswerInputWidget extends StatefulWidget
    implements AnswerInputWidget<String?> {
  @override
  final ValueNotifier<bool> hasInput = ValueNotifier<bool>(false);
  final List<MultipleChoiceOption> options;
  final ValueNotifier<MultipleChoiceOption?> selectedOption =
      ValueNotifier<MultipleChoiceOption?>(null);

  MultipleChoiceAnswerInputWidget(this.options, {super.key});

  @override
  String? getInput() {
    return selectedOption.value?.identifier;
  }

  @override
  State<MultipleChoiceAnswerInputWidget> createState() =>
      _MultipleChoiceAnswerInputWidgetState();
}

class _MultipleChoiceAnswerInputWidgetState
    extends State<MultipleChoiceAnswerInputWidget> {
  @override
  Widget build(BuildContext context) {
    // A ValueListenableBuilder is used to rebuild the widget when the selected option changes
    return ValueListenableBuilder(
        valueListenable: widget.selectedOption,
        builder: (context, value, child) {
          return Column(
              children: widget.options
                  .map((entry) => RadioListTile<MultipleChoiceOption>(
                      title: Text(
                        entry.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                      value: entry,
                      groupValue: widget.selectedOption.value,
                      onChanged: (value) {
                        widget.hasInput.value = true;
                        widget.selectedOption.value = value;
                      }))
                  .toList());
        });
  }
}

// Answer widget generators
TextAnswerInputWidget newTextAnswerWidget(Map<String, dynamic>? parameters) =>
    TextAnswerInputWidget();
IntegerAnswerInputWidget newIntegerAnswerWidget(
        Map<String, dynamic>? parameters) =>
    IntegerAnswerInputWidget();
DoubleAnswerInputWidget newDoubleAnswerWidget(
        Map<String, dynamic>? parameters) =>
    DoubleAnswerInputWidget();
MultipleChoiceAnswerInputWidget newMultipleChoiceAnswerWidget(
        Map<String, dynamic>? parameters) =>
    MultipleChoiceAnswerInputWidget(parameters == null
        ? []
        : (parameters.containsKey('options') ? parameters['options'] : []));
