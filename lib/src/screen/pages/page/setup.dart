import 'dart:math';

import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';



final aPPmAINuRL = 'https://englishmadhyam.info/api/';
final aPPdOMAIN = 'https://englishmadhyam.info/';



Map<int, Color> color = {
  50: Color(hexStringToHexInt('#006cb5')),
  100: Color(hexStringToHexInt('#006cb5')),
  200: Color(hexStringToHexInt('#006cb5')),
  300: Color(hexStringToHexInt('#006cb5')),
  400: Color(hexStringToHexInt('#006cb5')),
  500: Color(hexStringToHexInt('#006cb5')),
  600: Color(hexStringToHexInt('#006cb5')),
  700: Color(hexStringToHexInt('#006cb5')),
  800: Color(hexStringToHexInt('#006cb5')),
  900: Color(hexStringToHexInt('#006cb5')),
};
//ColorsNew
MaterialColor colorCustom = MaterialColor(hexStringToHexInt('#006cb5'), color);

final app_yellow = Color(hexStringToHexInt("#fedd69"));

final blue = Color(hexStringToHexInt("#84bce8"));

final live = Color(hexStringToHexInt("#f36a21"));
final not_started = Color(hexStringToHexInt("#f7bf6e"));
final active = Color(hexStringToHexInt("#7fc652"));
final chat = Color(hexStringToHexInt("#f8c126"));
final notes = Color(hexStringToHexInt("#4354a4"));
final recorded = Color(hexStringToHexInt("#179a9c"));
final ended = Color(hexStringToHexInt("#f1434c"));

final tag = Color(hexStringToHexInt("#eaeb97"));
final green = Color(hexStringToHexInt("#FF006400"));

final gray_batch = Color(hexStringToHexInt("#FFf0f0f0"));

final magenta = Color(hexStringToHexInt("#FF00FF"));
final tran = Color(hexStringToHexInt("#55000000"));
final full = Color(hexStringToHexInt("#EF4E3D"));
final early = Color(hexStringToHexInt("#17DC98"));
final remaining = Color(hexStringToHexInt("#BA0648"));

final primaryColor = Color(hexStringToHexInt("#0b78cd"));
final secondaryColor = Color(hexStringToHexInt('#818181'));
final lightGreyColor = Color(hexStringToHexInt('#d8d8d8'));
final redColor = Color(hexStringToHexInt('#208500'));
final blackMainColor = Color(hexStringToHexInt('#3D3D3D'));
final grey_light = Color(hexStringToHexInt('#FFE0E0E0'));

//Exam Color
final examGreenColor = Color(hexStringToHexInt("#006cb5"));
final examBlueColor = Color(hexStringToHexInt("#4079FF"));
final examGreyColor = Color(hexStringToHexInt("#C7C7C7"));
final examRedColor = Color(hexStringToHexInt("#FF0000"));

//others
final shadowColor = Color(hexStringToHexInt('#8F95A3'));
final subscribedColor = Color(hexStringToHexInt('#9CCC65'));
final shareColor = Color(hexStringToHexInt('#81C784'));

//Home Grid Color
final firstGridColor = Color(hexStringToHexInt('#C5E1A5'));
final secondGridColor = Color(hexStringToHexInt('#FFCC80'));
final thirdGridColor = Color(hexStringToHexInt('#4AA4AA'));
final fourthGridColor = Color(hexStringToHexInt('#FF8A65'));
final fifthGridColor = Color(hexStringToHexInt('#9575CD'));
final sixthGridColor = Color(hexStringToHexInt('#EC407A'));

//Video Thumbnail Color
final freeVideosColor = Color(hexStringToHexInt('#EE776D'));
final latestVideosColor = Color(hexStringToHexInt('#27B7CF'));
final recentVideosColor = Color(hexStringToHexInt('#6F7BF0'));

//Test Color
final correctColor = Color(hexStringToHexInt('#0FEE25'));
final attemptedColor = Color(hexStringToHexInt('#4DB6AC'));
final incorrectColor = Color(hexStringToHexInt('#FF0000'));
final performanceColor = Color(hexStringToHexInt('#8F8F8F'));

hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return val;
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

String getInitials(bank_account_name) {
  String initials = "";
  if (bank_account_name != "") {
    List<String> names = bank_account_name.split(" ");
    int numWords = 2;
    if (numWords > names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
  }
  return initials;
}

// var themeData = ThemeData(
//   backgroundColor: primaryColor,
//   primaryTextTheme: TextTheme(headline6: TextStyle(color: blackColor)),
//   appBarTheme: AppBarTheme(
//     centerTitle: false,
//     color: whiteColor,
//     iconTheme: IconThemeData(color: blackColor, size: 25),
//   ),
//   scaffoldBackgroundColor: whiteColor,
//   /*fontFamily: 'Segoe',*/
// );
var themeData = ThemeData(

  primaryTextTheme: TextTheme(titleLarge: TextStyle(color: blackColor)),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    color: whiteColor,
    iconTheme: IconThemeData(color: blackColor, size: 25),
  ),
  scaffoldBackgroundColor: whiteColor,

  // colorScheme: ColorScheme(background: primaryColor, brightness: null, primary: null, onPrimary: null, onSecondary: null,),
  /*fontFamily: 'Segoe',*/
);
/*

Future<Null> urlFileShare(String url,BuildContext context) async {
  final RenderBox box = context.findRenderObject();
  if (Platform.isAndroid) {
    var response = await get(url);
    final documentDirectory = (await getExternalStorageDirectory()).path;
    File imgFile = new File('$documentDirectory/flutter.png');
    imgFile.writeAsBytesSync(response.bodyBytes);

    Share.shareFiles(['$documentDirectory/flutter.png'],subject: "IAS GYAN",text: "Please check this image",sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  } else {
    Share.share('Hi please check this image '+url,
        subject: 'IAS GYAN',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}*/
