import 'package:flutter/material.dart';
import 'dart:math';

import 'generated_palettes.dart';
import 'package:flutter/services.dart';

class ColorProvider {
  int _index = 0;
  Map<ColorType, Color> palette = <ColorType, Color>{};
  Random random = Random();

  ColorProvider(int newIndex) {
    changePalette(newIndex);
  }

  ColorProvider.random() {
    changePalette(random.nextInt(_paletteCount()));
  }

  ColorProvider.white() {
    _index = -1;

    palette[ColorType.background] = Colors.white;
    palette[ColorType.action] = Colors.black;
    palette[ColorType.primary] = Colors.blue;
    palette[ColorType.secondary] = Colors.grey;
  }

  void changePaletteWithOffset(int offset) {
    changePalette(_index + offset);
  }

  void changePalette(int newIndex) {
    _index = newIndex % _paletteCount();

    palette[ColorType.background] = Color(palettes[_index]["background"]!);
    palette[ColorType.action] = Color(palettes[_index]["action"]!);
    palette[ColorType.primary] = Color(palettes[_index]["primary"]!);
    palette[ColorType.secondary] = Color(palettes[_index]["secondary"]!);
  }

  int _paletteCount() {
    return palettes.length;
  }

  Color getColor(ColorType type) {
    return palette[type]!;
  }
}

enum ColorType { primary, secondary, background, action }
