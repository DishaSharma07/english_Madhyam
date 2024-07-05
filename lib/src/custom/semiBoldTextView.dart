import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resrc/utils/routes/my_constant.dart';


class SemiBoldTextView extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final bool underline;
  final bool centerUnderline;
  final FontStyle fontStyle;
  final TextAlign textAlign;
  final FontWeight weight;
  final int maxLines;

  const SemiBoldTextView(
      {Key? key,
      required this.text,
      this.color = Colors.black,
      this.textSize = 14,
      this.underline = false,
      this.centerUnderline = false,
      this.fontStyle = FontStyle.normal,
      this.textAlign = TextAlign.center,
      this.weight = FontWeight.bold,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Text(text,
        textAlign: textAlign,
        maxLines: maxLines,softWrap: true,
        style: TextStyle(
            color: AdaptiveTheme.of(context).mode.isDark?Colors.white:color,
            fontStyle: fontStyle,
            fontFamily: MyConstant.currentFont,
            fontWeight: FontWeight.w600,
            fontSize: textSize,
            decoration: underline
                ? TextDecoration.underline
                : centerUnderline
                ? TextDecoration.overline
                : TextDecoration.none));
  }
}
