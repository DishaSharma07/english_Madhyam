import 'dart:math';

import 'package:flutter/material.dart';

//to convert hexadecimal string into int
hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return val;
}

final correctColor = Color(hexStringToHexInt('#0FEE25'));
final gradientLigthblue = Color(hexStringToHexInt("#5BABEA"));
final gradientBlue = Color(hexStringToHexInt("#1C68CF"));
final whiteColor = Color(hexStringToHexInt("#FFFFFF"));
final purpleColor = Color(hexStringToHexInt("#456AFD"));
final bgPurpleColor = Color(hexStringToHexInt("#EDF1FF"));
final purplegrColor = Color(hexStringToHexInt("#0033FD"));
final blackColor = Color(hexStringToHexInt("#000000"));
final authGreyColor = Color(hexStringToHexInt("#F9F9F9"));
final greenColor = Color(hexStringToHexInt("#1AA200"));
final themeYellowColor = Color(hexStringToHexInt("#FFBE00"));
final themePurpleColor = Color(hexStringToHexInt("#476CFF"));
final magenttaColor = Color(hexStringToHexInt("#712182"));
final seaGreenColor = Color(hexStringToHexInt("#3B909B"));
final brownColor = Color(hexStringToHexInt("#DE822D"));
final lightYellowColor = Color(hexStringToHexInt("#FFD969"));
final indigoColor = Color(hexStringToHexInt("#345EE5"));
final darkGreyColor = Color(hexStringToHexInt("#5C5C5C"));
final lightGreyColor = Color(hexStringToHexInt("#EAECEF"));
final pinkColor = Color(hexStringToHexInt("#E33858"));
final greyColor = Color(hexStringToHexInt("#949494"));
const indicatorColor = Color(0xffBABABA);

final darkGreenColor = Color(hexStringToHexInt("#148835"));
final lightGreenColor = Color(hexStringToHexInt("#65CE93"));
final lightPurpleColor = Color(hexStringToHexInt("#5D5BF5"));
final redColor = Color(hexStringToHexInt("#CA0B09"));
final Shader linearGradient = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    gradientBlue,
    gradientLigthblue.withOpacity(0.5),
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Gradient learning1 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff5041E2),
    Color(0xff48CBCD),
  ],
);
const Gradient learning2 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xffFA4873),
    Color(0xffFBB090),
  ],
);
final Gradient learning3 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xffF7C12A),
    Color(0xffFAD66B),
  ],
);
final Gradient learning4 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff8043D6),
    Color(0xffF149A0),
  ],
);
final Gradient learning5 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff0BC58C),
    Color(0xff52DEB4),
  ],
);
final Gradient learning6 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff4B3FF4),
    Color(0xff7C8DF5),
  ],
);
