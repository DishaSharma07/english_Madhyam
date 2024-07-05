import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class RegularTextView extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final bool underline;
  final bool centerUnderline;
  final TextAlign textAlign;
  final int maxLine;

  const RegularTextView({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.textSize = 14,
    this.underline = false,
    this.centerUnderline = false,
    this.textAlign = TextAlign.start,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLine,
        softWrap: true,
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'Poppins',
            color: AdaptiveTheme.of(context).mode.isDark ? Colors.white : color,
            fontSize: textSize,
            decoration: underline
                ? TextDecoration.underline
                : centerUnderline
                    ? TextDecoration.lineThrough
                    : TextDecoration.none));
  }
}

class RegularTextDarkMode extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final bool underline;
  final bool centerUnderline;
  final TextAlign textAlign;
  final int maxLine;

  const RegularTextDarkMode({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.textSize = 14,
    this.underline = false,
    this.centerUnderline = false,
    this.textAlign = TextAlign.start,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLine,
        softWrap: true,
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'Poppins',
            color: color,
            fontSize: textSize,
            overflow: TextOverflow.ellipsis,

            decoration: underline
                ? TextDecoration.underline
                : centerUnderline
                    ? TextDecoration.lineThrough
                    : TextDecoration.none));
  }
}
