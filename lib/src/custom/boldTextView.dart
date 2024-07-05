import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:english_madhyam/resrc/utils/app_colors.dart';




class BoldTextView extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final bool underline;
  final bool centerUnderline;
  final FontStyle fontStyle;
  final TextAlign textAlign;
  final FontWeight weight;
  final int maxLines;


  const BoldTextView({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.textSize = 14,
    this.underline=false,
    this.centerUnderline=false,
    this.fontStyle=FontStyle.normal,
    this.textAlign=TextAlign.center,
    this.weight=FontWeight.bold,
    this.maxLines=1
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Text(text,textAlign: textAlign,maxLines:maxLines,style: TextStyle(color: color,fontWeight: weight,fontStyle: fontStyle,
        fontSize: textSize,decoration: underline?TextDecoration.underline:centerUnderline?TextDecoration.overline:TextDecoration.none));
  }
}

class BoldTextViewSingleLine extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final bool underline;
  final bool centerUnderline;
  final FontStyle fontStyle;


  const BoldTextViewSingleLine({
    Key? key,
    required this.text,
    this.color = primaryColor,
    this.textSize = 17,
    this.underline=false,
    this.centerUnderline=false,
    this.fontStyle=FontStyle.normal,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Text(text, overflow: TextOverflow.ellipsis,style: TextStyle(color: color,fontWeight: FontWeight.bold,fontStyle: fontStyle
        ,fontSize: textSize,decoration: underline?TextDecoration.underline:centerUnderline?TextDecoration.overline:TextDecoration.none));
  }
}
