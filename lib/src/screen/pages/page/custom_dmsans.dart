import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDmSans extends StatelessWidget {
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
  final int?maxLines;
  TextDecoration? linethrough;

  CustomDmSans(
      {Key? key,
        this.overflow,
        this.color,
        this.align,
        this.fontFamily,
        this.letterspace,
        this.fontSize,
        this.fontWeight,
        this.locale,
        this.maxLines,
        this.foreground,
        required this.text,
        this.linethrough})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        letterSpacing: letterspace,
        foreground: foreground,
        fontSize: fontSize,
        //color: color,
        fontWeight: fontWeight,
        decoration: linethrough,
      ),
      textAlign: align,
      maxLines: maxLines,
    );
  }
}
