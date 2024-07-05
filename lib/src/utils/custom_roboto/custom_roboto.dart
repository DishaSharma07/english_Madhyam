import 'dart:ui';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomRoboto extends StatelessWidget {
  @required
  String text;
  final String? fontFamily;
  final double? fontSize;
  final Color? color;
  final TextAlign? align;
  final FontWeight? fontWeight;
  final double? letterspace;
  final Locale? locale;
  final TextOverflow? overflow;
  final Paint? foreground;
  TextDecoration? linethrough;

  CustomRoboto(
      {Key? key,
      this.overflow,
      this.color,
      this.align,
      this.fontFamily,
      this.letterspace,
      this.fontSize,
      this.fontWeight,
      this.locale,
      this.foreground,
      required this.text,
      this.linethrough})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        letterSpacing: letterspace,
        foreground: foreground,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: linethrough,
      ),
      textAlign: align,
    );
  }
}
