import 'dart:async';
import 'package:english_madhyam/src/auth/login/login_page.dart';
import 'package:english_madhyam/src/screen/bottom_nav/bottom_nav.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class Splash extends StatefulWidget {
  final AnimationController? animationController;
  const Splash({Key? key, this.animationController}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration =  const Duration(milliseconds: 2500);
    return  Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') == null) {

      Get.off(() => const LoginPage());
    } else {

      Get.off(() => const BottomWidget());
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: whiteColor,
        body: Center(
          child:  Image.asset('assets/animations/englishmahdya,.gif',fit: BoxFit.cover,),

        ));
  }
  //
  // Future _showNotificationWithDefaultSound(String title, String message) async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'channel_id', 'channel_name',
  //       priority: Priority.high);
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     '$title',
  //     '$message',
  //     platformChannelSpecifics,
  //     payload: 'Default_Sound',
  //   );
  // }
}
