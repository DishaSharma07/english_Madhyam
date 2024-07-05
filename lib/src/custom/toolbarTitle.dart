import 'package:english_madhyam/src/custom/semiBoldTextView.dart';
import 'package:flutter/material.dart';
class ToolbarTitle extends StatelessWidget {
  final String title;
  final Color color;
  const ToolbarTitle({
    Key? key,
    required this.title,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SemiBoldTextView(
      text: title,
      color: Colors.black,
      textSize: 18,
      textAlign: TextAlign.left,
    );
  }
}
