

import 'package:better_player/better_player.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';

class BasicPlayerPage extends StatefulWidget {
  final String url;
  final String title;
  const BasicPlayerPage({Key? key,required this.url,required this.title}) : super(key: key);

  @override
  _BasicPlayerPageState createState() => _BasicPlayerPageState();
}

class _BasicPlayerPageState extends State<BasicPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        title: CustomDmSans(text: widget.title,),
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer.network(
          widget.url,
        ),
      ),
    );
  }
}
