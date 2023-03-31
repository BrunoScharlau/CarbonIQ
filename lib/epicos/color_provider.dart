import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

import 'generated_palettes.dart';
import 'package:flutter/services.dart';

// To avoid changes on re-draw, we will use the hash of the key of the view to indicate what palette will be chosen.
class ColorProvider {

  int index = 0;
  Map<ColorType, Color> palette = <ColorType, Color>{};
  Random random = Random();

  ColorProvider (int newIndex){
    index = newIndex % paletteCount();

    palette[ColorType.background] = Color(palettes[index]["background"]!);
    palette[ColorType.action] = Color(palettes[index]["action"]!);
    palette[ColorType.primary] = Color(palettes[index]["primary"]!);
    palette[ColorType.secondary] = Color(palettes[index]["secondary"]!);
  }

  ColorProvider.random(){
    index = random.nextInt(paletteCount());

    palette[ColorType.background] = Color(palettes[index]["background"]!);
    palette[ColorType.action] = Color(palettes[index]["action"]!);
    palette[ColorType.primary] = Color(palettes[index]["primary"]!);
    palette[ColorType.secondary] = Color(palettes[index]["secondary"]!);
  }

  static int paletteCount () {
    return palettes.length;
  }

  Color getColor(ColorType type){
    return palette[type]!;
  }
}

enum ColorType {primary, secondary, background, action}
