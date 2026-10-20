import 'package:flutter/painting.dart';

class FrameColor {
  const FrameColor(this.name, this.color);

  final String name;
  final Color color;

  static const options = [
    FrameColor('Silver', Color(0xFFC8CED3)),
    FrameColor('Black', Color(0xFF1B1F23)),
    FrameColor('Bronze', Color(0xFF7A5C3E)),
    FrameColor('White', Color(0xFFFFFFFF)),
  ];

  static Color colorOf(String name) => options
      .firstWhere((c) => c.name == name, orElse: () => options.first)
      .color;
}