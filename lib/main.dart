


import 'dart:io';

import 'package:english_madhyam/src/helper/bindings/home_bindings/home_binding.dart';
import 'package:english_madhyam/src/screen/Splash/Splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


const debug = true;
void cancel(){
  Future.delayed(const Duration(milliseconds: 500),(){
    Fluttertoast.cancel();
  });
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: debug, ignoreSsl: true);

  Future<void> backGroundHandler(RemoteMessage message)async{


    AwesomeNotifications().createNotificationFromJsonData(
        message.data
    );
  }
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(backGroundHandler);

  AwesomeNotifications().initialize(
    'resource://drawable/logo_round',
    [
      NotificationChannel(
          channelName: 'Basic Notification',
          channelKey: 'test_channel',
          channelGroupKey: 'basic_tests',
          playSound: true,
          channelDescription: 'Notification for Test',
          channelShowBadge: true,

      ),

    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: "basic_tests",
        channelGroupName:  "Basic tests",

      ),
    ],
    debug: true,
  );
  ///when app is terminated
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if(message!=null){

      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'test_channel',
            title: message.notification!.title.toString(),
            body: message.notification!.body.toString(),
          bigPicture:message.data.isNotEmpty?message.data[0]:null,
          notificationLayout: message.data.isEmpty?NotificationLayout.Default:NotificationLayout.BigPicture,
        ),
      );
    }
  });
  ///when app is open
  FirebaseMessaging.onMessage.listen((message) {
    if(message.notification!=null){
      String? imageUrl;
      imageUrl ??= message.notification!.android?.imageUrl;
      imageUrl ??= message.notification!.apple?.imageUrl;



      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'test_channel',
              title: message.notification!.title.toString(),
              body: message.notification!.body.toString(),
            bigPicture:imageUrl ,
            notificationLayout: imageUrl==''?NotificationLayout.Default:NotificationLayout.BigPicture,
          ),
      );
    }
  });
  ///when app is running in background
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    if(message.notification!=null){

    }
  });
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: 'English Madhyam',
        initialBinding: HomeBinding(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  const Splash()
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}