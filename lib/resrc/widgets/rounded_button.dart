import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'boldTextView.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final double height;
  final bool showIcon;
  final FontWeight weight;

  const RoundedButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = primaryColor,
      this.textColor = Colors.white,
      this.textSize = 18,
      this.showIcon = false,
      this.height = 48,
      this.weight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
      height: height,
      child: MaterialButton(
          animationDuration: Duration(seconds: 1),
          color: color,
          hoverColor: primaryColor,
          splashColor: appBarColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: BoldTextView(
            text: text,
            color: textColor,
            textSize: textSize,
            weight: FontWeight.w400,
            /*weight: weight,*/
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              press();
            });
          }),
    );
  }
}


