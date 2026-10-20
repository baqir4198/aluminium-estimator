import 'dart:ui';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

TextStyle displayStyle(double size, {Color color = AppColors.ink}) =>
    GoogleFonts.barlowCondensed(
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.1,
      color: color,
    );

TextStyle bodyStyle(
    double size, {
      FontWeight weight = FontWeight.w400,
      Color color = AppColors.ink,
    }) =>
    GoogleFonts.barlow(fontSize: size, fontWeight: weight, color: color);

